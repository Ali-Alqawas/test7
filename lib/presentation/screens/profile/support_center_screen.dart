import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SupportCenterScreen extends StatelessWidget {
  const SupportCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.deepNavy : AppColors.lightBackground;
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    final cardC = isDark ? const Color(0xFF072A38) : Colors.white;
    final borderC = isDark
        ? AppColors.goldenBronze.withOpacity(0.15)
        : Colors.grey.shade200;

    final tickets = [
      {
        "id": "#1024",
        "title": "مشكلة في تحميل العروض",
        "status": "مفتوحة",
        "date": "25 فبراير",
        "statusColor": Colors.orange
      },
      {
        "id": "#1019",
        "title": "لم يتم احتساب النقاط",
        "status": "قيد المعالجة",
        "date": "22 فبراير",
        "statusColor": AppColors.goldenBronze
      },
      {
        "id": "#1005",
        "title": "استفسار عن سياسة الإرجاع",
        "status": "مغلقة",
        "date": "18 فبراير",
        "statusColor": Colors.green
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
          title: Text("مركز الدعم",
              style: TextStyle(
                  color: textC, fontSize: 18, fontWeight: FontWeight.w900)),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.goldenBronze,
          icon: const Icon(Icons.add_rounded, color: AppColors.deepNavy),
          label: const Text("تذكرة جديدة",
              style: TextStyle(
                  color: AppColors.deepNavy, fontWeight: FontWeight.bold)),
          onPressed: () =>
              _showCreateTicket(context, isDark, textC, cardC, borderC),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // FAQ quick links
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: cardC,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderC)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("الأسئلة الشائعة",
                        style: TextStyle(
                            color: textC,
                            fontSize: 15,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    _faqItem("كيف أكسب النقاط؟", textC, isDark),
                    _faqItem("كيف أتواصل مع التاجر؟", textC, isDark),
                    _faqItem("هل يمكنني إلغاء المتابعة؟", textC, isDark),
                    _faqItem("كيف أبلّغ عن متجر؟", textC, isDark),
                  ]),
            ),
            const SizedBox(height: 24),
            Text("تذاكر الدعم",
                style: TextStyle(
                    color: textC, fontSize: 16, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            ...tickets.map((t) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: cardC,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderC)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(t["id"] as String,
                              style: TextStyle(
                                  color: AppColors.goldenBronze,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                                color: (t["statusColor"] as Color)
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(t["status"] as String,
                                style: TextStyle(
                                    color: t["statusColor"] as Color,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ]),
                        const SizedBox(height: 8),
                        Text(t["title"] as String,
                            style: TextStyle(
                                color: textC,
                                fontSize: 14,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text(t["date"] as String,
                            style: TextStyle(
                                color: textC.withOpacity(0.4), fontSize: 11)),
                      ]),
                )),
          ],
        ),
      ),
    );
  }

  Widget _faqItem(String q, Color textC, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Icon(Icons.help_outline_rounded,
            color: AppColors.goldenBronze, size: 18),
        const SizedBox(width: 10),
        Expanded(
            child: Text(q,
                style: TextStyle(color: textC.withOpacity(0.7), fontSize: 13))),
        Icon(Icons.arrow_back_ios_new_rounded,
            color: AppColors.grey.withOpacity(0.4), size: 12),
      ]),
    );
  }

  void _showCreateTicket(
      BuildContext ctx, bool isDark, Color textC, Color cardC, Color borderC) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
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
              Text("إنشاء تذكرة جديدة",
                  style: TextStyle(
                      color: textC, fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 20),
              TextField(
                controller: titleCtrl,
                style: TextStyle(color: textC, fontSize: 14),
                decoration: InputDecoration(
                  labelText: "عنوان المشكلة",
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
                      borderSide:
                          const BorderSide(color: AppColors.goldenBronze)),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: descCtrl,
                maxLines: 4,
                style: TextStyle(color: textC, fontSize: 14),
                decoration: InputDecoration(
                  labelText: "وصف المشكلة",
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
                      borderSide:
                          const BorderSide(color: AppColors.goldenBronze)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(ctx),
                  icon:
                      const Icon(Icons.send_rounded, color: AppColors.deepNavy),
                  label: const Text("إرسال التذكرة",
                      style: TextStyle(
                          color: AppColors.deepNavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldenBronze,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14))),
                ),
              ),
              const SizedBox(height: 10),
            ]),
          ),
        ),
      ),
    );
  }
}
