import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'data/content_repository.dart';
import 'data/db/app_database.dart';
import 'features/profile/profile_select_screen.dart';

class Lop2App extends StatelessWidget {
  final ContentRepository repo;
  final AppDatabase db;

  const Lop2App({super.key, required this.repo, required this.db});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiếng Anh Lớp 2 — Global Success',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: ProfileSelectScreen(repo: repo, db: db),
    );
  }
}
