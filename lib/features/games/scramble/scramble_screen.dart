import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/models/models.dart';
import '../../../services/audio_service.dart';
import '../../../services/settings_service.dart';

/// F08 / G04 — Xếp chữ: chạm chữ cái xáo trộn để đặt vào ô trống tiếp theo;
/// chạm ô đã đặt để bỏ ra chọn lại. Âm ghép của unit (`sh`, `er`) được gộp
/// thành 1 ô duy nhất (xem CLAUDE.md §10). Cùng mô hình tương tác với G05
/// (xem CLAUDE.md §6, BUGS_CR.md CR-008): **không chấm đúng/sai ngay khi
/// chọn** — trẻ tự xếp xong cả từ rồi bấm "Kiểm tra" mới biết đúng/sai,
/// "Làm lại" xoá hết về trạng thái ban đầu.
class ScrambleScreen extends StatefulWidget {
  final UnitInfo unit;
  final List<ScrambleItem> items;

  const ScrambleScreen({super.key, required this.unit, required this.items});

  @override
  State<ScrambleScreen> createState() => _ScrambleScreenState();
}

class _ScrambleScreenState extends State<ScrambleScreen> {
  int _index = 0;
  final Set<int> _correctIndices = {};
  List<String> _answerTiles = [];
  List<String> _shuffledTiles = [];
  // slot[i] = vị trí (index) trong _shuffledTiles đang đặt ở ô thứ i, hoặc
  // null nếu ô còn trống.
  List<int?> _slots = [];
  // placed[j] = ô chữ ở vị trí j trong _shuffledTiles đã đặt vào 1 ô nào đó
  // chưa (dùng để ẩn khỏi khay chọn).
  List<bool> _placed = [];
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

  ScrambleItem get _it => widget.items[_index];
  bool get _isSolved => _correctIndices.contains(_index);
  bool get _allFilled => _slots.every((s) => s != null);

  /// Tách `word` thành các ô — âm ghép 2 ký tự của unit (`sh`/`er`) thành 1 ô.
  List<String> _tilesFor(String word) {
    final phonics = widget.unit.phonics;
    if (phonics.length == 2) {
      final idx = word.toLowerCase().indexOf(phonics.toLowerCase());
      if (idx != -1) {
        final tiles = <String>[];
        var i = 0;
        while (i < word.length) {
          if (i == idx) {
            tiles.add(word.substring(i, i + 2));
            i += 2;
          } else {
            tiles.add(word[i]);
            i++;
          }
        }
        return tiles;
      }
    }
    return word.split('');
  }

  void _prepare() {
    _answerTiles = _tilesFor(_it.word);
    _shuffledTiles = List.of(_answerTiles)..shuffle(Random());
    _placed = List.filled(_shuffledTiles.length, false);
    _slots = List<int?>.filled(_answerTiles.length, null);
    _feedback = null;
    if (_isSolved) {
      _fillAllFromAnswer();
    } else if (SettingsService.instance.isEasy) {
      _prefillFirstTile();
    }
  }

  /// Khôi phục cách xếp đúng khi quay lại từ đã hoàn thành — khớp giá trị
  /// (không phải vị trí gốc) để đúng cả với từ có chữ lặp lại (vd "popcorn").
  void _fillAllFromAnswer() {
    final used = List.filled(_shuffledTiles.length, false);
    for (var i = 0; i < _answerTiles.length; i++) {
      final want = _answerTiles[i];
      for (var p = 0; p < _shuffledTiles.length; p++) {
        if (!used[p] && _shuffledTiles[p] == want) {
          used[p] = true;
          _placed[p] = true;
          _slots[i] = p;
          break;
        }
      }
    }
  }

  /// Độ khó Dễ: tự điền sẵn ô chữ đầu tiên làm gợi ý khởi động.
  void _prefillFirstTile() {
    if (_answerTiles.isEmpty) return;
    final want = _answerTiles[0];
    for (var p = 0; p < _shuffledTiles.length; p++) {
      if (!_placed[p] && _shuffledTiles[p] == want) {
        _placed[p] = true;
        _slots[0] = p;
        break;
      }
    }
  }

  void _playHint() => AudioService.instance.play(_it.audio);

  bool get _locked => _isSolved || _feedback == AnswerFeedback.wrong;

  /// Chạm chữ còn trong khay chọn -> đặt vào ô trống đầu tiên.
  void _tapPoolTile(int poolIdx) {
    if (_locked || _placed[poolIdx]) return;
    final emptySlot = _slots.indexWhere((s) => s == null);
    if (emptySlot == -1) return;
    setState(() {
      _slots[emptySlot] = poolIdx;
      _placed[poolIdx] = true;
    });
  }

  /// Chạm chữ đã đặt trong từ -> bỏ ra lại khay chọn (xóa để chọn lại).
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
    final attempt = [for (final p in _slots) _shuffledTiles[p!]];
    var isCorrect = attempt.length == _answerTiles.length;
    if (isCorrect) {
      for (var i = 0; i < attempt.length; i++) {
        if (attempt[i] != _answerTiles[i]) {
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
      AudioService.instance.play(_it.audio);
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

  /// "Làm lại" — xóa hết về trạng thái ban đầu (chưa đặt chữ nào), xáo lại
  /// khay chọn cho mới.
  void _resetAttempt() {
    if (_isSolved) return;
    setState(() {
      _shuffledTiles = List.of(_answerTiles)..shuffle(Random());
      _placed = List.filled(_shuffledTiles.length, false);
      _slots = List<int?>.filled(_answerTiles.length, null);
      _feedback = null;
      if (SettingsService.instance.isEasy) _prefillFirstTile();
    });
  }

  void _goTo(int newIndex) {
    setState(() {
      _index = newIndex;
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
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
        title: Text('Xếp chữ • Unit ${widget.unit.unitId}'),
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
                  color: AppColors.success,
                  onPressed: _playHint,
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: WordImage(relativePath: _it.image),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                alignment: WrapAlignment.center,
                children: [
                  for (var i = 0; i < _slots.length; i++) _slotBox(i),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 2.4,
                  padding: EdgeInsets.zero,
                  children: [
                    for (var i = 0; i < _shuffledTiles.length; i++)
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
                        color: AppColors.success,
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
                        color: AppColors.success,
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

  Widget _slotBox(int slotIdx) {
    final poolIdx = _slots[slotIdx];
    final letter = poolIdx == null ? null : _shuffledTiles[poolIdx];
    return Material(
      color: letter == null ? AppColors.surface : AppColors.success,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        onTap: letter == null ? null : () => _tapSlot(slotIdx),
        child: Container(
          width: 40,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: AppColors.textSecondary, width: 1.5),
          ),
          child: Text(
            letter ?? '',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: letter == null ? Colors.transparent : Colors.white,
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
              _shuffledTiles[poolIdx],
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
