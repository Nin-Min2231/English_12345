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
  final String relativePath;
  final BoxFit fit;

  const WordImage(
      {super.key, required this.relativePath, this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ContentRepository.asset(relativePath),
      fit: fit,
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(Icons.image_not_supported_outlined,
            size: 48, color: AppColors.textSecondary),
      ),
    );
  }
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
