import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../data/providers/auth_provider.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});
  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  @override
  void initState() {
    super.initState();
    // تحديث البيانات
    final auth = context.read<AuthProvider>();
    auth.fetchPhones();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.deepNavy : AppColors.lightBackground;
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    final cardC = isDark ? const Color(0xFF072A38) : Colors.white;
    final borderC = isDark
        ? AppColors.goldenBronze.withOpacity(0.15)
        : Colors.grey.shade200;
    final auth = context.watch<AuthProvider>();

    // إخفاء جزء من البريد
    final email = auth.userEmail;
    final maskedEmail = email.length > 5
        ? '${email.substring(0, 3)}***${email.substring(email.indexOf('@'))}'
        : email;

    // إخفاء جزء من رقم الهاتف
    final phone = auth.primaryPhone;
    final maskedPhone = phone.length > 5
        ? '${phone.substring(0, phone.length - 4).replaceAll(RegExp(r'\d'), '*')}${phone.substring(phone.length - 4)}'
        : phone.isNotEmpty
            ? phone
            : 'لا يوجد رقم';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          leading: IconButton(
              icon:
                  Icon(Icons.arrow_forward_ios_rounded, color: textC, size: 20),
              onPressed: () => Navigator.pop(context)),
          title: Text("الأمان والخصوصية",
              style: TextStyle(
                  color: textC, fontSize: 18, fontWeight: FontWeight.w900)),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _actionTile("تغيير كلمة المرور", "تغيير كلمة المرور الحالية",
                Icons.lock_outline_rounded, cardC, borderC, textC, isDark,
                onTap: () => _showChangePasswordDialog(
                    context, isDark, textC, cardC, borderC)),
            const SizedBox(height: 12),
            _actionTile("رقم الهاتف", maskedPhone, Icons.phone_locked_rounded,
                cardC, borderC, textC, isDark,
                onTap: () =>
                    _showPhonesSheet(context, isDark, textC, cardC, borderC)),
            const SizedBox(height: 12),
            _actionTile("البريد الإلكتروني", maskedEmail, Icons.email_outlined,
                cardC, borderC, textC, isDark,
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: email.isNotEmpty
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    email.isNotEmpty ? "مؤكد" : "غير مؤكد",
                    style: TextStyle(
                        color: email.isNotEmpty ? Colors.green : Colors.orange,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                )),
            const SizedBox(height: 12),
            _actionTile(
                "حالة التحقق",
                auth.userProfile?['is_verified'] == true
                    ? "✓ حساب موثق"
                    : "حساب غير موثق",
                Icons.verified_user_outlined,
                cardC,
                borderC,
                textC,
                isDark,
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: auth.userProfile?['is_verified'] == true
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    auth.userProfile?['is_verified'] == true
                        ? "موثق"
                        : "غير موثق",
                    style: TextStyle(
                        color: auth.userProfile?['is_verified'] == true
                            ? Colors.green
                            : Colors.orange,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // أرقام الهاتف
  // ==========================================
  void _showPhonesSheet(
      BuildContext ctx, bool isDark, Color textC, Color cardC, Color borderC) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(builder: (context, setInnerState) {
          final auth = ctx.watch<AuthProvider>();
          final phones = auth.phones;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.deepNavy : Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10))),
                const SizedBox(height: 20),
                Row(children: [
                  Text("أرقام الهاتف",
                      style: TextStyle(
                          color: textC,
                          fontSize: 18,
                          fontWeight: FontWeight.w900)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _showAddPhoneDialog(ctx, isDark, textC, cardC, borderC);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          color: AppColors.goldenBronze.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8)),
                      child:
                          const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.add_rounded,
                            color: AppColors.goldenBronze, size: 16),
                        SizedBox(width: 4),
                        Text("إضافة رقم",
                            style: TextStyle(
                                color: AppColors.goldenBronze,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ),
                ]),
                const SizedBox(height: 16),
                if (phones.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(children: [
                      Icon(Icons.phone_disabled_rounded,
                          color: textC.withOpacity(0.2), size: 40),
                      const SizedBox(height: 8),
                      Text("لا توجد أرقام مسجلة",
                          style: TextStyle(
                              color: textC.withOpacity(0.4), fontSize: 13)),
                    ]),
                  )
                else
                  ...phones.map((p) {
                    final number = p['phone_number'] ?? p['number'] ?? '';
                    final isPrimary = p['is_primary'] == true;
                    final type = p['type'] ?? 'Mobile';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          color: cardC,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderC)),
                      child: Row(children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: AppColors.goldenBronze.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.phone_rounded,
                              color: AppColors.goldenBronze, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(number.toString(),
                                    style: TextStyle(
                                        color: textC,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700)),
                                Text(type.toString(),
                                    style: TextStyle(
                                        color: textC.withOpacity(0.4),
                                        fontSize: 11)),
                              ]),
                        ),
                        if (isPrimary)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6)),
                            child: const Text("أساسي",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ),
                      ]),
                    );
                  }),
                const SizedBox(height: 10),
              ]),
            ),
          );
        });
      },
    );
  }

  void _showAddPhoneDialog(
      BuildContext ctx, bool isDark, Color textC, Color cardC, Color borderC) {
    final phoneCtrl = TextEditingController();
    bool adding = false;

    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(builder: (context, setInnerState) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.deepNavy : Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10))),
                const SizedBox(height: 20),
                Text("إضافة رقم هاتف",
                    style: TextStyle(
                        color: textC,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 20),
                TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: textC, fontSize: 14),
                  decoration: InputDecoration(
                    labelText: "رقم الهاتف",
                    hintText: "+966xxxxxxxxx",
                    hintStyle: TextStyle(color: textC.withOpacity(0.2)),
                    labelStyle: TextStyle(color: textC.withOpacity(0.4)),
                    filled: true,
                    fillColor: cardC,
                    prefixIcon: const Icon(Icons.phone_rounded,
                        color: AppColors.goldenBronze),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: borderC)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: borderC)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                            const BorderSide(color: AppColors.goldenBronze)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: adding
                        ? null
                        : () async {
                            if (phoneCtrl.text.trim().isEmpty) {
                              AppToast.warning(ctx, 'يرجى إدخال رقم الهاتف');
                              return;
                            }

                            setInnerState(() => adding = true);
                            final auth = ctx.read<AuthProvider>();
                            final success = await auth.addPhone(
                              phoneNumber: phoneCtrl.text.trim(),
                            );
                            setInnerState(() => adding = false);

                            if (success) {
                              Navigator.pop(context);
                              AppToast.success(ctx, 'تمت إضافة الرقم بنجاح ✓');
                            } else {
                              AppToast.error(
                                  ctx, auth.errorMessage ?? 'فشل إضافة الرقم');
                            }
                          },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.goldenBronze,
                        foregroundColor: AppColors.deepNavy,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14))),
                    child: adding
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppColors.deepNavy))
                        : const Text("إضافة الرقم",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
                const SizedBox(height: 10),
              ]),
            ),
          ),
        );
      }),
    );
  }

  // ==========================================
  // تغيير كلمة المرور
  // ==========================================
  void _showChangePasswordDialog(
      BuildContext ctx, bool isDark, Color textC, Color cardC, Color borderC) {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    bool loading = false;
    bool obscureOld = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(builder: (context, setInnerState) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.deepNavy : Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10))),
                const SizedBox(height: 20),
                Text("تغيير كلمة المرور",
                    style: TextStyle(
                        color: textC,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 20),
                _passwordField("كلمة المرور الحالية", oldCtrl, obscureOld,
                    textC, cardC, borderC, () {
                  setInnerState(() => obscureOld = !obscureOld);
                }),
                const SizedBox(height: 12),
                _passwordField("كلمة المرور الجديدة", newCtrl, obscureNew,
                    textC, cardC, borderC, () {
                  setInnerState(() => obscureNew = !obscureNew);
                }),
                const SizedBox(height: 12),
                _passwordField("تأكيد كلمة المرور الجديدة", confirmCtrl,
                    obscureConfirm, textC, cardC, borderC, () {
                  setInnerState(() => obscureConfirm = !obscureConfirm);
                }),
                const SizedBox(height: 8),
                Text(
                    "يجب أن تكون 8 أحرف على الأقل، تحتوي على أحرف كبيرة وصغيرة وأرقام ورموز",
                    style: TextStyle(
                        color: textC.withOpacity(0.4),
                        fontSize: 11,
                        height: 1.5)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading
                        ? null
                        : () async {
                            if (oldCtrl.text.isEmpty ||
                                newCtrl.text.isEmpty ||
                                confirmCtrl.text.isEmpty) {
                              AppToast.warning(ctx, 'يرجى ملء جميع الحقول');
                              return;
                            }
                            if (newCtrl.text != confirmCtrl.text) {
                              AppToast.warning(
                                  ctx, 'كلمة المرور الجديدة غير متطابقة');
                              return;
                            }

                            setInnerState(() => loading = true);
                            final auth = ctx.read<AuthProvider>();
                            final success = await auth.changePassword(
                              oldPassword: oldCtrl.text,
                              newPassword: newCtrl.text,
                              confirmNewPassword: confirmCtrl.text,
                            );
                            setInnerState(() => loading = false);

                            if (success) {
                              Navigator.pop(context);
                              AppToast.success(
                                  ctx, 'تم تغيير كلمة المرور بنجاح ✓');
                            } else {
                              AppToast.error(ctx,
                                  auth.errorMessage ?? 'فشل تغيير كلمة المرور');
                            }
                          },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.goldenBronze,
                        foregroundColor: AppColors.deepNavy,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14))),
                    child: loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppColors.deepNavy))
                        : const Text("تغيير كلمة المرور",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
                const SizedBox(height: 10),
              ]),
            ),
          ),
        );
      }),
    );
  }

  Widget _passwordField(String label, TextEditingController ctrl, bool obscure,
      Color textC, Color cardC, Color borderC, VoidCallback toggleObscure) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      style: TextStyle(color: textC, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textC.withOpacity(0.4)),
        filled: true,
        fillColor: cardC,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: borderC)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: borderC)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.goldenBronze)),
        suffixIcon: IconButton(
          icon: Icon(
              obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
              color: textC.withOpacity(0.4),
              size: 20),
          onPressed: toggleObscure,
        ),
      ),
    );
  }

  Widget _actionTile(String title, String sub, IconData icon, Color cardC,
      Color borderC, Color textC, bool isDark,
      {VoidCallback? onTap, Widget? trailing}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: cardC,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderC)),
        child: Row(children: [
          Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: AppColors.goldenBronze.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: AppColors.goldenBronze, size: 22)),
          const SizedBox(width: 14),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: TextStyle(
                        color: textC,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
                Text(sub,
                    style: TextStyle(
                        color: textC.withOpacity(0.45), fontSize: 11)),
              ])),
          if (trailing != null)
            trailing
          else if (onTap != null)
            Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.grey.withOpacity(0.5), size: 14),
        ]),
      ),
    );
  }
}
