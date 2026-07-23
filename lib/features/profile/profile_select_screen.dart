import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/content_repository.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/profile_repository.dart';
import '../home/home_screen.dart';

const _avatarChoices = ['🐶', '🐱', '🐰', '🦊', '🐻', '🐼', '🦁', '🐸'];

/// F02 — Chọn / tạo hồ sơ trẻ trước khi vào Home. Không có mật khẩu,
/// chỉ tên + avatar vì trẻ chưa đọc thạo.
class ProfileSelectScreen extends StatefulWidget {
  final ContentRepository repo;
  final AppDatabase db;

  const ProfileSelectScreen({super.key, required this.repo, required this.db});

  @override
  State<ProfileSelectScreen> createState() => _ProfileSelectScreenState();
}

class _ProfileSelectScreenState extends State<ProfileSelectScreen> {
  late final ProfileRepository _profileRepo = ProfileRepository(widget.db);
  bool _creating = false;
  String _selectedAvatar = _avatarChoices.first;
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _openProfile(Profile p) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            HomeScreen(repo: widget.repo, db: widget.db, profile: p),
      ),
    );
  }

  Future<void> _submitCreate() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final p =
        await _profileRepo.create(name: name, avatarEmoji: _selectedAvatar);
    if (!mounted) return;
    _openProfile(p);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Hồ sơ của bé',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
      ),
      body: StreamBuilder<List<Profile>>(
        stream: _profileRepo.watchProfiles(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final profiles = snapshot.data!;
          final showCreate = _creating || profiles.isEmpty;
          if (showCreate) {
            return _buildCreateForm(canCancel: profiles.isNotEmpty);
          }
          return _buildProfileGrid(profiles);
        },
      ),
    );
  }

  Widget _buildProfileGrid(List<Profile> profiles) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
        ),
        itemCount: profiles.length + 1,
        itemBuilder: (context, i) {
          if (i == profiles.length) {
            return _AddProfileTile(
                onTap: () => setState(() => _creating = true));
          }
          final p = profiles[i];
          return _ProfileTile(profile: p, onTap: () => _openProfile(p));
        },
      ),
    );
  }

  Widget _buildCreateForm({required bool canCancel}) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Bé tên là gì?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Nhập tên...',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: AppSpacing.xl),
          const Text('Chọn hình đại diện',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: _avatarChoices
                .map((a) => _AvatarChoice(
                      emoji: a,
                      selected: a == _selectedAvatar,
                      onTap: () => setState(() => _selectedAvatar = a),
                    ))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.xxl),
          PrimaryButton(
              label: 'Bắt đầu',
              icon: Icons.check_rounded,
              onPressed: _submitCreate),
          if (canCancel) ...[
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: () => setState(() => _creating = false),
              child: const Text('Quay lại'),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final Profile profile;
  final VoidCallback onTap;

  const _ProfileTile({required this.profile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(profile.avatarEmoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(height: AppSpacing.xs),
              Text(profile.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddProfileTile extends StatelessWidget {
  final VoidCallback onTap;

  const _AddProfileTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        onTap: onTap,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline_rounded,
                size: 36, color: AppColors.primary),
            SizedBox(height: AppSpacing.xs),
            Text('Thêm hồ sơ', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _AvatarChoice extends StatelessWidget {
  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  const _AvatarChoice(
      {required this.emoji, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 28)),
      ),
    );
  }
}
