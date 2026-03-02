import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../data/dummy_data.dart';
import '../../../core/widgets/premium_categories.dart';
import '../../../core/widgets/premium_brochures_section.dart';
import '../../../core/widgets/premium_featured_offers.dart';
import '../../../core/widgets/premium_bundled_offers.dart';
import '../../../core/widgets/premium_standard_offer_card.dart';
import '../../../core/widgets/premium_quick_services.dart';
import '../../../core/widgets/premium_bottom_nav_bar.dart';
import '../../../core/widgets/ai_floating_button.dart';
import '../../../core/widgets/exclusive_offers_carousel.dart';
import '../chatbot/chatbot_screen.dart';
import '../categories/categories_screen.dart';
import '../offers/offers_screen.dart';
import '../offers/banner_offers_screen.dart';
import '../offers/all_brochures_screen.dart';
import '../offers/featured_offers_screen.dart';
import '../offers/bundled_offers_screen.dart';
import '../favorites/favorites_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';
import '../notifications/notifications_screen.dart';

// ============================================================================
// الشاشة الرئيسية (Home Screen)
// ============================================================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Scaffold(
          extendBody: true,

          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. الهيدر الديناميكي
              _buildDynamicHeader(isDarkMode),

              // 2. محرك البحث + أيقونة تبديل الثيم
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                  child: Row(
                    children: [
                      // أيقونة تبديل الثيم (يمين)
                      GestureDetector(
                        onTap: toggleGlobalTheme,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppColors.pureWhite
                                : AppColors.deepNavy,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: (isDarkMode
                                        ? Colors.black
                                        : AppColors.deepNavy)
                                    .withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            isDarkMode
                                ? Icons.wb_sunny_rounded
                                : Icons.nightlight_round,
                            color: AppColors.goldenBronze,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // محرك البحث (مصغّر قليلاً)
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SearchScreen())),
                          child: _buildThinSearchBar(isDarkMode),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. البانر الإعلاني
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ExclusiveOffersCarousel(
                    isDarkMode: isDarkMode,
                    onBrowseTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const BannerOffersScreen())),
                  ),
                ),
              ),

              // 4. الفئات
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: PremiumCategoriesBar(isDarkMode: isDarkMode),
                ),
              ),

              // 5. قسم كتيبات العروض (البروشورات 3D)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: FocusedBrochuresSection(
                    isDarkMode: isDarkMode,
                    onSeeAllTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AllBrochuresScreen())),
                  ),
                ),
              ),

              // 6. العروض المميزة ⭐️
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: PremiumFeaturedOffersSection(
                    isDarkMode: isDarkMode,
                    onSeeAllTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const FeaturedOffersScreen())),
                  ),
                ),
              ),

              // 7. باقات التوفير 🎁
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: PremiumBundledOffersSection(
                    isDarkMode: isDarkMode,
                    onSeeAllTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const BundledOffersScreen())),
                  ),
                ),
              ),

              // 8. العروض العادية
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: PremiumStandardOffersSection(
                    isDarkMode: isDarkMode,
                    onSeeAllTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const OffersScreen())),
                  ),
                ),
              ),

              // 9. قسم الخدمات السريعة
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: PremiumQuickServicesSection(isDarkMode: isDarkMode),
                ),
              ),

              // 10. شعار التطبيق
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Center(
                    child: Transform.translate(
                      offset: const Offset(0, -40),
                      child: isDarkMode
                          ? Image.asset(
                              'assets/images/logo_side_dark.png',
                              key: const ValueKey('darkLogo'),
                              height: 200,
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              'assets/images/logo_side_light.png',
                              key: const ValueKey('lightLogo'),
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // الشريط السفلي العائم
          bottomNavigationBar: PremiumBottomNavBar(
            isDarkMode: isDarkMode,
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (index == 0) return; // الرئيسية — نحن فيها أصلاً
              Widget screen;
              switch (index) {
                case 1:
                  screen = const CategoriesScreen();
                  break;
                case 2:
                  screen = const OffersScreen();
                  break;
                case 3:
                  screen = const FavoritesScreen();
                  break;
                case 4:
                  screen = const ProfileScreen();
                  break;
                default:
                  return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => screen),
              );
            },
          ),
        ),

        // زر الذكاء الاصطناعي العائم
        DraggableAIFab(
          isDarkMode: isDarkMode,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatbotScreen()),
            );
          },
        ),
      ],
    );
  }

  // --- دوال بناء الهيدر والبحث ---

  Widget _buildDynamicHeader(bool isDarkMode) {
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
          Text("أهلاً بك يا ${AppData.userName} ✨",
              style: TextStyle(
                  color:
                      isDarkMode ? AppColors.warmBeige : AppColors.goldenBronze,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen())),
          icon: Icon(Icons.notifications_none_rounded,
              color: contentColor, size: 28),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 8),
          child: GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfileScreen())),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.goldenBronze, width: 2),
              ),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.softCream,
                backgroundImage: NetworkImage(AppData.userImage),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThinSearchBar(bool isDark) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepNavy : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
            color: isDark
                ? AppColors.goldenBronze.withOpacity(0.3)
                : AppColors.goldenBronze,
            width: 1.2),
        boxShadow: [
          if (!isDark)
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
              color: isDark ? AppColors.warmBeige : AppColors.goldenBronze,
              size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text("ابحث عن منتج، متجر، أو عرض...",
                style: TextStyle(
                    color: isDark
                        ? AppColors.grey
                        : AppColors.lightText.withOpacity(0.5),
                    fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
