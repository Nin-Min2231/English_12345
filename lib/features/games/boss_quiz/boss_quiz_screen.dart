import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/models/models.dart';
import '../../../services/audio_service.dart';
import '../../../services/settings_service.dart';

/// F13 / G12 — Boss Quiz: trộn câu hỏi đã có sẵn từ G02 (nghe chọn hình)/G03
/// (điền chữ)/G05 (lắp câu) của 4 unit trước, sinh sẵn thành JSON tĩnh (xem
/// SPRINT3_PLAN.md Phase 3) — màn hình là bản sao gần như nguyên vẹn của
/// listen_pick_screen.dart, chỉ khác phần hiển thị prompt/lựa chọn phải xem
/// trường nào có giá trị (ảnh hay chữ) vì câu hỏi đến từ 3 nguồn khác nhau.
class BossQuizScreen extends StatefulWidget {
  final UnitInfo unit;
  final List<BossQuizQuestion> questions;
  final int fromUnit;
  final int toUnit;

  const BossQuizScreen({
    super.key,
    required this.unit,
    required this.questions,
    required this.fromUnit,
    required this.toUnit,
  });

  @override
  State<BossQuizScreen> createState() => _BossQuizScreenState();
}

class _BossQuizScreenState extends State<BossQuizScreen> {
  int _index = 0;
  final Set<int> _correctIndices = {};
  int? _wrongPick;
  bool _answered = false;
  AnswerFeedback? _feedback;
  List<int> _order = [];
  int? _eliminatedDisplayPos;

  @override
  void initState() {
    super.initState();
    _prepareOrder();
  }

  @override
  void dispose() {
    AudioService.instance.stop();
    super.dispose();
  }

  BossQuizQuestion get _q => widget.questions[_index];

  void _prepareOrder() {
    _order = List<int>.generate(_q.options.length, (i) => i)..shuffle(Random());
    _recomputeEliminated();
  }

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

  void _playPrompt() {
    if (_q.promptAudio != null) {
      AudioService.instance.play(_q.promptAudio, grade: widget.unit.grade);
    }
  }

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
        backgroundColor: AppColors.errorDark,
        foregroundColor: Colors.white,
        title: Text('Boss Quiz • Unit ${widget.fromUnit}-${widget.toUnit}'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text('Câu ${_index + 1}/${widget.questions.length}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              _promptArea(),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  itemCount: _q.options.length,
                  itemBuilder: (context, i) => _optionTile(i),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
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
                        color: AppColors.errorDark,
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

  /// Phần "hỏi" — tùy nguồn câu hỏi mà có ảnh, audio, chữ, hoặc cả 2.
  Widget _promptArea() {
    final children = <Widget>[];
    if (_q.promptImage != null) {
      children.add(SizedBox(
        height: 100,
        child:
            WordImage(grade: widget.unit.grade, relativePath: _q.promptImage!),
      ));
    }
    if (_q.promptText != null) {
      children.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Text(
          _q.promptText!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ));
    }
    if (_q.promptAudio != null) {
      children.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: PrimaryButton(
          label: 'Nghe',
          icon: Icons.volume_up_rounded,
          color: AppColors.errorDark,
          onPressed: _playPrompt,
        ),
      ));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(children: children),
    );
  }

  Widget _optionTile(int displayPos) {
    final actualIdx = _order[displayPos];
    final option = _q.options[actualIdx];
    final isAnswer = actualIdx == _q.answerIdx;
    final eliminated = displayPos == _eliminatedDisplayPos;
    Color border = Colors.transparent;
    if (_answered && isAnswer) {
      border = AppColors.success;
    } else if (_wrongPick == displayPos) {
      border = AppColors.error;
    }
    return Opacity(
      opacity: eliminated ? 0.3 : 1,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          onTap: eliminated ? null : () => _pick(displayPos),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: border, width: 4),
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (option.image != null)
                  WordImage(
                      grade: widget.unit.grade, relativePath: option.image!),
                if (option.text != null)
                  // CR-023: FittedBox co chữ lại cho vừa ô — câu hỏi nguồn
                  // G05 (lắp câu) có thể dài hơn nhiều so với 1 chữ nguồn G03,
                  // tránh tràn/cắt chữ trên ô vuông cố định (cùng cách xử lý
                  // với G10 letter_hunt_screen.dart).
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        option.text!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                if (_answered && isAnswer)
                  const Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.check_circle,
                        color: AppColors.success, size: 32),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
