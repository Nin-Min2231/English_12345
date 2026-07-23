import 'package:drift/drift.dart';

import '../db/app_database.dart';

const _gameTypes = ['g01', 'g02', 'g03'];

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

  /// Tổng sao 1 unit (0-9): tổng sao của g01+g02+g03.
  int totalStarsForUnit(List<LessonProgress> progress, int unitId) =>
      _gameTypes.fold(0, (sum, g) => sum + starsFor(progress, unitId, g));

  /// F03 — g01 luôn mở; g02 cần g01 đạt ≥1 sao; g03 cần g02 đạt ≥1 sao.
  bool isGameUnlocked(
      List<LessonProgress> progress, int unitId, String gameType) {
    final i = _gameTypes.indexOf(gameType);
    if (i <= 0) return true;
    return starsFor(progress, unitId, _gameTypes[i - 1]) >= 1;
  }

  /// F01 — unit 1 luôn mở; unit sau cần unit trước hoàn thành cả 3 game (≥1 sao).
  bool isUnitUnlocked(List<LessonProgress> progress, int unitId) {
    if (unitId <= 1) return true;
    return _gameTypes.every((g) => starsFor(progress, unitId - 1, g) >= 1);
  }
}
