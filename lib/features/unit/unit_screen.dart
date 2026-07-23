import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/content_repository.dart';
import '../../data/db/app_database.dart';
import '../../data/models/models.dart';
import '../../data/repositories/progress_repository.dart';
import '../flashcard/flashcard_screen.dart';
import '../games/fill_letter/fill_letter_screen.dart';
import '../games/listen_pick/listen_pick_screen.dart';

/// F03 — Màn hình một unit: 3 game P0, mở tuần tự (game sau cần game
/// trước đạt ≥1 sao). F14 — mỗi game trả về số sao qua Navigator.pop.
class UnitScreen extends StatefulWidget {
  final ContentRepository repo;
  final AppDatabase db;
  final Profile profile;
  final UnitInfo unit;

  const UnitScreen({
    super.key,
    required this.repo,
    required this.db,
    required this.profile,
    required this.unit,
  });

  @override
  State<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends State<UnitScreen> {
  late final ProgressRepository _progressRepo = ProgressRepository(widget.db);

  Future<void> _playGame(
      String gameType, Future<Object?> Function() openGame) async {
    final result = await openGame();
    if (result is int) {
      await _progressRepo.reportResult(
        profileId: widget.profile.id,
        unitId: widget.unit.unitId,
        gameType: gameType,
        stars: result,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final unit = widget.unit;
    final cards = widget.repo.flashByUnit[unit.unitId] ?? const [];
    final questions = widget.repo.listenByUnit[unit.unitId] ?? const [];
    final items = widget.repo.fillByUnit[unit.unitId] ?? const [];

    return AppScaffold(
      backgroundColor: AppColors.unitColor(unit.unitId),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text('Unit ${unit.unitId}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<List<LessonProgress>>(
        stream: _progressRepo.watchForProfile(widget.profile.id),
        builder: (context, snapshot) {
          final progress = snapshot.data ?? const [];
          final g01Stars = _progressRepo.starsFor(progress, unit.unitId, 'g01');
          final g02Stars = _progressRepo.starsFor(progress, unit.unitId, 'g02');
          final g03Stars = _progressRepo.starsFor(progress, unit.unitId, 'g03');
          final g02Unlocked =
              _progressRepo.isGameUnlocked(progress, unit.unitId, 'g02');
          final g03Unlocked =
              _progressRepo.isGameUnlocked(progress, unit.unitId, 'g03');

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              Text(unit.theme,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.xs),
              Text('Âm phonics của bài: "${unit.phonics}"',
                  style: const TextStyle(
                      fontSize: 16, color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.xl),
              _gameRow(
                stars: g01Stars,
                unlocked: true,
                button: PrimaryButton(
                  label: 'Flashcard (${cards.length} thẻ)',
                  icon: Icons.style_rounded,
                  onPressed: cards.isEmpty
                      ? null
                      : () => _playGame(
                            'g01',
                            () => Navigator.of(context).push<Object?>(
                              MaterialPageRoute(
                                builder: (_) =>
                                    FlashcardScreen(unit: unit, cards: cards),
                              ),
                            ),
                          ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _gameRow(
                stars: g02Stars,
                unlocked: g02Unlocked,
                button: PrimaryButton(
                  label: g02Unlocked
                      ? 'Nghe chọn hình (${questions.length} câu)'
                      : 'Nghe chọn hình 🔒',
                  icon: Icons.hearing_rounded,
                  color: AppColors.secondary,
                  onPressed: !g02Unlocked || questions.isEmpty
                      ? null
                      : () => _playGame(
                            'g02',
                            () => Navigator.of(context).push<Object?>(
                              MaterialPageRoute(
                                builder: (_) => ListenPickScreen(
                                    unit: unit, questions: questions),
                              ),
                            ),
                          ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _gameRow(
                stars: g03Stars,
                unlocked: g03Unlocked,
                button: PrimaryButton(
                  label: g03Unlocked
                      ? 'Điền chữ (${items.length} từ)'
                      : 'Điền chữ 🔒',
                  icon: Icons.abc_rounded,
                  color: AppColors.info,
                  onPressed: !g03Unlocked || items.isEmpty
                      ? null
                      : () => _playGame(
                            'g03',
                            () => Navigator.of(context).push<Object?>(
                              MaterialPageRoute(
                                builder: (_) =>
                                    FillLetterScreen(unit: unit, items: items),
                              ),
                            ),
                          ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _gameRow(
      {required int stars, required bool unlocked, required Widget button}) {
    return Row(
      children: [
        Expanded(child: button),
        if (unlocked) ...[
          const SizedBox(width: AppSpacing.sm),
          StarBar(stars: stars, size: 20),
        ],
      ],
    );
  }
}
