import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});
  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _allNotifs = true;
  bool _offers = true;
  bool _draws = true;
  bool _chat = true;
  bool _followers = false;
  bool _support = true;
  bool _sound = true;
  bool _vibration = true;

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
          title: Text("إعدادات الإشعارات",
              style: TextStyle(
                  color: textC, fontSize: 18, fontWeight: FontWeight.w900)),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Master toggle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.goldenBronze.withOpacity(isDark ? 0.1 : 0.06),
                borderRadius: BorderRadius.circular(18),
                border:
                    Border.all(color: AppColors.goldenBronze.withOpacity(0.3)),
              ),
              child: Row(children: [
                Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                        color: AppColors.goldenBronze.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.notifications_rounded,
                        color: AppColors.goldenBronze, size: 26)),
                const SizedBox(width: 14),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text("جميع الإشعارات",
                          style: TextStyle(
                              color: textC,
                              fontSize: 15,
                              fontWeight: FontWeight.w800)),
                      Text("تفعيل أو تعطيل كل الإشعارات",
                          style: TextStyle(
                              color: textC.withOpacity(0.45), fontSize: 11)),
                    ])),
                Switch(
                    value: _allNotifs,
                    onChanged: (v) => setState(() {
                          _allNotifs = v;
                          if (!v) {
                            _offers = false;
                            _draws = false;
                            _chat = false;
                            _followers = false;
                            _support = false;
                          } else {
                            _offers = true;
                            _draws = true;
                            _chat = true;
                            _support = true;
                          }
                        }),
                    activeColor: AppColors.goldenBronze),
              ]),
            ),
            const SizedBox(height: 24),
            Text("أنواع الإشعارات",
                style: TextStyle(
                    color: textC.withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _toggleItem(
                "العروض الجديدة",
                "إشعارات عند إضافة عروض من المتاجر المتابعة",
                Icons.local_offer_rounded,
                _offers,
                (v) => setState(() => _offers = v),
                cardC,
                borderC,
                textC),
            _toggleItem(
                "السحوبات والجوائز",
                "تنبيهات السحوبات الجديدة والنتائج",
                Icons.redeem_rounded,
                _draws,
                (v) => setState(() => _draws = v),
                cardC,
                borderC,
                textC),
            _toggleItem(
                "الرسائل",
                "إشعارات المحادثات مع المتاجر",
                Icons.chat_bubble_outline_rounded,
                _chat,
                (v) => setState(() => _chat = v),
                cardC,
                borderC,
                textC),
            _toggleItem(
                "المتابعين",
                "عند متابعة شخص لحسابك",
                Icons.person_add_rounded,
                _followers,
                (v) => setState(() => _followers = v),
                cardC,
                borderC,
                textC),
            _toggleItem(
                "الدعم الفني",
                "تحديثات التذاكر والردود",
                Icons.headset_mic_rounded,
                _support,
                (v) => setState(() => _support = v),
                cardC,
                borderC,
                textC),
            const SizedBox(height: 24),
            Text("الأصوات والاهتزاز",
                style: TextStyle(
                    color: textC.withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _toggleItem(
                "الصوت",
                "تشغيل صوت عند وصول إشعار",
                Icons.volume_up_rounded,
                _sound,
                (v) => setState(() => _sound = v),
                cardC,
                borderC,
                textC),
            _toggleItem(
                "الاهتزاز",
                "اهتزاز عند وصول إشعار",
                Icons.vibration_rounded,
                _vibration,
                (v) => setState(() => _vibration = v),
                cardC,
                borderC,
                textC),
          ],
        ),
      ),
    );
  }

  Widget _toggleItem(String title, String sub, IconData icon, bool val,
      ValueChanged<bool> onChanged, Color cardC, Color borderC, Color textC) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
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
            child: Icon(icon, color: AppColors.goldenBronze, size: 20)),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: TextStyle(
                  color: textC, fontSize: 13, fontWeight: FontWeight.w700)),
          Text(sub,
              style: TextStyle(color: textC.withOpacity(0.4), fontSize: 11)),
        ])),
        Switch(
            value: val,
            onChanged: _allNotifs || title == "الصوت" || title == "الاهتزاز"
                ? onChanged
                : null,
            activeColor: AppColors.goldenBronze),
      ]),
    );
  }
}
