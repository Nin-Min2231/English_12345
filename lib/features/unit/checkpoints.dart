import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/repositories/progress_repository.dart';
import '../games/boss_quiz/boss_quiz_screen.dart';
import '../games/memory_match/memory_match_screen.dart';
import 'game_defs.dart';

/// Sprint 3 — 1 điểm mốc gắn vào 1 unit cụ thể (không phải mọi unit như
/// G01-G10): Fun Time (G09) sau Unit 2/6/10/14, Boss Quiz (G12) sau Unit
/// 4/8/12/16. [afterUnit] là unit mà tile checkpoint xuất hiện trên đó (dùng
/// [ProgressRepository.isCheckpointUnlocked] để khóa/mở — cần chính unit đó
/// xong 4 game lõi, không phải unit trước). [fromUnit]/[toUnit] là phạm vi
/// nội dung checkpoint bao phủ, chỉ để hiển thị nhãn (vd "Unit 1-2").
class Checkpoint {
  final int afterUnit;
  final int fromUnit;
  final int toUnit;
  final String? badgeId;

  const Checkpoint({
    required this.afterUnit,
    required this.fromUnit,
    required this.toUnit,
    this.badgeId,
  });
}

const kFunTimeCheckpoints = [
  Checkpoint(afterUnit: 2, fromUnit: 1, toUnit: 2),
  Checkpoint(afterUnit: 6, fromUnit: 5, toUnit: 6),
  Checkpoint(afterUnit: 10, fromUnit: 9, toUnit: 10),
  Checkpoint(afterUnit: 14, fromUnit: 13, toUnit: 14),
];

const kBossQuizCheckpoints = [
  Checkpoint(afterUnit: 4, fromUnit: 1, toUnit: 4, badgeId: 'badge_u4'),
  Checkpoint(afterUnit: 8, fromUnit: 5, toUnit: 8, badgeId: 'badge_u8'),
  Checkpoint(afterUnit: 12, fromUnit: 9, toUnit: 12, badgeId: 'badge_u12'),
  Checkpoint(afterUnit: 16, fromUnit: 13, toUnit: 16, badgeId: 'badge_u16'),
];

GameDef _funTimeGameDef(Checkpoint cp) => GameDef(
      gameType: 'g09',
      // Đổi tên "Fun Time" -> "Lật thẻ" theo yêu cầu người dùng (CR-023).
      baseLabel: 'Lật thẻ',
      countSuffix: (n) => '($n cặp)',
      icon: Icons.grid_view_rounded,
      color: AppColors.successDark,
      // CR-023: yêu cầu chặt hơn isCheckpointUnlocked (chỉ 4 game lõi của 1
      // unit) — Lật thẻ (ôn tập) cần CẢ 2 unit trong phạm vi ôn tập
      // (cp.fromUnit/toUnit) đã hoàn tất MỌI game (kGameTypeOrder), không chỉ
      // 4 game lõi. Không đụng Boss Quiz — vẫn dùng isCheckpointUnlocked.
      // hasContent (CR-028 phần 2) bỏ qua game chưa có dữ liệu ở unit đó (vd
      // G06 Lớp 1) — thiếu chốt này Lật thẻ sẽ khóa cứng vĩnh viễn giống bug
      // G08 cũ, xem BUGS_CR.md CR-028.
      isUnlockedOverride: (repo, contentRepo, progress, unitId) =>
          repo.isFunTimeUnlocked(progress, cp.fromUnit, cp.toUnit,
              hasContent: (u, g) =>
                  gameDefsByType[g]!.countFor(contentRepo, u) > 0),
      countFor: (repo, unitId) => repo.funTimeByUnit[unitId]?.length ?? 0,
      buildScreen: (context, repo, unit) => MemoryMatchScreen(
        unit: unit,
        pairs: repo.funTimeByUnit[unit.unitId] ?? const [],
        fromUnit: cp.fromUnit,
        toUnit: cp.toUnit,
      ),
    );

GameDef _bossQuizGameDef(Checkpoint cp) => GameDef(
      gameType: 'g12',
      baseLabel: 'Boss Quiz',
      countSuffix: (n) => '($n câu)',
      icon: Icons.emoji_events_rounded,
      color: AppColors.errorDark,
      isUnlockedOverride: (repo, contentRepo, progress, unitId) =>
          repo.isCheckpointUnlocked(progress, unitId),
      badgeId: cp.badgeId,
      countFor: (repo, unitId) => repo.bossQuizByUnit[unitId]?.length ?? 0,
      buildScreen: (context, repo, unit) => BossQuizScreen(
        unit: unit,
        questions: repo.bossQuizByUnit[unit.unitId] ?? const [],
        fromUnit: cp.fromUnit,
        toUnit: cp.toUnit,
      ),
    );

/// Game bổ sung (nếu có) cho 1 unit cụ thể, ngoài [kUnitGames] (danh sách
/// dùng chung cho mọi unit). afterUnit của Fun Time (2/6/10/14) và Boss Quiz
/// (4/8/12/16) không bao giờ trùng nhau nên 1 unit chỉ có tối đa 1 checkpoint.
List<GameDef> extraGamesForUnit(int unitId) {
  for (final cp in kFunTimeCheckpoints) {
    if (cp.afterUnit == unitId) return [_funTimeGameDef(cp)];
  }
  for (final cp in kBossQuizCheckpoints) {
    if (cp.afterUnit == unitId) return [_bossQuizGameDef(cp)];
  }
  return const [];
}
