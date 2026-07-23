import 'package:shared_preferences/shared_preferences.dart';

/// F15 — Độ khó: Easy thêm gợi ý trực quan (1 đáp án nhiễu làm mờ bớt ở
/// G02/G03/G06, ô/token đầu tự điền sẵn ở G04/G05); Hard giữ nguyên hành vi
/// gốc, không gợi ý thêm.
enum Difficulty { easy, hard }

/// F15 — Cài đặt: âm thanh bật/tắt, độ khó. Đọc `SharedPreferences` một lần
/// lúc khởi động (`init()`, gọi trong `main.dart`), cache trong bộ nhớ để
/// mọi nơi khác đọc đồng bộ (get/set không cần async).
class SettingsService {
  SettingsService._();
  static final SettingsService instance = SettingsService._();

  static const _keySoundOn = 'sound_on';
  static const _keyDifficulty = 'difficulty';

  SharedPreferences? _prefs;
  bool _soundOn = true;
  Difficulty _difficulty = Difficulty.easy;

  bool get soundOn => _soundOn;
  Difficulty get difficulty => _difficulty;
  bool get isEasy => _difficulty == Difficulty.easy;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _soundOn = _prefs!.getBool(_keySoundOn) ?? true;
    _difficulty = _prefs!.getString(_keyDifficulty) == Difficulty.hard.name
        ? Difficulty.hard
        : Difficulty.easy;
  }

  Future<void> setSoundOn(bool value) async {
    _soundOn = value;
    await _prefs?.setBool(_keySoundOn, value);
  }

  Future<void> setDifficulty(Difficulty value) async {
    _difficulty = value;
    await _prefs?.setString(_keyDifficulty, value.name);
  }
}
