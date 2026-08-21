import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// F02 — Hồ sơ trẻ (nhiều profile trên 1 máy).
@DataClassName('Profile')
class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get avatarEmoji => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// F14 — Tiến độ & sao, theo (profile, unit, loại game).
@DataClassName('LessonProgress')
class LessonProgressTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  IntColumn get unitId => integer()();
  TextColumn get gameType => text()(); // 'g01' | 'g02' | 'g03'
  IntColumn get stars => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  // Sprint 4 — đa lớp. Mặc định 2 vì mọi dòng cũ trên máy thật đều là Lớp 2
  // (không được để migrate xong bị hiểu nhầm là Lớp 1). `unitId` chỉ duy
  // nhất trong phạm vi 1 lớp (Lớp 1 Unit 1 và Lớp 2 Unit 1 là 2 dòng khác
  // nhau, phân biệt bằng cột này).
  IntColumn get grade => integer().withDefault(const Constant(2))();
}

/// F13/G12 (Sprint 3) — huy hiệu đã trao cho 1 hồ sơ. `badgeId` khớp
/// `BadgeDef.badgeId` (badge_defs.dart, hằng số Dart do app tự định nghĩa —
/// không phải bảng "danh mục huy hiệu" trong DB, chỉ lưu SỰ KIỆN đã trao).
@DataClassName('EarnedBadge')
class EarnedBadges extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get badgeId => text()();
  DateTimeColumn get earnedAt => dateTime().withDefault(currentDateAndTime)();
  // Sprint 4 — thêm NGAY dù chưa code Boss Quiz cho Lớp 1: badgeId (vd
  // 'badge_u4') dùng chung mọi lớp, không có cột này thì huy hiệu Unit 4
  // của Lớp 1 và Lớp 2 sẽ đụng nhau ngay khi Lớp 1 tới Unit 4. Mặc định 2
  // vì huy hiệu cũ trên máy thật đều của Lớp 2.
  IntColumn get grade => integer().withDefault(const Constant(2))();
}

@DriftDatabase(tables: [Profiles, LessonProgressTable, EarnedBadges])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Sprint 3 — v2 thêm bảng EarnedBadges (F13/G12).
  // Sprint 4 — v3 thêm cột `grade` cho LessonProgressTable + EarnedBadges
  // (đa lớp). Máy thật đang có sẵn dữ liệu Lớp 2 thật, KHÔNG được để mất
  // khi cài bản mới đè lên (không phải gỡ cài đặt lại) — xem `migration`
  // override bên dưới. Nếu máy đang ở schemaVersion 1 (chưa từng cài bản
  // CR-019+), Drift chạy TUẦN TỰ cả 2 nhánh `from < 2` rồi `from < 3`.
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(earnedBadges);
          }
          if (from < 3) {
            await m.addColumn(lessonProgressTable, lessonProgressTable.grade);
            await m.addColumn(earnedBadges, earnedBadges.grade);
          }
        },
      );

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'lop2_english_app.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
