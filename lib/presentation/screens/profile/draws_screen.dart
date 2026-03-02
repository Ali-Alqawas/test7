import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class DrawsScreen extends StatelessWidget {
  const DrawsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.deepNavy : AppColors.lightBackground;
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    final cardC = isDark ? const Color(0xFF072A38) : Colors.white;
    final borderC = isDark
        ? AppColors.goldenBronze.withOpacity(0.15)
        : Colors.grey.shade200;

    final draws = [
      {
        "title": "سحب iPhone 16 Pro Max",
        "image":
            "https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=500&q=80",
        "points": 200,
        "endDate": "28 فبراير",
        "participants": 1240,
        "status": "active"
      },
      {
        "title": "سحب PlayStation 5",
        "image":
            "https://images.unsplash.com/photo-1606813907291-d86efa9b94db?auto=format&fit=crop&w=500&q=80",
        "points": 150,
        "endDate": "5 مارس",
        "participants": 890,
        "status": "active"
      },
      {
        "title": "سحب AirPods Pro",
        "image":
            "https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?auto=format&fit=crop&w=500&q=80",
        "points": 80,
        "endDate": "1 مارس",
        "participants": 2100,
        "status": "active"
      },
      {
        "title": "سحب ساعة Apple Watch",
        "image":
            "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=500&q=80",
        "points": 100,
        "endDate": "10 مارس",
        "participants": 560,
        "status": "active"
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
          title: Text("السحوبات والجوائز",
              style: TextStyle(
                  color: textC, fontSize: 18, fontWeight: FontWeight.w900)),
          centerTitle: true,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: draws.length,
          itemBuilder: (ctx, i) {
            final d = draws[i];
            return GestureDetector(
              onTap: () => _showDrawDetails(ctx, d, isDark, textC, cardC),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: cardC,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderC),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(19)),
                        child: Stack(children: [
                          Image.network(d["image"] as String,
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover),
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Text("جاري",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(d["title"] as String,
                                  style: TextStyle(
                                      color: textC,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(height: 10),
                              Row(children: [
                                _info(
                                    Icons.stars_rounded,
                                    "${d["points"]} نقطة للدخول",
                                    AppColors.goldenBronze),
                                const SizedBox(width: 16),
                                _info(
                                    Icons.people_rounded,
                                    "${d["participants"]} مشارك",
                                    textC.withOpacity(0.5)),
                              ]),
                              const SizedBox(height: 6),
                              _info(
                                  Icons.timer_rounded,
                                  "ينتهي ${d["endDate"]}",
                                  textC.withOpacity(0.5)),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.goldenBronze,
                                    foregroundColor: AppColors.deepNavy,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  child: const Text("دخول السحب",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                ),
                              ),
                            ]),
                      ),
                    ]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _info(IconData icon, String text, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: color, size: 15),
      const SizedBox(width: 4),
      Text(text,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    ]);
  }

  void _showDrawDetails(BuildContext ctx, Map<String, dynamic> d, bool isDark,
      Color textC, Color cardC) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(ctx).size.height * 0.75,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.deepNavy : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
              child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10)))),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(d["image"] as String,
                height: 200, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),
          Text(d["title"] as String,
              style: TextStyle(
                  color: textC, fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: cardC,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: isDark ? Colors.white10 : Colors.grey.shade200)),
            child: Column(children: [
              _detailRow("النقاط المطلوبة", "${d["points"]} نقطة", textC),
              Divider(
                  color: isDark ? Colors.white10 : Colors.grey.shade200,
                  height: 20),
              _detailRow("عدد المشاركين", "${d["participants"]}", textC),
              Divider(
                  color: isDark ? Colors.white10 : Colors.grey.shade200,
                  height: 20),
              _detailRow("تاريخ الانتهاء", d["endDate"] as String, textC),
            ]),
          ),
          const SizedBox(height: 16),
          Text("الشروط:",
              style: TextStyle(
                  color: textC, fontSize: 14, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(
              "• يجب أن يكون لديك رصيد كافٍ من النقاط\n• السحب عشوائي ومن خلال نظام آلي\n• الجائزة غير قابلة للاستبدال النقدي\n• يتم التواصل مع الفائز خلال 48 ساعة",
              style: TextStyle(
                  color: textC.withOpacity(0.6), fontSize: 12, height: 1.7)),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.goldenBronze,
                  foregroundColor: AppColors.deepNavy,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14))),
              child: const Text("دخول السحب 🎉",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _detailRow(String label, String value, Color textC) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label,
          style: TextStyle(color: textC.withOpacity(0.5), fontSize: 13)),
      Text(value,
          style: const TextStyle(
              color: AppColors.goldenBronze,
              fontSize: 14,
              fontWeight: FontWeight.bold)),
    ]);
  }
}
