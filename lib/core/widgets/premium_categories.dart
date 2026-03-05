import 'package:flutter/material.dart';
import 'package:test/presentation/screens/categories/category_offers_screen.dart';
import '../network/api_service.dart';
import '../network/api_constants.dart';
import '../theme/app_colors.dart';
import '../../presentation/screens/categories/categories_screen.dart';

// ============================================================================
// شريط التصنيفات — يجلب من API
// ============================================================================
class PremiumCategoriesBar extends StatefulWidget {
  final bool isDarkMode;

  const PremiumCategoriesBar({super.key, required this.isDarkMode});

  @override
  State<PremiumCategoriesBar> createState() => _PremiumCategoriesBarState();
}

class _PremiumCategoriesBarState extends State<PremiumCategoriesBar> {
  final ApiService _api = ApiService();
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  // أيقونات افتراضية حسب اسم التصنيف
  static final Map<String, IconData> _iconMap = {
    'إلكترونيات': Icons.laptop_mac_rounded,
    'أزياء': Icons.checkroom_rounded,
    'ملابس': Icons.checkroom_rounded,
    'مطاعم': Icons.restaurant_menu_rounded,
    'سوبرماركت': Icons.shopping_basket_rounded,
    'هايبر ماركت': Icons.shopping_basket_rounded,
    'صحة وجمال': Icons.spa_rounded,
    'خدمات': Icons.build_rounded,
    'رياضة': Icons.sports_soccer_rounded,
    'سيارات': Icons.directions_car_rounded,
    'أثاث': Icons.chair_rounded,
    'كتب': Icons.menu_book_rounded,
    'كافيهات': Icons.local_cafe_rounded,
  };

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final data = await _api.get(
        ApiConstants.categories,
        requiresAuth: false,
      );

      final List rawCategories =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);

      if (mounted) {
        setState(() {
          _categories = rawCategories.map<Map<String, dynamic>>((cat) {
            final name = cat['name']?.toString() ?? 'غير معروف';
            return {
              'id':
                  cat['id']?.toString() ?? cat['category_id']?.toString() ?? '',
              'name': name,
              'icon': _iconMap[name] ?? Icons.category_rounded,
              'image': cat['image'] != null
                  ? ApiConstants.resolveImageUrl(cat['image'].toString())
                  : null,
            };
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('خطأ في جلب التصنيفات: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        widget.isDarkMode ? AppColors.pureWhite : AppColors.lightText;
    final Color iconBoxColor =
        widget.isDarkMode ? const Color(0xFF072A38) : AppColors.lightBackground;
    final Color iconColor =
        widget.isDarkMode ? AppColors.warmBeige : AppColors.goldenBronze;

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
            child: _isLoading
                ? _buildLoadingShimmer(iconBoxColor)
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _categories.length) {
                        return _buildSeeAllButton(widget.isDarkMode);
                      }
                      final cat = _categories[index];

                      // 1. أضفنا GestureDetector هنا
                      return GestureDetector(
                        onTap: () {
                          debugPrint(
                              "تم الضغط على تصنيف: ${cat['name']} ورقم الـ ID: ${cat['id']}");

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CategoryOffersScreen(
                                categoryId: cat['id'] ?? '',
                                categoryName: cat['name'] ?? 'تصنيف',
                                // 2. هنا الحل السحري للشاشة الحمراء (صورة بديلة إذا كانت null)
                                categoryImage: cat['image'] ??
                                    'https://placehold.co/600x600/png?text=No+Image',
                              ),
                            ),
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
                                  color: iconBoxColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: widget.isDarkMode
                                        ? Colors.white.withOpacity(0.05)
                                        : AppColors.goldenBronze
                                            .withOpacity(0.1),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    if (!widget.isDarkMode)
                                      BoxShadow(
                                          color: AppColors.goldenBronze
                                              .withOpacity(0.05),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4)),
                                  ],
                                ),
                                child: cat['image'] != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          cat['image'],
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Icon(
                                              cat['icon'] as IconData,
                                              color: iconColor,
                                              size: 28),
                                        ),
                                      )
                                    : Icon(cat['icon'] as IconData,
                                        color: iconColor, size: 28),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                cat['name'],
                                style: TextStyle(
                                    color: textColor.withOpacity(0.8),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer(Color bgColor) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 10,
            width: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ]),
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
