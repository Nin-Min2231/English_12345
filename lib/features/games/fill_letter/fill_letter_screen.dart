import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/models/models.dart';
import '../../../services/audio_service.dart';
import '../../../services/settings_service.dart';

/// F08 / G03 — Điền chữ cái thiếu (theo âm phonics). Có hình + audio gợi ý.
/// Đúng: hiệu ứng + sang từ sau khi bấm "Tiếp theo". Sai: hiệu ứng nhẹ nhàng
/// + xáo trộn lại các lựa chọn, cho thử lại.
/// Từ ≥4 chữ ẩn 2 ô cùng lúc, vị trí có thể KHÔNG liền nhau (CR-020) — xem
/// `_wordSpans` (ghép từng ký tự riêng, không giả định `hiddenIdx` liền dải).
/// CR-023: mỗi ô trống điền RIÊNG 1 chữ cái (không còn 1 ô gộp trả lời chung
/// cho 2 ô) — khay chữ là 1 pool chung ([_it.answer] tách từng ký tự +
/// [_it.distractors], luôn là chữ đơn) dùng chung cho cả 1-2 ô của lượt hiện
/// tại; chạm đúng chữ mục tiêu của ô trống ĐẦU TIÊN (trái sang phải) mới
/// tính, xong ô đó mới chuyển mục tiêu sang ô kế tiếp. `_order` là vị trí
/// hiển thị -> index thật trong `_options` (xáo khi sai, giống
/// listen_pick_screen.dart) — KHÔNG xáo trực tiếp `_options` để index thật
/// (`_usedPositions`/`_eliminatedPos`) không bị lệch sau khi xáo.
class FillLetterScreen extends StatefulWidget {
  final UnitInfo unit;
  final List<FillItem> items;

  const FillLetterScreen({super.key, required this.unit, required this.items});

  @override
  State<FillLetterScreen> createState() => _FillLetterScreenState();
}

class _FillLetterScreenState extends State<FillLetterScreen>
    with WrongAnswerLockMixin<FillLetterScreen> {
  int _index = 0;
  // Từ đã điền đúng (index) — dùng tính sao, không đếm dồn khi xem lại.
  final Set<int> _correctIndices = {};
  // Số ô (trong hiddenIdx của lượt hiện tại) đã điền đúng, theo thứ tự trái
  // sang phải — 0..hiddenIdx.length.
  int _filledCount = 0;
  List<String> _options = []; // cố định trong 1 lượt, không tự xáo trực tiếp
  List<int> _order = []; // vị trí hiển thị -> index thật trong _options
  final Set<int> _usedPositions = {}; // index thật đã dùng đúng (ẩn khỏi khay)
  int? _wrongPick; // index thật vừa chọn sai
  // Độ khó Dễ: 1 vị trí (index thật) đáp án nhiễu bị loại bớt làm gợi ý.
  int? _eliminatedPos;
  AnswerFeedback? _feedback;

  @override
  void initState() {
    super.initState();
    _prepare();
    WidgetsBinding.instance.addPostFrameCallback((_) => _playHint());
  }

  @override
  void dispose() {
    AudioService.instance.stop();
    super.dispose();
  }

  FillItem get _it => widget.items[_index];

  void _prepare() {
    _options = [..._it.answer.split(''), ..._it.distractors];
    _order = List<int>.generate(_options.length, (i) => i)..shuffle(Random());
    _usedPositions.clear();
    _filledCount = 0;
    _wrongPick = null;
    _recomputeEliminated();
  }

  /// Độ khó Dễ: loại 1 vị trí đang giữ chữ KHÁC chữ mục tiêu của ô trống kế
  /// tiếp — phải gọi lại mỗi khi mục tiêu đổi (điền đúng 1 ô, hoặc xáo lại
  /// sau khi chọn sai), giống listen_pick_screen.dart.
  void _recomputeEliminated() {
    _eliminatedPos = null;
    if (SettingsService.instance.isEasy &&
        _filledCount < _it.hiddenIdx.length) {
      final target = _it.answer[_filledCount];
      final candidates = [
        for (final pos in _order)
          if (!_usedPositions.contains(pos) && _options[pos] != target) pos
      ]..shuffle(Random());
      if (candidates.isNotEmpty) _eliminatedPos = candidates.first;
    }
  }

  void _playHint() =>
      AudioService.instance.play(_it.audio, grade: widget.unit.grade);

  void _pick(int pos) {
    if (_correctIndices.contains(_index) ||
        _feedback == AnswerFeedback.wrong ||
        _usedPositions.contains(pos) ||
        pos == _eliminatedPos ||
        answerLockActive) {
      return;
    }
    final target = _it.answer[_filledCount];
    if (_options[pos] == target) {
      resetWrongStreak();
      final completing = _filledCount + 1 >= _it.hiddenIdx.length;
      setState(() {
        _usedPositions.add(pos);
        _filledCount++;
        _wrongPick = null;
        if (completing) {
          _correctIndices.add(_index);
          _feedback = AnswerFeedback.correct;
        }
      });
      AudioService.instance.playSfx('correct.mp3');
      if (completing) {
        AudioService.instance.play(_it.audio, grade: widget.unit.grade);
        Future.delayed(const Duration(milliseconds: 1100), () {
          if (!mounted || _feedback != AnswerFeedback.correct) return;
          setState(() => _feedback = null);
        });
      } else {
        _recomputeEliminated();
      }
    } else {
      registerWrongAnswer();
      setState(() {
        _wrongPick = pos;
        _feedback = AnswerFeedback.wrong;
      });
      AudioService.instance.playSfx('wrong.mp3');
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted || _feedback != AnswerFeedback.wrong) return;
        setState(() {
          _feedback = null;
          _wrongPick = null;
          _order.shuffle(Random());
          _recomputeEliminated();
        });
      });
    }
  }

  void _goTo(int newIndex) {
    setState(() {
      _index = newIndex;
      _prepare();
      // Quay lại 1 lượt ĐÃ đúng trước đó -> hiện lại đủ các ô đã điền.
      if (_correctIndices.contains(newIndex)) {
        _filledCount = _it.hiddenIdx.length;
      }
    });
    _playHint();
  }

  void _goBack() {
    if (_index > 0) _goTo(_index - 1);
  }

  void _goNext() {
    if (_index + 1 >= widget.items.length) {
      _showResult();
      return;
    }
    _goTo(_index + 1);
  }

  void _showResult() {
    final total = widget.items.length;
    final correct = _correctIndices.length;
    final stars = correct >= total ? 3 : (correct >= total * 0.6 ? 2 : 1);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
        title: const Text('Hoàn thành! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Đúng $correct/$total từ',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: AppSpacing.md),
            StarBar(stars: stars, size: 40),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // đóng dialog
              Navigator.of(context).pop(stars); // trả sao cho UnitScreen
            },
            child: const Text('Xong'),
          ),
        ],
      ),
    );
  }

  /// Ghép từng ký tự của [it.word] thành span riêng — vị trí trong
  /// `hiddenIdx` (có thể KHÔNG liền nhau, xem CR-020 BUGS_CR.md) hiện thành
  /// '_'/đáp án theo tiến độ [_filledCount] (điền theo thứ tự trái sang
  /// phải), ký tự còn lại giữ nguyên.
  List<InlineSpan> _wordSpans(FillItem it) {
    final spans = <InlineSpan>[];
    final buffer = StringBuffer();
    void flush() {
      if (buffer.isNotEmpty) {
        spans.add(TextSpan(text: buffer.toString()));
        buffer.clear();
      }
    }

    for (var i = 0; i < it.word.length; i++) {
      final hiddenPos = it.hiddenIdx.indexOf(i);
      if (hiddenPos == -1) {
        buffer.write(it.word[i]);
      } else {
        flush();
        final isFilled = hiddenPos < _filledCount;
        spans.add(TextSpan(
          text: isFilled ? it.answer[hiddenPos] : '_',
          style: TextStyle(
              color: isFilled ? AppColors.success : AppColors.primary),
        ));
      }
    }
    flush();
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final it = _it;

    return AppScaffold(
      backgroundColor: AppColors.unitColor(widget.unit.unitId),
      appBar: AppBar(
        backgroundColor: AppColors.info,
        foregroundColor: Colors.white,
        title: GameAppBarTitle(
            grade: widget.unit.grade,
            unitLabel: '${widget.unit.unitId}',
            gameName: 'Điền chữ'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text('Từ ${_index + 1}/${widget.items.length}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: PrimaryButton(
                  label: 'Nghe gợi ý',
                  icon: Icons.volume_up_rounded,
                  onPressed: _playHint,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                flex: 3,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: WordImage(
                      grade: widget.unit.grade, relativePath: it.image),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                  children: _wordSpans(it),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                alignment: WrapAlignment.center,
                children: [
                  for (final pos in _order)
                    if (!_usedPositions.contains(pos)) _letterTile(pos),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        label: 'Quay lại',
                        icon: Icons.arrow_back_rounded,
                        onPressed: _index > 0 ? _goBack : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: PrimaryButton(
                        label: 'Tiếp theo',
                        icon: Icons.arrow_forward_rounded,
                        onPressed:
                            _correctIndices.contains(_index) ? _goNext : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AnswerFeedbackOverlay(feedback: _feedback),
          WrongAnswerLockOverlay(
              active: answerLockActive, secondsLeft: answerLockCountdown),
        ],
      ),
    );
  }

  Widget _letterTile(int pos) {
    final letter = _options[pos];
    final eliminated = pos == _eliminatedPos;
    final wrong = _wrongPick == pos;
    return Opacity(
      opacity: eliminated ? 0.3 : 1,
      child: Material(
        color: wrong ? AppColors.error : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          onTap: eliminated ? null : () => _pick(pos),
          child: Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            child: Text(
              letter,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: wrong ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
