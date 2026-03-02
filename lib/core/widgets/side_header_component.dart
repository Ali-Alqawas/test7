import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// الهيدر الديناميكي العائم (SIDE Floating Header)
class SideSliverHeader extends StatelessWidget {
  final bool isDarkMode;
  final String userName;
  final String userImageUrl;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const SideSliverHeader({
    super.key,
    required this.isDarkMode,
    required this.userName,
    required this.userImageUrl,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color contentColor =
        isDarkMode ? AppColors.pureWhite : AppColors.lightText;
    final Color headerBgColor =
        isDarkMode ? const Color(0xFF072A38) : AppColors.pureWhite;

    return SliverAppBar(
      backgroundColor: headerBgColor,
      surfaceTintColor: Colors.transparent,
      floating: true,
      snap: true,
      pinned: false,
      elevation: isDarkMode ? 4 : 8,
      shadowColor: AppColors.goldenBronze.withOpacity(isDarkMode ? 0.05 : 0.15),
      toolbarHeight: 75,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      titleSpacing: 20,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("SIDE",
              style: TextStyle(
                  color: contentColor,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5)),
          Text("أهلاً بك يا $userName ✨",
              style: TextStyle(
                  color:
                      isDarkMode ? AppColors.warmBeige : AppColors.goldenBronze,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
      actions: [
        IconButton(
          onPressed: onNotificationTap,
          icon: Icon(Icons.notifications_none_rounded,
              color: contentColor, size: 28),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 8),
          child: GestureDetector(
            onTap: onProfileTap,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.goldenBronze, width: 2),
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.softCream,
                backgroundImage: NetworkImage(userImageUrl),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// محرك البحث النحيف (SIDE Slim Search)
class SideSearchSliver extends StatelessWidget {
  final bool isDarkMode;
  final String hintText;
  final VoidCallback? onSearchTap;

  const SideSearchSliver({
    super.key,
    required this.isDarkMode,
    this.hintText = "ابحث عن منتج، متجر، أو عرض...",
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        child: GestureDetector(
          onTap: onSearchTap,
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.deepNavy : AppColors.pureWhite,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                  color: isDarkMode
                      ? AppColors.goldenBronze.withOpacity(0.3)
                      : AppColors.goldenBronze,
                  width: 1.2),
              boxShadow: [
                if (!isDarkMode)
                  BoxShadow(
                      color: AppColors.goldenBronze.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Icon(Icons.search_rounded,
                    color: isDarkMode
                        ? AppColors.warmBeige
                        : AppColors.goldenBronze,
                    size: 20),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(hintText,
                        style: TextStyle(
                            color: isDarkMode
                                ? AppColors.grey
                                : AppColors.lightText.withOpacity(0.5),
                            fontSize: 13))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
