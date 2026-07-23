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

  ContentRepository({
    required this.units,
    required this.flashByUnit,
    required this.listenByUnit,
    required this.fillByUnit,
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

    return ContentRepository(
      units: units,
      flashByUnit: flash,
      listenByUnit: listen,
      fillByUnit: fill,
    );
  }
}
