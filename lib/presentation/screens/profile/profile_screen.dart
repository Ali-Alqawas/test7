import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../data/dummy_data.dart';
import 'edit_profile_screen.dart';
import 'saved_addresses_screen.dart';
import 'security_screen.dart';
import 'rewards_screen.dart';
import 'draws_screen.dart';
import 'inbox_screen.dart';
import 'merchant_upgrade_screen.dart';
import 'support_center_screen.dart';
import 'legal_screen.dart';
import 'notifications_settings_screen.dart';

// ============================================================================
// شاشة الحساب / البروفايل (Profile Screen) — التصميم الجديد
// ============================================================================
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? AppColors.deepNavy : AppColors.lightBackground;
    final Color textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    final Color cardC = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
    final Color borderC = isDark
        ? AppColors.goldenBronze.withOpacity(0.15)
        : Colors.grey.shade200;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                _buildTopBar(context, isDark, textC),
                _buildProfileCard(isDark, textC, cardC, borderC),
                _buildStatsCard(isDark, cardC, borderC, textC),
                const SizedBox(height: 16),

                // ===== المكافآت والسحوبات =====
                _buildRewardsSection(context, isDark, textC, cardC, borderC),
                const SizedBox(height: 20),

                // ===== إعدادات الحساب =====
                _buildSectionTitle("إعدادات الحساب", textC),
                _buildSettingsGroup([
                  _SettingItem(
                      Icons.person_outline_rounded,
                      "تعديل الملف الشخصي",
                      "الاسم، الصورة، البريد",
                      () => _push(context, const EditProfileScreen())),
                  _SettingItem(
                      Icons.location_on_outlined,
                      "العناوين المحفوظة",
                      "إضافة أو تعديل العناوين",
                      () => _push(context, const SavedAddressesScreen())),
                  _SettingItem(
                      Icons.lock_outline_rounded,
                      "الأمان والخصوصية",
                      "كلمة المرور والتحقق",
                      () => _push(context, const SecurityScreen())),
                ], isDark, cardC, borderC, textC),

                const SizedBox(height: 20),

                // ===== التفاعل والتواصل =====
                _buildSectionTitle("التفاعل والتواصل", textC),
                _buildSettingsGroup([
                  _SettingItem(
                      Icons.inbox_rounded,
                      "صندوق الوارد",
                      "المحادثات مع المتاجر",
                      () => _push(context, const InboxScreen())),
                  _SettingItem(
                      Icons.store_rounded,
                      "طلب ترقية لتاجر",
                      "افتح متجرك الخاص",
                      () => _push(context, const MerchantUpgradeScreen())),
                ], isDark, cardC, borderC, textC),

                const SizedBox(height: 20),

                // ===== التفضيلات =====
                _buildSectionTitle("التفضيلات", textC),
                _buildSettingsGroup([
                  _SettingItem(
                      Icons.notifications_none_rounded,
                      "الإشعارات",
                      "تحكم بالتنبيهات",
                      () =>
                          _push(context, const NotificationsSettingsScreen())),
                  _SettingItem(Icons.language_rounded, "اللغة", "العربية",
                      () => _showLanguageSheet(context, isDark)),
                  _SettingItem(
                      Icons.palette_outlined,
                      "المظهر",
                      isDark ? "الوضع الليلي" : "الوضع النهاري",
                      () => _showThemeSheet(context, isDark)),
                ], isDark, cardC, borderC, textC),

                const SizedBox(height: 20),

                // ===== الدعم والمساعدة =====
                _buildSectionTitle("الدعم والمساعدة", textC),
                _buildSettingsGroup([
                  _SettingItem(
                      Icons.headset_mic_outlined,
                      "مركز الدعم",
                      "التذاكر والأسئلة الشائعة",
                      () => _push(context, const SupportCenterScreen())),
                ], isDark, cardC, borderC, textC),

                const SizedBox(height: 20),

                // ===== المعلومات القانونية =====
                _buildSectionTitle("معلومات", textC),
                _buildSettingsGroup([
                  _SettingItem(
                      Icons.info_outline_rounded,
                      "من نحن",
                      "عن التطبيق",
                      () => _push(context,
                          const LegalScreen(title: "من نحن", type: "about"))),
                  _SettingItem(
                      Icons.privacy_tip_outlined,
                      "سياسة الخصوصية",
                      "حماية بياناتك",
                      () => _push(
                          context,
                          const LegalScreen(
                              title: "سياسة الخصوصية", type: "privacy"))),
                  _SettingItem(
                      Icons.description_outlined,
                      "الشروط والأحكام",
                      "قواعد الاستخدام",
                      () => _push(
                          context,
                          const LegalScreen(
                              title: "الشروط والأحكام", type: "terms"))),
                ], isDark, cardC, borderC, textC),

                const SizedBox(height: 25),
                _buildLogoutButton(isDark),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _push(BuildContext ctx, Widget screen) {
    Navigator.push(ctx, MaterialPageRoute(builder: (_) => screen));
  }

  // ==========================================
  // رأس الصفحة
  // ==========================================
  Widget _buildTopBar(BuildContext context, bool isDark, Color textC) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
      child: Row(
        children: [
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
              child:
                  Icon(Icons.arrow_forward_ios_rounded, color: textC, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Text("حسابي",
              style: TextStyle(
                  color: textC, fontSize: 24, fontWeight: FontWeight.w900)),
          const Spacer(),
          GestureDetector(
            onTap: toggleGlobalTheme,
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
                  color: AppColors.goldenBronze,
                  size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // بطاقة البروفايل
  // ==========================================
  Widget _buildProfileCard(
      bool isDark, Color textC, Color cardC, Color borderC) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardC,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppColors.goldenBronze.withOpacity(isDark ? 0.3 : 0.2),
            width: 1.5),
        boxShadow: [
          BoxShadow(
              color: AppColors.goldenBronze.withOpacity(isDark ? 0.08 : 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.goldenBronze, width: 2.5),
            boxShadow: [
              BoxShadow(
                  color: AppColors.goldenBronze.withOpacity(0.3),
                  blurRadius: 10)
            ],
          ),
          child: const CircleAvatar(
              radius: 35,
              backgroundColor: AppColors.softCream,
              backgroundImage: NetworkImage(AppData.userImage)),
        ),
        const SizedBox(width: 16),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(AppData.userName,
              style: TextStyle(
                  color: textC, fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.location_on_outlined,
                color: AppColors.goldenBronze, size: 14),
            const SizedBox(width: 4),
            Text(AppData.userLocation,
                style: TextStyle(
                    color:
                        isDark ? AppColors.warmBeige : AppColors.goldenBronze,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ]),
        ])),
      ]),
    );
  }

  // ==========================================
  // بطاقة الإحصائيات — المحدّثة
  // ==========================================
  Widget _buildStatsCard(bool isDark, Color cardC, Color borderC, Color textC) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: cardC,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderC),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.15 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(children: [
        _buildStatItem(
            "متابعاتي", "8", Icons.storefront_rounded, isDark, textC),
        _buildDivider(isDark),
        _buildStatItem(
            "كوبوناتي", "5", Icons.local_offer_outlined, isDark, textC),
        _buildDivider(isDark),
        _buildStatItem(
            "المفضلة", "23", Icons.favorite_border_rounded, isDark, textC),
        _buildDivider(isDark),
        _buildStatItem(
            "نقاطي", AppData.userPoints, Icons.stars_rounded, isDark, textC),
      ]),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, bool isDark, Color textC) {
    return Expanded(
        child: Column(children: [
      Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
            color: AppColors.goldenBronze.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: AppColors.goldenBronze, size: 22),
      ),
      const SizedBox(height: 8),
      Text(value,
          style: TextStyle(
              color: textC, fontSize: 16, fontWeight: FontWeight.w900)),
      const SizedBox(height: 2),
      Text(label,
          style: TextStyle(
              color: isDark
                  ? AppColors.grey
                  : AppColors.lightText.withOpacity(0.5),
              fontSize: 10,
              fontWeight: FontWeight.w600)),
    ]));
  }

  Widget _buildDivider(bool isDark) {
    return Container(
        width: 1,
        height: 50,
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200);
  }

  // ==========================================
  // قسم المكافآت والسحوبات
  // ==========================================
  Widget _buildRewardsSection(BuildContext context, bool isDark, Color textC,
      Color cardC, Color borderC) {
    final draws = [
      {
        "title": "iPhone 16 Pro",
        "image":
            "https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=300&q=80",
        "points": "200 نقطة"
      },
      {
        "title": "PlayStation 5",
        "image":
            "https://images.unsplash.com/photo-1606813907291-d86efa9b94db?auto=format&fit=crop&w=300&q=80",
        "points": "150 نقطة"
      },
      {
        "title": "AirPods Pro",
        "image":
            "https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?auto=format&fit=crop&w=300&q=80",
        "points": "80 نقطة"
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Points card
        GestureDetector(
          onTap: () => _push(context, const RewardsScreen()),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                AppColors.goldenBronze,
                AppColors.goldenBronze.withOpacity(0.75)
              ], begin: Alignment.topRight, end: Alignment.bottomLeft),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: AppColors.goldenBronze.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6))
              ],
            ),
            child: Row(children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.stars_rounded,
                    color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const Text("محفظة النقاط",
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text("${AppData.userPoints} نقطة",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900)),
                  ])),
              Column(children: [
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(const ClipboardData(text: "HAZEM2024"));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text("تم نسخ رابط الإحالة ✓"),
                        backgroundColor: AppColors.goldenBronze,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))));
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.copy_rounded, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text("إحالة",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ),
                const SizedBox(height: 6),
                const Text("عرض السجل ←",
                    style: TextStyle(color: Colors.white60, fontSize: 10)),
              ]),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        // Active draws
        Row(children: [
          Text("السحوبات الجارية",
              style: TextStyle(
                  color: textC, fontSize: 15, fontWeight: FontWeight.w800)),
          const Spacer(),
          GestureDetector(
            onTap: () => _push(context, const DrawsScreen()),
            child: const Text("عرض الكل",
                style: TextStyle(
                    color: AppColors.goldenBronze,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
        ]),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: draws.length,
            itemBuilder: (_, i) {
              final d = draws[i];
              return GestureDetector(
                onTap: () => _push(context, const DrawsScreen()),
                child: Container(
                  width: 130,
                  margin: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: cardC,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderC),
                  ),
                  child: Column(children: [
                    Expanded(
                        child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.network(d["image"]!,
                          fit: BoxFit.cover, width: double.infinity),
                    )),
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(children: [
                          Text(d["title"]!,
                              style: TextStyle(
                                  color: textC,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text(d["points"]!,
                              style: const TextStyle(
                                  color: AppColors.goldenBronze,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        ])),
                  ]),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }

  // ==========================================
  // عناوين الأقسام
  // ==========================================
  Widget _buildSectionTitle(String title, Color textC) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(title,
            style: TextStyle(
                color: textC.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5)),
      ),
    );
  }

  // ==========================================
  // مجموعة الإعدادات
  // ==========================================
  Widget _buildSettingsGroup(List<_SettingItem> items, bool isDark, Color cardC,
      Color borderC, Color textC) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: cardC,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderC),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.15 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;
          return Column(children: [
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: AppColors.goldenBronze.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(item.icon, color: AppColors.goldenBronze, size: 22),
              ),
              title: Text(item.title,
                  style: TextStyle(
                      color: textC, fontSize: 14, fontWeight: FontWeight.w700)),
              subtitle: Text(item.subtitle,
                  style: TextStyle(
                      color: isDark
                          ? AppColors.grey
                          : AppColors.lightText.withOpacity(0.4),
                      fontSize: 11)),
              trailing: Icon(Icons.arrow_back_ios_new_rounded,
                  color: isDark ? AppColors.grey : Colors.grey.shade400,
                  size: 14),
              onTap: item.onTap,
            ),
            if (!isLast)
              Divider(height: 0, indent: 70, endIndent: 16, color: borderC),
          ]);
        }).toList(),
      ),
    );
  }

  // ==========================================
  // زر تسجيل الخروج
  // ==========================================
  Widget _buildLogoutButton(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.error.withOpacity(0.3)),
          ),
          child:
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
            SizedBox(width: 8),
            Text("تسجيل الخروج",
                style: TextStyle(
                    color: AppColors.error,
                    fontSize: 15,
                    fontWeight: FontWeight.w800)),
          ]),
        ),
      ),
    );
  }

  // ==========================================
  // قائمة اللغة
  // ==========================================
  void _showLanguageSheet(BuildContext ctx, bool isDark) {
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    final cardC = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          decoration: BoxDecoration(
            color: cardC,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text("اختر اللغة",
                style: TextStyle(
                    color: textC, fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 20),
            _languageOption("العربية", "🇸🇦", true, isDark, textC, cardC, ctx),
            const SizedBox(height: 10),
            _languageOption(
                "English", "🇺🇸", false, isDark, textC, cardC, ctx),
            const SizedBox(height: 10),
          ]),
        ),
      ),
    );
  }

  Widget _languageOption(String label, String flag, bool isSelected,
      bool isDark, Color textC, Color cardC, BuildContext ctx) {
    return GestureDetector(
      onTap: () => Navigator.pop(ctx),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.goldenBronze.withOpacity(0.12)
              : (isDark ? AppColors.deepNavy : AppColors.lightBackground),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isSelected
                  ? AppColors.goldenBronze.withOpacity(0.5)
                  : (isDark ? Colors.white10 : Colors.grey.shade200)),
        ),
        child: Row(children: [
          Text(flag, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Expanded(
              child: Text(label,
                  style: TextStyle(
                      color: textC,
                      fontSize: 15,
                      fontWeight: FontWeight.w700))),
          if (isSelected)
            const Icon(Icons.check_circle_rounded,
                color: AppColors.goldenBronze, size: 22),
        ]),
      ),
    );
  }

  // ==========================================
  // قائمة المظهر
  // ==========================================
  void _showThemeSheet(BuildContext ctx, bool isDark) {
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    final cardC = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          decoration: BoxDecoration(
            color: cardC,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text("اختر المظهر",
                style: TextStyle(
                    color: textC, fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 20),
            _themeOption("الوضع النهاري", Icons.wb_sunny_rounded, !isDark,
                isDark, textC, cardC, ctx),
            const SizedBox(height: 10),
            _themeOption("الوضع الليلي", Icons.nightlight_round, isDark, isDark,
                textC, cardC, ctx),
            const SizedBox(height: 10),
          ]),
        ),
      ),
    );
  }

  Widget _themeOption(String label, IconData icon, bool isSelected, bool isDark,
      Color textC, Color cardC, BuildContext ctx) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(ctx);
        if (!isSelected) toggleGlobalTheme();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.goldenBronze.withOpacity(0.12)
              : (isDark ? AppColors.deepNavy : AppColors.lightBackground),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isSelected
                  ? AppColors.goldenBronze.withOpacity(0.5)
                  : (isDark ? Colors.white10 : Colors.grey.shade200)),
        ),
        child: Row(children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: AppColors.goldenBronze.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.goldenBronze, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
              child: Text(label,
                  style: TextStyle(
                      color: textC,
                      fontSize: 15,
                      fontWeight: FontWeight.w700))),
          if (isSelected)
            const Icon(Icons.check_circle_rounded,
                color: AppColors.goldenBronze, size: 22),
        ]),
      ),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _SettingItem(this.icon, this.title, this.subtitle, this.onTap);
}
