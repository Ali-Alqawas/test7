import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/auth_provider.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.deepNavy : AppColors.lightBackground;
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    final cardC = isDark ? const Color(0xFF072A38) : Colors.white;
    final borderC = isDark
        ? AppColors.goldenBronze.withOpacity(0.15)
        : Colors.grey.shade200;

    final history = [
      {
        "title": "إحالة صديق",
        "points": "+50",
        "date": "25 فبراير",
        "icon": Icons.person_add_rounded,
        "positive": true
      },
      {
        "title": "مشاركة عرض",
        "points": "+10",
        "date": "24 فبراير",
        "icon": Icons.share_rounded,
        "positive": true
      },
      {
        "title": "دخول سحب iPhone",
        "points": "-200",
        "date": "23 فبراير",
        "icon": Icons.redeem_rounded,
        "positive": false
      },
      {
        "title": "تسجيل دخول يومي",
        "points": "+5",
        "date": "23 فبراير",
        "icon": Icons.login_rounded,
        "positive": true
      },
      {
        "title": "تقييم متجر",
        "points": "+15",
        "date": "22 فبراير",
        "icon": Icons.star_rounded,
        "positive": true
      },
      {
        "title": "إحالة صديق",
        "points": "+50",
        "date": "20 فبراير",
        "icon": Icons.person_add_rounded,
        "positive": true
      },
    ];

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
          title: Text("نقاطي ومكافآتي",
              style: TextStyle(
                  color: textC, fontSize: 18, fontWeight: FontWeight.w900)),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Points wallet card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppColors.goldenBronze,
                  AppColors.goldenBronze.withOpacity(0.7)
                ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.goldenBronze.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8))
                ],
              ),
              child: Column(
                children: [
                  const Text("رصيدك الحالي",
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 8),
                  Text(
                      context
                              .watch<AuthProvider>()
                              .userProfile?['points']
                              ?.toString() ??
                          '0',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w900)),
                  const Text("نقطة",
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 20),
                  // Referral
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(const ClipboardData(text: "HAZEM2024"));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: const Text("تم نسخ رابط الإحالة ✓"),
                            backgroundColor: AppColors.goldenBronze,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.copy_rounded,
                                color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text("انسخ رابط الإحالة",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold)),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // How to earn
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: cardC,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderC)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("كيف تكسب النقاط؟",
                        style: TextStyle(
                            color: textC,
                            fontSize: 15,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    _earnWay("إحالة صديق", "+50 نقطة", Icons.person_add_rounded,
                        textC),
                    _earnWay(
                        "مشاركة عرض", "+10 نقاط", Icons.share_rounded, textC),
                    _earnWay(
                        "تقييم متجر", "+15 نقطة", Icons.star_rounded, textC),
                    _earnWay("تسجيل دخول يومي", "+5 نقاط", Icons.login_rounded,
                        textC),
                  ]),
            ),
            const SizedBox(height: 24),
            Text("سجل العمليات",
                style: TextStyle(
                    color: textC, fontSize: 16, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            ...history.map((h) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: cardC,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderC)),
                  child: Row(children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: (h["positive"] as bool)
                            ? AppColors.goldenBronze.withOpacity(0.1)
                            : AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(h["icon"] as IconData,
                          color: (h["positive"] as bool)
                              ? AppColors.goldenBronze
                              : AppColors.error,
                          size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(h["title"] as String,
                              style: TextStyle(
                                  color: textC,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700)),
                          Text(h["date"] as String,
                              style: TextStyle(
                                  color: textC.withOpacity(0.4), fontSize: 11)),
                        ])),
                    Text(h["points"] as String,
                        style: TextStyle(
                          color: (h["positive"] as bool)
                              ? Colors.green
                              : AppColors.error,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        )),
                  ]),
                )),
          ],
        ),
      ),
    );
  }

  Widget _earnWay(String title, String pts, IconData icon, Color textC) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Icon(icon, color: AppColors.goldenBronze, size: 18),
        const SizedBox(width: 10),
        Text(title,
            style: TextStyle(color: textC.withOpacity(0.7), fontSize: 13)),
        const Spacer(),
        Text(pts,
            style: const TextStyle(
                color: AppColors.goldenBronze,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
      ]),
    );
  }
}
