import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/parent_gate.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/profile_repository.dart';
import '../grade/grade_select_screen.dart';

const _avatarChoices = ['🐶', '🐱', '🐰', '🦊', '🐻', '🐼', '🦁', '🐸'];

/// F02 — Chọn / tạo hồ sơ trẻ trước khi vào màn chọn lớp (SCR-00, Sprint 4).
/// Không có mật khẩu, chỉ tên + avatar vì trẻ chưa đọc thạo. Đứng trước chọn
/// lớp vì hồ sơ là danh tính đứa trẻ, độc lập với lớp đang học.
class ProfileSelectScreen extends StatefulWidget {
  final AppDatabase db;

  const ProfileSelectScreen({super.key, required this.db});

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

  /// `push` (không `pushReplacement`) — giữ `ProfileSelectScreen` này trong
  /// stack để `GradeSelectScreen` có nút "Quay lại" tự động về đúng lại màn
  /// hình này (trước đây `pushReplacement` xóa hẳn màn hồ sơ khỏi stack,
  /// không có đường lùi lại).
  void _openProfile(Profile p) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GradeSelectScreen(profile: p, db: widget.db),
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

  /// F15 — Chạm giữ 1 hồ sơ để sửa tên/avatar hoặc xóa (gate bằng cổng phụ
  /// huynh trước khi cho vào bảng chọn hành động).
  Future<void> _handleLongPress(Profile p) async {
    final gateOk = await showParentGate(context);
    if (!gateOk || !mounted) return;

    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: Text('Sửa hồ sơ "${p.name}"'),
              onTap: () => Navigator.of(context).pop('edit'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.error),
              title: const Text('Xóa hồ sơ'),
              onTap: () => Navigator.of(context).pop('delete'),
            ),
          ],
        ),
      ),
    );
    if (!mounted || action == null) return;

    if (action == 'edit') {
      await _showEditDialog(p);
    } else if (action == 'delete') {
      final confirmed = await confirmDeleteProfile(context, p.name);
      if (!confirmed || !mounted) return;
      await _profileRepo.delete(p.id);
    }
  }

  Future<void> _showEditDialog(Profile p) async {
    final result = await showDialog<_EditProfileResult>(
      context: context,
      builder: (_) => _EditProfileDialog(profile: p),
    );
    if (result != null && mounted) {
      await _profileRepo.update(p.id,
          name: result.name, avatarEmoji: result.avatarEmoji);
    }
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
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
                return _ProfileTile(
                  profile: p,
                  onTap: () => _openProfile(p),
                  onLongPress: () => _handleLongPress(p),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Mẹo: chạm giữ 1 hồ sơ để sửa hoặc xóa (dành cho phụ huynh)',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
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

class _EditProfileResult {
  final String name;
  final String avatarEmoji;

  const _EditProfileResult(this.name, this.avatarEmoji);
}

/// Hộp thoại sửa tên/avatar — tách riêng thành `StatefulWidget` (giống
/// `_ParentGateDialog` trong `parent_gate.dart`) để `TextEditingController`
/// được sở hữu và dispose đúng lúc bởi `State.dispose()` của CHÍNH dialog
/// này. Bản trước dùng `StatefulBuilder` + controller tạo/dispose thủ công
/// ngay sau `await showDialog(...)` — Future đó hoàn tất ngay khi
/// `Navigator.pop()` được gọi, TRƯỚC KHI hiệu ứng đóng dialog kết thúc, nên
/// `dispose()` chạy trong lúc `TextField` vẫn còn gắn với controller ->
/// Flutter báo lỗi "A TextEditingController was used after being disposed"
/// đúng lúc bấm "Lưu" (bug thật người dùng báo).
class _EditProfileDialog extends StatefulWidget {
  final Profile profile;

  const _EditProfileDialog({required this.profile});

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  late final _nameController = TextEditingController(text: widget.profile.name);
  late String _avatar = widget.profile.avatarEmoji;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(_EditProfileResult(name, _avatar));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
      title: const Text('Sửa hồ sơ'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _avatarChoices
                .map((a) => _AvatarChoice(
                      emoji: a,
                      selected: a == _avatar,
                      onTap: () => setState(() => _avatar = a),
                    ))
                .toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final Profile profile;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ProfileTile(
      {required this.profile, required this.onTap, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        onTap: onTap,
        onLongPress: onLongPress,
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
