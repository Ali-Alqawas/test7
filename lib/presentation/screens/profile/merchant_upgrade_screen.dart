import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class MerchantUpgradeScreen extends StatefulWidget {
  const MerchantUpgradeScreen({super.key});
  @override
  State<MerchantUpgradeScreen> createState() => _MerchantUpgradeScreenState();
}

class _MerchantUpgradeScreenState extends State<MerchantUpgradeScreen> {
  final _storeNameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  String _selectedCategory = "اختر التصنيف";
  bool _agreed = false;

  @override
  void dispose() {
    _storeNameCtrl.dispose();
    _descCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
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
          title: Text("طلب ترقية لتاجر",
              style: TextStyle(
                  color: textC, fontSize: 18, fontWeight: FontWeight.w900)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppColors.goldenBronze.withOpacity(0.15),
                  AppColors.goldenBronze.withOpacity(0.05)
                ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: AppColors.goldenBronze.withOpacity(0.3)),
              ),
              child: Row(children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                      color: AppColors.goldenBronze.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.store_rounded,
                      color: AppColors.goldenBronze, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text("ابدأ رحلتك التجارية",
                          style: TextStyle(
                              color: textC,
                              fontSize: 16,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text("افتح متجرك الخاص وابدأ بعرض منتجاتك للآلاف",
                          style: TextStyle(
                              color: textC.withOpacity(0.5), fontSize: 12)),
                    ])),
              ]),
            ),
            const SizedBox(height: 24),
            Text("معلومات المتجر",
                style: TextStyle(
                    color: textC, fontSize: 16, fontWeight: FontWeight.w900)),
            const SizedBox(height: 14),
            _formField("اسم المتجر", _storeNameCtrl,
                Icons.store_mall_directory_rounded, cardC, borderC, textC),
            _formField("وصف المتجر", _descCtrl, Icons.description_rounded,
                cardC, borderC, textC,
                maxLines: 3),
            _formField("رقم التواصل", _phoneCtrl, Icons.phone_rounded, cardC,
                borderC, textC,
                isPhone: true),
            _formField("المدينة", _cityCtrl, Icons.location_city_rounded, cardC,
                borderC, textC),
            // Category dropdown
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                  color: cardC,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderC)),
              child: Row(children: [
                Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: AppColors.goldenBronze.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.category_rounded,
                        color: AppColors.goldenBronze, size: 22)),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    underline: const SizedBox(),
                    dropdownColor: cardC,
                    style: TextStyle(color: textC, fontSize: 14),
                    items: [
                      "اختر التصنيف",
                      "إلكترونيات",
                      "ملابس وأزياء",
                      "مطاعم وكافيهات",
                      "هايبر ماركت",
                      "صحة وجمال",
                      "خدمات"
                    ]
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v!),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 8),
            // Upload docs
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: cardC,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.goldenBronze.withOpacity(0.3),
                      style: BorderStyle.solid),
                ),
                child: Column(children: [
                  Icon(Icons.cloud_upload_rounded,
                      color: AppColors.goldenBronze.withOpacity(0.5), size: 40),
                  const SizedBox(height: 8),
                  Text("ارفع المستندات المطلوبة",
                      style: TextStyle(
                          color: textC.withOpacity(0.5), fontSize: 13)),
                  Text("(السجل التجاري، الهوية)",
                      style: TextStyle(
                          color: textC.withOpacity(0.3), fontSize: 11)),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            // Agree
            Row(children: [
              Checkbox(
                  value: _agreed,
                  onChanged: (v) => setState(() => _agreed = v!),
                  activeColor: AppColors.goldenBronze),
              Expanded(
                  child: Text("أوافق على شروط وأحكام فتح متجر في المنصة",
                      style: TextStyle(
                          color: textC.withOpacity(0.6), fontSize: 12))),
            ]),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _agreed ? () => Navigator.pop(context) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.goldenBronze,
                  foregroundColor: AppColors.deepNavy,
                  disabledBackgroundColor: AppColors.grey.withOpacity(0.3),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text("إرسال الطلب",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }

  Widget _formField(String label, TextEditingController ctrl, IconData icon,
      Color cardC, Color borderC, Color textC,
      {int maxLines = 1, bool isPhone = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
          color: cardC,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderC)),
      child: Row(
          crossAxisAlignment: maxLines > 1
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.only(top: maxLines > 1 ? 14 : 0),
                child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: AppColors.goldenBronze.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12)),
                    child:
                        Icon(icon, color: AppColors.goldenBronze, size: 22))),
            const SizedBox(width: 12),
            Expanded(
                child: TextField(
              controller: ctrl,
              maxLines: maxLines,
              keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
              style: TextStyle(
                  color: textC, fontSize: 14, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                  labelText: label,
                  labelStyle:
                      TextStyle(color: textC.withOpacity(0.4), fontSize: 13),
                  border: InputBorder.none),
            )),
          ]),
    );
  }
}
