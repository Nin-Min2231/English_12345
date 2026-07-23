import 'package:flutter/material.dart';

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

  const BadgeDef({
    required this.badgeId,
    required this.name,
    required this.icon,
    required this.afterUnit,
  });
}

// Tên/icon là đề xuất ban đầu (placeholder-quality, giống cách 2 file sfx
// correct.mp3/wrong.mp3 từng là suy đoán chờ xác nhận) — đổi dễ dàng, chỉ sửa
// list này, không cần đụng logic trao huy hiệu.
const kBadgeDefs = [
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
];
