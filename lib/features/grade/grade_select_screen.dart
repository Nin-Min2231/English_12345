import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/content_repository.dart';
import '../../data/db/app_database.dart';
import '../badges/badges_screen.dart';
import '../home/home_screen.dart';
import '../settings/settings_screen.dart';

/// SCR-00 — Chọn lớp (Sprint 4, đa lớp). Đứng giữa ProfileSelect (SCR-01a/b)
/// và Home (SCR-02): 1 hồ sơ có thể học nhiều lớp, nên chọn hồ sơ đứng trước
/// chọn lớp (độc lập với lớp). Danh sách cấu hình `kGradeOptions` — mô phỏng
/// đúng pattern `GameDef`/`gameDefsByType` (game_defs.dart): bật 1 lớp mới sau
/// này chỉ đổi `enabled: false → true` + `subtitle`, không sửa layout/logic.
class GradeOption {
  final int grade;
  final String label;
  final String subtitle;
  final bool enabled;

  const GradeOption({
    required this.grade,
    required this.label,
    required this.subtitle,
    required this.enabled,
  });
}

const kGradeOptions = [
  GradeOption(
      grade: 1,
      label: 'Lớp 1',
      subtitle: 'Đang phát triển — Unit 1',
      enabled: true),
  GradeOption(
      grade: 2, label: 'Lớp 2', subtitle: 'Đầy đủ 16 Unit', enabled: true),
  GradeOption(grade: 3, label: 'Lớp 3', subtitle: 'Sắp ra mắt', enabled: false),
  GradeOption(grade: 4, label: 'Lớp 4', subtitle: 'Sắp ra mắt', enabled: false),
  GradeOption(grade: 5, label: 'Lớp 5', subtitle: 'Sắp ra mắt', enabled: false),
];

class GradeSelectScreen extends StatefulWidget {
  final Profile profile;
  final AppDatabase db;

  const GradeSelectScreen({super.key, required this.profile, required this.db});

  @override
  State<GradeSelectScreen> createState() => _GradeSelectScreenState();
}

class _GradeSelectScreenState extends State<GradeSelectScreen> {
  // Chặn chạm 2 lần trong lúc đang `await ContentRepository.load()` — không
  // có cờ này, chạm nhanh 2 lần có thể push 2 HomeScreen chồng nhau.
  bool _loading = false;

  Future<void> _openGrade(GradeOption option) async {
    if (!option.enabled || _loading) return;
    setState(() => _loading = true);
    try {
      final repo = await ContentRepository.load(grade: option.grade);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              HomeScreen(repo: repo, db: widget.db, profile: widget.profile),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Chọn lớp',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        // Nút back tự động hiện (Flutter tự thêm vì màn "Hồ sơ của bé" vẫn
        // còn ở dưới trong stack, xem profile_select_screen.dart._openProfile
        // — không push thay thế nữa). 3 action còn lại khớp đúng bộ với
        // HomeScreen ("Chọn bài học") để đồng bộ header xuyên suốt luồng
        // Hồ sơ -> Chọn lớp -> Chọn bài (CR-030 BUGS_CR.md).
        actions: [
          IconButton(
            tooltip: 'Huy hiệu',
            // Chưa chọn lớp ở màn này -> hiện huy hiệu đã đạt ở BẤT KỲ lớp
            // nào của hồ sơ (grade: null, xem badge_repository.dart).
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    BadgesScreen(db: widget.db, profile: widget.profile),
              ),
            ),
            icon: const Icon(Icons.emoji_events_rounded),
          ),
          IconButton(
            tooltip: 'Cài đặt',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    SettingsScreen(db: widget.db, profile: widget.profile),
              ),
            ),
            icon: const Icon(Icons.settings_rounded),
          ),
          // Quay lại đúng màn "Hồ sơ của bé" ngay dưới trong stack (không
          // tạo instance mới) — xem home_screen.dart cho lý do tương tự.
          IconButton(
            tooltip: widget.profile.name,
            onPressed: () => Navigator.of(context).pop(),
            icon: Text(widget.profile.avatarEmoji,
                style: const TextStyle(fontSize: 24)),
          ),
        ],
      ),
      body: Stack(
        children: [
          GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.1,
            ),
            itemCount: kGradeOptions.length,
            itemBuilder: (context, i) =>
                _GradeCard(option: kGradeOptions[i], onTap: _openGrade),
          ),
          if (_loading)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.black26,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}

class _GradeCard extends StatelessWidget {
  final GradeOption option;
  final void Function(GradeOption) onTap;

  const _GradeCard({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final locked = !option.enabled;
    return Opacity(
      opacity: locked ? 0.55 : 1,
      child: Material(
        color: AppColors.unitColor(option.grade),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          onTap: locked ? null : () => onTap(option),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (locked)
                  const Icon(Icons.lock_rounded,
                      color: AppColors.textSecondary, size: 32)
                else
                  const Icon(Icons.menu_book_rounded,
                      color: AppColors.primary, size: 32),
                const SizedBox(height: AppSpacing.sm),
                Text(option.label,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const SizedBox(height: AppSpacing.xs),
                Text(option.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
