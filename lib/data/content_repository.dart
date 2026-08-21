import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'models/models.dart';

/// Nạp toàn bộ nội dung (unit + config game) từ assets/data một lần khi mở app.
/// Ở bản production sẽ thay bằng Drift/SQLite (sheet 07); ở demo slice này
/// đọc thẳng JSON cho gọn.
class ContentRepository {
  // Sprint 4 — đa lớp: repo này chỉ đại diện đúng 1 lớp (nạp qua
  // `load(grade:)`). Nơi nào cầm `repo` (HomeScreen, SettingsScreen,
  // BadgesScreen, ...) đọc trực tiếp `repo.grade` thay vì tự suy ra từ
  // `units.first.grade`.
  final int grade;
  final List<UnitInfo> units;
  final Map<int, List<FlashCard>> flashByUnit;
  final Map<int, List<ListenQuestion>> listenByUnit;
  final Map<int, List<FillItem>> fillByUnit;
  final Map<int, List<ScrambleItem>> scrambleByUnit;
  final Map<int, List<SentenceItem>> sentenceByUnit;
  final Map<int, List<MindmapItem>> mindmapByUnit;
  // Sprint 3 — key = unit checkpoint gắn Fun Time (2/6/10/14, xem
  // checkpoints.dart), không phải mọi unit.
  final Map<int, List<MemoryPairItem>> funTimeByUnit;
  // G10 (đổi mới, CR-020) — nghe & chọn từ vựng đúng, cùng shape List như mọi
  // game khác (đã bỏ shape "config phẳng 1 mục/unit" cũ, xem models.dart).
  final Map<int, List<WordHuntQuestion>> huntByUnit;
  // Sprint 3 — key = unit checkpoint gắn Boss Quiz (4/8/12/16).
  final Map<int, List<BossQuizQuestion>> bossQuizByUnit;

  ContentRepository({
    required this.grade,
    required this.units,
    required this.flashByUnit,
    required this.listenByUnit,
    required this.fillByUnit,
    required this.scrambleByUnit,
    required this.sentenceByUnit,
    required this.mindmapByUnit,
    required this.funTimeByUnit,
    required this.huntByUnit,
    required this.bossQuizByUnit,
  });

  /// Đường dẫn ảnh/audio đầy đủ cho 1 lớp (mirror của 04_image+audio, mục con
  /// theo lớp — Sprint 4). Hàm thuần, không static state: mọi nơi gọi (vd
  /// `WordImage`, `AudioService.play`) đều đã có sẵn `grade` qua `UnitInfo`
  /// đang cầm, nên không cần giữ "lớp hiện tại" ở đâu cả.
  static String asset({required int grade, required String relativePath}) =>
      'assets/content/lop$grade/$relativePath';

  static Future<Map<String, dynamic>> _read(String path) async {
    final raw = await rootBundle.loadString(path);
    return json.decode(raw) as Map<String, dynamic>;
  }

  /// Như [_read] nhưng dung thứ file game CHƯA TỒN TẠI (trả rỗng thay vì ném
  /// lỗi) — Sprint 4: Lớp 1 Unit 1 chưa có `g09_memory.json`/`g12_boss_quiz.json`
  /// (chưa tới checkpoint), và các lớp sau (3/4/5) sẽ còn thiếu nhiều hơn nữa
  /// lúc mới bắt đầu. Không có hàm này thì chạm vào 1 lớp thiếu file là app
  /// crash ngay khi `load()`.
  static Future<Map<String, dynamic>> _readOptionalGame(String path) async {
    try {
      return await _read(path);
    } catch (_) {
      return const {'instances': []};
    }
  }

  static Future<ContentRepository> load({required int grade}) async {
    final base = 'assets/data/lop$grade';
    final unitsRaw = await _read('$base/units.json');
    final units = (unitsRaw['units'] as List)
        .map((e) => UnitInfo.fromJson(e as Map<String, dynamic>, grade: grade))
        .toList();

    final flash = <int, List<FlashCard>>{};
    final g01 = await _readOptionalGame('$base/games/g01_flashcard.json');
    for (final inst in (g01['instances'] as List)) {
      final m = inst as Map<String, dynamic>;
      final cfg = m['config'] as Map<String, dynamic>;
      flash[m['unit_id'] as int] = (cfg['cards'] as List)
          .map((e) => FlashCard.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final listen = <int, List<ListenQuestion>>{};
    final g02 = await _readOptionalGame('$base/games/g02_listen_pick.json');
    for (final inst in (g02['instances'] as List)) {
      final m = inst as Map<String, dynamic>;
      final cfg = m['config'] as Map<String, dynamic>;
      listen[m['unit_id'] as int] = (cfg['questions'] as List)
          .map((e) => ListenQuestion.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final fill = <int, List<FillItem>>{};
    final g03 = await _readOptionalGame('$base/games/g03_fill_letter.json');
    for (final inst in (g03['instances'] as List)) {
      final m = inst as Map<String, dynamic>;
      final cfg = m['config'] as Map<String, dynamic>;
      fill[m['unit_id'] as int] = (cfg['items'] as List)
          .map((e) => FillItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final scramble = <int, List<ScrambleItem>>{};
    final g04 = await _readOptionalGame('$base/games/g04_scramble.json');
    for (final inst in (g04['instances'] as List)) {
      final m = inst as Map<String, dynamic>;
      final cfg = m['config'] as Map<String, dynamic>;
      scramble[m['unit_id'] as int] = (cfg['items'] as List)
          .map((e) => ScrambleItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final sentence = <int, List<SentenceItem>>{};
    final g05 = await _readOptionalGame('$base/games/g05_sentence.json');
    for (final inst in (g05['instances'] as List)) {
      final m = inst as Map<String, dynamic>;
      final cfg = m['config'] as Map<String, dynamic>;
      sentence[m['unit_id'] as int] = (cfg['items'] as List)
          .map((e) => SentenceItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final mindmap = <int, List<MindmapItem>>{};
    final g06 = await _readOptionalGame('$base/games/g06_mindmap.json');
    for (final inst in (g06['instances'] as List)) {
      final m = inst as Map<String, dynamic>;
      final cfg = m['config'] as Map<String, dynamic>;
      mindmap[m['unit_id'] as int] = (cfg['items'] as List)
          .map((e) => MindmapItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final funTime = <int, List<MemoryPairItem>>{};
    final g09 = await _readOptionalGame('$base/games/g09_memory.json');
    for (final inst in (g09['instances'] as List)) {
      final m = inst as Map<String, dynamic>;
      final cfg = m['config'] as Map<String, dynamic>;
      funTime[m['unit_id'] as int] = (cfg['pairs'] as List)
          .map((e) => MemoryPairItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final hunt = <int, List<WordHuntQuestion>>{};
    final g10 = await _readOptionalGame('$base/games/g10_letter_hunt.json');
    for (final inst in (g10['instances'] as List)) {
      final m = inst as Map<String, dynamic>;
      final cfg = m['config'] as Map<String, dynamic>;
      hunt[m['unit_id'] as int] = (cfg['questions'] as List)
          .map((e) => WordHuntQuestion.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final bossQuiz = <int, List<BossQuizQuestion>>{};
    final g12 = await _readOptionalGame('$base/games/g12_boss_quiz.json');
    for (final inst in (g12['instances'] as List)) {
      final m = inst as Map<String, dynamic>;
      final cfg = m['config'] as Map<String, dynamic>;
      bossQuiz[m['unit_id'] as int] = (cfg['questions'] as List)
          .map((e) => BossQuizQuestion.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return ContentRepository(
      grade: grade,
      units: units,
      flashByUnit: flash,
      listenByUnit: listen,
      fillByUnit: fill,
      scrambleByUnit: scramble,
      sentenceByUnit: sentence,
      mindmapByUnit: mindmap,
      funTimeByUnit: funTime,
      huntByUnit: hunt,
      bossQuizByUnit: bossQuiz,
    );
  }
}
