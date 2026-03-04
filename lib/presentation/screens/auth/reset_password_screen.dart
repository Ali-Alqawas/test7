import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../data/providers/auth_provider.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email; // نستقبل الإيميل من الشاشة السابقة

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- تأكيد إعادة التعيين عبر AuthProvider ---
  Future<void> _confirmReset() async {
    final otp = _otpController.text.trim();
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (otp.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      _showError('يرجى تعبئة جميع الحقول');
      return;
    }

    if (newPass != confirmPass) {
      _showError('كلمات المرور الجديدة غير متطابقة');
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.confirmPasswordReset(
      email: widget.email,
      otpCode: otp,
      newPassword: newPass,
      confirmPassword: confirmPass,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('تم تغيير كلمة المرور بنجاح!'),
            backgroundColor: Colors.green),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } else {
      _showError(authProvider.errorMessage ?? 'رمز غير صحيح أو بيانات خاطئة');
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
                  const SizedBox(height: 40),

                  // أيقونة
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.goldenBronze.withOpacity(0.08)
                          : AppColors.goldenBronze.withOpacity(0.06),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.goldenBronze.withOpacity(0.2),
                          width: 1.5),
                    ),
                    child: const Icon(Icons.password_rounded,
                        size: 40, color: AppColors.goldenBronze),
                  ),
                  const SizedBox(height: 25),

                  Text(
                    "تعيين كلمة مرور جديدة",
                    style: TextStyle(
                      color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "أدخل الرمز المرسل إلى:\n${widget.email}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.warmBeige
                          : const Color(0xFF5D4037),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 35),

                  // الحقول
                  CustomTextField(
                    hint: "رمز التحقق (6 أرقام)",
                    prefixIcon: Icons.pin_outlined,
                    keyboardType: TextInputType.number,
                    controller: _otpController,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hint: "كلمة المرور الجديدة",
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    controller: _newPasswordController,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hint: "تأكيد كلمة المرور الجديدة",
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    controller: _confirmPasswordController,
                  ),
                  const SizedBox(height: 40),

                  // زر الحفظ
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) => auth.isLoading
                        ? const CircularProgressIndicator(
                            color: AppColors.goldenBronze)
                        : CustomButton(
                            text: "حفظ وتسجيل الدخول",
                            onPressed: _confirmReset,
                            icon: Icons.check_circle_outline_rounded,
                          ),
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
}
