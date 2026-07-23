import 'package:drift/drift.dart';

import '../db/app_database.dart';

/// F02 — Hồ sơ trẻ: tạo, sửa, xóa và theo dõi danh sách hồ sơ.
class ProfileRepository {
  final AppDatabase db;

  const ProfileRepository(this.db);

  Stream<List<Profile>> watchProfiles() => db.select(db.profiles).watch();

  Future<Profile> create(
      {required String name, required String avatarEmoji}) async {
    final id = await db.into(db.profiles).insert(
          ProfilesCompanion.insert(name: name, avatarEmoji: avatarEmoji),
        );
    return (db.select(db.profiles)..where((t) => t.id.equals(id))).getSingle();
  }

  /// F15 — Sửa tên/avatar hồ sơ (gate bằng cổng phụ huynh ở màn hình gọi).
  Future<void> update(int id,
      {required String name, required String avatarEmoji}) async {
    await (db.update(db.profiles)..where((t) => t.id.equals(id))).write(
      ProfilesCompanion(
        name: Value(name),
        avatarEmoji: Value(avatarEmoji),
      ),
    );
  }

  /// F15 — Xóa hồ sơ + toàn bộ tiến độ/huy hiệu liên quan. `LessonProgressTable`
  /// và `EarnedBadges` (Sprint 3) đều tham chiếu `Profiles` qua khóa ngoại
  /// nhưng DB **chưa bật FK enforcement/cascade** (xem `app_database.dart`),
  /// nên phải tự xóa theo đúng thứ tự trong 1 transaction để không để lại
  /// dòng tiến độ/huy hiệu mồ côi.
  Future<void> delete(int id) async {
    await db.transaction(() async {
      await (db.delete(db.lessonProgressTable)
            ..where((t) => t.profileId.equals(id)))
          .go();
      await (db.delete(db.earnedBadges)..where((t) => t.profileId.equals(id)))
          .go();
      await (db.delete(db.profiles)..where((t) => t.id.equals(id))).go();
    });
  }
}
