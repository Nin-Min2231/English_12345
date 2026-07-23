import 'package:flutter/material.dart';

import 'app.dart';
import 'data/content_repository.dart';
import 'data/db/app_database.dart';
import 'services/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsService.instance.init();
  final repo = await ContentRepository.load();
  final db = AppDatabase();
  runApp(Lop2App(repo: repo, db: db));
}
