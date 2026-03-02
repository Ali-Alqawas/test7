import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});
  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.deepNavy : AppColors.lightBackground;
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    final cardC = isDark ? const Color(0xFF072A38) : Colors.white;
    final borderC = isDark
        ? AppColors.goldenBronze.withOpacity(0.15)
        : Colors.grey.shade200;

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
            _actionTile("تغيير كلمة المرور", "آخر تغيير منذ 30 يوم",
                Icons.lock_outline_rounded, cardC, borderC, textC, isDark,
                onTap: () {}),
            const SizedBox(height: 12),
            _actionTile("تغيير رقم الهاتف", "+967 777 ***",
                Icons.phone_locked_rounded, cardC, borderC, textC, isDark,
                onTap: () {}),
            const SizedBox(height: 12),
            _actionTile("تغيير البريد الإلكتروني", "haz***@example.com",
                Icons.email_outlined, cardC, borderC, textC, isDark,
                onTap: () {}),
          ],
        ),
      ),
    );
  }

  Widget _actionTile(String title, String sub, IconData icon, Color cardC,
      Color borderC, Color textC, bool isDark,
      {VoidCallback? onTap}) {
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
          Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.grey.withOpacity(0.5), size: 14),
        ]),
      ),
    );
  }
}
