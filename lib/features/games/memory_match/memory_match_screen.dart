import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/models/models.dart';
import '../../../services/audio_service.dart';
import '../../../services/settings_service.dart';

enum _CardKind { image, word }

class _MemCard {
  final int pairIndex;
  final _CardKind kind;
  final MemoryPairItem item;
  const _MemCard(this.pairIndex, this.kind, this.item);
}

/// F11 / G09 — "Lật thẻ" (đổi tên từ "Fun Time", CR-023): lật cặp thẻ hình-từ
/// (memory match). Gắn vào 1 unit checkpoint (sau Unit 2/6/10/14, xem
/// checkpoints.dart), không phải mọi unit như G01-G10. Khác quy ước "chọn sai
/// thì xáo trộn" (CR-002): board KHÔNG xáo lại vị trí khi lật sai — xáo sẽ
/// phá hỏng ý nghĩa của trò nhớ vị trí.
/// Độ khó Dễ (CR-021): xem trước toàn bộ thẻ vài giây lúc mới vào màn hình —
/// không khớp 2 mẫu độ khó chuẩn (không có "lựa chọn sai" để làm mờ, không có
/// "ô/token" để điền sẵn, xem CLAUDE.md §6) nên dùng cơ chế riêng phù hợp hơn
/// với bản chất trò nhớ vị trí: "bớt trở ngại" bằng cách hé lộ tạm thời.
/// CR-023: mở khóa chặt hơn (`isFunTimeUnlocked` — cần MỌI game của cả 2 unit
/// trong phạm vi ôn tập, không chỉ 4 game lõi); công thức sao rộng rãi hơn để
/// khuyến khích trẻ; lưới thẻ phóng to gần lấp đầy màn hình (`LayoutBuilder`).
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
  static const _previewDuration = Duration(seconds: 4);

  late List<_MemCard> _cards;
  late List<bool> _matched;
  int? _firstFlipped;
  int? _secondFlipped;
  bool _locked = false;
  int _attempts = 0;
  AnswerFeedback? _feedback;
  // Độ khó Dễ: true trong vài giây đầu — mọi thẻ lật ngửa, chưa chạm được.
  bool _previewing = false;

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
    _previewing = SettingsService.instance.isEasy;
    if (_previewing) {
      Future.delayed(_previewDuration, () {
        if (!mounted) return;
        setState(() => _previewing = false);
      });
    }
  }

  @override
  void dispose() {
    AudioService.instance.stop();
    super.dispose();
  }

  bool get _allMatched => _matched.every((m) => m);
  int get _matchedPairs => _matched.where((m) => m).length ~/ 2;

  void _tap(int pos) {
    if (_previewing || _locked || _matched[pos] || pos == _firstFlipped) {
      return;
    }
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
    // CR-023: nới rộng mốc tính sao (trước đây _attempts<=pairs mới được 3
    // sao — gần như phải chơi hoàn hảo, quá khó) để khuyến khích trẻ hơn.
    final stars = _attempts <= pairs * 2 ? 3 : (_attempts <= pairs * 3 ? 2 : 1);
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
        title: Text('Lật thẻ • Unit ${widget.fromUnit}-${widget.toUnit}'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                child: Text(
                  _previewing
                      ? 'Ghi nhớ vị trí các cặp nhé!'
                      : 'Lượt: $_attempts  •  Đã ghép: $_matchedPairs/${widget.pairs.length} cặp',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: _cardGrid(),
                ),
              ),
            ],
          ),
          AnswerFeedbackOverlay(feedback: _feedback),
        ],
      ),
    );
  }

  static const _crossAxisCount = 4;

  /// Lưới thẻ phóng to gần lấp đầy màn hình (CR-023) — `GridView.count` mặc
  /// định ô vuông tính theo bề rộng, để trống nhiều khoảng dưới nếu số hàng
  /// ít hơn chiều cao sẵn có. Dùng `LayoutBuilder` đo đúng không gian thật rồi
  /// tính `childAspectRatio` để ô kéo giãn lấp cả chiều cao lẫn chiều rộng.
  Widget _cardGrid() {
    return LayoutBuilder(builder: (context, constraints) {
      const spacing = AppSpacing.sm;
      final rows = (_cards.length / _crossAxisCount).ceil();
      final cellWidth =
          (constraints.maxWidth - spacing * (_crossAxisCount - 1)) /
              _crossAxisCount;
      final cellHeight = (constraints.maxHeight - spacing * (rows - 1)) / rows;
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: cellWidth / cellHeight,
        ),
        itemCount: _cards.length,
        itemBuilder: (context, i) => _cardTile(i),
      );
    });
  }

  Widget _cardTile(int pos) {
    final card = _cards[pos];
    final faceUp = _previewing ||
        _matched[pos] ||
        pos == _firstFlipped ||
        pos == _secondFlipped;
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
                    color: AppColors.textSecondary, size: 40)
                : card.kind == _CardKind.image
                    ? WordImage(relativePath: card.item.image)
                    : FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          card.item.word,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
