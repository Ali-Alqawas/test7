import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../presentation/screens/categories/categories_screen.dart';

class PremiumCategoriesBar extends StatelessWidget {
  final bool isDarkMode;

  const PremiumCategoriesBar({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {"name": "إلكترونيات", "icon": Icons.laptop_mac_rounded},
      {"name": "أزياء", "icon": Icons.checkroom_rounded},
      {"name": "مطاعم", "icon": Icons.restaurant_menu_rounded},
      {"name": "سوبرماركت", "icon": Icons.shopping_basket_rounded},
      {"name": "صحة وجمال", "icon": Icons.spa_rounded},
    ];

    final Color textColor =
        isDarkMode ? AppColors.pureWhite : AppColors.lightText;
    final Color iconBoxColor =
        isDarkMode ? const Color(0xFF072A38) : AppColors.lightBackground;
    final Color iconColor =
        isDarkMode ? AppColors.warmBeige : AppColors.goldenBronze;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "تسوق حسب الفئة",
                  style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length + 1,
              itemBuilder: (context, index) {
                if (index == categories.length) {
                  return _buildSeeAllButton(isDarkMode);
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: iconBoxColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.05)
                                : AppColors.goldenBronze.withOpacity(0.1),
                            width: 1,
                          ),
                          boxShadow: [
                            if (!isDarkMode)
                              BoxShadow(
                                  color:
                                      AppColors.goldenBronze.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Icon(categories[index]["icon"],
                            color: iconColor, size: 28),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        categories[index]["name"],
                        style: TextStyle(
                            color: textColor.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeeAllButton(bool isDark) {
    final Color fadedBgColor =
        isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200;
    final Color fadedIconColor = isDark ? Colors.white54 : Colors.grey.shade600;

    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CategoriesScreen()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    color: fadedBgColor,
                    borderRadius: BorderRadius.circular(16)),
                child: Icon(Icons.grid_view_rounded,
                    color: fadedIconColor, size: 26),
              ),
              const SizedBox(height: 8),
              Text("عرض الكل",
                  style: TextStyle(
                      color: fadedIconColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
