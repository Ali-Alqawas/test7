import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../presentation/screens/stores/all_stores_screen.dart';
import '../../presentation/screens/profile/draws_screen.dart';
import '../../presentation/screens/profile/rewards_screen.dart';
import '../../presentation/screens/profile/support_center_screen.dart';
import '../../presentation/screens/profile/merchant_upgrade_screen.dart';

class PremiumQuickServicesSection extends StatelessWidget {
  final bool isDarkMode;

  const PremiumQuickServicesSection({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> services = [
      {
        "title": "المتاجر",
        "icon": Icons.storefront_rounded,
        "screen": const AllStoresScreen()
      },
      {
        "title": "المكافآت",
        "icon": Icons.card_giftcard_rounded,
        "screen": null
      },
      {
        "title": "السحوبات",
        "icon": Icons.confirmation_num_outlined,
        "screen": const DrawsScreen()
      },
      {"title": "عروض اليوم", "icon": Icons.bolt_rounded, "screen": null},
      {"title": "كوبونات", "icon": Icons.local_offer_outlined, "screen": null},
      {
        "title": "محفظة النقاط",
        "icon": Icons.account_balance_wallet_rounded,
        "screen": const RewardsScreen()
      },
      {
        "title": "الترقية لتاجر",
        "icon": Icons.store_mall_directory_rounded,
        "screen": const MerchantUpgradeScreen()
      },
      {
        "title": "خدمة العملاء",
        "icon": Icons.support_agent_rounded,
        "screen": const SupportCenterScreen()
      },
    ];

    final Color textColor =
        isDarkMode ? AppColors.pureWhite : AppColors.lightText;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text("خدمات تهمك ✨",
                style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 15,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                return _buildServiceItem(context, services[index], isDarkMode);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(
      BuildContext context, Map<String, dynamic> service, bool isDark) {
    const Color iconColor = AppColors.goldenBronze;
    final Color bgColor = AppColors.goldenBronze.withOpacity(0.1);
    final Color borderColor = isDark
        ? AppColors.goldenBronze.withOpacity(0.3)
        : AppColors.goldenBronze.withOpacity(0.2);

    return GestureDetector(
      onTap: () {
        final screen = service["screen"];
        if (screen != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => screen as Widget));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 1),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                      color: AppColors.goldenBronze.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 3)),
              ],
            ),
            child: Icon(service["icon"], color: iconColor, size: 26),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              service["title"],
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: isDark
                      ? AppColors.pureWhite
                      : AppColors.lightText.withOpacity(0.8),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  height: 1.1),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
