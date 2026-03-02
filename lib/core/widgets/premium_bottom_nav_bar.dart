import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PremiumBottomNavBar extends StatelessWidget {
  final bool isDarkMode;
  final int currentIndex;
  final Function(int) onTap;

  const PremiumBottomNavBar({
    super.key,
    required this.isDarkMode,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor =
        isDarkMode ? const Color(0xFF072A38) : AppColors.pureWhite;
    final Color unselectedColor =
        isDarkMode ? AppColors.grey : AppColors.lightText.withOpacity(0.4);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 90,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double itemWidth = constraints.maxWidth / 5;

            return Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 70,
                  child: Container(
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(25)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black
                                .withOpacity(isDarkMode ? 0.3 : 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, -5))
                      ],
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.fastOutSlowIn,
                  right: currentIndex * itemWidth,
                  bottom: 0,
                  height: 70,
                  width: itemWidth,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: currentIndex == 2 ? 0.0 : 1.0,
                    child: Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.goldenBronze.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppColors.goldenBronze, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildNavItem(0, Icons.home_rounded, "الرئيسية", itemWidth,
                        unselectedColor),
                    _buildNavItem(1, Icons.grid_view_rounded, "الفئات",
                        itemWidth, unselectedColor),
                    _buildMiddleProminentItem(itemWidth),
                    _buildNavItem(3, Icons.favorite_border_rounded, "المفضلة",
                        itemWidth, unselectedColor),
                    _buildNavItem(4, Icons.person_outline_rounded, "الحساب",
                        itemWidth, unselectedColor),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, double width,
      Color unselectedColor) {
    bool isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTheme(
              data: ThemeData(
                  iconTheme: IconThemeData(
                      color:
                          isActive ? AppColors.goldenBronze : unselectedColor)),
              child: Icon(icon, size: 26),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                  color: isActive ? AppColors.goldenBronze : unselectedColor,
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiddleProminentItem(double width) {
    bool isActive = currentIndex == 2;
    return GestureDetector(
      onTap: () => onTap(2),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        height: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: AppColors.goldenBronze,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.goldenBronze.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 5))
                ],
                border: Border.all(
                    color: isActive
                        ? (isDarkMode
                            ? AppColors.pureWhite
                            : AppColors.deepNavy)
                        : Colors.transparent,
                    width: 2),
              ),
              child: const Icon(Icons.local_offer_rounded,
                  color: AppColors.pureWhite, size: 26),
            ),
            const SizedBox(height: 6),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isActive
                    ? AppColors.goldenBronze
                    : (isDarkMode ? AppColors.pureWhite : AppColors.lightText),
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
              child: const Text("عروض"),
            ),
          ],
        ),
      ),
    );
  }
}
