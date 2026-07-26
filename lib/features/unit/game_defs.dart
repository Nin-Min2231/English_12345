import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/content_repository.dart';
import '../../data/db/app_database.dart';
import '../../data/models/models.dart';
import '../../data/repositories/progress_repository.dart';
import '../flashcard/flashcard_screen.dart';
import '../games/fill_letter/fill_letter_screen.dart';
import '../games/listen_pick/listen_pick_screen.dart';
import '../games/mindmap/mindmap_screen.dart';
import '../games/letter_hunt/letter_hunt_screen.dart';
import '../games/record/record_screen.dart';
import '../games/scramble/scramble_screen.dart';
import '../games/sentence_build/sentence_build_screen.dart';

/// Khai báo 1 game trong danh sách game của 1 unit (UnitScreen) — thay cho
/// việc chép tay 1 khối `_gameRow` cho mỗi game. Thêm game mới = thêm 1 mục
/// vào [_gameDefsByType] + đúng gameType đó vào `kGameTypeOrder`
/// (progress_repository.dart), không cần sửa UnitScreen.
class GameDef {
  final String gameType;
  final String baseLabel;
  final String Function(int count) countSuffix;
  final IconData icon;
  final Color? color;
  // Nền sáng màu (warning vàng, error đỏ nhạt) cần chữ tối để đủ tương phản
  // cho trẻ đọc — xem CR-005/CR-008 BUGS_CR.md. null = mặc định trắng.
  final Color? foregroundColor;
  // Sprint 3 — game checkpoint (Fun Time/Boss Quiz, xem checkpoints.dart)
  // không nằm trong kGameTypeOrder nên cần điều kiện mở khóa riêng thay vì
  // ProgressRepository.isGameUnlocked mặc định. null = dùng isGameUnlocked.
  final bool Function(
          ProgressRepository repo, List<LessonProgress> progress, int unitId)?
      isUnlockedOverride;
  // Sprint 3 — chỉ set cho 4 checkpoint Boss Quiz; UnitScreen dùng để trao
  // huy hiệu sau khi hoàn thành đạt ngưỡng (xem unit_screen.dart).
  final String? badgeId;
  final int Function(ContentRepository repo, int unitId) countFor;
  final Widget Function(
      BuildContext context, ContentRepository repo, UnitInfo unit) buildScreen;

  const GameDef({
    required this.gameType,
    required this.baseLabel,
    required this.countSuffix,
    required this.icon,
    this.color,
    this.foregroundColor,
    this.isUnlockedOverride,
    this.badgeId,
    required this.countFor,
    required this.buildScreen,
  });

  String label(int count) => '$baseLabel ${countSuffix(count)}';
  String lockedLabel() => '$baseLabel 🔒';
}

final Map<String, GameDef> gameDefsByType = {
  'g01': GameDef(
    gameType: 'g01',
    baseLabel: 'Flashcard',
    countSuffix: (n) => '($n thẻ)',
    icon: Icons.style_rounded,
    countFor: (repo, unitId) => repo.flashByUnit[unitId]?.length ?? 0,
    buildScreen: (context, repo, unit) => FlashcardScreen(
      unit: unit,
      cards: repo.flashByUnit[unit.unitId] ?? const [],
    ),
  ),
  'g02': GameDef(
    gameType: 'g02',
    baseLabel: 'Nghe chọn hình',
    countSuffix: (n) => '($n câu)',
    icon: Icons.hearing_rounded,
    color: AppColors.secondary,
    countFor: (repo, unitId) => repo.listenByUnit[unitId]?.length ?? 0,
    buildScreen: (context, repo, unit) => ListenPickScreen(
      unit: unit,
      questions: repo.listenByUnit[unit.unitId] ?? const [],
    ),
  ),
  'g03': GameDef(
    gameType: 'g03',
    baseLabel: 'Điền chữ',
    countSuffix: (n) => '($n từ)',
    icon: Icons.abc_rounded,
    color: AppColors.info,
    countFor: (repo, unitId) => repo.fillByUnit[unitId]?.length ?? 0,
    buildScreen: (context, repo, unit) => FillLetterScreen(
      unit: unit,
      items: repo.fillByUnit[unit.unitId] ?? const [],
    ),
  ),
  'g04': GameDef(
    gameType: 'g04',
    baseLabel: 'Xếp chữ',
    countSuffix: (n) => '($n từ)',
    icon: Icons.extension_rounded,
    color: AppColors.success,
    countFor: (repo, unitId) => repo.scrambleByUnit[unitId]?.length ?? 0,
    buildScreen: (context, repo, unit) => ScrambleScreen(
      unit: unit,
      items: repo.scrambleByUnit[unit.unitId] ?? const [],
    ),
  ),
  'g05': GameDef(
    gameType: 'g05',
    baseLabel: 'Lắp ráp câu',
    countSuffix: (n) => '($n câu)',
    icon: Icons.reorder_rounded,
    color: AppColors.warning,
    foregroundColor: AppColors.textPrimary,
    countFor: (repo, unitId) => repo.sentenceByUnit[unitId]?.length ?? 0,
    buildScreen: (context, repo, unit) => SentenceBuildScreen(
      unit: unit,
      items: repo.sentenceByUnit[unit.unitId] ?? const [],
    ),
  ),
  'g06': GameDef(
    gameType: 'g06',
    baseLabel: 'Hoàn thành câu',
    countSuffix: (n) => '($n câu)',
    icon: Icons.psychology_alt_rounded,
    color: AppColors.error,
    foregroundColor: AppColors.textPrimary,
    countFor: (repo, unitId) => repo.mindmapByUnit[unitId]?.length ?? 0,
    buildScreen: (context, repo, unit) => MindmapScreen(
      unit: unit,
      items: repo.mindmapByUnit[unit.unitId] ?? const [],
    ),
  ),
  'g08': GameDef(
    gameType: 'g08',
    baseLabel: 'Ghi âm',
    countSuffix: (n) => '($n từ)',
    icon: Icons.mic_rounded,
    color: AppColors.infoDark,
    // Đã dùng hết 6 màu vai trò trong AppColors (sheet 09) cho G01-G06 —
    // G08 dùng lại info (giống G03) nhưng tông đậm hơn (infoDark, CR-018) vì
    // chữ trắng trên info gốc khó đọc; phân biệt G09+ sau này bằng icon/nhãn
    // khi hết màu riêng.
    countFor: (repo, unitId) => repo.flashByUnit[unitId]?.length ?? 0,
    buildScreen: (context, repo, unit) => RecordScreen(
      unit: unit,
      items: repo.flashByUnit[unit.unitId] ?? const [],
    ),
  ),
  'g10': GameDef(
    gameType: 'g10',
    baseLabel: 'Săn chữ',
    countSuffix: (n) => '($n từ)',
    icon: Icons.search_rounded,
    color: AppColors.secondaryDark,
    // Sao tối đa 2 (không phải 3) theo catalog gốc — xem
    // progress_repository.dart _maxStarsByGameType.
    countFor: (repo, unitId) => repo.huntByUnit[unitId]?.length ?? 0,
    buildScreen: (context, repo, unit) => LetterHuntScreen(
      unit: unit,
      questions: repo.huntByUnit[unit.unitId] ?? const [],
    ),
  ),
};

/// Danh sách hiển thị trên UnitScreen, thứ tự SUY RA từ kGameTypeOrder
/// (progress_repository.dart) — không tự giữ thứ tự riêng nữa (xem
/// BUGS_CR.md Sprint 3 Phase 0: 2 danh sách độc lập trước đây là 1 lỗi tiềm
/// ẩn, thiếu đồng bộ 1 bên sẽ không hiện lỗi rõ ràng). Thiếu 1 GameDef so với
/// kGameTypeOrder sẽ crash ngay lúc khởi động (thay vì âm thầm sai) — cố ý,
/// dễ phát hiện hơn khi thêm game mới.
final List<GameDef> kUnitGames =
    kGameTypeOrder.map((t) => gameDefsByType[t]!).toList();
