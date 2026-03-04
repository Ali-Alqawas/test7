// import 'package:flutter/material.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/theme_manager.dart';
// import '../../../core/widgets/custom_button.dart';

// class InterestsScreen extends StatefulWidget {
//   const InterestsScreen({super.key});

//   @override
//   State<InterestsScreen> createState() => _InterestsScreenState();
// }

// class _InterestsScreenState extends State<InterestsScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animController;
//   late Animation<double> _fadeAnim;

//   // الاهتمامات المتاحة — مناسبة لتطبيق عروض وتسوق فخم
//   final List<Map<String, dynamic>> _interests = [
//     {'name': 'إلكترونيات', 'icon': Icons.devices_rounded, 'selected': false},
//     {'name': 'أزياء رجالية', 'icon': Icons.man_rounded, 'selected': false},
//     {'name': 'أزياء نسائية', 'icon': Icons.woman_rounded, 'selected': false},
//     {'name': 'ساعات فاخرة', 'icon': Icons.watch_rounded, 'selected': false},
//     {'name': 'عطور', 'icon': Icons.spa_rounded, 'selected': false},
//     {'name': 'مجوهرات', 'icon': Icons.diamond_rounded, 'selected': false},
//     {'name': 'أحذية', 'icon': Icons.snowshoeing_rounded, 'selected': false},
//     {'name': 'حقائب', 'icon': Icons.shopping_bag_rounded, 'selected': false},
//     {'name': 'نظارات', 'icon': Icons.visibility_rounded, 'selected': false},
//     {'name': 'أثاث ومنزل', 'icon': Icons.weekend_rounded, 'selected': false},
//     {'name': 'مستلزمات مطبخ', 'icon': Icons.kitchen_rounded, 'selected': false},
//     {'name': 'أجهزة منزلية', 'icon': Icons.tv_rounded, 'selected': false},
//     {
//       'name': 'تجميل وعناية',
//       'icon': Icons.face_retouching_natural_rounded,
//       'selected': false
//     },
//     {
//       'name': 'رياضة ولياقة',
//       'icon': Icons.fitness_center_rounded,
//       'selected': false
//     },
//     {
//       'name': 'ألعاب وترفيه',
//       'icon': Icons.sports_esports_rounded,
//       'selected': false
//     },
//     {'name': 'كتب ومكتبات', 'icon': Icons.menu_book_rounded, 'selected': false},
//     {
//       'name': 'مطاعم وكافيهات',
//       'icon': Icons.restaurant_rounded,
//       'selected': false
//     },
//     {
//       'name': 'سوبرماركت',
//       'icon': Icons.shopping_cart_rounded,
//       'selected': false
//     },
//     {'name': 'سفر وفنادق', 'icon': Icons.flight_rounded, 'selected': false},
//     {'name': 'سيارات', 'icon': Icons.directions_car_rounded, 'selected': false},
//     {
//       'name': 'أطفال وألعاب',
//       'icon': Icons.child_care_rounded,
//       'selected': false
//     },
//     {
//       'name': 'صحة وصيدلية',
//       'icon': Icons.local_pharmacy_rounded,
//       'selected': false
//     },
//     {'name': 'حيوانات أليفة', 'icon': Icons.pets_rounded, 'selected': false},
//     {
//       'name': 'هدايا ومناسبات',
//       'icon': Icons.card_giftcard_rounded,
//       'selected': false
//     },
//   ];

//   int get _selectedCount =>
//       _interests.where((i) => i['selected'] == true).length;

//   @override
//   void initState() {
//     super.initState();
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//     _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
//     _animController.forward();
//   }

//   @override
//   void dispose() {
//     _animController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor: isDark ? AppColors.deepNavy : AppColors.lightBackground,
//       body: SafeArea(
//         child: FadeTransition(
//           opacity: _fadeAnim,
//           child: Column(
//             children: [
//               // --- الهيدر ---
//               _buildHeader(isDark),

//               // --- الشبكة ---
//               Expanded(
//                 child: SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
//                   child: Wrap(
//                     spacing: 10,
//                     runSpacing: 12,
//                     children: List.generate(_interests.length, (index) {
//                       return _buildInterestChip(index, isDark);
//                     }),
//                   ),
//                 ),
//               ),

//               // --- الزر السفلي ---
//               _buildBottomSection(isDark),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // --- الهيدر ---
//   Widget _buildHeader(bool isDark) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // زر تبديل الثيم
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               GestureDetector(
//                 onTap: () => toggleGlobalTheme(),
//                 child: Container(
//                   width: 42,
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
//                     borderRadius: BorderRadius.circular(14),
//                     boxShadow: [
//                       BoxShadow(
//                           color: (isDark ? Colors.black : AppColors.deepNavy)
//                               .withOpacity(0.15),
//                           blurRadius: 8,
//                           offset: const Offset(0, 3))
//                     ],
//                   ),
//                   child: Icon(
//                       isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
//                       size: 20,
//                       color: AppColors.goldenBronze),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color:
//                         isDark ? const Color(0xFF072A38) : AppColors.pureWhite,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                         color: isDark
//                             ? AppColors.goldenBronze.withOpacity(0.3)
//                             : Colors.grey.shade300),
//                   ),
//                   child: Icon(Icons.arrow_forward_ios_rounded,
//                       size: 18,
//                       color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 25),

//           // العنوان
//           Text(
//             "ما الذي يهمك؟",
//             style: TextStyle(
//               color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             "اختر اهتماماتك لنخصص لك أفضل العروض والتخفيضات",
//             style: TextStyle(
//               color: isDark ? AppColors.warmBeige : const Color(0xFF5D4037),
//               fontSize: 14,
//               height: 1.5,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             "اختر 3 على الأقل",
//             style: TextStyle(
//               color: AppColors.goldenBronze.withOpacity(0.8),
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- شريحة الاهتمام ---
//   Widget _buildInterestChip(int index, bool isDark) {
//     final item = _interests[index];
//     final bool isSelected = item['selected'];

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _interests[index]['selected'] = !isSelected;
//         });
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? (isDark
//                   ? AppColors.goldenBronze.withOpacity(0.15)
//                   : AppColors.goldenBronze.withOpacity(0.1))
//               : (isDark ? Colors.white.withOpacity(0.05) : Colors.white),
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: isSelected
//                 ? AppColors.goldenBronze
//                 : (isDark
//                     ? Colors.white.withOpacity(0.1)
//                     : Colors.grey.shade300),
//             width: isSelected ? 1.5 : 1,
//           ),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               item['icon'],
//               size: 20,
//               color: isSelected
//                   ? AppColors.goldenBronze
//                   : (isDark ? Colors.white54 : Colors.grey.shade500),
//             ),
//             const SizedBox(width: 8),
//             Text(
//               item['name'],
//               style: TextStyle(
//                 color: isSelected
//                     ? (isDark ? AppColors.goldenBronze : AppColors.deepNavy)
//                     : (isDark ? Colors.white70 : Colors.grey.shade700),
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
//                 fontSize: 14,
//               ),
//             ),
//             if (isSelected) ...[
//               const SizedBox(width: 6),
//               const Icon(Icons.check_circle,
//                   size: 16, color: AppColors.goldenBronze),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   // --- القسم السفلي ---
//   Widget _buildBottomSection(bool isDark) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
//       decoration: BoxDecoration(
//         color: isDark ? AppColors.deepNavy : AppColors.lightBackground,
//         boxShadow: [
//           BoxShadow(
//             color: isDark
//                 ? Colors.black.withOpacity(0.3)
//                 : Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, -5),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // عداد الاختيارات
//           Padding(
//             padding: const EdgeInsets.only(bottom: 14),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "$_selectedCount",
//                   style: const TextStyle(
//                     color: AppColors.goldenBronze,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   " اهتمام محدد",
//                   style: TextStyle(
//                     color: isDark ? Colors.white54 : Colors.grey.shade600,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // زر المتابعة
//           CustomButton(
//             text: "متابعة",
//             onPressed: _selectedCount >= 3
//                 ? () {
//                     final selected = _interests
//                         .where((i) => i['selected'] == true)
//                         .map((i) => i['name'])
//                         .toList();
//                     debugPrint("الاهتمامات المختارة: $selected");
//                     // TODO: حفظ الاهتمامات والانتقال للشاشة الرئيسية
//                   }
//                 : () {},
//             icon: Icons.arrow_forward_rounded,
//           ),

//           // رابط التخطي
//           const SizedBox(height: 10),
//           GestureDetector(
//             onTap: () {
//               // TODO: تخطي والانتقال للشاشة الرئيسية
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(8),
//               child: Text(
//                 "تخطي الآن",
//                 style: TextStyle(
//                   color: isDark ? Colors.white38 : Colors.grey.shade500,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../../core/network/api_service.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/token_manager.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../core/widgets/custom_button.dart';
import '../home/home_screen.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // قائمة الاهتمامات التي سنجلبها من السيرفر
  List<Map<String, dynamic>> _interests = [];
  bool _isLoadingCategories = true;
  bool _isSaving = false;

  final ApiService _api = ApiService();

  int get _selectedCount =>
      _interests.where((i) => i['selected'] == true).length;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();

    // جلب الفئات فور فتح الشاشة
    _fetchCategories();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // --- دالة مساعدة لربط الفئات بأيقونات مناسبة ---
  IconData _getIconForCategory(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('إلكترونيات') || name.contains('electronics'))
      return Icons.devices_rounded;
    if (name.contains('أزياء') || name.contains('fashion'))
      return Icons.checkroom_rounded;
    if (name.contains('طعام') || name.contains('food') || name.contains('مطعم'))
      return Icons.restaurant_rounded;
    if (name.contains('تجميل') || name.contains('beauty'))
      return Icons.face_retouching_natural_rounded;
    if (name.contains('منزل') || name.contains('home'))
      return Icons.weekend_rounded;
    if (name.contains('رياضة') || name.contains('sports'))
      return Icons.fitness_center_rounded;
    if (name.contains('سيارات') || name.contains('cars'))
      return Icons.directions_car_rounded;
    return Icons.category_rounded; // أيقونة افتراضية
  }

  // --- جلب الفئات عبر ApiService ---
  Future<void> _fetchCategories() async {
    try {
      final data = await _api.get(ApiConstants.categories, requiresAuth: false);

      List categories = data is Map && data.containsKey('results')
          ? data['results']
          : (data is List ? data : []);

      if (mounted) {
        setState(() {
          _interests = categories
              .map<Map<String, dynamic>>((cat) => {
                    'id': cat['id'] ?? cat['category_id'],
                    'name': cat['name'] ?? cat['name_en'] ?? 'فئة غير معروفة',
                    'icon': _getIconForCategory(cat['name'] ?? ''),
                    'selected': false,
                  })
              .toList();
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      _showError('تأكد من اتصالك بالإنترنت والخادم');
      if (mounted) setState(() => _isLoadingCategories = false);
    }
  }

  // --- حفظ الاهتمامات عبر ApiService ---
  Future<void> _saveInterests() async {
    final selectedIds = _interests
        .where((i) => i['selected'] == true)
        .map((i) => i['id'])
        .toList();

    if (selectedIds.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      for (var categoryId in selectedIds) {
        await _api.post(
          ApiConstants.interests,
          body: {'category': categoryId},
        );
      }

      if (mounted) {
        _navigateToHome();
      }
    } catch (e) {
      _showError('حدث خطأ أثناء حفظ الاهتمامات');
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _navigateToHome() async {
    // حفظ أن المستخدم أكمل اختيار اهتماماته
    await TokenManager.setInterestsCompleted();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('تم الحفظ! جاري الانتقال للرئيسية...'),
          backgroundColor: Colors.green),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.deepNavy : AppColors.lightBackground,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              _buildHeader(isDark),
              Expanded(
                child: _isLoadingCategories
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.goldenBronze))
                    : _interests.isEmpty
                        ? Center(
                            child: Text(
                              "لا توجد فئات متاحة حالياً",
                              style: TextStyle(
                                  color:
                                      isDark ? Colors.white70 : Colors.black54),
                            ),
                          )
                        : SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 12,
                              children:
                                  List.generate(_interests.length, (index) {
                                return _buildInterestChip(index, isDark);
                              }),
                            ),
                          ),
              ),
              _buildBottomSection(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => toggleGlobalTheme(), // تأكد من استيراد هذه الدالة
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: (isDark ? Colors.black : AppColors.deepNavy)
                              .withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child: Icon(
                      isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                      size: 20,
                      color: AppColors.goldenBronze),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                        isDark ? const Color(0xFF072A38) : AppColors.pureWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: isDark
                            ? AppColors.goldenBronze.withOpacity(0.3)
                            : Colors.grey.shade300),
                  ),
                  child: Icon(Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Text(
            "ما الذي يهمك؟",
            style: TextStyle(
              color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "اختر اهتماماتك لنخصص لك أفضل العروض والتخفيضات",
            style: TextStyle(
              color: isDark ? AppColors.warmBeige : const Color(0xFF5D4037),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "اختر 3 على الأقل",
            style: TextStyle(
              color: AppColors.goldenBronze.withOpacity(0.8),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestChip(int index, bool isDark) {
    final item = _interests[index];
    final bool isSelected = item['selected'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _interests[index]['selected'] = !isSelected;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.goldenBronze.withOpacity(0.15)
                  : AppColors.goldenBronze.withOpacity(0.1))
              : (isDark ? Colors.white.withOpacity(0.05) : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.goldenBronze
                : (isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.grey.shade300),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item['icon'],
              size: 20,
              color: isSelected
                  ? AppColors.goldenBronze
                  : (isDark ? Colors.white54 : Colors.grey.shade500),
            ),
            const SizedBox(width: 8),
            Text(
              item['name'],
              style: TextStyle(
                color: isSelected
                    ? (isDark ? AppColors.goldenBronze : AppColors.deepNavy)
                    : (isDark ? Colors.white70 : Colors.grey.shade700),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              const Icon(Icons.check_circle,
                  size: 16, color: AppColors.goldenBronze),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepNavy : AppColors.lightBackground,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$_selectedCount",
                  style: const TextStyle(
                    color: AppColors.goldenBronze,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  " اهتمام محدد",
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _isSaving
              ? const CircularProgressIndicator(color: AppColors.goldenBronze)
              : CustomButton(
                  text: "متابعة",
                  onPressed: _selectedCount >= 3 ? _saveInterests : () {},
                  icon: Icons.arrow_forward_rounded,
                ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _navigateToHome,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                "تخطي الآن",
                style: TextStyle(
                  color: isDark ? Colors.white38 : Colors.grey.shade500,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
