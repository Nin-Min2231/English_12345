import 'package:flutter/material.dart';

import '../../data/course.dart';

/// F13/G12 — 1 huy hiệu trao sau khi vượt qua Boss Quiz của 1 Review (xem
/// checkpoints.dart: kBossQuizCheckpoints.badgeId khớp đúng [badgeId] ở đây).
/// Dữ liệu app tự định nghĩa (tài liệu gốc ghi "App tự định nghĩa" cho huy
/// hiệu — không có tên/tiêu chí/hình có sẵn) nên là hằng số Dart, giống
/// GameDef/kUnitGames, không phải nội dung nạp từ JSON/DB.
class BadgeDef {
  final String badgeId;
  final String name;
  final IconData icon;
  final int afterUnit;

  /// CR-037 — null = huy hiệu của chương trình lớp (1-5, hiện "Sau Unit N");
  /// kTopicCourseId = huy hiệu của luồng Chủ đề.
  final int? courseId;

  /// Dòng mô tả dưới tên huy hiệu; null = tự suy ra "Sau Unit $afterUnit".
  final String? subtitle;

  const BadgeDef({
    required this.badgeId,
    required this.name,
    required this.icon,
    required this.afterUnit,
    this.courseId,
    this.subtitle,
  });

  String get caption => subtitle ?? 'Sau Unit $afterUnit';
}

String topicBadgeId(int topicId) =>
    'badge_topic_${topicId.toString().padLeft(2, '0')}';

// Tên/icon là đề xuất ban đầu (placeholder-quality, giống cách 2 file sfx
// correct.mp3/wrong.mp3 từng là suy đoán chờ xác nhận) — đổi dễ dàng, chỉ sửa
// list này, không cần đụng logic trao huy hiệu.
const kBadgeDefs = [
  // ---- Lớp 1-5: GIỮ NGUYÊN 4 huy hiệu cũ, không đổi badgeId (đã có trong DB
  // của máy thật -> đổi là mất huy hiệu bé đã đạt).
  BadgeDef(
    badgeId: 'badge_u4',
    name: 'Ong Chăm Chỉ',
    icon: Icons.emoji_events_rounded,
    afterUnit: 4,
  ),
  BadgeDef(
    badgeId: 'badge_u8',
    name: 'Ngôi Sao Nhỏ',
    icon: Icons.workspace_premium_rounded,
    afterUnit: 8,
  ),
  BadgeDef(
    badgeId: 'badge_u12',
    name: 'Nhà Vô Địch',
    icon: Icons.military_tech_rounded,
    afterUnit: 12,
  ),
  BadgeDef(
    badgeId: 'badge_u16',
    name: 'Siêu Sao Anh Ngữ',
    icon: Icons.auto_awesome_rounded,
    afterUnit: 16,
  ),
  // ---- CR-037: 15 huy hiệu Chủ đề
  BadgeDef(
      badgeId: 'badge_topic_01',
      name: 'Hoạ Sĩ Nhí',
      icon: Icons.palette_rounded,
      afterUnit: 1,
      courseId: kTopicCourseId,
      subtitle: 'Chủ đề Màu sắc'),
  BadgeDef(
      badgeId: 'badge_topic_02',
      name: 'Vua Trái Cây',
      icon: Icons.eco_rounded,
      afterUnit: 2,
      courseId: kTopicCourseId,
      subtitle: 'Chủ đề Trái cây'),
  BadgeDef(
      badgeId: 'badge_topic_03',
      name: 'Bạn Của Muông Thú',
      icon: Icons.pets_rounded,
      afterUnit: 3,
      courseId: kTopicCourseId,
      subtitle: 'Chủ đề Động vật'),
  BadgeDef(
      badgeId: 'badge_topic_04',
      name: 'Người Đọc Mây Trời',
      icon: Icons.cloud_rounded,
      afterUnit: 4,
      courseId: kTopicCourseId,
      subtitle: 'Chủ đề Thời tiết'),
  BadgeDef(
      badgeId: 'badge_topic_05',
      name: 'Bạn Của Bốn Mùa',
      icon: Icons.ac_unit_rounded,
      afterUnit: 5,
      courseId: kTopicCourseId,
      subtitle: 'Chủ đề Bốn mùa'),
  BadgeDef(
      badgeId: 'badge_topic_06',
      name: 'Chủ Nhân Cuốn Lịch',
      icon: Icons.calendar_month_rounded,
      afterUnit: 6,
      courseId: kTopicCourseId,
      subtitle: 'Chủ đề Thứ, ngày, tháng'),
  BadgeDef(
      badgeId: 'badge_topic_07',
      name: 'Trái Tim Ấm Áp',
      icon: Icons.favorite_rounded,
      afterUnit: 7,
      courseId: kTopicCourseId,
      subtitle: 'Chủ đề Cảm xúc'),
  BadgeDef(
      badgeId: 'badge_topic_08',
      name: 'Bác Sĩ Tí Hon',
      icon: Icons.health_and_safety_rounded,
      afterUnit: 8,
      courseId: kTopicCourseId,
      subtitle: 'Chủ đề Bộ phận cơ thể'),
  BadgeDef(
      badgeId: 'badge_topic_09',
      name: 'Kiến Trúc Sư Nhí',
      icon: Icons.category_rounded,
      afterUnit: 9,
      courseId: kTopicCourseId,
      subtitle: 'Chủ đề Hình khối'),
  BadgeDef(
      badgeId: 'badge_topic_10',
      name: 'Nhà Thám Hiểm',
      icon: Icons.directions_bus_rounded,
      afterUnit: 10,
      courseId: kTopicCourseId,
      subtitle: 'Chủ đề Phương tiện'),
  BadgeDef(
      badgeId: 'badge_topic_11',
      name: 'Tổ Ấm Yêu Thương',
      icon: Icons.family_restroom_rounded,
      afterUnit: 11,
      courseId: kTopicCourseId,
      subtitle: 'Chủ đề Gia đình'),
  BadgeDef(
      badgeId: 'badge_topic_12',
      name: 'Ước Mơ Lớn',
      icon: Icons.work_rounded,
      afterUnit: 12,
      courseId: kTopicCourseId,
      subtitle: 'Chủ đề Nghề nghiệp'),
  BadgeDef(
      badgeId: 'badge_topic_13',
      name: 'Học Trò Chăm Chỉ',
      icon: Icons.school_rounded,
      afterUnit: 13,
      courseId: kTopicCourseId,
      subtitle: 'Chủ đề Dụng cụ học tập'),
  BadgeDef(
      badgeId: 'badge_topic_14',
      name: 'Đầu Bếp Nhí',
      icon: Icons.restaurant_rounded,
      afterUnit: 14,
      courseId: kTopicCourseId,
      subtitle: 'Chủ đề Món ăn'),
  BadgeDef(
      badgeId: 'badge_topic_15',
      name: 'Thần Đồng Con Số',
      icon: Icons.calculate_rounded,
      afterUnit: 15,
      courseId: kTopicCourseId,
      subtitle: 'Chủ đề Số đếm'),
];
