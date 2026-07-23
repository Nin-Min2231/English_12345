import 'package:flutter/material.dart';

import 'app.dart';
import 'data/content_repository.dart';
import 'data/db/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = await ContentRepository.load();
  final db = AppDatabase();
  runApp(Lop2App(repo: repo, db: db));
}
