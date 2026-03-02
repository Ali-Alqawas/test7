import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/page_background.dart';
import '../main_layout/main_layout_screen.dart';
import '../auth/login_screen.dart';
import '../auth/signup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  // --- بيانات الشرائح (مكتوبة بعناية لتشرح الميزات الذكية) ---
  final List<Map<String, dynamic>> _slides = [
    {
      "title": "وكيلك الذكي للتخفيضات",
      "subtitle": "AI Smart Agent",
      "desc":
          "لا تبحث عن العروض، هو يبحث عنك. وكيل ذكي يراقب الأسعار، يقتنص الخصومات الخفية، وينبهك فور توفر ما تحب بأفضل سعر.",
      "icon": Icons.psychology_alt_outlined, // أيقونة توحي بالعقل/الذكاء
    },
    {
      "title": "مستشار التسوق التفاعلي",
      "subtitle": "Interactive Chatbot",
      "desc":
          "أكثر من مجرد بحث. تحدث مع المساعد الشخصي ليقترح عليك هدايا، يقارن بين المنتجات، ويجيب على استفساراتك كخبير مختص.",
      "icon": Icons.forum_outlined, // أيقونة المحادثة
    },
    {
      "title": "بوابة النخبة والمكافآت",
      "subtitle": "Exclusive Rewards",
      "desc":
          "تجربة صممت للتميز. انضم الآن لتتمتع بنظام ولاء فريد، واجمع النقاط مع كل عملية شرائية لاستبدالها بجوائز قيمة.",
      "icon": Icons.diamond_outlined, // أيقونة الفخامة
    },
  ];

  void _goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainLayoutScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // نجبر الصفحة على استخدام الثيم النهاري لتبقى مشرقة وفخمة
    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        body: PageBackground(
          child: SafeArea(
            child: Column(
              children: [
                // 1. زر "تخطي" في الأعلى (جهة اليسار)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: _currentIndex < 2
                          ? 1.0
                          : 0.0, // يختفي في الصفحة الأخيرة
                      child: TextButton(
                        onPressed: _goToHome,
                        child: const Text(
                          "تخطي",
                          style: TextStyle(
                            color: AppColors.goldenBronze,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // 2. منطقة العرض المتحركة (Slider)
                SizedBox(
                  height: 500, // مساحة كافية للرسم والنصوص
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _slides.length,
                    onPageChanged: (index) =>
                        setState(() => _currentIndex = index),
                    itemBuilder: (context, index) {
                      return _buildSlide(_slides[index]);
                    },
                  ),
                ),

                // 3. مؤشرات الصفحات (Dots)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentIndex == index ? 30 : 8,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? AppColors.goldenBronze
                            : AppColors.deepNavy.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // 4. منطقة الأزرار (في الأسفل)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: _buildBottomButtons(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- تصميم الشريحة الواحدة ---
  Widget _buildSlide(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // الرسم/الأيقونة داخل الختم الرسمي
          Container(
            width: 200,
            height: 200,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepNavy.withOpacity(0.08),
                  blurRadius: 40,
                  offset: const Offset(0, 15),
                ),
              ],
              border: Border.all(
                color: AppColors.goldenBronze.withOpacity(0.4),
                width: 1.5, // إطار اسمك قليلاً
              ),
            ),
            // هنا نستخدم الأيقونة لتمثيل الرسم، ويمكنك استبدالها بصورة asset لاحقاً
            child: Icon(
              data['icon'],
              size: 90,
              color: AppColors.goldenBronze,
            ),
          ),

          const SizedBox(height: 40),

          // العنوان الرئيسي
          Text(
            data['title'],
            style: const TextStyle(
              fontFamily: 'Segoe UI',
              color: AppColors.deepNavy,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // العنوان الفرعي الإنجليزي (يعطي لمسة تقنية وفخامة)
          Text(
            data['subtitle'],
            style: TextStyle(
              color: AppColors.goldenBronze.withOpacity(0.8),
              fontSize: 14,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // الوصف التفصيلي
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              data['desc'],
              style: const TextStyle(
                color: Color(0xFF5D4037),
                fontSize: 15,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // --- منطقة الأزرار المتغيرة ---
  Widget _buildBottomButtons() {
    // إذا وصلنا للشريحة الأخيرة (رقم 2)
    if (_currentIndex == 2) {
      return Column(
        mainAxisSize: MainAxisSize.min, // ليأخذ أقل مساحة ممكنة
        children: [
          // 1. زر تسجيل الدخول (الأهم)
          CustomButton(
            text: "تسجيل الدخول",
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          ),
          const SizedBox(height: 12),

          // 2. زر إنشاء حساب (ثانوي)
          CustomButton(
            text: "إنشاء حساب جديد",
            isOutlined: true,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SignUpScreen()));
            },
          ),

          const SizedBox(height: 15),

          // 3. رابط الزائر
          GestureDetector(
            onTap: _goToHome,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                "تصفح التطبيق كزائر",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.grey, // لون الخط تحت النص
                ),
              ),
            ),
          ),
        ],
      );
    }

    // في الشرائح الأولى (0 و 1) نعرض زر "التالي" فقط
    else {
      return SizedBox(
        width: double.infinity, // ليكون الزر عريضاً
        child: CustomButton(
          text: "التالي",
          onPressed: () {
            _controller.nextPage(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOutCubic, // حركة ناعمة جداً
            );
          },
        ),
      );
    }
  }
}
