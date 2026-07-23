import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/content_repository.dart';
import '../../data/db/app_database.dart';
import '../../data/models/models.dart';
import '../../data/repositories/progress_repository.dart';
import 'game_defs.dart';

/// F03 — Màn hình một unit: danh sách game ([kUnitGames]), mở tuần tự (game
/// sau cần game trước đạt ≥1 sao). F14 — mỗi game trả về số sao qua
/// Navigator.pop.
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
              for (final game in kUnitGames) ...[
                _gameRowFor(context, game, progress, unit),
                const SizedBox(height: AppSpacing.lg),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _gameRowFor(BuildContext context, GameDef game,
      List<LessonProgress> progress, UnitInfo unit) {
    final stars = _progressRepo.starsFor(progress, unit.unitId, game.gameType);
    final unlocked =
        _progressRepo.isGameUnlocked(progress, unit.unitId, game.gameType);
    final count = game.countFor(widget.repo, unit.unitId);

    return _gameRow(
      stars: stars,
      unlocked: unlocked,
      button: PrimaryButton(
        label: unlocked ? game.label(count) : game.lockedLabel(),
        icon: game.icon,
        color: game.color,
        foregroundColor: game.foregroundColor,
        onPressed: !unlocked || count == 0
            ? null
            : () => _playGame(
                  game.gameType,
                  () => Navigator.of(context).push<Object?>(
                    MaterialPageRoute(
                      builder: (_) =>
                          game.buildScreen(context, widget.repo, unit),
                    ),
                  ),
                ),
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
