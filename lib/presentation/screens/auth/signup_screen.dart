// import 'package:flutter/material.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/theme_manager.dart';
// import '../../../core/widgets/custom_button.dart';
// import '../../../core/widgets/custom_textfield.dart';
// import 'login_screen.dart';
// import 'verification_screen.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animController;
//   late Animation<double> _fadeAnim;
//   late Animation<Offset> _slideAnim;

//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//     _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
//     _slideAnim = Tween<Offset>(
//       begin: const Offset(0, 0.05),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
//     _animController.forward();
//   }

//   @override
//   void dispose() {
//     _animController.dispose();
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor: isDark ? AppColors.deepNavy : AppColors.lightBackground,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           padding: const EdgeInsets.symmetric(horizontal: 28),
//           child: FadeTransition(
//             opacity: _fadeAnim,
//             child: SlideTransition(
//               position: _slideAnim,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 40),

//                   // --- زر الرجوع + تبديل الثيم ---
//                   _buildHeader(isDark),
//                   const SizedBox(height: 30),

//                   // --- الشعار ---
//                   _buildLogo(isDark),
//                   const SizedBox(height: 25),

//                   // --- العنوان ---
//                   Text(
//                     "إنشاء حساب جديد",
//                     style: TextStyle(
//                       color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "أنشئ حسابك للاستمتاع بجميع المزايا",
//                     style: TextStyle(
//                       color: isDark
//                           ? AppColors.warmBeige
//                           : const Color(0xFF5D4037),
//                       fontSize: 14,
//                     ),
//                   ),
//                   const SizedBox(height: 35),

//                   // --- حقول الإدخال ---
//                   CustomTextField(
//                     hint: "الاسم الكامل",
//                     prefixIcon: Icons.person_outline,
//                     controller: _nameController,
//                   ),
//                   const SizedBox(height: 16),
//                   CustomTextField(
//                     hint: "البريد الإلكتروني",
//                     prefixIcon: Icons.email_outlined,
//                     keyboardType: TextInputType.emailAddress,
//                     controller: _emailController,
//                   ),
//                   const SizedBox(height: 16),
//                   CustomTextField(
//                     hint: "رقم الهاتف",
//                     prefixIcon: Icons.phone_outlined,
//                     keyboardType: TextInputType.phone,
//                     controller: _phoneController,
//                   ),
//                   const SizedBox(height: 16),
//                   CustomTextField(
//                     hint: "كلمة المرور",
//                     prefixIcon: Icons.lock_outline,
//                     isPassword: true,
//                     controller: _passwordController,
//                   ),
//                   const SizedBox(height: 16),
//                   CustomTextField(
//                     hint: "تأكيد كلمة المرور",
//                     prefixIcon: Icons.lock_outline,
//                     isPassword: true,
//                     controller: _confirmPasswordController,
//                   ),
//                   const SizedBox(height: 30),

//                   // --- زر إنشاء الحساب ---
//                   CustomButton(
//                     text: "إنشاء حساب",
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => VerificationScreen(
//                             email: _emailController.text.isNotEmpty
//                                 ? _emailController.text
//                                 : "example@email.com",
//                           ),
//                         ),
//                       );
//                     },
//                     icon: Icons.person_add_alt_1_rounded,
//                   ),
//                   const SizedBox(height: 25),

//                   // --- لديك حساب؟ ---
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "لديك حساب بالفعل؟",
//                         style: TextStyle(
//                           color: isDark ? Colors.white54 : Colors.grey.shade600,
//                           fontSize: 14,
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => const LoginScreen()),
//                           );
//                         },
//                         child: const Text(
//                           "سجل دخول",
//                           style: TextStyle(
//                             color: AppColors.goldenBronze,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // --- هيدر مع زر الرجوع + تبديل الثيم ---
//   Widget _buildHeader(bool isDark) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         GestureDetector(
//           onTap: () => toggleGlobalTheme(),
//           child: Container(
//             width: 42,
//             height: 42,
//             decoration: BoxDecoration(
//               color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
//               borderRadius: BorderRadius.circular(14),
//               boxShadow: [
//                 BoxShadow(
//                     color: (isDark ? Colors.black : AppColors.deepNavy)
//                         .withOpacity(0.15),
//                     blurRadius: 8,
//                     offset: const Offset(0, 3))
//               ],
//             ),
//             child: Icon(
//                 isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
//                 size: 20,
//                 color: AppColors.goldenBronze),
//           ),
//         ),
//         GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: isDark ? const Color(0xFF072A38) : AppColors.pureWhite,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                   color: isDark
//                       ? AppColors.goldenBronze.withOpacity(0.3)
//                       : Colors.grey.shade300),
//             ),
//             child: Icon(Icons.arrow_forward_ios_rounded,
//                 size: 18,
//                 color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
//           ),
//         ),
//       ],
//     );
//   }

//   // --- الشعار ---
//   Widget _buildLogo(bool isDark) {
//     return Image.asset(
//       isDark
//           ? 'assets/images/logo_side_dark.png'
//           : 'assets/images/logo_side_light.png',
//       width: 130,
//       height: 90,
//       fit: BoxFit.contain,
//     );
//   }
// }

import 'dart:convert'; // جديد للتعامل مع JSON
import 'package:http/http.dart' as http; // جديد للاتصال بالخادم
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import 'login_screen.dart';
import 'verification_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // --- جديد: متغير للتحكم في حالة التحميل ---
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- جديد: دالة الاتصال بالخادم لإنشاء الحساب ---
  Future<void> _registerUser() async {
    // 1. التحقق الأساسي من الحقول
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تعبئة جميع الحقول المطلوبة')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمات المرور غير متطابقة')),
      );
      return;
    }

    // تفعيل مؤشر التحميل
    setState(() {
      _isLoading = true;
    });

    try {
      // ⚠️ تنبيه هام: يجب تغيير هذا الـ IP إلى الـ IPv4 الخاص بجهاز الكمبيوتر الخاص بك
      // للتحقق في لينكس/ماك اكتب: ifconfig | grep inet
      // للتحقق في ويندوز اكتب: ipconfig
      const String ipAddress = '192.168.1.103'; // <--- ضع الـ IP هنا
      final Uri url = Uri.parse('http://$ipAddress:8000/api/v1/auth/register/');

      // 2. إرسال الطلب
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username':
              _nameController.text.trim(), // نرسله احتياطاً كما في التوثيق
          'full_name': _nameController.text.trim(), // 👈 أضفنا هذا الحقل الجديد
          'email': _emailController.text.trim(),
          'phone_number': _phoneController.text.trim(),
          'password': _passwordController.text,
          'confirm_password': _confirmPasswordController.text,
        }),
      );

      if (response.body.startsWith('<')) {
        // إذا كان الرد يبدأ بعلامة HTML، فهذا يعني أن هناك خطأ في السيرفر
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('خطأ في السيرفر: تم إرجاع صفحة بدلاً من بيانات')),
          );
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // 3. معالجة الرد
      if (response.statusCode == 201 || response.statusCode == 200) {
        // تم التسجيل بنجاح
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('تم إنشاء الحساب بنجاح!'),
                backgroundColor: Colors.green),
          );

          // الانتقال لشاشة التوثيق (أو شاشة الدخول)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => VerificationScreen(
                email: _emailController.text,
              ),
            ),
          );
        }
      } else {
        // فشل التسجيل (مثلاً البريد موجود مسبقاً)
        if (mounted) {
          final decoded = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('خطأ: ${decoded.toString()}'),
                backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      // خطأ في الاتصال (السيرفر مغلق أو الـ IP خطأ)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'فشل الاتصال بالخادم: تأكد من عنوان الـ IP والشبكة\n$e')),
        );
      }
    } finally {
      // إيقاف مؤشر التحميل في كل الأحوال
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.deepNavy : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  _buildHeader(isDark),
                  const SizedBox(height: 30),
                  _buildLogo(isDark),
                  const SizedBox(height: 25),
                  Text(
                    "إنشاء حساب جديد",
                    style: TextStyle(
                      color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "أنشئ حسابك للاستمتاع بجميع المزايا",
                    style: TextStyle(
                      color: isDark
                          ? AppColors.warmBeige
                          : const Color(0xFF5D4037),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 35),
                  CustomTextField(
                    hint:
                        "اسم المستخدم (Username)", // تم التعديل ليتوافق مع API
                    prefixIcon: Icons.person_outline,
                    controller: _nameController,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hint: "البريد الإلكتروني",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hint: "رقم الهاتف",
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hint: "كلمة المرور",
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hint: "تأكيد كلمة المرور",
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    controller: _confirmPasswordController,
                  ),
                  const SizedBox(height: 30),

                  // --- جديد: إظهار مؤشر تحميل أو زر الإرسال ---
                  _isLoading
                      ? const CircularProgressIndicator(
                          color: AppColors.goldenBronze)
                      : CustomButton(
                          text: "إنشاء حساب",
                          onPressed: _registerUser, // ربط الزر بالدالة الجديدة
                          icon: Icons.person_add_alt_1_rounded,
                        ),
                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "لديك حساب بالفعل؟",
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          "سجل دخول",
                          style: TextStyle(
                            color: AppColors.goldenBronze,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // بقية الدوال لم تتغير
  Widget _buildHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () =>
              toggleGlobalTheme(), // افترضت أن هذه الدالة موجودة خارج الـ class
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                    color: (isDark ? Colors.black : AppColors.deepNavy)
                        .withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3))
              ],
            ),
            child: Icon(
                isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                size: 20,
                color: AppColors.goldenBronze),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF072A38) : AppColors.pureWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: isDark
                      ? AppColors.goldenBronze.withOpacity(0.3)
                      : Colors.grey.shade300),
            ),
            child: Icon(Icons.arrow_forward_ios_rounded,
                size: 18,
                color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo(bool isDark) {
    return Image.asset(
      isDark
          ? 'assets/images/logo_side_dark.png'
          : 'assets/images/logo_side_light.png',
      width: 130,
      height: 90,
      fit: BoxFit.contain,
    );
  }
}
