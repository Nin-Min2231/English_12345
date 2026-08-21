import 'package:just_audio/just_audio.dart';

import '../data/content_repository.dart';
import 'settings_service.dart';

/// Phát audio từ vựng/gợi ý. Bọc try/catch để file thiếu (vd 7 từ mở rộng
/// chưa có audio) không làm app crash.
class AudioService {
  AudioService._();
  static final AudioService instance = AudioService._();

  final AudioPlayer _player = AudioPlayer();
  // Player riêng cho âm hiệu ứng đúng/sai — để không cắt ngang audio từ vựng
  // đang phát cùng lúc (vd vừa phát lại từ vừa phát tiếng "đúng").
  final AudioPlayer _sfxPlayer = AudioPlayer();

  static const String _sfxBase = 'assets/sfx/';

  /// [relativePath] dạng "Unit01/audio/word_pasta.mp3" (như trong JSON).
  /// [grade] — Sprint 4, đa lớp: bắt buộc truyền (luôn có sẵn ở nơi gọi qua
  /// `widget.unit.grade`) để phát đúng file của đúng lớp.
  Future<void> play(String? relativePath, {required int grade}) async {
    if (relativePath == null || relativePath.isEmpty) return;
    if (!SettingsService.instance.soundOn) return;
    try {
      await _player.stop();
      await _player.setAsset(
          ContentRepository.asset(grade: grade, relativePath: relativePath));
      await _player.play();
    } catch (_) {
      // Bỏ qua khi thiếu file audio.
    }
  }

  /// Âm hiệu ứng ngắn khi trả lời đúng/sai (vd "correct.mp3", "wrong.mp3"
  /// trong `assets/sfx/`). An toàn khi thiếu file — xem mục 9 CLAUDE.md.
  Future<void> playSfx(String fileName) async {
    if (!SettingsService.instance.soundOn) return;
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setAsset('$_sfxBase$fileName');
      await _sfxPlayer.play();
    } catch (_) {
      // Bỏ qua khi thiếu file sfx.
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {}
    try {
      await _sfxPlayer.stop();
    } catch (_) {}
  }
}
