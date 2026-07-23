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
}

@DriftDatabase(tables: [Profiles, LessonProgressTable, EarnedBadges])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Sprint 3 — v2 thêm bảng EarnedBadges (F13/G12). Đây là migration đầu
  // tiên của app: máy thật đang có sẵn Profiles/LessonProgressTable của
  // người dùng thật, KHÔNG được để mất khi cài bản mới đè lên (không phải
  // gỡ cài đặt lại) — xem `migration` override bên dưới, bắt buộc phải có
  // từ lúc này, không còn dùng được onCreate mặc định một mình.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(earnedBadges);
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
