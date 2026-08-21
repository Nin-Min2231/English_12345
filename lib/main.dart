import 'package:flutter/material.dart';

import 'app.dart';
import 'data/db/app_database.dart';
import 'services/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsService.instance.init();
  // Sprint 4 — đa lớp: không còn nạp ContentRepository ở đây — chưa biết
  // đang chọn lớp nào cho tới khi qua GradeSelectScreen (SCR-00), nạp lazy
  // đúng lúc chạm vào 1 ô lớp.
  final db = AppDatabase();
  runApp(Lop2App(db: db));
}
