import 'package:flutter/material.dart';

/// Bảng màu lấy từ tài liệu — sheet 09 Design System.
class AppColors {
  static const primary = Color(0xFF4C6FFF);
  static const secondary = Color(0xFFFF8A3D);
  static const success = Color(0xFF34C759);
  static const warning = Color(0xFFFFCC00);
  static const error = Color(0xFFFF6B6B);
  static const info = Color(0xFF5AC8FA);
  static const background = Color(0xFFF7F9FC);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);

  /// Mỗi unit một màu nền pastel để trẻ dễ phân biệt chủ đề.
  static const List<Color> unitColors = [
    Color(0xFFFFE0E0),
    Color(0xFFFFF0D9),
    Color(0xFFE0F7FF),
    Color(0xFFE3FBE3),
    Color(0xFFF0E6FF),
    Color(0xFFFFF6D6),
    Color(0xFFFFE6F0),
    Color(0xFFE0F0FF),
    Color(0xFFFDF0E0),
    Color(0xFFE9FBE9),
    Color(0xFFEDE7FF),
    Color(0xFFFFEFE0),
    Color(0xFFE0FBF4),
    Color(0xFFFFE9E9),
    Color(0xFFEAF2FF),
    Color(0xFFFFF3DA),
  ];

  static Color unitColor(int unitId) =>
      unitColors[(unitId - 1) % unitColors.length];
}

/// Khoảng cách, bo góc, vùng chạm — lưới 8pt (sheet 09).
class AppSpacing {
  static const double xs = 4, sm = 8, md = 12, lg = 16, xl = 24, xxl = 32;
  static const double radiusSm = 12, radiusMd = 16, radiusLg = 24;
  static const double touchMin = 48, primaryButtonHeight = 60;
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      brightness: Brightness.light,
    );
    // Ghi chú: font Baloo 2 / Nunito (sheet 09) có thể thêm qua package
    // google_fonts hoặc bundle file .ttf. Demo dùng font hệ thống + cỡ/độ đậm
    // đúng chuẩn tối thiểu 16sp.
    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
    );
  }
}
