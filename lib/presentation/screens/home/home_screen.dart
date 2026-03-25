import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/network/api_service.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../data/providers/auth_provider.dart';
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
import 'package:test/data/providers/social_provider.dart';

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
  int _unreadNotifCount = 0;
  final ApiService _api = ApiService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SocialProvider>(context, listen: false).fetchUserSocialData();
      _fetchUnreadCount();
    });
  }

  Future<void> _fetchUnreadCount() async {
    try {
      final data = await _api.get(ApiConstants.unreadNotificationCount);
      if (data is Map && mounted) {
        setState(() {
          _unreadNotifCount = data['unread_count'] ?? 0;
        });
      }
    } catch (_) {}
  }

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
    final auth = context.watch<AuthProvider>();

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
          Text("أهلاً بك يا ${auth.userName} ✨",
              style: TextStyle(
                  color:
                      isDarkMode ? AppColors.warmBeige : AppColors.goldenBronze,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()));
            _fetchUnreadCount(); // تحديث البادج بعد الرجوع
          },
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.notifications_none_rounded,
                  color: contentColor, size: 28),
              if (_unreadNotifCount > 0)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(color: headerBgColor, width: 1.5),
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      _unreadNotifCount > 9 ? '9+' : '$_unreadNotifCount',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
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
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.softCream,
                backgroundImage: NetworkImage(auth.userImage),
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
