import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart'; // استدعاء ملف الثيم
import '../../../core/widgets/page_background.dart'; // استدعاء الخلفية الحية
import '../onboarding/onboarding_screen.dart'; // بدلاً من main_layout

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // إجبار شريط الحالة (Status Bar) أن يكون بأيقونات داكنة لأن الخلفية ستكون فاتحة
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const OnboardingScreen()), // هنا التغيير
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 💡 السر هنا: نغلف الصفحة بـ Theme نهاري لإجبارها على استخدام الألوان الفاتحة والفقاعات الفاتحة
    // حتى لو كان التطبيق في الوضع الليلي، هذه الصفحة ستبقى نهارية
    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        // استخدمنا PageBackground لتظهر الفقاعات (الرسم) التي طلبتها
        body: PageBackground(
          child: Stack(
            children: [
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // --- حاوية الشعار (الختم الفخم) ---
                        Container(
                          width: 180,
                          height: 180,
                          clipBehavior: Clip.antiAlias,
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.deepNavy.withOpacity(0.1),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                            border: Border.all(
                              color: AppColors.goldenBronze.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/side_logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 30),

                        const SizedBox(height: 10),

                        // --- الشعار اللفظي ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 1,
                                width: 30,
                                color: AppColors.goldenBronze),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "ELEGANCE & OFFERS",
                                style: TextStyle(
                                  color: AppColors.goldenBronze,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            Container(
                                height: 1,
                                width: 30,
                                color: AppColors.goldenBronze),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // الحقوق في الأسفل
              const Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    "© 2026 SIDE Inc.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
