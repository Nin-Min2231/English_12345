import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'models/models.dart';

/// Nạp toàn bộ nội dung (unit + config game) từ assets/data một lần khi mở app.
/// Ở bản production sẽ thay bằng Drift/SQLite (sheet 07); ở demo slice này
/// đọc thẳng JSON cho gọn.
class ContentRepository {
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
  // Sprint 3 — G10 chỉ có 1 mục/unit (không phải List), xem models.dart.
  final Map<int, HuntLetterItem> huntByUnit;
  // Sprint 3 — key = unit checkpoint gắn Boss Quiz (4/8/12/16).
  final Map<int, List<BossQuizQuestion>> bossQuizByUnit;

  ContentRepository({
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

  /// Thư mục gốc chứa ảnh/audio (mirror của 04_image+audio).
  static const String assetBase = 'assets/content/';

  static String asset(String relativePath) => '$assetBase$relativePath';

  static Future<Map<String, dynamic>> _read(String path) async {
    final raw = await rootBundle.loadString(path);
    return json.decode(raw) as Map<String, dynamic>;
  }

  static Future<ContentRepository> load() async {
    final unitsRaw = await _read('assets/data/units.json');
    final units = (unitsRaw['units'] as List)
        .map((e) => UnitInfo.fromJson(e as Map<String, dynamic>))
        .toList();

    final flash = <int, List<FlashCard>>{};
    final g01 = await _read('assets/data/games/g01_flashcard.json');
    for (final inst in (g01['instances'] as List)) {
      final m = inst as Map<String, dynamic>;
      final cfg = m['config'] as Map<String, dynamic>;
      flash[m['unit_id'] as int] = (cfg['cards'] as List)
          .map((e) => FlashCard.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final listen = <int, List<ListenQuestion>>{};
    final g02 = await _read('assets/data/games/g02_listen_pick.json');
    for (final inst in (g02['instances'] as List)) {
      final m = inst as Map<String, dynamic>;
      final cfg = m['config'] as Map<String, dynamic>;
      listen[m['unit_id'] as int] = (cfg['questions'] as List)
          .map((e) => ListenQuestion.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final fill = <int, List<FillItem>>{};
    final g03 = await _read('assets/data/games/g03_fill_letter.json');
    for (final inst in (g03['instances'] as List)) {
      final m = inst as Map<String, dynamic>;
      final cfg = m['config'] as Map<String, dynamic>;
      fill[m['unit_id'] as int] = (cfg['items'] as List)
          .map((e) => FillItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final scramble = <int, List<ScrambleItem>>{};
    final g04 = await _read('assets/data/games/g04_scramble.json');
    for (final inst in (g04['instances'] as List)) {
      final m = inst as Map<String, dynamic>;
      final cfg = m['config'] as Map<String, dynamic>;
      scramble[m['unit_id'] as int] = (cfg['items'] as List)
          .map((e) => ScrambleItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final sentence = <int, List<SentenceItem>>{};
    final g05 = await _read('assets/data/games/g05_sentence.json');
    for (final inst in (g05['instances'] as List)) {
      final m = inst as Map<String, dynamic>;
      final cfg = m['config'] as Map<String, dynamic>;
      sentence[m['unit_id'] as int] = (cfg['items'] as List)
          .map((e) => SentenceItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final mindmap = <int, List<MindmapItem>>{};
    final g06 = await _read('assets/data/games/g06_mindmap.json');
    for (final inst in (g06['instances'] as List)) {
      final m = inst as Map<String, dynamic>;
      final cfg = m['config'] as Map<String, dynamic>;
      mindmap[m['unit_id'] as int] = (cfg['items'] as List)
          .map((e) => MindmapItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final funTime = <int, List<MemoryPairItem>>{};
    final g09 = await _read('assets/data/games/g09_memory.json');
    for (final inst in (g09['instances'] as List)) {
      final m = inst as Map<String, dynamic>;
      final cfg = m['config'] as Map<String, dynamic>;
      funTime[m['unit_id'] as int] = (cfg['pairs'] as List)
          .map((e) => MemoryPairItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final hunt = <int, HuntLetterItem>{};
    final g10 = await _read('assets/data/games/g10_letter_hunt.json');
    for (final inst in (g10['instances'] as List)) {
      final m = inst as Map<String, dynamic>;
      final cfg = m['config'] as Map<String, dynamic>;
      hunt[m['unit_id'] as int] = HuntLetterItem.fromJson(cfg);
    }

    final bossQuiz = <int, List<BossQuizQuestion>>{};
    final g12 = await _read('assets/data/games/g12_boss_quiz.json');
    for (final inst in (g12['instances'] as List)) {
      final m = inst as Map<String, dynamic>;
      final cfg = m['config'] as Map<String, dynamic>;
      bossQuiz[m['unit_id'] as int] = (cfg['questions'] as List)
          .map((e) => BossQuizQuestion.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return ContentRepository(
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
