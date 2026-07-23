import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/models/models.dart';
import '../../../services/audio_service.dart';
import '../../../services/settings_service.dart';

/// F08 / G03 — Điền chữ cái thiếu (theo âm phonics). Chạm chữ đúng để điền
/// vào ô trống. Hỗ trợ digraph (sh, er) như một khối. Có hình + audio gợi ý.
/// Đúng: hiệu ứng + sang từ sau khi bấm "Tiếp theo". Sai: hiệu ứng nhẹ nhàng
/// + xáo trộn lại các lựa chọn, cho thử lại.
class FillLetterScreen extends StatefulWidget {
  final UnitInfo unit;
  final List<FillItem> items;

  const FillLetterScreen({super.key, required this.unit, required this.items});

  @override
  State<FillLetterScreen> createState() => _FillLetterScreenState();
}

class _FillLetterScreenState extends State<FillLetterScreen> {
  int _index = 0;
  // Từ đã điền đúng (index) — dùng tính sao, không đếm dồn khi xem lại.
  final Set<int> _correctIndices = {};
  bool _filled = false;
  String? _wrongPick;
  List<String> _options = [];
  // Độ khó Dễ: 1 đáp án nhiễu bị loại bớt làm gợi ý.
  String? _eliminatedLetter;
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
    _options = [_it.answer, ..._it.distractors]..shuffle(Random());
    _eliminatedLetter = null;
    if (SettingsService.instance.isEasy) {
      final distractors = _options.where((o) => o != _it.answer).toList();
      if (distractors.isNotEmpty) {
        _eliminatedLetter = (distractors..shuffle(Random())).first;
      }
    }
  }

  void _playHint() => AudioService.instance.play(_it.audio);

  void _pick(String letter) {
    if (_filled ||
        _feedback == AnswerFeedback.wrong ||
        letter == _eliminatedLetter) {
      return;
    }
    if (letter == _it.answer) {
      setState(() {
        _filled = true;
        _wrongPick = null;
        _correctIndices.add(_index);
        _feedback = AnswerFeedback.correct;
      });
      AudioService.instance.play(_it.audio);
      AudioService.instance.playSfx('correct.mp3');
      Future.delayed(const Duration(milliseconds: 1100), () {
        if (!mounted || _feedback != AnswerFeedback.correct) return;
        setState(() => _feedback = null);
      });
    } else {
      setState(() {
        _wrongPick = letter;
        _feedback = AnswerFeedback.wrong;
      });
      AudioService.instance.playSfx('wrong.mp3');
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted || _feedback != AnswerFeedback.wrong) return;
        setState(() {
          _feedback = null;
          _wrongPick = null;
          _options.shuffle(Random());
        });
      });
    }
  }

  void _goTo(int newIndex) {
    setState(() {
      _index = newIndex;
      _filled = _correctIndices.contains(newIndex);
      _wrongPick = null;
      _feedback = null;
      _prepare();
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

  @override
  Widget build(BuildContext context) {
    final it = _it;
    final prefix = it.word.substring(0, it.hiddenIdx.first);
    final suffix = it.word.substring(it.hiddenIdx.last + 1);
    final slot = _filled ? it.answer : '_' * it.hiddenIdx.length;

    return AppScaffold(
      backgroundColor: AppColors.unitColor(widget.unit.unitId),
      appBar: AppBar(
        backgroundColor: AppColors.info,
        foregroundColor: Colors.white,
        title: Text('Điền chữ • Unit ${widget.unit.unitId}'),
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
                  child: WordImage(relativePath: it.image),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                  children: [
                    TextSpan(text: prefix),
                    TextSpan(
                      text: slot,
                      style: TextStyle(
                          color:
                              _filled ? AppColors.success : AppColors.primary),
                    ),
                    TextSpan(text: suffix),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                alignment: WrapAlignment.center,
                children: _options.map(_letterTile).toList(),
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
                        onPressed: _filled ? _goNext : null,
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

  Widget _letterTile(String letter) {
    final isAnswer = letter == _it.answer;
    final eliminated = letter == _eliminatedLetter;
    Color bg = AppColors.surface;
    if (_filled && isAnswer) {
      bg = AppColors.success;
    } else if (_wrongPick == letter) {
      bg = AppColors.error;
    }
    final light = (_filled && isAnswer) || _wrongPick == letter;
    return Opacity(
      opacity: eliminated ? 0.3 : 1,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          onTap: eliminated ? null : () => _pick(letter),
          child: Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            child: Text(
              letter,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: light ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
