import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/content_repository.dart';
import '../../data/db/app_database.dart';
import '../../data/models/models.dart';
import '../../data/repositories/badge_repository.dart';
import '../../data/repositories/progress_repository.dart';
import '../badges/badge_defs.dart';
import 'checkpoints.dart';
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
  late final BadgeRepository _badgeRepo = BadgeRepository(widget.db);

  Future<void> _playGame(
      GameDef game, Future<Object?> Function() openGame) async {
    final result = await openGame();
    if (result is! int) return;
    await _progressRepo.reportResult(
      profileId: widget.profile.id,
      grade: widget.unit.grade,
      unitId: widget.unit.unitId,
      gameType: game.gameType,
      stars: result,
    );
    // Sprint 3 — chỉ Boss Quiz (G12) có badgeId; ngưỡng đạt huy hiệu = cùng
    // mốc 2 sao dùng cho "khá tốt" ở nơi khác trong app (vd G08 CR-018).
    final badgeId = game.badgeId;
    if (badgeId != null && result >= 2 && mounted) {
      final isNew = await _badgeRepo.award(widget.profile.id, badgeId,
          grade: widget.unit.grade);
      if (isNew && mounted) await _showBadgeEarnedDialog(badgeId);
    }
  }

  Future<void> _showBadgeEarnedDialog(String badgeId) {
    final badge = kBadgeDefs.firstWhere((b) => b.badgeId == badgeId);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
        title: const Text('Huy hiệu mới! 🏅'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(badge.icon, color: AppColors.warning, size: 56),
            const SizedBox(height: AppSpacing.md),
            Text(badge.name,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.sm),
            const Text('Bé giỏi quá! Tiếp tục cố gắng nhé.',
                textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tuyệt vời!'),
          ),
        ],
      ),
    );
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
        stream: _progressRepo.watchForProfile(widget.profile.id,
            grade: widget.unit.grade),
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
              // Sprint 4 — đa lớp: game CHƯA CÓ dữ liệu cho unit/lớp này (vd
              // G06 "Hoàn thành câu" chưa phát triển cho Lớp 1, xem BUGS_CR.md
              // CR-028) bị ẩn hẳn khỏi danh sách — "bỏ ra khỏi chương trình"
              // đúng nghĩa, không hiện dòng khóa vĩnh viễn gây hiểu nhầm.
              for (final game in kUnitGames)
                if (game.countFor(widget.repo, unit.unitId) > 0) ...[
                  _gameRowFor(context, game, progress, unit),
                  const SizedBox(height: AppSpacing.lg),
                ],
              // Sprint 3 — Fun Time (G09) / Boss Quiz (G12) chỉ xuất hiện
              // trên đúng 1 unit checkpoint, xem checkpoints.dart.
              for (final game in extraGamesForUnit(unit.unitId))
                if (game.countFor(widget.repo, unit.unitId) > 0) ...[
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
        game.isUnlockedOverride?.call(_progressRepo, progress, unit.unitId) ??
            _progressRepo.isGameUnlocked(progress, unit.unitId, game.gameType,
                hasContent: (t) =>
                    gameDefsByType[t]!.countFor(widget.repo, unit.unitId) > 0);
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
                  game,
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
