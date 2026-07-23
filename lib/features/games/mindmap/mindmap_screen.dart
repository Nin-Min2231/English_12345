import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/models/models.dart';
import '../../../services/audio_service.dart';
import '../../../services/settings_service.dart';

/// F10 / G06 — Mindmap hoàn thành câu: đọc câu mẫu khuyết 1 từ (`pattern` có
/// "___"), chạm đúng hình để điền từ hoàn thành câu. Cùng cơ chế chọn-đáp-án
/// với G02 (ListenPickScreen) — chỉ khác phần "hỏi" là chữ (đọc) thay vì audio
/// (nghe); xem CLAUDE.md §6 quy ước chung, SPRINT2_PLAN.md Phase 2.
class MindmapScreen extends StatefulWidget {
  final UnitInfo unit;
  final List<MindmapItem> items;

  const MindmapScreen({super.key, required this.unit, required this.items});

  @override
  State<MindmapScreen> createState() => _MindmapScreenState();
}

class _MindmapScreenState extends State<MindmapScreen> {
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

  MindmapItem get _it => widget.items[_index];

  void _prepareOrder() {
    _order = List<int>.generate(_it.options.length, (i) => i)
      ..shuffle(Random());
    _recomputeEliminated();
  }

  /// Độ khó Dễ: bớt 1 lựa chọn sai — xem ghi chú tương tự trong
  /// listen_pick_screen.dart.
  void _recomputeEliminated() {
    _eliminatedDisplayPos = null;
    if (SettingsService.instance.isEasy && _order.length > 2) {
      final wrongPositions = [
        for (var i = 0; i < _order.length; i++)
          if (_order[i] != _it.answerIdx) i
      ]..shuffle(Random());
      _eliminatedDisplayPos = wrongPositions.first;
    }
  }

  void _playPattern() => AudioService.instance.play(_it.audio);

  void _pick(int displayPos) {
    if (_answered ||
        _feedback == AnswerFeedback.wrong ||
        displayPos == _eliminatedDisplayPos) {
      return;
    }
    final actualIdx = _order[displayPos];
    if (actualIdx == _it.answerIdx) {
      setState(() {
        _answered = true;
        _wrongPick = null;
        _correctIndices.add(_index);
        _feedback = AnswerFeedback.correct;
      });
      AudioService.instance.play(_it.options[actualIdx].audio);
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
        backgroundColor: AppColors.error,
        foregroundColor: AppColors.textPrimary,
        title: Text('Hoàn thành câu • Unit ${widget.unit.unitId}'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
                child: Text('Câu ${_index + 1}/${widget.items.length}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                child: PrimaryButton(
                  label: 'Gợi ý',
                  icon: Icons.volume_up_rounded,
                  color: AppColors.error,
                  foregroundColor: AppColors.textPrimary,
                  onPressed: _playPattern,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
                child: Text(
                  _it.pattern,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  itemCount: _it.options.length,
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
                        color: AppColors.error,
                        foregroundColor: AppColors.textPrimary,
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
    final option = _it.options[actualIdx];
    final isAnswer = actualIdx == _it.answerIdx;
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
            child: Stack(
              children: [
                WordImage(relativePath: option.image),
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
