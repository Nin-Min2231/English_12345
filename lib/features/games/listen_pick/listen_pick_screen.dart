import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/models/models.dart';
import '../../../services/audio_service.dart';

/// F07 / G02 — Nghe chọn hình. Phát audio → chọn 1 trong các hình.
/// Đúng: xanh + phát âm lại + hiệu ứng + sang câu sau khi bấm "Tiếp theo".
/// Sai: hiệu ứng nhẹ nhàng + xáo trộn lại vị trí các hình, cho thử lại.
class ListenPickScreen extends StatefulWidget {
  final UnitInfo unit;
  final List<ListenQuestion> questions;

  const ListenPickScreen(
      {super.key, required this.unit, required this.questions});

  @override
  State<ListenPickScreen> createState() => _ListenPickScreenState();
}

class _ListenPickScreenState extends State<ListenPickScreen> {
  int _index = 0;
  // Câu đã trả lời đúng (index) — dùng tính sao, không đếm dồn khi xem lại.
  final Set<int> _correctIndices = {};
  int? _wrongPick; // vị trí (display) vừa chọn sai
  bool _answered = false;
  AnswerFeedback? _feedback;
  // Vị trí hiển thị -> index thật trong _q.options (xáo trộn khi vào câu mới
  // hoặc sau khi chọn sai, để trẻ không nhớ vị trí mà đoán mò).
  List<int> _order = [];

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

  ListenQuestion get _q => widget.questions[_index];

  void _prepareOrder() {
    _order = List<int>.generate(_q.options.length, (i) => i)..shuffle(Random());
  }

  void _playPrompt() => AudioService.instance.play(_q.promptAudio);

  void _pick(int displayPos) {
    if (_answered) return;
    final actualIdx = _order[displayPos];
    if (actualIdx == _q.answerIdx) {
      setState(() {
        _answered = true;
        _wrongPick = null;
        _correctIndices.add(_index);
        _feedback = AnswerFeedback.correct;
      });
      AudioService.instance.play(_q.promptAudio);
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
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        title: Text('Nghe chọn hình • Unit ${widget.unit.unitId}'),
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
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: PrimaryButton(
                  label: 'Nghe',
                  icon: Icons.volume_up_rounded,
                  onPressed: _playPrompt,
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
    final option = _q.options[actualIdx];
    final isAnswer = actualIdx == _q.answerIdx;
    Color border = Colors.transparent;
    if (_answered && isAnswer) {
      border = AppColors.success;
    } else if (_wrongPick == displayPos) {
      border = AppColors.error;
    }
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        onTap: () => _pick(displayPos),
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
    );
  }
}
