import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/content_repository.dart';
import '../theme/app_theme.dart';

/// Nút chính to, bo tròn (sheet 09 — PrimaryButton).
class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  // Mặc định trắng (khớp nền primary/secondary/info/success hiện có, sẫm màu).
  // Nền sáng màu (vd warning vàng, error đỏ nhạt) cần truyền chữ tối để đủ
  // tương phản cho trẻ đọc — xem CR-005/CR-008 BUGS_CR.md.
  final Color? foregroundColor;
  // CR-022: khi nút bị disabled (onPressed null), Flutter mặc định phớt lờ
  // `color`/`foregroundColor` và tự vẽ màu xám disabled riêng — nếu muốn màu
  // tùy biến VẪN hiện đúng lúc disabled (vd G08 "Ghi âm" nền đỏ khi đang nghe,
  // lúc đó nút đang bị disabled), phải truyền rõ 2 giá trị này. Để trống (mặc
  // định null) thì giữ nguyên màu xám disabled chuẩn của Flutter như trước.
  final Color? disabledColor;
  final Color? disabledForegroundColor;

  const PrimaryButton({
    super.key,
    required this.label,
    this.icon = Icons.play_arrow_rounded,
    this.onPressed,
    this.color,
    this.foregroundColor,
    this.disabledColor,
    this.disabledForegroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.primaryButtonHeight,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 26),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          foregroundColor: foregroundColor ?? Colors.white,
          disabledBackgroundColor: disabledColor,
          disabledForegroundColor: disabledForegroundColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      ),
    );
  }
}

/// Thanh 1–3 sao (sheet 09 — StarBar).
class StarBar extends StatelessWidget {
  final int stars;
  final double size;

  const StarBar({super.key, required this.stars, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (i) => Icon(
          i < stars ? Icons.star_rounded : Icons.star_border_rounded,
          color: AppColors.warning,
          size: size,
        ),
      ),
    );
  }
}

/// Ảnh từ vựng an toàn — nếu thiếu file thì hiện placeholder thay vì crash.
class WordImage extends StatelessWidget {
  // Sprint 4 — đa lớp: bắt buộc truyền để biết đọc ảnh từ
  // `assets/content/lop$grade/...` nào. Luôn có sẵn ở nơi gọi qua
  // `widget.unit.grade`, không cần state/context mới.
  final int grade;
  final String relativePath;
  final BoxFit fit;

  const WordImage(
      {super.key,
      required this.grade,
      required this.relativePath,
      this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ContentRepository.asset(grade: grade, relativePath: relativePath),
      fit: fit,
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(Icons.image_not_supported_outlined,
            size: 48, color: AppColors.textSecondary),
      ),
    );
  }
}

/// Header dùng chung cho các màn hình từ danh sách game trong 1 Unit
/// (`UnitScreen`) đến từng màn hình game bên trong — luôn hiện đủ "Lớp X •
/// Unit Y • Tên game" để biết ngay chương trình lớp mấy, unit bao nhiêu,
/// đang chơi game gì (trước đây chỉ có "Tên game • Unit Y", thiếu lớp — dễ
/// nhầm khi app đã hỗ trợ nhiều lớp từ Sprint 4). `gameName` để trống ở màn
/// danh sách game (chưa vào 1 game cụ thể). `unitLabel` là chuỗi vì game
/// checkpoint (Lật thẻ/Boss Quiz) gộp 2 unit liền nhau (vd "2-3").
/// `overflow`/`maxLines` để không vỡ AppBar trên máy màn hình hẹp khi chuỗi
/// dài (lớp lớn + unit 2 chữ số + tên game dài).
class GameAppBarTitle extends StatelessWidget {
  final int grade;
  final String unitLabel;
  final String? gameName;

  const GameAppBarTitle({
    super.key,
    required this.grade,
    required this.unitLabel,
    this.gameName,
  });

  @override
  Widget build(BuildContext context) {
    final parts = [
      'Lớp $grade',
      'Unit $unitLabel',
      if (gameName != null) gameName!,
    ];
    return Text(
      parts.join(' • '),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
    );
  }
}

/// Chiều cao 1 hàng cho lưới ô chọn 2 cột dùng `childAspectRatio`/
/// `mainAxisExtent` cố định (G04 Xếp chữ, G05 Lắp ráp câu) — khi từ/câu dài
/// (nhiều ô chữ/token hơn -> nhiều hàng hơn), hàng co nhỏ lại theo 1 ngân
/// sách chiều cao CỐ ĐỊNH cho cả lưới, để tổng chiều cao KHÔNG BAO GIỜ tăng
/// theo số hàng và tràn màn hình che nút bấm bên dưới (bug thật gặp ở G04
/// Lớp 2 Unit 8 "volleyball" — 10 ô chữ -> 5 hàng cao bằng nhau tràn 65px,
/// khóa nút "Quay lại"/"Tiếp theo" không bấm được). Với số hàng ít (bằng
/// cách chơi phổ biến, ≤3 hàng) trả về đúng [baseRowHeight] như cũ, không
/// đổi giao diện.
double tileGridRowHeight(
  int itemCount, {
  int crossAxisCount = 2,
  double baseRowHeight = 64,
  double heightBudget = 200,
  double minRowHeight = 36,
}) {
  final rows = (itemCount / crossAxisCount).ceil();
  if (rows <= 0) return baseRowHeight;
  return (heightBudget / rows).clamp(minRowHeight, baseRowHeight);
}

/// Scaffold dùng chung cho MỌI màn hình — bọc sẵn [SafeArea] quanh [body] để
/// tránh bị thanh điều hướng hệ thống (3 nút hoặc gesture bar) che nội dung/
/// nút ở đáy màn hình (xem BUGS_CR.md BUG-001). `top` tắt khi có `appBar` vì
/// AppBar đã tự lo phần status bar phía trên — bọc thêm sẽ bị dư khoảng trắng.
/// Luôn dùng widget này thay vì `Scaffold` trần khi tạo màn hình mới.
class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      body: SafeArea(top: appBar == null, child: body),
    );
  }
}

/// Nút phụ (vd "Quay lại") — cùng chiều cao [PrimaryButton] để xếp hàng đẹp.
class SecondaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const SecondaryButton({
    super.key,
    required this.label,
    this.icon = Icons.arrow_back_rounded,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.primaryButtonHeight,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 22),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.textSecondary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      ),
    );
  }
}

/// Đúng/sai khi chọn đáp án — dùng chung cho mọi game có chọn đáp án (G02,
/// G03 và các game tương tự sau này: G09 memory, G10 săn chữ, ...).
enum AnswerFeedback { correct, wrong }

/// Message + hiệu ứng nổi giữa màn hình khi trả lời đúng/sai. Đặt trong 1
/// `Stack` bọc ngoài nội dung game (xem cách dùng trong listen_pick_screen.dart
/// / fill_letter_screen.dart). Không chặn thao tác nhờ [IgnorePointer].
class AnswerFeedbackOverlay extends StatelessWidget {
  final AnswerFeedback? feedback;

  const AnswerFeedbackOverlay({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    final fb = feedback;
    return IgnorePointer(
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: fb == null
              ? const SizedBox.shrink(key: ValueKey('none'))
              : _FeedbackPop(key: ValueKey(fb), feedback: fb),
        ),
      ),
    );
  }
}

class _FeedbackPop extends StatelessWidget {
  final AnswerFeedback feedback;

  const _FeedbackPop({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    final correct = feedback == AnswerFeedback.correct;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1),
      duration: const Duration(milliseconds: 450),
      curve: Curves.elasticOut,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          if (correct) const _ConfettiBurst(),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
            decoration: BoxDecoration(
              color: correct ? AppColors.success : AppColors.error,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 4)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(correct ? '🎉' : '😢',
                    style: const TextStyle(fontSize: 48)),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  correct ? 'Chính xác!' : 'Chưa đúng, thử lại nhé!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Khóa tạm 1 màn hình game sau khi trả lời/kiểm tra SAI 3 lần LIÊN TIẾP
/// (chưa có lần đúng nào ở giữa) — hiện popup nhắc rồi đếm lùi 3 giây, chặn
/// hẳn thao tác trong lúc đếm (dùng cùng [WrongAnswerLockOverlay]). KHÔNG áp
/// dụng cho G08 Ghi âm (không có khái niệm đúng/sai ngay khi chọn) và G09
/// Lật thẻ (checkpoint trí nhớ, theo yêu cầu người dùng) — 2 màn đó không
/// trộn mixin này.
///
/// Cách dùng: `class _XScreenState extends State<XScreen> with
/// WrongAnswerLockMixin<XScreen>` rồi gọi [registerWrongAnswer] ở nhánh SAI,
/// [resetWrongStreak] ở nhánh ĐÚNG của hàm chấm điểm; thêm guard
/// `answerLockActive` vào đầu hàm xử lý chạm; thêm [WrongAnswerLockOverlay]
/// vào cuối `Stack` của `body` (đè lên [AnswerFeedbackOverlay]).
mixin WrongAnswerLockMixin<T extends StatefulWidget> on State<T> {
  int _wrongStreak = 0;
  bool _answerLockActive = false;
  int _answerLockCountdown = 0;

  bool get answerLockActive => _answerLockActive;
  int get answerLockCountdown => _answerLockCountdown;

  /// Gọi ở nhánh trả lời/kiểm tra ĐÚNG — về lại 0 lượt sai liên tiếp.
  void resetWrongStreak() => _wrongStreak = 0;

  /// Gọi ở nhánh trả lời/kiểm tra SAI — đếm dồn, đủ 3 lần liên tiếp thì khóa
  /// tạm màn hình: hiện popup (bấm "OK" mới đóng), sau đó đếm lùi 3 giây rồi
  /// tự mở lại. Không `await` lời gọi này ở nơi gọi — hàm tự quản lý toàn bộ
  /// bằng `setState`, nơi gọi không cần chờ.
  Future<void> registerWrongAnswer() async {
    _wrongStreak++;
    if (_wrongStreak < 3) return;
    _wrongStreak = 0;
    if (!mounted) return;
    setState(() => _answerLockActive = true);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
        // Icon tròn màu ấm (warning — cùng màu ngôi sao, không dùng đỏ để
        // tránh cảm giác bị phạt) + emoji thân thiện thay vì chỉ chữ suông,
        // dễ nhìn/dễ hiểu hơn với trẻ Lớp 1 chưa đọc thạo.
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text('🤔', style: TextStyle(fontSize: 48)),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Con đã làm sai 3 lần rồi, hãy tập trung suy nghĩ làm đúng nhé.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SizedBox(
            width: 180,
            child: PrimaryButton(
              label: 'OK',
              icon: Icons.emoji_emotions_rounded,
              color: AppColors.warning,
              foregroundColor: AppColors.textPrimary,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
    for (var s = 3; s >= 1; s--) {
      if (!mounted) return;
      setState(() => _answerLockCountdown = s);
      await Future.delayed(const Duration(seconds: 1));
    }
    if (!mounted) return;
    setState(() {
      _answerLockActive = false;
      _answerLockCountdown = 0;
    });
  }
}

/// Lớp phủ chặn thao tác khi [WrongAnswerLockMixin.answerLockActive] — khác
/// [AnswerFeedbackOverlay] (chỉ trang trí, dùng `IgnorePointer`), overlay này
/// dùng `AbsorbPointer` để CHẶN THẬT mọi chạm trong lúc đếm lùi. Đặt làm con
/// CUỐI CÙNG của `Stack` bọc `body` để nằm trên hết.
class WrongAnswerLockOverlay extends StatelessWidget {
  final bool active;
  final int secondsLeft;

  const WrongAnswerLockOverlay(
      {super.key, required this.active, required this.secondsLeft});

  @override
  Widget build(BuildContext context) {
    if (!active) return const SizedBox.shrink();
    return Positioned.fill(
      child: AbsorbPointer(
        child: Container(
          color: Colors.black45,
          alignment: Alignment.center,
          child: secondsLeft > 0
              ? _CountdownBubble(
                  key: ValueKey(secondsLeft), seconds: secondsLeft)
              : null,
        ),
      ),
    );
  }
}

/// Quả bóng đếm lùi nảy vui mắt — tái dùng kỹ thuật "pop" của [_FeedbackPop]
/// (đổi `key` mỗi giây để hiệu ứng nảy lặp lại) + pháo hoa nhỏ
/// [_ConfettiBurst], đổi màu xoay vòng mỗi giây cho đỡ căng thẳng lúc trẻ bị
/// khóa tạm màn hình.
class _CountdownBubble extends StatelessWidget {
  final int seconds;

  const _CountdownBubble({super.key, required this.seconds});

  static const _colors = [
    AppColors.secondary,
    AppColors.primary,
    AppColors.success,
  ];

  @override
  Widget build(BuildContext context) {
    final color = _colors[(seconds - 1) % _colors.length];
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.elasticOut,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          const _ConfettiBurst(),
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 4)),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              '$seconds',
              style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// Vài ngôi sao/lấp lánh bay ra từ tâm khi trả lời đúng — "pháo hoa" đơn giản
/// bằng widget có sẵn của Flutter, không cần thêm package ngoài.
class _ConfettiBurst extends StatelessWidget {
  const _ConfettiBurst();

  static const _emojis = ['✨', '🎉', '⭐', '✨', '⭐', '🎊'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(_emojis.length, (i) {
          final angle = (i / _emojis.length) * 2 * pi;
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 600 + i * 70),
            curve: Curves.easeOut,
            builder: (context, t, child) {
              final opacity = (t < 0.5 ? t * 2 : (1 - t) * 2).clamp(0.0, 1.0);
              return Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: Offset(cos(angle) * 95 * t, sin(angle) * 95 * t),
                  child: child,
                ),
              );
            },
            child: Text(_emojis[i], style: const TextStyle(fontSize: 26)),
          );
        }),
      ),
    );
  }
}
