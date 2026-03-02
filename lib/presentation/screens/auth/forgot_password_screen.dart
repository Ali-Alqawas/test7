// import 'package:flutter/material.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/theme_manager.dart';
// import '../../../core/widgets/custom_button.dart';
// import '../../../core/widgets/custom_textfield.dart';
// import 'login_screen.dart';
// import 'verification_screen.dart';

// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animController;
//   late Animation<double> _fadeAnim;
//   late Animation<Offset> _slideAnim;

//   final _emailController = TextEditingController();

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
//     _emailController.dispose();
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

//                   // --- زر الرجوع ---
//                   _buildBackButton(isDark),
//                   const SizedBox(height: 60),

//                   // --- أيقونة القفل ---
//                   _buildLockIcon(isDark),
//                   const SizedBox(height: 35),

//                   // --- العنوان ---
//                   Text(
//                     "نسيت كلمة المرور؟",
//                     style: TextStyle(
//                       color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     child: Text(
//                       "لا تقلق، أدخل بريدك الإلكتروني المسجل وسنرسل لك رمز إعادة تعيين كلمة المرور",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: isDark
//                             ? AppColors.warmBeige
//                             : const Color(0xFF5D4037),
//                         fontSize: 14,
//                         height: 1.6,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 40),

//                   // --- حقل البريد الإلكتروني ---
//                   CustomTextField(
//                     hint: "البريد الإلكتروني",
//                     prefixIcon: Icons.email_outlined,
//                     keyboardType: TextInputType.emailAddress,
//                     controller: _emailController,
//                   ),
//                   const SizedBox(height: 30),

//                   // --- زر إرسال الرمز ---
//                   CustomButton(
//                     text: "إرسال رمز التحقق",
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
//                     icon: Icons.send_rounded,
//                   ),
//                   const SizedBox(height: 40),

//                   // --- تذكرت كلمة المرور؟ ---
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "تذكرت كلمة المرور؟",
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
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // --- زر الرجوع ---
//   Widget _buildBackButton(bool isDark) {
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

//   // --- أيقونة القفل ---
//   Widget _buildLockIcon(bool isDark) {
//     return Container(
//       width: 110,
//       height: 110,
//       decoration: BoxDecoration(
//         color: isDark
//             ? AppColors.goldenBronze.withOpacity(0.08)
//             : AppColors.goldenBronze.withOpacity(0.06),
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: AppColors.goldenBronze.withOpacity(0.2),
//           width: 1.5,
//         ),
//       ),
//       child: const Icon(
//         Icons.lock_reset_rounded,
//         size: 50,
//         color: AppColors.goldenBronze,
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import 'login_screen.dart';
import 'reset_password_screen.dart'; // 👈 استدعاء الشاشة الجديدة التي سنصنعها

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final _emailController = TextEditingController();
  bool _isLoading = false;

  // ⚠️ تنبيه: ضع عنوان IP الخاص بجهازك هنا
  final String baseUrl = 'http://192.168.1.103:8000/api/v1/auth';

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
    _emailController.dispose();
    super.dispose();
  }

  // --- دالة طلب الرمز من الخادم ---
  Future<void> _requestResetCode() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showError('يرجى إدخال البريد الإلكتروني');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final Uri url = Uri.parse('$baseUrl/password-reset/request/');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إرسال رمز التحقق إلى بريدك!'), backgroundColor: Colors.green),
          );
          // الانتقال لشاشة تعيين كلمة المرور الجديدة وتمرير الإيميل لها
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ResetPasswordScreen(email: email),
            ),
          );
        }
      } else if (response.statusCode == 404) {
        _showError('هذا البريد الإلكتروني غير مسجل لدينا');
      } else {
        _showError('حدث خطأ، يرجى المحاولة مرة أخرى');
      }
    } catch (e) {
      _showError('فشل الاتصال بالخادم، تحقق من الشبكة والـ IP');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
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
                  _buildBackButton(isDark),
                  const SizedBox(height: 60),
                  _buildLockIcon(isDark),
                  const SizedBox(height: 35),
                  Text(
                    "نسيت كلمة المرور؟",
                    style: TextStyle(
                      color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "لا تقلق، أدخل بريدك الإلكتروني المسجل وسنرسل لك رمز إعادة تعيين كلمة المرور",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark ? AppColors.warmBeige : const Color(0xFF5D4037),
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    hint: "البريد الإلكتروني",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 30),
                  
                  // --- ربط الزر بالدالة ---
                  _isLoading
                      ? const CircularProgressIndicator(color: AppColors.goldenBronze)
                      : CustomButton(
                          text: "إرسال رمز التحقق",
                          onPressed: _requestResetCode,
                          icon: Icons.send_rounded,
                        ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "تذكرت كلمة المرور؟",
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => toggleGlobalTheme(),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: (isDark ? Colors.black : AppColors.deepNavy).withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 3))
              ],
            ),
            child: Icon(isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round, size: 20, color: AppColors.goldenBronze),
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
              border: Border.all(color: isDark ? AppColors.goldenBronze.withOpacity(0.3) : Colors.grey.shade300),
            ),
            child: Icon(Icons.arrow_forward_ios_rounded, size: 18, color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
          ),
        ),
      ],
    );
  }

  Widget _buildLockIcon(bool isDark) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: isDark ? AppColors.goldenBronze.withOpacity(0.08) : AppColors.goldenBronze.withOpacity(0.06),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.goldenBronze.withOpacity(0.2), width: 1.5),
      ),
      child: const Icon(Icons.lock_reset_rounded, size: 50, color: AppColors.goldenBronze),
    );
  }
}