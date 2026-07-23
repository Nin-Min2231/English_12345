import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// F15 — Cổng phụ huynh: phép tính cộng/trừ đơn giản (1-2 chữ số) để chặn
/// trẻ tự ý vào cài đặt/xóa hồ sơ. Không khóa, không giới hạn số lần thử —
/// chỉ 1 gia đình dùng chung máy, không cần chống đoán mò kiểu brute-force.
/// Trả `true` nếu giải đúng, `false` nếu bấm Hủy.
Future<bool> showParentGate(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => const _ParentGateDialog(),
  );
  return result ?? false;
}

/// Hộp thoại xác nhận xóa hồ sơ — dùng chung cho màn Cài đặt và màn Hồ sơ
/// (chạm giữ để xóa). Trả `true` nếu người dùng chọn Xóa.
Future<bool> confirmDeleteProfile(
    BuildContext context, String profileName) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
      title: const Text('Xóa hồ sơ?'),
      content: Text(
          'Toàn bộ tiến độ học của "$profileName" sẽ mất và không khôi phục được.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: const Text('Xóa'),
        ),
      ],
    ),
  );
  return result ?? false;
}

class _ParentGateDialog extends StatefulWidget {
  const _ParentGateDialog();

  @override
  State<_ParentGateDialog> createState() => _ParentGateDialogState();
}

class _ParentGateDialogState extends State<_ParentGateDialog> {
  final _controller = TextEditingController();
  late int _a;
  late int _b;
  late bool _isAddition;
  String? _error;

  @override
  void initState() {
    super.initState();
    _newProblem();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _newProblem() {
    final rng = Random();
    _isAddition = rng.nextBool();
    _a = rng.nextInt(99) + 1;
    _b = _isAddition ? rng.nextInt(99) + 1 : rng.nextInt(_a + 1);
    _controller.clear();
  }

  void _submit() {
    final answer = int.tryParse(_controller.text.trim());
    final correct = _isAddition ? _a + _b : _a - _b;
    if (answer == correct) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _error = 'Chưa đúng, thử lại nhé!';
      _newProblem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
      title: const Text('Dành cho phụ huynh'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Giải phép tính sau để tiếp tục:',
              style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.md),
          Text(
            '$_a ${_isAddition ? '+' : '−'} $_b = ?',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              errorText: _error,
            ),
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Xác nhận'),
        ),
      ],
    );
  }
}
