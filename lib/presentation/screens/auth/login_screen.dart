// import 'package:flutter/material.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/theme_manager.dart';
// import '../../../core/widgets/custom_button.dart';
// import '../../../core/widgets/custom_textfield.dart';
// import 'signup_screen.dart';
// import 'forgot_password_screen.dart';
// import 'interests_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animController;
//   late Animation<double> _fadeAnim;
//   late Animation<Offset> _slideAnim;

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
//                   const SizedBox(height: 20),

//                   // --- زر تبديل الثيم ---
//                   _buildThemeToggle(isDark),
//                   const SizedBox(height: 30),

//                   // --- الشعار ---
//                   _buildLogo(isDark),
//                   const SizedBox(height: 40),

//                   // --- العنوان ---
//                   Text(
//                     "تسجيل الدخول",
//                     style: TextStyle(
//                       color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "أهلاً بعودتك، سجل دخولك للمتابعة",
//                     style: TextStyle(
//                       color: isDark
//                           ? AppColors.warmBeige
//                           : const Color(0xFF5D4037),
//                       fontSize: 14,
//                     ),
//                   ),
//                   const SizedBox(height: 40),

//                   // --- حقول الإدخال ---
//                   const CustomTextField(
//                     hint: "البريد الإلكتروني",
//                     prefixIcon: Icons.email_outlined,
//                     keyboardType: TextInputType.emailAddress,
//                   ),
//                   const SizedBox(height: 16),
//                   const CustomTextField(
//                     hint: "كلمة المرور",
//                     prefixIcon: Icons.lock_outline,
//                     isPassword: true,
//                   ),

//                   // --- نسيت كلمة المرور ---
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (_) => const ForgotPasswordScreen()),
//                         );
//                       },
//                       child: const Text(
//                         "نسيت كلمة المرور؟",
//                         style: TextStyle(
//                           color: AppColors.goldenBronze,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   // --- زر تسجيل الدخول ---
//                   CustomButton(
//                     text: "تسجيل الدخول",
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const InterestsScreen()),
//                       );
//                     },
//                     icon: Icons.login_rounded,
//                   ),
//                   const SizedBox(height: 30),

//                   // --- فاصل "أو" ---
//                   _buildDividerOr(isDark),
//                   const SizedBox(height: 25),

//                   // --- أزرار التسجيل الخارجي ---
//                   _buildSocialButton(
//                     isDark: isDark,
//                     label: "المتابعة مع Google",
//                     icon: Icons.g_mobiledata_rounded,
//                     onTap: () {},
//                   ),
//                   const SizedBox(height: 12),
//                   _buildSocialButton(
//                     isDark: isDark,
//                     label: "المتابعة مع Apple",
//                     icon: Icons.apple_rounded,
//                     onTap: () {},
//                   ),
//                   const SizedBox(height: 35),

//                   // --- ليس لديك حساب؟ ---
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "ليس لديك حساب؟",
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
//                                 builder: (_) => const SignUpScreen()),
//                           );
//                         },
//                         child: const Text(
//                           "أنشئ حساب",
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

//   // --- زر تبديل الثيم ---
//   Widget _buildThemeToggle(bool isDark) {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: GestureDetector(
//         onTap: () => toggleGlobalTheme(),
//         child: Container(
//           width: 42,
//           height: 42,
//           decoration: BoxDecoration(
//             color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
//             borderRadius: BorderRadius.circular(14),
//             boxShadow: [
//               BoxShadow(
//                   color: (isDark ? Colors.black : AppColors.deepNavy)
//                       .withOpacity(0.15),
//                   blurRadius: 8,
//                   offset: const Offset(0, 3))
//             ],
//           ),
//           child: Icon(isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
//               size: 20, color: AppColors.goldenBronze),
//         ),
//       ),
//     );
//   }

//   // --- الشعار ---
//   Widget _buildLogo(bool isDark) {
//     return Image.asset(
//       isDark
//           ? 'assets/images/logo_side_dark.png'
//           : 'assets/images/logo_side_light.png',
//       width: 140,
//       height: 100,
//       fit: BoxFit.contain,
//     );
//   }

//   // --- فاصل "أو" ---
//   Widget _buildDividerOr(bool isDark) {
//     return Row(
//       children: [
//         Expanded(
//           child: Divider(
//             color: isDark ? Colors.white12 : Colors.grey.shade300,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Text(
//             "أو",
//             style: TextStyle(
//               color: isDark ? Colors.white38 : Colors.grey.shade500,
//               fontSize: 13,
//             ),
//           ),
//         ),
//         Expanded(
//           child: Divider(
//             color: isDark ? Colors.white12 : Colors.grey.shade300,
//           ),
//         ),
//       ],
//     );
//   }

//   // --- زر اجتماعي (Google / Apple) ---
//   Widget _buildSocialButton({
//     required bool isDark,
//     required String label,
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         height: 52,
//         decoration: BoxDecoration(
//           color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color:
//                 isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade300,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon,
//                 size: 24,
//                 color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
//             const SizedBox(width: 10),
//             Text(
//               label,
//               style: TextStyle(
//                 color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 15,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../data/providers/auth_provider.dart';
import '../home/home_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'interests_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // --- جديد: وحدات التحكم لالتقاط النصوص ---
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
    _passwordController.dispose();
    super.dispose();
  }

  // --- تسجيل الدخول عبر AuthProvider ---
  Future<void> _loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('يرجى إدخال البريد الإلكتروني (أو اسم المستخدم) وكلمة المرور');
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(email: email, password: password);

    if (!mounted) return;

    if (success) {
      AppToast.success(context, 'تم تسجيل الدخول بنجاح!');

      // مستخدم قديم (أكمل الاهتمامات) → الرئيسية مباشرة
      // مستخدم جديد (لم يكمل الاهتمامات) → شاشة الاهتمامات
      final Widget destination = authProvider.hasCompletedInterests
          ? const HomeScreen()
          : const InterestsScreen();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => destination),
        (route) => false, // مسح كل تاريخ التنقل
      );
    } else {
      _showError(authProvider.errorMessage ?? 'فشل تسجيل الدخول');
    }
  }

  void _showError(String message) {
    if (mounted) {
      AppToast.error(context, message);
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
                  const SizedBox(height: 20),
                  _buildThemeToggle(isDark),
                  const SizedBox(height: 30),
                  _buildLogo(isDark),
                  const SizedBox(height: 40),
                  Text(
                    "تسجيل الدخول",
                    style: TextStyle(
                      color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "أهلاً بعودتك، سجل دخولك للمتابعة",
                    style: TextStyle(
                      color: isDark
                          ? AppColors.warmBeige
                          : const Color(0xFF5D4037),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- تعديل: ربط الحقول بـ Controllers ---
                  CustomTextField(
                    hint: "البريد الإلكتروني أو اسم المستخدم",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController, // 👈 تم الربط
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hint: "كلمة المرور",
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    controller: _passwordController, // 👈 تم الربط
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen()),
                        );
                      },
                      child: const Text(
                        "نسيت كلمة المرور؟",
                        style: TextStyle(
                          color: AppColors.goldenBronze,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // --- زر الإرسال مع مؤشر التحميل ---
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) => auth.isLoading
                        ? const CircularProgressIndicator(
                            color: AppColors.goldenBronze)
                        : CustomButton(
                            text: "تسجيل الدخول",
                            onPressed: _loginUser,
                            icon: Icons.login_rounded,
                          ),
                  ),
                  const SizedBox(height: 30),

                  _buildDividerOr(isDark),
                  const SizedBox(height: 25),
                  _buildSocialButton(
                    isDark: isDark,
                    label: "المتابعة مع Google",
                    icon: Icons.g_mobiledata_rounded,
                    onTap: () {
                      _showError("تسجيل الدخول عبر جوجل غير مفعل حالياً");
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildSocialButton(
                    isDark: isDark,
                    label: "المتابعة مع Apple",
                    icon: Icons.apple_rounded,
                    onTap: () {
                      _showError("تسجيل الدخول عبر آبل غير مفعل حالياً");
                    },
                  ),
                  const SizedBox(height: 35),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ليس لديك حساب؟",
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
                                builder: (_) => const SignUpScreen()),
                          );
                        },
                        child: const Text(
                          "أنشئ حساب",
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

  Widget _buildThemeToggle(bool isDark) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => toggleGlobalTheme(),
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
          child: Icon(isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
              size: 20, color: AppColors.goldenBronze),
        ),
      ),
    );
  }

  Widget _buildLogo(bool isDark) {
    return Image.asset(
      isDark
          ? 'assets/images/logo_side_dark.png'
          : 'assets/images/logo_side_light.png',
      width: 140,
      height: 100,
      fit: BoxFit.contain,
    );
  }

  Widget _buildDividerOr(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: isDark ? Colors.white12 : Colors.grey.shade300,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "أو",
            style: TextStyle(
              color: isDark ? Colors.white38 : Colors.grey.shade500,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: isDark ? Colors.white12 : Colors.grey.shade300,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required bool isDark,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 24,
                color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
