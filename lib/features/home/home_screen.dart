import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/content_repository.dart';
import '../../data/db/app_database.dart';
import '../../data/models/models.dart';
import '../../data/repositories/progress_repository.dart';
import '../badges/badges_screen.dart';
import '../grade/grade_select_screen.dart';
import '../profile/profile_select_screen.dart';
import '../settings/settings_screen.dart';
import '../unit/unit_screen.dart';

/// F01 — Trang chủ & Bản đồ Unit: hiện sao đã đạt + khóa unit chưa mở.
class HomeScreen extends StatelessWidget {
  final ContentRepository repo;
  final AppDatabase db;
  final Profile profile;

  const HomeScreen(
      {super.key, required this.repo, required this.db, required this.profile});

  @override
  Widget build(BuildContext context) {
    final progressRepo = ProgressRepository(db);
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Chọn bài học',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        actions: [
          IconButton(
            tooltip: 'Đổi lớp',
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => GradeSelectScreen(profile: profile, db: db),
              ),
            ),
            icon: const Icon(Icons.swap_horiz_rounded),
          ),
          IconButton(
            tooltip: 'Huy hiệu',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    BadgesScreen(db: db, profile: profile, grade: repo.grade),
              ),
            ),
            icon: const Icon(Icons.emoji_events_rounded),
          ),
          IconButton(
            tooltip: 'Cài đặt',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SettingsScreen(db: db, profile: profile),
              ),
            ),
            icon: const Icon(Icons.settings_rounded),
          ),
          IconButton(
            tooltip: profile.name,
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => ProfileSelectScreen(db: db),
              ),
            ),
            icon:
                Text(profile.avatarEmoji, style: const TextStyle(fontSize: 24)),
          ),
        ],
      ),
      body: StreamBuilder<List<LessonProgress>>(
        stream: progressRepo.watchForProfile(profile.id, grade: repo.grade),
        builder: (context, snapshot) {
          final progress = snapshot.data ?? const [];
          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.1,
            ),
            itemCount: repo.units.length,
            itemBuilder: (context, i) {
              final u = repo.units[i];
              final unlocked = progressRepo.isUnitUnlocked(progress, u.unitId);
              final stars = progressRepo.totalStarsForUnit(progress, u.unitId);
              return _UnitCard(
                unit: u,
                stars: stars,
                maxStars: progressRepo.maxStarsPerUnit,
                locked: !unlocked,
                onTap: !unlocked
                    ? null
                    : () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => UnitScreen(
                              repo: repo,
                              db: db,
                              profile: profile,
                              unit: u,
                            ),
                          ),
                        ),
              );
            },
          );
        },
      ),
    );
  }
}

class _UnitCard extends StatelessWidget {
  final UnitInfo unit;
  final int stars;
  final int maxStars;
  final bool locked;
  final VoidCallback? onTap;

  const _UnitCard(
      {required this.unit,
      required this.stars,
      required this.maxStars,
      required this.locked,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: locked ? 0.55 : 1,
      child: Material(
        color: AppColors.unitColor(unit.unitId),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      child: Text('${unit.unitId}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const Spacer(),
                    if (locked)
                      const Icon(Icons.lock_rounded,
                          color: AppColors.textSecondary, size: 22)
                    else
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppColors.warning, size: 18),
                          Text(' $stars/$maxStars',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                  ],
                ),
                const Spacer(),
                Text(
                  unit.theme,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text('Âm: ${unit.phonics}   •   ${unit.wordCount} từ',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
