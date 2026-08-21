import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/models/models.dart';
import '../../../services/audio_service.dart';
import '../../../services/settings_service.dart';

/// F10 / G05 — Lắp ráp câu: chạm token (từ) xáo trộn để đặt vào chỗ trống
/// theo thứ tự trái sang phải; chạm token đã đặt để bỏ ra chọn lại. Khác G04:
/// **không chấm đúng/sai ngay khi chọn** — trẻ tự xếp xong cả câu rồi bấm
/// "Kiểm tra" mới biết đúng/sai (để có thể thử nhiều cách sắp xếp trước khi
/// chốt), "Làm lại" xoá hết về trạng thái ban đầu. Không có ảnh minh họa
/// riêng (config không có trường `image`) — gợi ý duy nhất là audio mẫu câu
/// dùng chung cả unit (xem CLAUDE.md §5, SPRINT2_PLAN.md Phase 2, BUGS_CR.md
/// CR-008).
class SentenceBuildScreen extends StatefulWidget {
  final UnitInfo unit;
  final List<SentenceItem> items;

  const SentenceBuildScreen(
      {super.key, required this.unit, required this.items});

  @override
  State<SentenceBuildScreen> createState() => _SentenceBuildScreenState();
}

class _SentenceBuildScreenState extends State<SentenceBuildScreen> {
  int _index = 0;
  final Set<int> _correctIndices = {};
  List<String> _answerTokens = [];
  List<String> _shuffledTokens = [];
  // slot[i] = vị trí (index) trong _shuffledTokens đang đặt ở ô thứ i, hoặc
  // null nếu ô còn trống.
  List<int?> _slots = [];
  // placed[j] = token ở vị trí j trong _shuffledTokens đã được đặt vào 1 ô
  // nào đó chưa (dùng để ẩn khỏi khay chọn).
  List<bool> _placed = [];
  AnswerFeedback? _feedback;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  @override
  void dispose() {
    AudioService.instance.stop();
    super.dispose();
  }

  SentenceItem get _it => widget.items[_index];
  bool get _isSolved => _correctIndices.contains(_index);
  bool get _allFilled => _slots.every((s) => s != null);

  void _prepare() {
    _answerTokens = _it.tokens;
    _shuffledTokens = List.of(_answerTokens)..shuffle(Random());
    _placed = List.filled(_shuffledTokens.length, false);
    _slots = List<int?>.filled(_answerTokens.length, null);
    _feedback = null;
    if (_isSolved) {
      _fillAllFromAnswer();
    } else if (SettingsService.instance.isEasy) {
      _prefillFirstToken();
    }
  }

  /// Khôi phục cách xếp đúng khi quay lại câu đã hoàn thành — khớp giá trị
  /// (không phải vị trí gốc) để đúng cả với câu có từ lặp lại (vd "the").
  void _fillAllFromAnswer() {
    final used = List.filled(_shuffledTokens.length, false);
    for (var i = 0; i < _answerTokens.length; i++) {
      final want = _answerTokens[i];
      for (var p = 0; p < _shuffledTokens.length; p++) {
        if (!used[p] && _shuffledTokens[p] == want) {
          used[p] = true;
          _placed[p] = true;
          _slots[i] = p;
          break;
        }
      }
    }
  }

  /// Độ khó Dễ: tự điền sẵn token đầu tiên làm gợi ý khởi động.
  void _prefillFirstToken() {
    if (_answerTokens.isEmpty) return;
    final want = _answerTokens[0];
    for (var p = 0; p < _shuffledTokens.length; p++) {
      if (!_placed[p] && _shuffledTokens[p] == want) {
        _placed[p] = true;
        _slots[0] = p;
        break;
      }
    }
  }

  void _playHint() =>
      AudioService.instance.play(_it.audio, grade: widget.unit.grade);

  bool get _locked => _isSolved || _feedback == AnswerFeedback.wrong;

  /// Chạm token còn trong khay chọn -> đặt vào ô trống đầu tiên.
  void _tapPoolTile(int poolIdx) {
    if (_locked || _placed[poolIdx]) return;
    final emptySlot = _slots.indexWhere((s) => s == null);
    if (emptySlot == -1) return;
    setState(() {
      _slots[emptySlot] = poolIdx;
      _placed[poolIdx] = true;
    });
  }

  /// Chạm token đã đặt trong câu -> bỏ ra lại khay chọn (xóa để chọn lại).
  void _tapSlot(int slotIdx) {
    if (_locked) return;
    final poolIdx = _slots[slotIdx];
    if (poolIdx == null) return;
    setState(() {
      _slots[slotIdx] = null;
      _placed[poolIdx] = false;
    });
  }

  void _checkAnswer() {
    if (!_allFilled || _isSolved) return;
    final attempt = [for (final p in _slots) _shuffledTokens[p!]];
    var isCorrect = attempt.length == _answerTokens.length;
    if (isCorrect) {
      for (var i = 0; i < attempt.length; i++) {
        if (attempt[i] != _answerTokens[i]) {
          isCorrect = false;
          break;
        }
      }
    }
    setState(() {
      _feedback = isCorrect ? AnswerFeedback.correct : AnswerFeedback.wrong;
      if (isCorrect) _correctIndices.add(_index);
    });
    if (isCorrect) {
      AudioService.instance.playSfx('correct.mp3');
      Future.delayed(const Duration(milliseconds: 1100), () {
        if (!mounted || _feedback != AnswerFeedback.correct) return;
        setState(() => _feedback = null);
      });
    } else {
      AudioService.instance.playSfx('wrong.mp3');
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted || _feedback != AnswerFeedback.wrong) return;
        setState(() => _feedback = null);
      });
    }
  }

  /// "Làm lại" — xóa hết về trạng thái ban đầu (chưa đặt token nào), xáo lại
  /// khay chọn cho mới.
  void _resetAttempt() {
    if (_isSolved) return;
    setState(() {
      _shuffledTokens = List.of(_answerTokens)..shuffle(Random());
      _placed = List.filled(_shuffledTokens.length, false);
      _slots = List<int?>.filled(_answerTokens.length, null);
      _feedback = null;
      if (SettingsService.instance.isEasy) _prefillFirstToken();
    });
  }

  void _goTo(int newIndex) {
    setState(() {
      _index = newIndex;
      _prepare();
    });
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
            Text('Đúng $correct/$total câu',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: AppSpacing.md),
            StarBar(stars: stars, size: 40),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(stars);
            },
            child: const Text('Xong'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColors.unitColor(widget.unit.unitId),
      appBar: AppBar(
        backgroundColor: AppColors.warning,
        foregroundColor: AppColors.textPrimary,
        title: Text('Lắp ráp câu • Unit ${widget.unit.unitId}'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text('Câu ${_index + 1}/${widget.items.length}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: PrimaryButton(
                  label: 'Gợi ý',
                  icon: Icons.volume_up_rounded,
                  color: AppColors.warning,
                  foregroundColor: AppColors.textPrimary,
                  onPressed: _playHint,
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        for (var i = 0; i < _slots.length; i++) _slotSpan(i),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 2.8,
                  padding: EdgeInsets.zero,
                  children: [
                    for (var i = 0; i < _shuffledTokens.length; i++)
                      _poolTile(i),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        label: 'Làm lại',
                        icon: Icons.refresh_rounded,
                        onPressed: _isSolved ? null : _resetAttempt,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: PrimaryButton(
                        label: 'Kiểm tra',
                        icon: Icons.check_rounded,
                        color: AppColors.warning,
                        foregroundColor: AppColors.textPrimary,
                        onPressed:
                            (_allFilled && !_isSolved) ? _checkAnswer : null,
                      ),
                    ),
                  ],
                ),
              ),
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
                        color: AppColors.warning,
                        foregroundColor: AppColors.textPrimary,
                        onPressed: _isSolved ? _goNext : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AnswerFeedbackOverlay(feedback: _feedback),
        ],
      ),
    );
  }

  /// 1 ô trong câu đang ghép: có token thì hiện chữ (chạm để bỏ ra), trống
  /// thì hiện gạch chân mờ — cùng nối liền dòng với nhau như câu văn thật.
  Widget _slotSpan(int slotIdx) {
    final poolIdx = _slots[slotIdx];
    if (poolIdx == null) {
      return const Text(
        '___',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
      );
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        onTap: () => _tapSlot(slotIdx),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            _shuffledTokens[poolIdx],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.warning,
              decorationThickness: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _poolTile(int poolIdx) {
    final placed = _placed[poolIdx];
    return Visibility(
      visible: !placed,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          onTap: () => _tapPoolTile(poolIdx),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text(
              _shuffledTokens[poolIdx],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
