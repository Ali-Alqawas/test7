import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/auth_provider.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../theme/app_colors.dart';

/// حارس المصادقة — يتحقق من تسجيل الدخول قبل تنفيذ الإجراءات المحمية.
class AuthGuard {
  /// يتحقق من تسجيل الدخول. إذا غير مسجل → يعرض ديالوج ويرجع false.
  static bool requireAuth(BuildContext context) {
    final auth = context.read<AuthProvider>();
    if (auth.isLoggedIn) return true;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor:
              isDark ? const Color(0xFF072A38) : AppColors.pureWhite,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          icon: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.goldenBronze.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock_outline_rounded,
                color: AppColors.goldenBronze, size: 28),
          ),
          title: Text("تسجيل الدخول مطلوب",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: isDark ? AppColors.pureWhite : AppColors.lightText,
                  fontWeight: FontWeight.w800,
                  fontSize: 18)),
          content: Text(
              "سجّل دخولك للاستمتاع بجميع الميزات مثل الإعجاب، التعليق، والمزيد.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: isDark
                      ? AppColors.pureWhite.withOpacity(0.7)
                      : AppColors.lightText.withOpacity(0.7),
                  fontSize: 14,
                  height: 1.5)),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("لاحقاً", style: TextStyle(color: AppColors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldenBronze,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              child: const Text("تسجيل الدخول",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
    return false;
  }
}
