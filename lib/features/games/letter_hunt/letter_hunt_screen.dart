import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/models/models.dart';
import '../../../services/audio_service.dart';
import '../../../services/settings_service.dart';

/// F11 / G10 — Săn chữ: tìm đúng chữ mục tiêu (âm phonics của unit) giữa các
/// chữ nhiễu, lặp lại 5 lượt (bắt đủ 5 lần đúng) để mở khóa hình thưởng. Theo
/// mẫu chọn-đáp-án chuẩn (giống G02) — không phải chữ rơi/di chuyển thật như
/// mô tả gốc, đơn giản hóa có chủ ý để tránh thêm animation/va chạm mới (xem
/// SPRINT3_PLAN.md Phase 2). Nút "Nghe gợi ý" phát audio từ thưởng (âm đầu từ
/// gần đúng âm phonics, không phải phát âm tách biệt — chưa có audio phonics
/// riêng lẻ).
class LetterHuntScreen extends StatefulWidget {
  final UnitInfo unit;
  final HuntLetterItem item;

  const LetterHuntScreen({super.key, required this.unit, required this.item});

  @override
  State<LetterHuntScreen> createState() => _LetterHuntScreenState();
}

class _LetterHuntScreenState extends State<LetterHuntScreen> {
  static const _target = 5;

  late List<String> _options;
  int _caught = 0;
  int _misses = 0;
  int? _wrongPick;
  bool _done = false;
  AnswerFeedback? _feedback;
  int? _eliminatedPos;

  HuntLetterItem get _item => widget.item;

  @override
  void initState() {
    super.initState();
    _prepareOptions();
  }

  @override
  void dispose() {
    AudioService.instance.stop();
    super.dispose();
  }

  void _prepareOptions() {
    _options = [_item.targetLetter, ..._item.distractors]..shuffle(Random());
    _recomputeEliminated();
  }

  /// Độ khó Dễ: loại 1 chữ nhiễu — xem listen_pick_screen.dart cùng cơ chế.
  void _recomputeEliminated() {
    _eliminatedPos = null;
    if (SettingsService.instance.isEasy) {
      final wrongPositions = [
        for (var i = 0; i < _options.length; i++)
          if (_options[i] != _item.targetLetter) i
      ]..shuffle(Random());
      _eliminatedPos = wrongPositions.first;
    }
  }

  void _playHint() => AudioService.instance.play(_item.rewardAudio);

  void _pick(int pos) {
    if (_done || _feedback == AnswerFeedback.wrong || pos == _eliminatedPos) {
      return;
    }
    final isCorrect = _options[pos] == _item.targetLetter;
    if (isCorrect) {
      setState(() {
        _wrongPick = null;
        _caught++;
        _feedback = AnswerFeedback.correct;
      });
      AudioService.instance.playSfx('correct.mp3');
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted || _feedback != AnswerFeedback.correct) return;
        final finished = _caught >= _target;
        setState(() {
          _feedback = null;
          if (finished) {
            _done = true;
          } else {
            _prepareOptions();
          }
        });
        if (finished) _showResult();
      });
    } else {
      setState(() {
        _wrongPick = pos;
        _misses++;
        _feedback = AnswerFeedback.wrong;
      });
      AudioService.instance.playSfx('wrong.mp3');
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted || _feedback != AnswerFeedback.wrong) return;
        setState(() {
          _feedback = null;
          _wrongPick = null;
          _options.shuffle(Random());
          _recomputeEliminated();
        });
      });
    }
  }

  void _showResult() {
    final stars = _misses == 0 ? 2 : 1;
    AudioService.instance.play(_item.rewardAudio);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
        title: const Text('Mở khóa phần thưởng! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                height: 120, child: WordImage(relativePath: _item.rewardImage)),
            const SizedBox(height: AppSpacing.sm),
            Text(_item.rewardWord,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                child: Text('Đã bắt: $_caught/$_target',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: PrimaryButton(
                  label: 'Nghe gợi ý',
                  icon: Icons.volume_up_rounded,
                  color: AppColors.secondaryDark,
                  onPressed: _playHint,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Tìm chữ: ${_item.targetLetter.toUpperCase()}',
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold)),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  itemCount: _options.length,
                  itemBuilder: (context, i) => _optionTile(i),
                ),
              ),
            ],
          ),
          AnswerFeedbackOverlay(feedback: _feedback),
        ],
      ),
    );
  }

  Widget _optionTile(int pos) {
    final letter = _options[pos];
    final eliminated = pos == _eliminatedPos;
    Color border = Colors.transparent;
    if (_wrongPick == pos) border = AppColors.error;
    return Opacity(
      opacity: eliminated ? 0.3 : 1,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          onTap: eliminated ? null : () => _pick(pos),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: border, width: 4),
            ),
            alignment: Alignment.center,
            child: Text(
              letter.toUpperCase(),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
