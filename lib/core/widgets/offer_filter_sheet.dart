import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class OfferFilterSheet extends StatefulWidget {
  final bool isDarkMode;
  final Map<String, String> initialFilters;
  final Function(Map<String, String>) onApply;
  final bool showFeaturedFilter;

  const OfferFilterSheet({
    super.key,
    required this.isDarkMode,
    required this.initialFilters,
    required this.onApply,
    this.showFeaturedFilter = true,
  });

  @override
  State<OfferFilterSheet> createState() => _OfferFilterSheetState();
}

class _OfferFilterSheetState extends State<OfferFilterSheet> {
  late Map<String, String> _currentFilters;

  @override
  void initState() {
    super.initState();
    // نأخذ نسخة من الفلاتر الحالية لكي نعدل عليها
    _currentFilters = Map<String, String>.from(widget.initialFilters);
  }

  void _applyAndClose() {
    widget.onApply(_currentFilters);
    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      _currentFilters.clear();
    });
    widget.onApply(_currentFilters);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Color sheetBg =
        widget.isDarkMode ? const Color(0xFF072A38) : AppColors.pureWhite;
    final Color textColor =
        widget.isDarkMode ? AppColors.pureWhite : AppColors.lightText;
    final Color chipBg =
        widget.isDarkMode ? AppColors.deepNavy : AppColors.lightBackground;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // المقبض
            Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: AppColors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),

            // العنوان
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("فلترة العروض",
                    style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
                GestureDetector(
                  onTap: _resetFilters,
                  child: Text("إعادة ضبط",
                      style: TextStyle(
                          color: AppColors.goldenBronze.withOpacity(0.8),
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- فلتر الترتيب (Ordering) ---
            Text("الترتيب حسب",
                style: TextStyle(
                    color: textColor.withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            _buildFilterOption(
                Icons.fiber_new_rounded, "الأحدث", '-created_at', textColor),
            _buildFilterOption(
                Icons.trending_down_rounded, "الأقل سعراً", 'price', textColor),
            _buildFilterOption(
                Icons.trending_up_rounded, "الأعلى سعراً", '-price', textColor),
            const SizedBox(height: 10),

            // --- فلتر النوع (Featured) ---
            if (widget.showFeaturedFilter) ...[
              Text("النوع",
                  style: TextStyle(
                      color: textColor.withOpacity(0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTypeChip(
                      "الكل", Icons.apps_rounded, null, chipBg, textColor),
                  _buildTypeChip(
                      "مميزة ⭐", Icons.star_rounded, 'true', chipBg, textColor),
                  _buildTypeChip("عادية", Icons.grid_view_rounded, 'false',
                      chipBg, textColor),
                ],
              ),
            ],
            const SizedBox(height: 30),
            // زر التطبيق
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _applyAndClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.goldenBronze,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("تطبيق الفرز",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(
      IconData icon, String label, String orderingValue, Color textColor) {
    final bool isSelected = _currentFilters['ordering'] == orderingValue;
    return GestureDetector(
      onTap: () => setState(() => _currentFilters['ordering'] = orderingValue),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.goldenBronze
                      : AppColors.goldenBronze.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon,
                  color: isSelected ? Colors.white : AppColors.goldenBronze,
                  size: 18),
            ),
            const SizedBox(width: 12),
            Text(label,
                style: TextStyle(
                    color: isSelected ? AppColors.goldenBronze : textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.goldenBronze, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label, IconData icon, String? isFeaturedValue,
      Color chipBg, Color textColor) {
    final bool isSelected = _currentFilters['is_featured'] == isFeaturedValue ||
        (isFeaturedValue == null &&
            !_currentFilters.containsKey('is_featured'));
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isFeaturedValue == null) {
            _currentFilters.remove('is_featured');
          } else {
            _currentFilters['is_featured'] = isFeaturedValue;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
            color: isSelected ? AppColors.goldenBronze : chipBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.goldenBronze.withOpacity(0.3))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon,
              color: isSelected ? Colors.white : AppColors.goldenBronze,
              size: 16),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: isSelected ? Colors.white : textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}
