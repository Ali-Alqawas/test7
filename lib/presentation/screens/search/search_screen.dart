import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';

// ============================================================================
// شاشة البحث (Search Screen)
// ============================================================================
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  final List<String> _recentSearches = [
    "ساعة رولكس",
    "حذاء نايك",
    "عطر شانيل",
    "MacBook Pro",
    "سماعة ابل",
  ];

  final List<Map<String, dynamic>> _trendingSearches = [
    {"text": "خصم 50%", "icon": Icons.local_fire_department_rounded},
    {"text": "عروض رمضان", "icon": Icons.star_rounded},
    {"text": "أجهزة إلكترونية", "icon": Icons.devices_rounded},
    {"text": "أزياء صيفية", "icon": Icons.checkroom_rounded},
    {"text": "عطور فاخرة", "icon": Icons.spa_rounded},
    {"text": "مطاعم قريبة", "icon": Icons.restaurant_rounded},
  ];

  final List<Map<String, dynamic>> _popularCategories = [
    {
      "name": "إلكترونيات",
      "icon": Icons.phone_android_rounded,
      "color": const Color(0xFF2196F3)
    },
    {
      "name": "أزياء",
      "icon": Icons.checkroom_rounded,
      "color": const Color(0xFFE91E63)
    },
    {
      "name": "مطاعم",
      "icon": Icons.restaurant_rounded,
      "color": const Color(0xFFFF9800)
    },
    {
      "name": "عطور",
      "icon": Icons.spa_rounded,
      "color": const Color(0xFF9C27B0)
    },
    {
      "name": "ساعات",
      "icon": Icons.watch_rounded,
      "color": const Color(0xFF607D8B)
    },
    {
      "name": "رياضة",
      "icon": Icons.fitness_center_rounded,
      "color": const Color(0xFF4CAF50)
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor =
        isDarkMode ? AppColors.deepNavy : AppColors.lightBackground;
    final Color textColor =
        isDarkMode ? AppColors.pureWhite : AppColors.lightText;
    final Color cardColor =
        isDarkMode ? const Color(0xFF072A38) : AppColors.pureWhite;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Column(
            children: [
              // الهيدر: رجوع + بحث + ثيم
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFF072A38)
                              : AppColors.pureWhite,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: isDarkMode
                                  ? AppColors.goldenBronze.withOpacity(0.3)
                                  : Colors.grey.shade300),
                        ),
                        child: Icon(Icons.arrow_forward_ios_rounded,
                            color: textColor, size: 18),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                              color: isDarkMode
                                  ? AppColors.goldenBronze.withOpacity(0.3)
                                  : AppColors.goldenBronze,
                              width: 1.2),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(children: [
                          Icon(Icons.search_rounded,
                              color: isDarkMode
                                  ? AppColors.warmBeige
                                  : AppColors.goldenBronze,
                              size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocus,
                              style: TextStyle(color: textColor, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: "ابحث عن منتج، متجر، أو عرض...",
                                hintStyle: TextStyle(
                                    color: isDarkMode
                                        ? AppColors.grey
                                        : AppColors.lightText.withOpacity(0.5),
                                    fontSize: 13),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _searchController.clear()),
                              child: Icon(Icons.close_rounded,
                                  color: AppColors.grey, size: 18),
                            ),
                        ]),
                      ),
                    ),
                    const SizedBox(width: 10),
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
                                offset: const Offset(0, 3))
                          ],
                        ),
                        child: Icon(
                            isDarkMode
                                ? Icons.wb_sunny_rounded
                                : Icons.nightlight_round,
                            color: AppColors.goldenBronze,
                            size: 20),
                      ),
                    ),
                  ],
                ),
              ),

              // المحتوى
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- عمليات البحث الأخيرة ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("عمليات البحث الأخيرة",
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800)),
                          GestureDetector(
                            onTap: () =>
                                setState(() => _recentSearches.clear()),
                            child: Text("مسح الكل",
                                style: TextStyle(
                                    color:
                                        AppColors.goldenBronze.withOpacity(0.7),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._recentSearches.map((term) =>
                          _buildRecentItem(term, isDarkMode, textColor)),
                      const SizedBox(height: 25),

                      // --- الأكثر بحثاً ---
                      Text("الأكثر بحثاً 🔥",
                          style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _trendingSearches
                            .map((item) =>
                                _buildTrendingChip(item, isDarkMode, textColor))
                            .toList(),
                      ),
                      const SizedBox(height: 25),

                      // --- تصنيفات شائعة ---
                      Text("تصنيفات شائعة",
                          style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.1,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _popularCategories.length,
                        itemBuilder: (_, i) => _buildCategoryTile(
                            _popularCategories[i], isDarkMode, textColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentItem(String term, bool isDark, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(Icons.history_rounded,
              color: AppColors.grey.withOpacity(0.5), size: 18),
          const SizedBox(width: 10),
          Expanded(
              child: Text(term,
                  style: TextStyle(
                      color: textColor.withOpacity(0.8), fontSize: 14))),
          GestureDetector(
            onTap: () => setState(() => _recentSearches.remove(term)),
            child: Icon(Icons.close_rounded,
                color: AppColors.grey.withOpacity(0.4), size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingChip(
      Map<String, dynamic> item, bool isDark, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF072A38) : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.goldenBronze.withOpacity(0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(item["icon"], color: AppColors.goldenBronze, size: 16),
        const SizedBox(width: 6),
        Text(item["text"],
            style: TextStyle(
                color: textColor, fontSize: 12, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _buildCategoryTile(
      Map<String, dynamic> cat, bool isDark, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF072A38) : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: (cat["color"] as Color).withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (cat["color"] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(cat["icon"], color: cat["color"], size: 22),
          ),
          const SizedBox(height: 8),
          Text(cat["name"],
              style: TextStyle(
                  color: textColor, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
