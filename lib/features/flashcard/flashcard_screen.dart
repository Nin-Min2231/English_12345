import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/models/models.dart';
import '../../services/audio_service.dart';

/// F06 / G01 — Flashcard lật thẻ. Vuốt qua lại, chạm để lật hình↔nghĩa,
/// tự phát âm khi mở thẻ.
class FlashcardScreen extends StatefulWidget {
  final UnitInfo unit;
  final List<FlashCard> cards;

  const FlashcardScreen({super.key, required this.unit, required this.cards});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final PageController _controller = PageController();
  int _index = 0;
  bool _showMeaning = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _playCurrent());
  }

  @override
  void dispose() {
    _controller.dispose();
    AudioService.instance.stop();
    super.dispose();
  }

  void _playCurrent() => AudioService.instance.play(widget.cards[_index].audio);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColors.unitColor(widget.unit.unitId),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text('Flashcard • Unit ${widget.unit.unitId}'),
        actions: [
          // Flashcard không có đúng/sai — hoàn thành = 3 sao cố định.
          TextButton(
            onPressed: () => Navigator.of(context).pop(3),
            child: const Text('Xong', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text('Thẻ ${_index + 1}/${widget.cards.length}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.cards.length,
              onPageChanged: (i) {
                setState(() {
                  _index = i;
                  _showMeaning = false;
                });
                _playCurrent();
              },
              itemBuilder: (context, i) => _card(widget.cards[i]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: PrimaryButton(
              label: 'Nghe lại',
              icon: Icons.volume_up_rounded,
              onPressed: _playCurrent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(FlashCard c) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: GestureDetector(
        onTap: () => setState(() => _showMeaning = !_showMeaning),
        child: Card(
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _showMeaning
                  ? Center(
                      key: const ValueKey('back'),
                      child: Text(
                        c.meaningVi,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary),
                      ),
                    )
                  : Column(
                      key: const ValueKey('front'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: WordImage(relativePath: c.image)),
                        const SizedBox(height: AppSpacing.md),
                        Text(c.word,
                            style: const TextStyle(
                                fontSize: 36, fontWeight: FontWeight.bold)),
                        Text(c.ipa,
                            style: const TextStyle(
                                fontSize: 18, color: AppColors.textSecondary)),
                        const SizedBox(height: AppSpacing.sm),
                        const Text('Chạm vào thẻ để xem nghĩa',
                            style: TextStyle(
                                fontSize: 13, color: AppColors.textSecondary)),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
