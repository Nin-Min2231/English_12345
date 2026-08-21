import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/models/models.dart';
import '../../../services/audio_service.dart';

/// F09 / G08 — Ghi âm (shadowing): nghe từ mẫu → nói theo → bấm "Dừng" khi
/// xong → so khớp văn bản nhận diện được với đáp án bằng khoảng cách
/// Levenshtein ra % chính xác → quy đổi điểm 0-100 + âm thanh cảnh báo theo
/// mốc điểm (<=50 / 51-80 / 81-100). Đổi từ package `record` sang
/// `speech_to_text` (CR-018) — đánh đổi đã xác nhận với người dùng: KHÔNG còn
/// phát lại giọng ghi âm của bé (package không lộ file âm thanh thô) và
/// KHÔNG còn tự chấm sao thủ công.
/// CR-022: thêm `_isScoring` — khoảng thời gian giữa lúc mic dừng và lúc kết
/// quả cuối cùng thực sự về tới (`onResult(finalResult: true)`) có thể trễ
/// vài giây; khóa nút "Ghi âm" + hiện "Đang chấm điểm..." trong lúc chờ, và
/// thêm trần chờ 1.5s (`_resultGraceWindow`) — quá hạn thì chấm luôn bằng
/// bản ghi nhận từng phần gần nhất thay vì chờ vô thời hạn.
/// CR-023: bỏ hẳn cơ chế tự dừng khi im lặng — trẻ tự bấm "Dừng" khi nói
/// xong (`_stopListening`, gọi `_speech.stop()`); `pauseFor` đặt bằng
/// `listenFor` để im lặng giữa chừng không còn tự ngắt (chỉ còn `listenFor`
/// làm trần an toàn nếu trẻ quên bấm Dừng).
/// CR-024: thêm banner hướng dẫn thao tác ở đầu màn hình + đổi trạng thái
/// `_isScoring` từ text nhỏ inline sang `_ScoringOverlay` che toàn màn hình
/// (dễ nhận biết hơn cho trẻ, chặn luôn thao tác trong lúc chờ điểm).
/// CR-025: `_startListening` xóa điểm lượt trước của từ hiện tại
/// (`_scores[_index] = null`) — sửa bug ghi âm lại không tính điểm mới/không
/// hiện loading (nguyên nhân: `onStatus` dựa vào `_scores[_index] != null`
/// để biết lượt đã có điểm, điểm CŨ còn sót lại làm nó tưởng lượt MỚI xong
/// rồi); banner hướng dẫn đổi màu `infoDark` đậm + in đậm cho dễ đọc.
class RecordScreen extends StatefulWidget {
  final UnitInfo unit;
  final List<FlashCard> items;

  const RecordScreen({super.key, required this.unit, required this.items});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  // CR-022: trần thời gian chờ kết quả CUỐI CÙNG sau khi mic đã dừng — nếu
  // `speech_to_text` không trả `finalResult` trong khoảng này, dùng luôn bản
  // ghi nhận từng phần (partial) gần nhất thay vì chờ vô thời hạn (xem
  // `_onResult`/`onStatus` bên dưới).
  static const _resultGraceWindow = Duration(milliseconds: 1500);

  int _index = 0;
  late List<int?> _scores; // % chính xác 0-100 mỗi từ; null = chưa nói thử.
  final _speech = SpeechToText();
  bool _speechAvailable = false;
  bool _isListening = false;
  // Giữa lúc dừng nghe và lúc có điểm thật sự (CR-020) — khóa nút "Ghi âm"
  // trong lúc này, xem class doc comment.
  bool _isScoring = false;
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
        // Lỗi thì không kẹt mãi ở "Đang chấm điểm..." (CR-020).
        setState(() {
          _isListening = false;
          _isScoring = false;
        });
      },
      onStatus: (status) {
        if (!mounted) return;
        if (status == 'done' || status == 'notListening') {
          final roundIndex = _index;
          final alreadyScored = _scores[roundIndex] != null;
          setState(() {
            _isListening = false;
            // Chỉ báo "đang chấm điểm" nếu lượt này CHƯA có điểm — status
            // done/notListening có thể tới trước HOẶC sau khi kết quả cuối
            // cùng đã về (xem CR-020 class doc comment).
            if (!alreadyScored) _isScoring = true;
          });
          if (!alreadyScored) {
            // CR-022: chặn trần thời gian chờ — nếu quá lâu vẫn chưa có
            // finalResult thật, chấm luôn bằng bản ghi nhận từng phần gần
            // nhất thay vì để trẻ chờ vô thời hạn. Chốt `roundIndex` từ lúc
            // hẹn giờ để không lỡ chấm nhầm từ nếu trẻ đã bấm "Quay lại"/
            // "Tiếp theo" sang từ khác trong lúc chờ.
            Future.delayed(_resultGraceWindow, () {
              if (!mounted) return;
              if (_index == roundIndex && _scores[roundIndex] == null) {
                _finishAttempt(_recognized);
              }
            });
          }
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
    AudioService.instance.play(_it.audio, grade: widget.unit.grade);
  }

  Future<void> _startListening() async {
    if (_isListening || _isScoring) return;
    if (!_speechAvailable) {
      await _initSpeech();
      if (!_speechAvailable) return;
    }
    setState(() {
      _recognized = '';
      // CR-025: xóa điểm lượt trước của TỪ NÀY — nếu không xóa, `onStatus`
      // bên dưới thấy `_scores[_index] != null` (điểm CŨ) sẽ tưởng lượt ghi
      // âm MỚI này đã có điểm rồi, bỏ qua cả `_isScoring`/loading lẫn cơ chế
      // chờ kết quả (grace window) — khiến ghi âm lại không tính điểm mới.
      _scores[_index] = null;
      _isListening = true;
      _isScoring = false;
    });
    await _speech.listen(
      onResult: _onResult,
      listenOptions: SpeechListenOptions(
        partialResults: true,
        // CR-023: pauseFor = listenFor để im lặng giữa chừng KHÔNG tự ngắt —
        // trẻ tự bấm "Dừng" (_stopListening); listenFor chỉ còn là trần an
        // toàn nếu quên bấm.
        listenFor: const Duration(seconds: 8),
        pauseFor: const Duration(seconds: 8),
        localeId: 'en_US',
      ),
    );
  }

  void _stopListening() {
    if (!_isListening) return;
    _speech.stop();
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
      _isScoring = false;
    });
    AudioService.instance.playSfx(_tierFor(score).sfx);
  }

  void _goTo(int newIndex) {
    setState(() {
      _index = newIndex;
      _recognized = '';
      _isListening = false;
      _isScoring = false;
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
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.infoDark.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: AppColors.infoDark),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Hãy bấm "Ghi âm" sau đó đọc 1 lần duy nhất rồi bấm '
                          '"Dừng ghi âm".',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.infoDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text('Từ ${_index + 1}/${widget.items.length}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: WordImage(
                      grade: widget.unit.grade, relativePath: _it.image),
                ),
              ),
              Text(_it.word,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold)),
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
                  label: _isListening
                      ? 'Dừng ghi âm'
                      : (_isScoring ? 'Đang chấm điểm...' : 'Ghi âm'),
                  icon: _isListening
                      ? Icons.stop_circle_rounded
                      : (_isScoring
                          ? Icons.hourglass_top_rounded
                          : Icons.mic_rounded),
                  // Nền đỏ nhạt khi đang nghe để dễ phân biệt trạng thái (CR-020)
                  // — chữ tối để đủ tương phản trên nền sáng màu (quy ước CR-009).
                  // CR-023: nút này giờ LUÔN bấm được lúc đang nghe (để dừng thủ
                  // công) nên không còn cần disabledColor cho nhánh đó — chỉ lúc
                  // "Đang chấm điểm..." mới thực sự disabled, dùng màu xám mặc
                  // định của Flutter là đủ (nhất quán với các nút chờ khác trong
                  // app, vd "Tiếp theo" lúc chưa trả lời).
                  color: _isListening ? AppColors.error : AppColors.infoDark,
                  foregroundColor:
                      _isListening ? AppColors.textPrimary : Colors.white,
                  onPressed: _isListening
                      ? _stopListening
                      : (_isScoring ? null : _startListening),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (_isListening)
                const Text('Đang nghe... nói từ vừa nghe, xong thì bấm "Dừng"!',
                    style:
                        TextStyle(fontSize: 14, color: AppColors.textSecondary))
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
          if (_isScoring) const _ScoringOverlay(),
        ],
      ),
    );
  }
}

/// Màn hình loading toàn màn hình khi chờ kết quả nhận diện giọng nói sau khi
/// bé bấm "Dừng ghi âm" — chặn hết thao tác (Container có màu nên tự chặn hit
/// test cho các widget bên dưới trong Stack) cho tới khi có điểm.
class _ScoringOverlay extends StatelessWidget {
  const _ScoringOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.55),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.infoDark),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Hệ thống đang chấm điểm cho bé, vui lòng chờ tý nhé!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
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
