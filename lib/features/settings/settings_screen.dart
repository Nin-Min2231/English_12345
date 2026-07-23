import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/parent_gate.dart';
import '../../data/content_repository.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/profile_repository.dart';
import '../../services/settings_service.dart';
import '../profile/profile_select_screen.dart';

/// F15 — Cài đặt: âm thanh, độ khó, xóa hồ sơ (gate bằng cổng phụ huynh).
class SettingsScreen extends StatefulWidget {
  final ContentRepository repo;
  final AppDatabase db;
  final Profile profile;

  const SettingsScreen({
    super.key,
    required this.repo,
    required this.db,
    required this.profile,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundOn = SettingsService.instance.soundOn;
  Difficulty _difficulty = SettingsService.instance.difficulty;

  Future<void> _deleteProfile() async {
    final gateOk = await showParentGate(context);
    if (!gateOk || !mounted) return;
    final confirmed = await confirmDeleteProfile(context, widget.profile.name);
    if (!confirmed || !mounted) return;

    await ProfileRepository(widget.db).delete(widget.profile.id);
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => ProfileSelectScreen(repo: widget.repo, db: widget.db),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Cài đặt'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const _SectionLabel('Âm thanh'),
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: SwitchListTile(
              value: _soundOn,
              onChanged: (v) {
                setState(() => _soundOn = v);
                SettingsService.instance.setSoundOn(v);
              },
              title: const Text('Bật âm thanh'),
              subtitle: const Text('Âm từ vựng, hiệu ứng đúng/sai'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const _SectionLabel('Độ khó'),
          Row(
            children: [
              Expanded(
                child: _DifficultyChip(
                  label: 'Dễ',
                  icon: Icons.sentiment_satisfied_alt_rounded,
                  selected: _difficulty == Difficulty.easy,
                  onTap: () {
                    setState(() => _difficulty = Difficulty.easy);
                    SettingsService.instance.setDifficulty(Difficulty.easy);
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _DifficultyChip(
                  label: 'Khó',
                  icon: Icons.sentiment_neutral_rounded,
                  selected: _difficulty == Difficulty.hard,
                  onTap: () {
                    setState(() => _difficulty = Difficulty.hard);
                    SettingsService.instance.setDifficulty(Difficulty.hard);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Dễ: có thêm gợi ý (bớt 1 lựa chọn nhiễu, tự điền sẵn ô đầu). '
            'Khó: không có gợi ý thêm.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const _SectionLabel('Hồ sơ'),
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
              leading: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.error),
              title: Text('Xóa hồ sơ "${widget.profile.name}"'),
              subtitle: const Text('Cần giải phép tính xác nhận (phụ huynh)'),
              onTap: _deleteProfile,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary),
      ),
    );
  }
}

class _DifficultyChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _DifficultyChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.textSecondary,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: selected ? Colors.white : AppColors.textPrimary),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
