// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/theme_manager.dart';
// import '../../../core/widgets/custom_button.dart';
// import 'interests_screen.dart';

// class VerificationScreen extends StatefulWidget {
//   final String email;

//   const VerificationScreen({super.key, required this.email});

//   @override
//   State<VerificationScreen> createState() => _VerificationScreenState();
// }

// class _VerificationScreenState extends State<VerificationScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animController;
//   late Animation<double> _fadeAnim;

//   final List<TextEditingController> _otpControllers =
//       List.generate(6, (_) => TextEditingController());
//   final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

//   int _resendSeconds = 60;
//   Timer? _timer;
//   bool _canResend = false;

//   @override
//   void initState() {
//     super.initState();
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//     _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
//     _animController.forward();
//     _startTimer();
//   }

//   void _startTimer() {
//     _resendSeconds = 60;
//     _canResend = false;
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_resendSeconds > 0) {
//         setState(() => _resendSeconds--);
//       } else {
//         setState(() => _canResend = true);
//         timer.cancel();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _animController.dispose();
//     _timer?.cancel();
//     for (var c in _otpControllers) {
//       c.dispose();
//     }
//     for (var f in _focusNodes) {
//       f.dispose();
//     }
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
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 40),

//                 // --- زر الرجوع ---
//                 _buildBackButton(isDark),
//                 const SizedBox(height: 50),

//                 // --- أيقونة التحقق ---
//                 _buildVerifyIcon(isDark),
//                 const SizedBox(height: 35),

//                 // --- العنوان ---
//                 Text(
//                   "التحقق من الحساب",
//                   style: TextStyle(
//                     color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   "أرسلنا رمز التحقق إلى",
//                   style: TextStyle(
//                     color:
//                         isDark ? AppColors.warmBeige : const Color(0xFF5D4037),
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   widget.email,
//                   style: const TextStyle(
//                     color: AppColors.goldenBronze,
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 40),

//                 // --- حقول OTP ---
//                 _buildOtpFields(isDark),
//                 const SizedBox(height: 30),

//                 // --- زر التحقق ---
//                 CustomButton(
//                   text: "تحقق",
//                   onPressed: () {
//                     String otp = _otpControllers.map((c) => c.text).join();
//                     debugPrint("OTP: $otp");
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => const InterestsScreen()),
//                     );
//                   },
//                   icon: Icons.verified_outlined,
//                 ),
//                 const SizedBox(height: 30),

//                 // --- إعادة الإرسال ---
//                 _buildResendSection(isDark),

//                 const SizedBox(height: 30),
//               ],
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

//   // --- أيقونة التحقق ---
//   Widget _buildVerifyIcon(bool isDark) {
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
//         Icons.mark_email_read_outlined,
//         size: 50,
//         color: AppColors.goldenBronze,
//       ),
//     );
//   }

//   // --- حقول الإدخال OTP ---
//   Widget _buildOtpFields(bool isDark) {
//     return Directionality(
//       textDirection: TextDirection.ltr,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(6, (index) {
//           return Container(
//             width: 48,
//             height: 56,
//             margin: EdgeInsets.only(left: index < 5 ? 8 : 0),
//             decoration: BoxDecoration(
//               color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: _otpControllers[index].text.isNotEmpty
//                     ? AppColors.goldenBronze
//                     : (isDark
//                         ? Colors.white.withOpacity(0.1)
//                         : Colors.grey.shade300),
//                 width: _otpControllers[index].text.isNotEmpty ? 1.5 : 1,
//               ),
//             ),
//             child: TextField(
//               controller: _otpControllers[index],
//               focusNode: _focusNodes[index],
//               textAlign: TextAlign.center,
//               keyboardType: TextInputType.number,
//               maxLength: 1,
//               style: TextStyle(
//                 color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//               decoration: const InputDecoration(
//                 counterText: "",
//                 border: InputBorder.none,
//               ),
//               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//               onChanged: (value) {
//                 setState(() {}); // لتحديث لون الحدود
//                 if (value.isNotEmpty && index < 5) {
//                   _focusNodes[index + 1].requestFocus();
//                 } else if (value.isEmpty && index > 0) {
//                   _focusNodes[index - 1].requestFocus();
//                 }
//               },
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   // --- إعادة الإرسال ---
//   Widget _buildResendSection(bool isDark) {
//     return Column(
//       children: [
//         Text(
//           "لم تستلم الرمز؟",
//           style: TextStyle(
//             color: isDark ? Colors.white54 : Colors.grey.shade600,
//             fontSize: 14,
//           ),
//         ),
//         const SizedBox(height: 8),
//         _canResend
//             ? GestureDetector(
//                 onTap: () {
//                   _startTimer();
//                   // TODO: إعادة إرسال الرمز
//                 },
//                 child: const Text(
//                   "إعادة إرسال الرمز",
//                   style: TextStyle(
//                     color: AppColors.goldenBronze,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15,
//                   ),
//                 ),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "إعادة الإرسال بعد ",
//                     style: TextStyle(
//                       color: isDark ? Colors.white38 : Colors.grey.shade500,
//                       fontSize: 14,
//                     ),
//                   ),
//                   Text(
//                     "00:${_resendSeconds.toString().padLeft(2, '0')}",
//                     style: const TextStyle(
//                       color: AppColors.goldenBronze,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15,
//                     ),
//                   ),
//                 ],
//               ),
//       ],
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../data/providers/auth_provider.dart';
import 'login_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String email;

  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendSeconds = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    _startTimer();
  }

  void _startTimer() {
    _resendSeconds = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _timer?.cancel();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  // --- التحقق عبر AuthProvider ---
  Future<void> _verifyOtp() async {
    String otp = _otpControllers.map((c) => c.text).join();

    if (otp.length < 6) {
      AppToast.warning(context, 'الرجاء إدخال الرمز المكون من 6 أرقام بالكامل');
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success =
        await authProvider.verifyOtp(email: widget.email, otpCode: otp);

    if (!mounted) return;

    if (success) {
      AppToast.success(context, 'تم التحقق بنجاح! يمكنك الآن تسجيل الدخول');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      _showError(authProvider.errorMessage ?? 'رمز خاطئ أو منتهي الصلاحية');
    }
  }

  // --- إعادة إرسال الرمز عبر AuthProvider ---
  Future<void> _resendOtp() async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.resendOtp(email: widget.email);

    if (!mounted) return;

    if (success) {
      AppToast.success(context, 'تم إعادة إرسال الرمز بنجاح');
      _startTimer();
    } else {
      _showError(authProvider.errorMessage ?? 'فشل إعادة إرسال الرمز');
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                _buildBackButton(isDark),
                const SizedBox(height: 50),
                _buildVerifyIcon(isDark),
                const SizedBox(height: 35),
                Text(
                  "التحقق من الحساب",
                  style: TextStyle(
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "أرسلنا رمز التحقق إلى",
                  style: TextStyle(
                    color:
                        isDark ? AppColors.warmBeige : const Color(0xFF5D4037),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.email,
                  style: const TextStyle(
                    color: AppColors.goldenBronze,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                _buildOtpFields(isDark),
                const SizedBox(height: 30),

                // --- زر التحقق مع مؤشر التحميل ---
                Consumer<AuthProvider>(
                  builder: (context, auth, _) => auth.isLoading
                      ? const CircularProgressIndicator(
                          color: AppColors.goldenBronze)
                      : CustomButton(
                          text: "تحقق",
                          onPressed: _verifyOtp,
                          icon: Icons.verified_outlined,
                        ),
                ),
                const SizedBox(height: 30),
                _buildResendSection(isDark),
                const SizedBox(height: 30),
              ],
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
          onTap: () => toggleGlobalTheme(), // دالة التبديل الخارجية
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

  Widget _buildVerifyIcon(bool isDark) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.goldenBronze.withOpacity(0.08)
            : AppColors.goldenBronze.withOpacity(0.06),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.goldenBronze.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: const Icon(
        Icons.mark_email_read_outlined,
        size: 50,
        color: AppColors.goldenBronze,
      ),
    );
  }

  Widget _buildOtpFields(bool isDark) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        children: List.generate(11, (i) {
          // الفهارس الزوجية = حقل OTP، الفهارس الفردية = فراغ بين الحقول
          if (i.isOdd) return const SizedBox(width: 10);
          final index = i ~/ 2;
          return Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _otpControllers[index].text.isNotEmpty
                      ? AppColors.goldenBronze
                      : (isDark
                          ? Colors.white.withOpacity(0.15)
                          : Colors.grey.shade300),
                  width: _otpControllers[index].text.isNotEmpty ? 2 : 1,
                ),
                boxShadow: _otpControllers[index].text.isNotEmpty
                    ? [
                        BoxShadow(
                          color: AppColors.goldenBronze.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: TextField(
                controller: _otpControllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: TextStyle(
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  setState(() {});
                  if (value.isNotEmpty && index < 5) {
                    _focusNodes[index + 1].requestFocus();
                  } else if (value.isEmpty && index > 0) {
                    _focusNodes[index - 1].requestFocus();
                  }
                },
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildResendSection(bool isDark) {
    return Column(
      children: [
        Text(
          "لم تستلم الرمز؟",
          style: TextStyle(
            color: isDark ? Colors.white54 : Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        _canResend
            ? Consumer<AuthProvider>(
                builder: (context, auth, _) => GestureDetector(
                  onTap: auth.isLoading ? null : _resendOtp,
                  child: Text(
                    "إعادة إرسال الرمز",
                    style: TextStyle(
                      color:
                          auth.isLoading ? Colors.grey : AppColors.goldenBronze,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "إعادة الإرسال بعد ",
                    style: TextStyle(
                      color: isDark ? Colors.white38 : Colors.grey.shade500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "00:${_resendSeconds.toString().padLeft(2, '0')}",
                    style: const TextStyle(
                      color: AppColors.goldenBronze,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
