import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// ============================================================================
// نظام التنبيهات الموحد — AppToast
// يظهر من الأعلى بحركة أنيقة، يختفي تلقائياً، يدعم الوضع الداكن والفاتح
// ============================================================================

enum ToastType { success, error, warning, info }

class AppToast {
  static OverlayEntry? _currentToast;
  static Timer? _dismissTimer;

  // ─── الاستدعاءات السريعة ───────────────────────────────────

  static void success(BuildContext context, String message,
      {String? title, int durationMs = 3000}) {
    _show(context, message,
        title: title ?? 'تم بنجاح',
        type: ToastType.success,
        durationMs: durationMs);
  }

  static void error(BuildContext context, String message,
      {String? title, int durationMs = 4000}) {
    _show(context, message,
        title: title ?? 'خطأ', type: ToastType.error, durationMs: durationMs);
  }

  static void warning(BuildContext context, String message,
      {String? title, int durationMs = 3500}) {
    _show(context, message,
        title: title ?? 'تنبيه',
        type: ToastType.warning,
        durationMs: durationMs);
  }

  static void info(BuildContext context, String message,
      {String? title, int durationMs = 3000}) {
    _show(context, message,
        title: title ?? 'معلومة', type: ToastType.info, durationMs: durationMs);
  }

  // ─── إزالة التوست الحالي ───────────────────────────────────

  static void dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _currentToast?.remove();
    _currentToast = null;
  }

  // ─── المحرك الرئيسي ────────────────────────────────────────

  static void _show(
    BuildContext context,
    String message, {
    required String title,
    required ToastType type,
    required int durationMs,
  }) {
    // أزل أي توست موجود أولاً
    dismiss();

    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder: (ctx) => _ToastWidget(
        message: message,
        title: title,
        type: type,
        onDismiss: dismiss,
      ),
    );

    _currentToast = entry;
    overlay.insert(entry);

    _dismissTimer = Timer(Duration(milliseconds: durationMs), () {
      dismiss();
    });
  }
}

// ============================================================================
// ويدجت التوست — يظهر من الأعلى مع حركة انسيابية
// ============================================================================

class _ToastWidget extends StatefulWidget {
  final String message;
  final String title;
  final ToastType type;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.message,
    required this.title,
    required this.type,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ─── ألوان وأيقونات حسب النوع ──────────────────────────────

  static const Map<ToastType, IconData> _icons = {
    ToastType.success: Icons.check_circle_rounded,
    ToastType.error: Icons.error_rounded,
    ToastType.warning: Icons.warning_rounded,
    ToastType.info: Icons.info_rounded,
  };

  Color _accentColor(bool isDark) {
    switch (widget.type) {
      case ToastType.success:
        return isDark ? const Color(0xFF10B981) : const Color(0xFF059669);
      case ToastType.error:
        return isDark ? const Color(0xFFEF4444) : const Color(0xFFDC2626);
      case ToastType.warning:
        return AppColors.goldenBronze;
      case ToastType.info:
        return isDark ? const Color(0xFF3B82F6) : const Color(0xFF2563EB);
    }
  }

  Color _bgColor(bool isDark) {
    switch (widget.type) {
      case ToastType.success:
        return isDark ? const Color(0xFF062B20) : const Color(0xFFECFDF5);
      case ToastType.error:
        return isDark ? const Color(0xFF2D0A0A) : const Color(0xFFFEF2F2);
      case ToastType.warning:
        return isDark ? const Color(0xFF2A1F0E) : const Color(0xFFFFFBEB);
      case ToastType.info:
        return isDark ? const Color(0xFF0A1929) : const Color(0xFFEFF6FF);
    }
  }

  Color _borderColor(bool isDark) {
    final accent = _accentColor(isDark);
    return accent.withOpacity(isDark ? 0.35 : 0.3);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color accent = _accentColor(isDark);
    final Color bg = _bgColor(isDark);
    final Color border = _borderColor(isDark);
    final Color textColor = isDark ? AppColors.pureWhite : AppColors.lightText;
    final mediaQuery = MediaQuery.of(context);

    return Positioned(
      top: mediaQuery.padding.top + 10,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity != null &&
                      details.primaryVelocity! < -100) {
                    widget.onDismiss();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: border, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withOpacity(isDark ? 0.12 : 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── أيقونة النوع ──
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _icons[widget.type],
                          color: accent,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // ── المحتوى ──
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                color: accent,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.message,
                              style: TextStyle(
                                color: textColor.withOpacity(0.75),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // ── زر الإغلاق ──
                      GestureDetector(
                        onTap: widget.onDismiss,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4, top: 2),
                          child: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: textColor.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
