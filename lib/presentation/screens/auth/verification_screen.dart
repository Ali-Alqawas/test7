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
import 'dart:convert'; // جديد للتعامل مع JSON
import 'package:http/http.dart' as http; // جديد للاتصال بالخادم
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../core/widgets/custom_button.dart';
import 'login_screen.dart'; // 👈 تم الاستيراد للانتقال إليها بعد النجاح

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
  
  // --- جديد: حالة التحميل للزر ---
  bool _isLoading = false;

  // ⚠️ تنبيه هام: تذكر وضع عنوان IP الخاص بجهازك العامل بنظام لينكس هنا
  final String baseUrl = 'http://192.168.1.103:8000/api/v1/auth';

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

  // --- جديد: دالة التحقق من الخادم ---
  Future<void> _verifyOtp() async {
    // جمع الأرقام من الحقول الستة
    String otp = _otpControllers.map((c) => c.text).join();

    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال الرمز المكون من 6 أرقام بالكامل')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final Uri url = Uri.parse('$baseUrl/verify-otp/');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': widget.email,
          'otp_code': otp,
        }),
      );

      // حماية من ردود HTML
      if (response.body.startsWith('<')) {
        _showError('خطأ في السيرفر: الاستجابة غير صالحة');
        return;
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // تم التحقق بنجاح!
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم التحقق بنجاح! يمكنك الآن تسجيل الدخول'), backgroundColor: Colors.green),
          );
          
          // يمكنك هنا حفظ الـ Token لاحقاً إذا أردت: responseData['access']
          
          // الانتقال لصفحة تسجيل الدخول
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      } else {
        // معالجة حالات الخطأ المحددة في ملف التوثيق
        String errorMessage = 'رمز خاطئ أو منتهي الصلاحية';
        if (response.statusCode == 404) errorMessage = 'المستخدم غير موجود';
        if (response.statusCode == 410) errorMessage = 'الرمز منتهي الصلاحية، يرجى طلب رمز جديد';
        if (response.statusCode == 429) errorMessage = 'تجاوزت الحد المسموح، حسابك محظور مؤقتاً';
        
        _showError(responseData['detail'] ?? errorMessage);
      }
    } catch (e) {
      _showError('فشل الاتصال بالخادم، يرجى التحقق من الشبكة');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // --- جديد: دالة إعادة إرسال الرمز ---
  Future<void> _resendOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // ملاحظة: تأكد من اسم الـ Endpoint لإعادة الإرسال من الـ Swagger لديك
      final Uri url = Uri.parse('$baseUrl/resend-otp/'); 
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': widget.email,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إعادة إرسال الرمز بنجاح'), backgroundColor: Colors.green),
        );
        _startTimer(); // إعادة تشغيل العداد
      } else {
        _showError('فشل إعادة إرسال الرمز');
      }
    } catch (e) {
      _showError('فشل الاتصال بالخادم');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
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
                    color: isDark ? AppColors.warmBeige : const Color(0xFF5D4037),
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

                // --- تعديل: إظهار مؤشر التحميل أثناء الاتصال ---
                _isLoading
                    ? const CircularProgressIndicator(color: AppColors.goldenBronze)
                    : CustomButton(
                        text: "تحقق",
                        onPressed: _verifyOtp, // 👈 استدعاء دالة التحقق
                        icon: Icons.verified_outlined,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (index) {
          return Container(
            width: 48,
            height: 56,
            margin: EdgeInsets.only(left: index < 5 ? 8 : 0),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _otpControllers[index].text.isNotEmpty
                    ? AppColors.goldenBronze
                    : (isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.grey.shade300),
                width: _otpControllers[index].text.isNotEmpty ? 1.5 : 1,
              ),
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
            ? GestureDetector(
                onTap: _isLoading ? null : _resendOtp, // 👈 استدعاء دالة إعادة الإرسال
                child: Text(
                  "إعادة إرسال الرمز",
                  style: TextStyle(
                    color: _isLoading ? Colors.grey : AppColors.goldenBronze,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
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