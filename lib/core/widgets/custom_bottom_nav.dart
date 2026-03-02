// import 'package:flutter/material.dart';
// import '../theme/app_colors.dart';
// import 'glass_container.dart';

// class CustomBottomNav extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;

//   const CustomBottomNav({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Padding(
//       // هوامش لجعله يطفو فوق الخلفية ولا يلتصق بالحواف
//       padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
//       child: GlassContainer(
//         borderRadius: 25,
//         width: double.infinity, // <--- (1) هذا هو السطر الناقص لإصلاح المشكلة
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//         useLightGlass: !isDark,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween, // الآن ستعمل المسافات بشكل صحيح
//           children: [
//             _buildNavItem(context, 0, Icons.home_rounded, "الرئيسية"),
//             _buildNavItem(context, 1, Icons.grid_view_rounded, "التصنيفات"),
//             _buildNavItem(context, 2, Icons.favorite_border_rounded, "المفضلة"),
//             _buildNavItem(context, 3, Icons.notifications_none_rounded, "الإشعارات"),
//             _buildNavItem(context, 4, Icons.person_outline_rounded, "حسابي"),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
//     final bool isSelected = currentIndex == index;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return GestureDetector(
//       onTap: () => onTap(index),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//         padding: EdgeInsets.symmetric(horizontal: isSelected ? 12 : 8, vertical: 8),
//         decoration: isSelected
//             ? BoxDecoration(
//                 color: AppColors.goldenBronze.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(15),
//               )
//             : null,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // الأيقونة تكبر قليلاً عند التحديد وتتغير حالتها
//             AnimatedScale(
//               scale: isSelected ? 1.1 : 1.0,
//               duration: const Duration(milliseconds: 200),
//               child: Icon(
//                 // نغير الأيقونة لنسخة "ممتلئة" عند التحديد إذا أمكن (اختياري)
//                 isSelected ? _filledIcon(index) : icon,
//                 color: isSelected
//                     ? AppColors.goldenBronze
//                     : (isDark ? Colors.white54 : Colors.grey.shade600),
//                 size: 26,
//               ),
//             ),
//             // نقطة صغيرة تظهر تحت العنصر النشط
//             if (isSelected)
//               Container(
//                 margin: const EdgeInsets.only(top: 4),
//                 width: 4,
//                 height: 4,
//                 decoration: const BoxDecoration(
//                   color: AppColors.goldenBronze,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   // دالة مساعدة لتحويل الأيقونات إلى الممتلئة عند التحديد (لمسة جمالية)
//   IconData _filledIcon(int index) {
//     switch (index) {
//       case 0: return Icons.home;
//       case 1: return Icons.grid_view;
//       case 2: return Icons.favorite;
//       case 3: return Icons.notifications;
//       case 4: return Icons.person;
//       default: return Icons.circle;
//     }
//   }
// }

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'glass_container.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: GlassContainer(
        borderRadius: 30, // زوايا أكثر استدارة
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        useLightGlass: !isDark,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(context, 0, Icons.home_rounded, Icons.home_outlined),
            _buildNavItem(context, 1, Icons.grid_view_rounded, Icons.grid_view),
            _buildNavItem(context, 2, Icons.favorite_rounded,
                Icons.favorite_border_rounded),
            _buildNavItem(context, 3, Icons.notifications_rounded,
                Icons.notifications_none_rounded),
            _buildNavItem(
                context, 4, Icons.person_rounded, Icons.person_outline_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData activeIcon,
      IconData inactiveIcon) {
    final bool isSelected = currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        height: 50,
        width: isSelected ? 65 : 50,
        decoration: BoxDecoration(
          // في النهاري: الخلفية عند التفعيل تكون ذهبية خفيفة جداً، وفي الليلي أغمق قليلاً
          color: isSelected
              ? AppColors.goldenBronze.withOpacity(isDark ? 0.15 : 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.goldenBronze.withOpacity(0.5)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              // التعديل هنا: في النهاري الأيقونة غير النشطة تكون كحلي شفاف بدلاً من رمادي
              color: isSelected
                  ? AppColors.goldenBronze
                  : (isDark
                      ? Colors.white54
                      : AppColors.deepNavy.withOpacity(0.4)),
              size: 26,
            ),
            if (isSelected)
              Positioned(
                bottom: 8,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.goldenBronze,
                    shape: BoxShape.circle,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
