import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/models/models.dart';
import '../../../services/audio_service.dart';
import '../../../services/settings_service.dart';

/// F11 / G10 — Săn chữ (đổi mới, CR-020): nghe 1 từ vựng → chọn đúng từ đó
/// trong 6 đáp án CHỮ (không phải hình như G02, không phải chữ cái đơn lẻ
/// như bản cũ). `options[]` gộp từ vựng unit hiện tại + unit liền trước
/// (Unit 1 dùng 3 đại từ You/He/She, xem WordHuntQuestion/content_repository).
/// Vào màn hình tự phát audio ngay + có nút "Nghe lại". Mẫu chọn-đáp-án chuẩn
/// (chấm ngay, xáo trộn khi sai, chốt chặn BUG-003) — giống hệt
/// listen_pick_screen.dart (G02), chỉ khác hiển thị chữ thay vì hình.
/// CR-022: F11 (`03_Mô tả tính năng.xlsx`) yêu cầu "săn chữ có thưởng" — CR-020
/// đã bỏ hẳn cơ chế thưởng cũ khi đổi mẫu. Khôi phục bằng cách hiện hình +
/// audio của câu hỏi ĐẦU TIÊN trong unit (giống quy ước "thưởng = từ đầu unit"
/// của bản cũ) như 1 phần thưởng nhỏ trong dialog hoàn thành.
class LetterHuntScreen extends StatefulWidget {
  final UnitInfo unit;
  final List<WordHuntQuestion> questions;

  const LetterHuntScreen(
      {super.key, required this.unit, required this.questions});

  @override
  State<LetterHuntScreen> createState() => _LetterHuntScreenState();
}

class _LetterHuntScreenState extends State<LetterHuntScreen> {
  int _index = 0;
  // Từ đã trả lời đúng (index) — dùng tính sao, không đếm dồn khi xem lại.
  final Set<int> _correctIndices = {};
  int? _wrongPick; // vị trí (display) vừa chọn sai
  bool _answered = false;
  AnswerFeedback? _feedback;
  // Vị trí hiển thị -> index thật trong _q.options (xáo trộn khi vào câu mới
  // hoặc sau khi chọn sai) — giống hệt listen_pick_screen.dart.
  List<int> _order = [];
  // Độ khó Dễ: bớt 1 lựa chọn sai (vị trí hiển thị) làm gợi ý.
  int? _eliminatedDisplayPos;

  @override
  void initState() {
    super.initState();
    _prepareOrder();
    WidgetsBinding.instance.addPostFrameCallback((_) => _playPrompt());
  }

  @override
  void dispose() {
    AudioService.instance.stop();
    super.dispose();
  }

  WordHuntQuestion get _q => widget.questions[_index];

  void _prepareOrder() {
    _order = List<int>.generate(_q.options.length, (i) => i)..shuffle(Random());
    _recomputeEliminated();
  }

  /// Độ khó Dễ: chọn 1 vị trí hiển thị đang giữ lựa chọn SAI để loại bớt.
  /// Phải gọi lại mỗi khi `_order` đổi — xem listen_pick_screen.dart.
  void _recomputeEliminated() {
    _eliminatedDisplayPos = null;
    if (SettingsService.instance.isEasy && _order.length > 2) {
      final wrongPositions = [
        for (var i = 0; i < _order.length; i++)
          if (_order[i] != _q.answerIdx) i
      ]..shuffle(Random());
      _eliminatedDisplayPos = wrongPositions.first;
    }
  }

  void _playPrompt() =>
      AudioService.instance.play(_q.promptAudio, grade: widget.unit.grade);

  void _pick(int displayPos) {
    if (_answered ||
        _feedback == AnswerFeedback.wrong ||
        displayPos == _eliminatedDisplayPos) {
      return;
    }
    final actualIdx = _order[displayPos];
    if (actualIdx == _q.answerIdx) {
      setState(() {
        _answered = true;
        _wrongPick = null;
        _correctIndices.add(_index);
        _feedback = AnswerFeedback.correct;
      });
      AudioService.instance.play(_q.promptAudio, grade: widget.unit.grade);
      AudioService.instance.playSfx('correct.mp3');
      Future.delayed(const Duration(milliseconds: 1100), () {
        if (!mounted || _feedback != AnswerFeedback.correct) return;
        setState(() => _feedback = null);
      });
    } else {
      setState(() {
        _wrongPick = displayPos;
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
      _answered = _correctIndices.contains(newIndex);
      _wrongPick = null;
      _feedback = null;
      _prepareOrder();
    });
    _playPrompt();
  }

  void _goBack() {
    if (_index > 0) _goTo(_index - 1);
  }

  void _goNext() {
    if (_index + 1 >= widget.questions.length) {
      _showResult();
      return;
    }
    _goTo(_index + 1);
  }

  void _showResult() {
    final total = widget.questions.length;
    final correct = _correctIndices.length;
    // G10 tối đa 2 sao (không phải 3) theo catalog gốc — xem
    // progress_repository.dart _maxStarsByGameType.
    final stars = correct >= total ? 2 : 1;
    // Phần thưởng (CR-022, khôi phục tiêu chí F11 "săn chữ có thưởng") — từ
    // đầu tiên của unit, giống quy ước thưởng của bản cũ trước CR-020.
    final reward = widget.questions.first;
    AudioService.instance.play(reward.promptAudio, grade: widget.unit.grade);
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
            const SizedBox(height: AppSpacing.lg),
            const Text('Phần thưởng cho bạn! 🎁',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
                height: 100,
                child: WordImage(
                    grade: widget.unit.grade, relativePath: reward.image)),
            const SizedBox(height: AppSpacing.xs),
            Text(reward.word,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColors.unitColor(widget.unit.unitId),
      appBar: AppBar(
        backgroundColor: AppColors.secondaryDark,
        foregroundColor: Colors.white,
        title: Text('Săn chữ • Unit ${widget.unit.unitId}'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text('Từ ${_index + 1}/${widget.questions.length}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: PrimaryButton(
                  label: 'Nghe lại',
                  icon: Icons.volume_up_rounded,
                  color: AppColors.secondaryDark,
                  onPressed: _playPrompt,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text(
                  'Lựa chọn đáp án đúng với từ đã nghe',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  // CR-023: đổi từ Wrap (mỗi từ dài chiếm hẳn 1 dòng) sang
                  // lưới 2 cột cố định, giống G04/G12 — chữ tự co lại
                  // (FittedBox trong _optionTile) để 2 đáp án luôn nằm cùng
                  // 1 dòng dù từ dài (vd "grandmother").
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 2.4,
                    children:
                        List.generate(_q.options.length, (i) => _optionTile(i)),
                  ),
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
                        color: AppColors.secondaryDark,
                        onPressed: _answered ? _goNext : null,
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

  Widget _optionTile(int displayPos) {
    final actualIdx = _order[displayPos];
    final word = _q.options[actualIdx];
    final isAnswer = actualIdx == _q.answerIdx;
    final eliminated = displayPos == _eliminatedDisplayPos;
    Color bg = AppColors.surface;
    if (_answered && isAnswer) {
      bg = AppColors.success;
    } else if (_wrongPick == displayPos) {
      bg = AppColors.error;
    }
    final light = (_answered && isAnswer) || _wrongPick == displayPos;
    return Opacity(
      opacity: eliminated ? 0.3 : 1,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          onTap: eliminated ? null : () => _pick(displayPos),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            alignment: Alignment.center,
            // FittedBox co chữ lại cho vừa ô — cần thiết vì lưới 2 cột cố
            // định chiều rộng trong khi từ vựng dài ngắn khác nhau nhiều
            // (vd "he" so với "grandmother").
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                word,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: light ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
