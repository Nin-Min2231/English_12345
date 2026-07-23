import 'package:drift/drift.dart';

import '../db/app_database.dart';

// Thứ tự = thứ tự mở khóa tuần tự trong 1 unit. g07 KHÔNG nằm trong danh sách
// này — karaoke không chấm sao, không khóa/mở (xem unit_screen.dart, kUnitGames).
const _gameTypes = ['g01', 'g02', 'g03', 'g04', 'g05', 'g06', 'g08'];

// Chỉ 4 game lõi (từ vựng/phonics) là điều kiện mở unit tiếp theo — g05/g06/g08
// vẫn cho sao nhưng không chặn tiến độ, giữ 1 unit gần mục tiêu "≤5 phút/phiên".
const _coreGameTypes = ['g01', 'g02', 'g03', 'g04'];

/// F14 — Tiến độ & sao. Cũng chứa quy tắc khóa/mở dùng chung cho
/// Home (F01, khóa unit) và Unit (F03, khóa game tuần tự trong unit).
class ProgressRepository {
  final AppDatabase db;

  const ProgressRepository(this.db);

  Stream<List<LessonProgress>> watchForProfile(int profileId) =>
      (db.select(db.lessonProgressTable)
            ..where((t) => t.profileId.equals(profileId)))
          .watch();

  /// Ghi kết quả 1 game; chỉ tăng sao (không hạ sao khi chơi lại kém hơn).
  Future<void> reportResult({
    required int profileId,
    required int unitId,
    required String gameType,
    required int stars,
  }) async {
    final existing = await (db.select(db.lessonProgressTable)
          ..where((t) =>
              t.profileId.equals(profileId) &
              t.unitId.equals(unitId) &
              t.gameType.equals(gameType)))
        .getSingleOrNull();

    if (existing == null) {
      await db.into(db.lessonProgressTable).insert(
            LessonProgressTableCompanion.insert(
              profileId: profileId,
              unitId: unitId,
              gameType: gameType,
              stars: Value(stars),
            ),
          );
    } else if (stars > existing.stars) {
      await (db.update(db.lessonProgressTable)
            ..where((t) => t.id.equals(existing.id)))
          .write(LessonProgressTableCompanion(
        stars: Value(stars),
        updatedAt: Value(DateTime.now()),
      ));
    }
  }

  int starsFor(List<LessonProgress> progress, int unitId, String gameType) {
    for (final p in progress) {
      if (p.unitId == unitId && p.gameType == gameType) return p.stars;
    }
    return 0;
  }

  /// Tổng sao tối đa 1 unit = số game (đang là 7) × 3 — dùng thay vì hardcode
  /// số, tránh lệch khi thêm/bớt game (xem home_screen.dart _UnitCard).
  int get maxStarsPerUnit => _gameTypes.length * 3;

  /// Tổng sao 1 unit: cộng sao mọi game trong _gameTypes (g01..g06,g08).
  int totalStarsForUnit(List<LessonProgress> progress, int unitId) =>
      _gameTypes.fold(0, (sum, g) => sum + starsFor(progress, unitId, g));

  /// F03 — game đầu tiên (g01) luôn mở; game sau cần game ngay trước đạt ≥1 sao.
  bool isGameUnlocked(
      List<LessonProgress> progress, int unitId, String gameType) {
    final i = _gameTypes.indexOf(gameType);
    if (i <= 0) return true;
    return starsFor(progress, unitId, _gameTypes[i - 1]) >= 1;
  }

  /// F01 — unit 1 luôn mở; unit sau cần unit trước hoàn thành **4 game lõi**
  /// (g01-g04, ≥1 sao mỗi game) — g05/g06/g08 không chặn mở unit tiếp theo.
  bool isUnitUnlocked(List<LessonProgress> progress, int unitId) {
    if (unitId <= 1) return true;
    return _coreGameTypes.every((g) => starsFor(progress, unitId - 1, g) >= 1);
  }
}
