import 'package:drift/drift.dart';

import '../db/app_database.dart';

/// F13/G12 — Huy hiệu đã trao cho từng hồ sơ (xem badge_defs.dart cho danh
/// mục huy hiệu — hằng số Dart, không nạp từ đây).
class BadgeRepository {
  final AppDatabase db;

  const BadgeRepository(this.db);

  // Sprint 4 — đa lớp: `badgeId` (vd 'badge_u4') dùng CHUNG mọi lớp, phân
  // biệt bằng cột `grade` mới — lọc tại query giống progress_repository.dart.
  Stream<List<EarnedBadge>> watchForProfile(int profileId,
          {required int grade}) =>
      (db.select(db.earnedBadges)
            ..where(
                (t) => t.profileId.equals(profileId) & t.grade.equals(grade)))
          .watch();

  /// Trao huy hiệu nếu chưa có (không trao trùng); trả về true nếu vừa trao
  /// mới (để màn hình chỉ ăn mừng đúng 1 lần).
  Future<bool> award(int profileId, String badgeId,
      {required int grade}) async {
    final existing = await (db.select(db.earnedBadges)
          ..where((t) =>
              t.profileId.equals(profileId) &
              t.grade.equals(grade) &
              t.badgeId.equals(badgeId)))
        .getSingleOrNull();
    if (existing != null) return false;
    await db.into(db.earnedBadges).insert(
          EarnedBadgesCompanion.insert(
              profileId: profileId, badgeId: badgeId, grade: Value(grade)),
        );
    return true;
  }
}
