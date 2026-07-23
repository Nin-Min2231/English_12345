import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/models/models.dart';
import '../../../services/audio_service.dart';

enum _CardKind { image, word }

class _MemCard {
  final int pairIndex;
  final _CardKind kind;
  final MemoryPairItem item;
  const _MemCard(this.pairIndex, this.kind, this.item);
}

/// F11 / G09 — Fun Time: lật cặp thẻ hình-từ (memory match). Gắn vào 1 unit
/// checkpoint (sau Unit 2/6/10/14, xem checkpoints.dart), không phải mọi
/// unit như G01-G10. Khác quy ước "chọn sai thì xáo trộn" (CR-002): board KHÔNG
/// xáo lại vị trí khi lật sai — xáo sẽ phá hỏng ý nghĩa của trò nhớ vị trí.
class MemoryMatchScreen extends StatefulWidget {
  final UnitInfo unit;
  final List<MemoryPairItem> pairs;
  final int fromUnit;
  final int toUnit;

  const MemoryMatchScreen({
    super.key,
    required this.unit,
    required this.pairs,
    required this.fromUnit,
    required this.toUnit,
  });

  @override
  State<MemoryMatchScreen> createState() => _MemoryMatchScreenState();
}

class _MemoryMatchScreenState extends State<MemoryMatchScreen> {
  late List<_MemCard> _cards;
  late List<bool> _matched;
  int? _firstFlipped;
  int? _secondFlipped;
  bool _locked = false;
  int _attempts = 0;
  AnswerFeedback? _feedback;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  void _prepare() {
    _cards = [];
    for (var i = 0; i < widget.pairs.length; i++) {
      _cards.add(_MemCard(i, _CardKind.image, widget.pairs[i]));
      _cards.add(_MemCard(i, _CardKind.word, widget.pairs[i]));
    }
    _cards.shuffle(Random());
    _matched = List.filled(_cards.length, false);
    _firstFlipped = null;
    _secondFlipped = null;
    _locked = false;
    _attempts = 0;
    _feedback = null;
  }

  @override
  void dispose() {
    AudioService.instance.stop();
    super.dispose();
  }

  bool get _allMatched => _matched.every((m) => m);
  int get _matchedPairs => _matched.where((m) => m).length ~/ 2;

  void _tap(int pos) {
    if (_locked || _matched[pos] || pos == _firstFlipped) return;
    if (_firstFlipped == null) {
      setState(() => _firstFlipped = pos);
      return;
    }
    final a = _firstFlipped!;
    final isMatch = _cards[a].pairIndex == _cards[pos].pairIndex &&
        _cards[a].kind != _cards[pos].kind;
    setState(() {
      _secondFlipped = pos;
      _locked = true;
      _attempts++;
      _feedback = isMatch ? AnswerFeedback.correct : AnswerFeedback.wrong;
      if (isMatch) {
        _matched[a] = true;
        _matched[pos] = true;
      }
    });
    if (isMatch) {
      AudioService.instance.playSfx('correct.mp3');
      AudioService.instance.play(_cards[a].item.audio);
    } else {
      AudioService.instance.playSfx('wrong.mp3');
    }
    Future.delayed(Duration(milliseconds: isMatch ? 900 : 800), () {
      if (!mounted) return;
      setState(() {
        _feedback = null;
        _firstFlipped = null;
        _secondFlipped = null;
        _locked = false;
      });
      if (isMatch && _allMatched) _showResult();
    });
  }

  void _showResult() {
    final pairs = widget.pairs.length;
    final stars = _attempts <= pairs ? 3 : (_attempts <= pairs * 2 ? 2 : 1);
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
            Text('Ghép xong sau $_attempts lượt',
                style: const TextStyle(fontSize: 16)),
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
        backgroundColor: AppColors.successDark,
        foregroundColor: Colors.white,
        title: Text('Fun Time • Unit ${widget.fromUnit}-${widget.toUnit}'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  'Lượt: $_attempts  •  Đã ghép: $_matchedPairs/${widget.pairs.length} cặp',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: AppSpacing.sm,
                      mainAxisSpacing: AppSpacing.sm,
                    ),
                    itemCount: _cards.length,
                    itemBuilder: (context, i) => _cardTile(i),
                  ),
                ),
              ),
            ],
          ),
          AnswerFeedbackOverlay(feedback: _feedback),
        ],
      ),
    );
  }

  Widget _cardTile(int pos) {
    final card = _cards[pos];
    final faceUp =
        _matched[pos] || pos == _firstFlipped || pos == _secondFlipped;
    return Material(
      color: _matched[pos]
          ? AppColors.success.withValues(alpha: 0.25)
          : AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        onTap: faceUp ? null : () => _tap(pos),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Center(
            child: !faceUp
                ? const Icon(Icons.help_outline_rounded,
                    color: AppColors.textSecondary, size: 28)
                : card.kind == _CardKind.image
                    ? WordImage(relativePath: card.item.image)
                    : Text(
                        card.item.word,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
          ),
        ),
      ),
    );
  }
}
