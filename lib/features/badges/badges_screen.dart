import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/course.dart';
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
  // lớp, cột `grade` trong DB mới là chỗ phân biệt thật). `null` (gọi từ màn
  // "Chọn lớp", chưa có lớp cụ thể) = hiện huy hiệu đã đạt ở BẤT KỲ lớp nào.
  final int? grade;

  const BadgesScreen(
      {super.key, required this.db, required this.profile, this.grade});

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
          // CR-036: lọc danh mục huy hiệu theo khoá học đang xem. KHÔNG lọc thì màn
          // huy hiệu của Lớp 2 sẽ hiện thêm 15 ô mờ của Chủ đề (và ngược lại).
          final defs = grade == null
              ? kBadgeDefs // từ màn "Chọn lớp": hiện TẤT CẢ
              : isTopicCourse(grade!)
                  ? kBadgeDefs
                      .where((b) => b.courseId == kTopicCourseId)
                      .toList()
                  : kBadgeDefs.where((b) => b.courseId == null).toList();
          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.1,
            ),
            itemCount: defs.length,
            itemBuilder: (context, i) => _BadgeCard(
                badge: defs[i], earned: earnedIds.contains(defs[i].badgeId)),
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
              // CR-036: subtitle chủ đề dài hơn hẳn "Sau Unit N" cũ (vd "Chủ đề
              // Thứ, ngày, tháng") — chặn tràn 2 dòng, giống mẫu _UnitCard.
              Text(badge.caption,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
