import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/models/models.dart';
import '../../../services/audio_service.dart';

/// F09 / G08 — Ghi âm (shadowing): nghe từ mẫu → nói theo (tự dừng khi im
/// lặng ~2 giây, không cần bấm "Dùng") → so khớp văn bản nhận diện được với
/// đáp án bằng khoảng cách Levenshtein ra % chính xác → quy đổi điểm 0-100 +
/// âm thanh cảnh báo theo mốc điểm (<=50 / 51-80 / 81-100). Đổi từ package
/// `record` sang `speech_to_text` (CR-018) — đánh đổi đã xác nhận với người
/// dùng: KHÔNG còn phát lại giọng ghi âm của bé (package không lộ file âm
/// thanh thô) và KHÔNG còn tự chấm sao thủ công.
class RecordScreen extends StatefulWidget {
  final UnitInfo unit;
  final List<FlashCard> items;

  const RecordScreen({super.key, required this.unit, required this.items});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  int _index = 0;
  late List<int?> _scores; // % chính xác 0-100 mỗi từ; null = chưa nói thử.
  final _speech = SpeechToText();
  bool _speechAvailable = false;
  bool _isListening = false;
  String _recognized = '';
  String? _micError; // 'denied' | 'permanentlyDenied' | 'notAvailable'

  @override
  void initState() {
    super.initState();
    _scores = List.filled(widget.items.length, null);
    _initSpeech();
    WidgetsBinding.instance.addPostFrameCallback((_) => _playModel());
  }

  Future<void> _initSpeech() async {
    final available = await _speech.initialize(
      onError: (_) {
        if (!mounted) return;
        setState(() => _isListening = false);
      },
      onStatus: (status) {
        if (!mounted) return;
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
    );
    if (!mounted) return;
    if (available) {
      setState(() {
        _speechAvailable = true;
        _micError = null;
      });
      return;
    }
    final status = await Permission.microphone.status;
    if (!mounted) return;
    setState(() {
      _speechAvailable = false;
      _micError = status.isPermanentlyDenied ? 'permanentlyDenied' : 'denied';
    });
  }

  @override
  void dispose() {
    _speech.stop();
    AudioService.instance.stop();
    super.dispose();
  }

  FlashCard get _it => widget.items[_index];
  int? get _score => _scores[_index];

  void _playModel() {
    if (_isListening) return;
    AudioService.instance.play(_it.audio);
  }

  Future<void> _startListening() async {
    if (_isListening) return;
    if (!_speechAvailable) {
      await _initSpeech();
      if (!_speechAvailable) return;
    }
    setState(() {
      _recognized = '';
      _isListening = true;
    });
    await _speech.listen(
      onResult: _onResult,
      listenOptions: SpeechListenOptions(
        partialResults: true,
        listenFor: const Duration(seconds: 8),
        pauseFor: const Duration(seconds: 2),
        localeId: 'en_US',
      ),
    );
  }

  void _onResult(SpeechRecognitionResult result) {
    if (!mounted) return;
    if (result.finalResult) {
      _finishAttempt(result.recognizedWords);
    } else {
      setState(() => _recognized = result.recognizedWords);
    }
  }

  void _finishAttempt(String recognized) {
    final score = _scoreFor(recognized, _it.word);
    setState(() {
      _recognized = recognized;
      _scores[_index] = score;
      _isListening = false;
    });
    AudioService.instance.playSfx(_tierFor(score).sfx);
  }

  void _goTo(int newIndex) {
    setState(() {
      _index = newIndex;
      _recognized = '';
      _isListening = false;
    });
    _playModel();
  }

  void _goBack() {
    if (_index > 0) _goTo(_index - 1);
  }

  void _goNext() {
    if (_index + 1 >= widget.items.length) {
      _showResult();
      return;
    }
    _goTo(_index + 1);
  }

  void _showResult() {
    final done = _scores.whereType<int>().toList();
    final avg =
        done.isEmpty ? 0 : (done.reduce((a, b) => a + b) / done.length).round();
    final stars = _tierFor(avg).stars;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
        title: const Text('Hoàn thành! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Điểm phát âm trung bình: $avg/100',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: AppSpacing.md),
            StarBar(stars: stars, size: 40),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(stars);
            },
            child: const Text('Xong'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = _score;
    final tier = score == null ? null : _tierFor(score);
    return AppScaffold(
      backgroundColor: AppColors.unitColor(widget.unit.unitId),
      appBar: AppBar(
        backgroundColor: AppColors.infoDark,
        foregroundColor: Colors.white,
        title: Text('Ghi âm • Unit ${widget.unit.unitId}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text('Từ ${_index + 1}/${widget.items.length}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: WordImage(relativePath: _it.image),
            ),
          ),
          Text(_it.word,
              style:
                  const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.lg),
          if (_micError != null) _MicErrorBanner(kind: _micError!),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: PrimaryButton(
              label: 'Nghe mẫu',
              icon: Icons.volume_up_rounded,
              color: AppColors.infoDark,
              onPressed: _isListening ? null : _playModel,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: PrimaryButton(
              label: _isListening ? 'Đang nghe...' : 'Ghi âm',
              icon: _isListening ? Icons.graphic_eq_rounded : Icons.mic_rounded,
              color: AppColors.infoDark,
              onPressed: _isListening ? null : _startListening,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_isListening)
            const Text('Đang nghe... nói từ vừa nghe nhé!',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary))
          else if (score != null) ...[
            if (_recognized.isNotEmpty)
              Text('Bé nói: "$_recognized"',
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.xs),
            Text('$score điểm — ${tier!.label}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: tier.color)),
          ],
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: 'Quay lại',
                    icon: Icons.arrow_back_rounded,
                    onPressed: _index > 0 ? _goBack : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: PrimaryButton(
                    label: 'Tiếp theo',
                    icon: Icons.arrow_forward_rounded,
                    color: AppColors.infoDark,
                    onPressed: score != null ? _goNext : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Khoảng cách Levenshtein (số bước sửa tối thiểu để biến [a] thành [b]).
int _levenshtein(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;
  var prev = List<int>.generate(b.length + 1, (j) => j);
  for (var i = 1; i <= a.length; i++) {
    final curr = List<int>.filled(b.length + 1, 0);
    curr[0] = i;
    for (var j = 1; j <= b.length; j++) {
      final cost = a[i - 1] == b[j - 1] ? 0 : 1;
      curr[j] = [curr[j - 1] + 1, prev[j] + 1, prev[j - 1] + cost]
          .reduce((x, y) => x < y ? x : y);
    }
    prev = curr;
  }
  return prev[b.length];
}

/// % giống nhau giữa lời nói nhận diện được và đáp án (0-100) — so sánh
/// không phân biệt hoa/thường, bỏ khoảng trắng thừa đầu/cuối (CR-018).
int _scoreFor(String recognized, String target) {
  final a = recognized.trim().toLowerCase();
  final b = target.trim().toLowerCase();
  if (a.isEmpty) return 0;
  final maxLen = a.length > b.length ? a.length : b.length;
  if (maxLen == 0) return 100;
  final similarity = 1 - (_levenshtein(a, b) / maxLen);
  return (similarity.clamp(0, 1) * 100).round();
}

/// Mốc điểm (CR-018, theo yêu cầu người dùng: <=50 / 51-80 / 81-100) — dùng
/// chung cho cả âm thanh cảnh báo mỗi từ lẫn quy đổi sao tổng kết.
({String sfx, String label, Color color, int stars}) _tierFor(int score) {
  if (score > 80) {
    return (
      sfx: 'score_high.mp3',
      label: 'Tuyệt vời!',
      color: AppColors.success,
      stars: 3,
    );
  }
  if (score > 50) {
    return (
      sfx: 'score_mid.mp3',
      label: 'Khá tốt!',
      color: AppColors.warning,
      stars: 2,
    );
  }
  return (
    sfx: 'score_low.mp3',
    label: 'Cần cố gắng thêm!',
    color: AppColors.error,
    stars: 1,
  );
}

class _MicErrorBanner extends StatelessWidget {
  final String kind;

  const _MicErrorBanner({required this.kind});

  @override
  Widget build(BuildContext context) {
    final permanentlyDenied = kind == 'permanentlyDenied';
    final notAvailable = kind == 'notAvailable';
    String message;
    if (notAvailable) {
      message = 'Thiết bị này không hỗ trợ nhận diện giọng nói.';
    } else if (permanentlyDenied) {
      message = 'Chưa có quyền dùng micro. Mở Cài đặt để bật quyền cho app.';
    } else {
      message =
          'Cần quyền dùng micro để ghi âm. Bấm "Ghi âm" lần nữa để cho phép.';
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: const TextStyle(color: AppColors.error)),
          if (permanentlyDenied) ...[
            const SizedBox(height: AppSpacing.sm),
            const TextButton(
              onPressed: openAppSettings,
              child: Text('Mở Cài đặt'),
            ),
          ],
        ],
      ),
    );
  }
}
