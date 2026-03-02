import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart'; // استدعاء المدير
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../core/widgets/custom_bottom_nav.dart';

class DesignSystemGallery extends StatelessWidget {
  const DesignSystemGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // 1. الخلفية (نفس خلفية التطبيق الحية)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Stack(
              children: [
                Positioned(top: -100, right: -100, child: _blob(AppColors.goldenBronze)),
                Positioned(bottom: -100, left: -100, child: _blob(AppColors.deepNavy)),
              ],
            ),
          ),
          
          // 2. زر الرجوع (للعودة للتطبيق)
          Positioned(
            top: 50, left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 3. محتوى المعرض
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  
                  // --- الهيدر (العنوان + زر الثيم) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("نظام التصميم", style: Theme.of(context).textTheme.headlineMedium),
                          Text("Design System v1.0", style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                      // زر تبديل الثيم
                      IconButton(
                        onPressed: () => toggleGlobalTheme(),
                        icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.goldenBronze.withOpacity(0.2)
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  
                  // ==========================================================
                  // هنا تبدأ عناصر التصميم (منقولة من الكود القديم)
                  // ==========================================================

                  // --- قسم الطباعة (Typography) ---
                  _sectionTitle(context, "1. النصوص والخطوط"),
                  GlassContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("عنوان رئيسي كبير",
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 26)),
                        const SizedBox(height: 10),
                        Text("عنوان فرعي متوسط",
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20)),
                        const SizedBox(height: 10),
                        Text(
                            "نص عادي: هذا مثال على النص العادي الذي سيستخدم في وصف المنتجات.",
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 10),
                        Text("نص تفصيلي باهت: يستخدم للتاريخ والوقت.",
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- قسم الأزرار (Buttons) ---
                  _sectionTitle(context, "2. الأزرار (Actions)"),
                  CustomButton(
                      text: "زر رئيسي (Primary)",
                      onPressed: () {},
                      icon: Icons.check),
                  const SizedBox(height: 15),
                  CustomButton(
                      text: "زر تحميل (Loading)",
                      onPressed: () {},
                      isLoading: true),
                  const SizedBox(height: 15),
                  CustomButton(
                      text: "زر شفاف (Outline)",
                      onPressed: () {},
                      isOutlined: true,
                      icon: Icons.info_outline),
                  const SizedBox(height: 30),

                  // --- قسم الإدخال (Inputs) ---
                  _sectionTitle(context, "3. حقول الإدخال (Forms)"),
                  const CustomTextField(
                      hint: "البريد الإلكتروني",
                      prefixIcon: Icons.email_outlined),
                  const SizedBox(height: 15),
                  const CustomTextField(
                      hint: "كلمة المرور",
                      prefixIcon: Icons.lock_outline,
                      isPassword: true),
                  const SizedBox(height: 15),
                  const CustomTextField(
                      hint: "بحث عن منتج...", prefixIcon: Icons.search),
                  const SizedBox(height: 30),

                  // --- قسم البطاقات (Cards) ---
                  _sectionTitle(context, "4. البطاقات (Cards)"),
                  Row(
                    children: [
                      // البطاقة الأولى
                      Expanded(
                        child: GlassContainer(
                          height: 150,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.shopping_bag, size: 40, color: AppColors.goldenBronze),
                                const SizedBox(height: 10),
                                Text("بطاقة زجاجية", style: Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // البطاقة الثانية
                      Expanded(
                        child: GlassContainer(
                          height: 150,
                          useLightGlass: true, // تجربة الزجاج الفاتح
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.star, size: 40, color: AppColors.goldenBronze),
                                const SizedBox(height: 10),
                                Text("زجاج فاتح", style: Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ], 
                  ),
                  const SizedBox(height: 30),

                  // --- قسم التنقل (Navigation) ---
                  _sectionTitle(context, "5. شريط التنقل (Navigation)"),
                  Container(
                    height: 120, // مساحة وهمية للعرض
                    alignment: Alignment.bottomCenter,
                    child: CustomBottomNav(
                      currentIndex: 2, // نفترض أننا في صفحة "المفضلة" للتجربة
                      onTap: (index) {},
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.goldenBronze,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _blob(Color color) {
    return Container(
      width: 300, height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.15),
        boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 100)],
      ),
    );
  }
}