import 'package:drift/drift.dart';

import '../db/app_database.dart';

// Thứ tự = thứ tự mở khóa tuần tự trong 1 unit. Đây là nguồn sự thật duy nhất
// cho thứ tự — game_defs.dart's kUnitGames được SUY RA từ danh sách này (map
// theo gameType), không tự giữ 1 danh sách riêng nữa (tránh 2 danh sách lệch
// nhau, xem BUGS_CR.md Sprint 3 Phase 0). g07 (karaoke) và g09/g12 (checkpoint
// Fun Time/Boss Quiz, xem checkpoints.dart) KHÔNG nằm trong danh sách này —
// isGameUnlocked coi gameType không có trong danh sách là "luôn mở" (indexOf
// trả -1), nên bỏ sót 1 game cần khóa riêng khỏi đây sẽ âm thầm biến nó thành
// luôn mở, không phải lỗi hiện rõ — đây là lý do phải cố ý loại trừ, không chỉ
// đơn giản là quên thêm.
const kGameTypeOrder = ['g01', 'g02', 'g03', 'g04', 'g05', 'g06', 'g08', 'g10'];

// Chỉ 4 game lõi (từ vựng/phonics) là điều kiện mở unit tiếp theo — g05/g06/g08/g10
// vẫn cho sao nhưng không chặn tiến độ, giữ 1 unit gần mục tiêu "≤5 phút/phiên".
// Cũng là điều kiện mở checkpoint Fun Time/Boss Quiz gắn vào unit đó (xem
// isCheckpointUnlocked).
const _coreGameTypes = ['g01', 'g02', 'g03', 'g04'];

// Sao tối đa của từng loại game khác 3 (G10 "Săn chữ" theo catalog gốc chỉ có
// thang 1-2 sao) — game không có trong map này mặc định tối đa 3.
const _maxStarsByGameType = {'g10': 2};

/// F14 — Tiến độ & sao. Cũng chứa quy tắc khóa/mở dùng chung cho
/// Home (F01, khóa unit) và Unit (F03, khóa game tuần tự trong unit).
class ProgressRepository {
  final AppDatabase db;

  const ProgressRepository(this.db);

  /// Sprint 4 — đa lớp: lọc TẠI QUERY theo `grade` (không phải sau khi lấy
  /// về) — nhờ vậy list `progress` trả ra CHỈ chứa dòng của đúng 1 lớp, mọi
  /// hàm thuần bên dưới (starsFor, isUnitUnlocked, ...) không cần biết
  /// `grade` nữa vì `unitId` trong list này đã hết nhập nhằng giữa 2 lớp.
  Stream<List<LessonProgress>> watchForProfile(int profileId,
          {required int grade}) =>
      (db.select(db.lessonProgressTable)
            ..where(
                (t) => t.profileId.equals(profileId) & t.grade.equals(grade)))
          .watch();

  /// Ghi kết quả 1 game; chỉ tăng sao (không hạ sao khi chơi lại kém hơn).
  Future<void> reportResult({
    required int profileId,
    required int grade,
    required int unitId,
    required String gameType,
    required int stars,
  }) async {
    final existing = await (db.select(db.lessonProgressTable)
          ..where((t) =>
              t.profileId.equals(profileId) &
              t.grade.equals(grade) &
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
              grade: Value(grade),
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

  /// Tổng sao tối đa 1 unit = cộng sao tối đa từng game trong kGameTypeOrder
  /// (đa số 3, riêng G10 chỉ 2 — xem _maxStarsByGameType) — dùng thay vì
  /// hardcode số, tránh lệch khi thêm/bớt game (xem home_screen.dart _UnitCard).
  int get maxStarsPerUnit =>
      kGameTypeOrder.fold(0, (sum, g) => sum + (_maxStarsByGameType[g] ?? 3));

  /// Tổng sao 1 unit: cộng sao mọi game trong kGameTypeOrder.
  int totalStarsForUnit(List<LessonProgress> progress, int unitId) =>
      kGameTypeOrder.fold(0, (sum, g) => sum + starsFor(progress, unitId, g));

  /// F03 — game đầu tiên (g01) luôn mở; game sau cần game ngay trước đạt ≥1 sao.
  /// Sprint 4 — đa lớp: [hasContent] (nếu truyền) cho biết loại game nào KHÔNG
  /// có dữ liệu cho unit/lớp này (vd G06 "Hoàn thành câu" chưa phát triển cho
  /// Lớp 1) — những game đó bị bỏ qua khi tìm "game ngay trước", coi như trong
  /// suốt/không tồn tại trong chuỗi mở khóa. Không có tham số này thì y hệt
  /// hành vi cũ (dùng cho Lớp 2, mọi game đều có dữ liệu mọi unit). Thiếu chốt
  /// này thì 1 game chưa phát triển sẽ khóa cứng VĨNH VIỄN mọi game phía sau
  /// nó trong kGameTypeOrder — không ai bao giờ earn được sao của 1 game
  /// không chơi được.
  bool isGameUnlocked(
      List<LessonProgress> progress, int unitId, String gameType,
      {bool Function(String gameType)? hasContent}) {
    var i = kGameTypeOrder.indexOf(gameType);
    if (i <= 0) return true;
    if (hasContent != null) {
      while (i > 0 && !hasContent(kGameTypeOrder[i - 1])) {
        i--;
      }
    }
    if (i <= 0) return true;
    return starsFor(progress, unitId, kGameTypeOrder[i - 1]) >= 1;
  }

  /// F01 — unit 1 luôn mở; unit sau cần unit trước hoàn thành **4 game lõi**
  /// (g01-g04, ≥1 sao mỗi game) — g05/g06/g08/g10 không chặn mở unit tiếp theo.
  bool isUnitUnlocked(List<LessonProgress> progress, int unitId) {
    if (unitId <= 1) return true;
    return _coreGameTypes.every((g) => starsFor(progress, unitId - 1, g) >= 1);
  }

  /// Sprint 3 — checkpoint Fun Time (G09) / Boss Quiz (G12) gắn vào 1 unit cụ
  /// thể (xem checkpoints.dart). Khác isUnitUnlocked: kiểm tra 4 game lõi của
  /// CHÍNH unit đang gắn checkpoint (không phải unit trước) — chạm được vào
  /// màn hình unit đó chỉ đảm bảo unit TRƯỚC đã xong, không đảm bảo unit này
  /// đã xong, nên checkpoint cần điều kiện riêng.
  bool isCheckpointUnlocked(List<LessonProgress> progress, int unitId) =>
      _coreGameTypes.every((g) => starsFor(progress, unitId, g) >= 1);

  /// Fun Time / "Lật thẻ" (CR-023) — chặt hơn [isCheckpointUnlocked]: đây là
  /// game ôn tập nên đòi hỏi HOÀN TẤT MỌI game (`kGameTypeOrder`, không chỉ 4
  /// game lõi) của CẢ 2 unit trong phạm vi ôn tập (`fromUnit`/`toUnit` của
  /// Checkpoint, xem checkpoints.dart). Không ảnh hưởng Boss Quiz (G12) —
  /// game đó vẫn dùng [isCheckpointUnlocked] như cũ.
  /// Cùng bug/cùng cách sửa với [isGameUnlocked] (CR-028): [hasContent] (nếu
  /// truyền) cho biết loại game nào KHÔNG có dữ liệu ở 1 unit cụ thể — game đó
  /// bị bỏ qua khi xét điều kiện "hoàn tất mọi game", coi như trong suốt.
  /// Thiếu chốt này thì 1 game chưa phát triển ở fromUnit/toUnit (vd G06 Lớp
  /// 1) sẽ khóa cứng Lật thẻ VĨNH VIỄN, giống hệt bug G08 ở CR-028. Không
  /// truyền tham số này thì y hệt hành vi cũ (Lớp 2, mọi game có dữ liệu mọi
  /// unit).
  bool isFunTimeUnlocked(
          List<LessonProgress> progress, int fromUnit, int toUnit,
          {bool Function(int unitId, String gameType)? hasContent}) =>
      [fromUnit, toUnit].every((u) => kGameTypeOrder.every((g) =>
          (hasContent != null && !hasContent(u, g)) ||
          starsFor(progress, u, g) >= 1));
}
