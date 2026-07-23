import '../db/app_database.dart';

/// F02 — Hồ sơ trẻ: tạo và theo dõi danh sách hồ sơ.
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
}
