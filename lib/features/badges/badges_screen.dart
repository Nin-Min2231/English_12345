import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/badge_repository.dart';
import 'badge_defs.dart';

/// F13/G12 (Sprint 3) — xem lại huy hiệu đã/chưa đạt. Không có màn này, huy
/// hiệu chỉ hiện đúng 1 lần lúc vừa đạt rồi biến mất — xem SPRINT3_PLAN.md
/// Phase 3.
class BadgesScreen extends StatelessWidget {
  final AppDatabase db;
  final Profile profile;
  // Sprint 4 — đa lớp: huy hiệu phân biệt theo lớp (badgeId dùng chung mọi
  // lớp, cột `grade` trong DB mới là chỗ phân biệt thật).
  final int grade;

  const BadgesScreen(
      {super.key,
      required this.db,
      required this.profile,
      required this.grade});

  @override
  Widget build(BuildContext context) {
    final badgeRepo = BadgeRepository(db);
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.errorDark,
        foregroundColor: Colors.white,
        title: const Text('Huy hiệu của bé'),
      ),
      body: StreamBuilder<List<EarnedBadge>>(
        stream: badgeRepo.watchForProfile(profile.id, grade: grade),
        builder: (context, snapshot) {
          final earnedIds =
              (snapshot.data ?? const []).map((e) => e.badgeId).toSet();
          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.1,
            ),
            itemCount: kBadgeDefs.length,
            itemBuilder: (context, i) {
              final b = kBadgeDefs[i];
              return _BadgeCard(
                  badge: b, earned: earnedIds.contains(b.badgeId));
            },
          );
        },
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final BadgeDef badge;
  final bool earned;

  const _BadgeCard({required this.badge, required this.earned});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: earned ? 1 : 0.55,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                earned ? badge.icon : Icons.lock_rounded,
                color: earned ? AppColors.warning : AppColors.textSecondary,
                size: 48,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                badge.name,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text('Sau Unit ${badge.afterUnit}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
