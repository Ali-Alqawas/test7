// import 'package:flutter/material.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/theme_manager.dart';
// import 'category_offers_screen.dart';

// // ============================================================================
// // شاشة التصنيفات / الفئات (Categories Screen)
// // ============================================================================
// class CategoriesScreen extends StatelessWidget {
//   const CategoriesScreen({super.key});

//   // بيانات التصنيفات مع صور تعبيرية
//   static final List<Map<String, dynamic>> _categories = [
//     {
//       "name": "إلكترونيات",
//       "image":
//           "https://images.unsplash.com/photo-1498049794561-7780e7231661?auto=format&fit=crop&w=600&q=80",
//       "count": 245,
//     },
//     {
//       "name": "أزياء رجالية",
//       "image":
//           "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=600&q=80",
//       "count": 182,
//     },
//     {
//       "name": "أزياء نسائية",
//       "image":
//           "https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=600&q=80",
//       "count": 310,
//     },
//     {
//       "name": "مطاعم وكافيهات",
//       "image":
//           "https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=600&q=80",
//       "count": 128,
//     },
//     {
//       "name": "سوبرماركت",
//       "image":
//           "https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=600&q=80",
//       "count": 95,
//     },
//     {
//       "name": "صحة وجمال",
//       "image":
//           "https://images.unsplash.com/photo-1596462502278-27bfdc403348?auto=format&fit=crop&w=600&q=80",
//       "count": 167,
//     },
//     {
//       "name": "أجهزة منزلية",
//       "image":
//           "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?auto=format&fit=crop&w=600&q=80",
//       "count": 74,
//     },
//     {
//       "name": "رياضة ولياقة",
//       "image":
//           "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=600&q=80",
//       "count": 89,
//     },
//     {
//       "name": "عطور ومجوهرات",
//       "image":
//           "https://images.unsplash.com/photo-1594035910387-fea47794261f?auto=format&fit=crop&w=600&q=80",
//       "count": 112,
//     },
//     {
//       "name": "أطفال وألعاب",
//       "image":
//           "https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?auto=format&fit=crop&w=600&q=80",
//       "count": 203,
//     },
//     {
//       "name": "سيارات وقطع غيار",
//       "image":
//           "https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=600&q=80",
//       "count": 56,
//     },
//     {
//       "name": "خدمات ومنوعات",
//       "image":
//           "https://images.unsplash.com/photo-1521791136064-7986c2920216?auto=format&fit=crop&w=600&q=80",
//       "count": 34,
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final Color bgColor =
//         isDarkMode ? AppColors.deepNavy : AppColors.lightBackground;

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: bgColor,
//         body: SafeArea(
//           child: Column(
//             children: [
//               // ===== 1. الهيدر (عنوان + بحث + تبديل الثيم) =====
//               _buildHeader(context, isDarkMode),

//               // ===== 2. شبكة التصنيفات =====
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: GridView.builder(
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.only(top: 10, bottom: 100),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       mainAxisSpacing: 14,
//                       crossAxisSpacing: 14,
//                       childAspectRatio: 1.05,
//                     ),
//                     itemCount: _categories.length,
//                     itemBuilder: (context, index) {
//                       return _buildCategoryCard(
//                           context, _categories[index], isDarkMode);
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ==========================================
//   // الهيدر: عنوان + بحث + ثيم
//   // ==========================================
//   Widget _buildHeader(BuildContext context, bool isDarkMode) {
//     final Color textColor =
//         isDarkMode ? AppColors.pureWhite : AppColors.lightText;

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // الصف العلوي: رجوع + عنوان + عدد + ثيم
//           Row(
//             children: [
//               // زر الرجوع (يمين في RTL)
//               GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: isDarkMode
//                         ? const Color(0xFF072A38)
//                         : AppColors.pureWhite,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                         color: isDarkMode
//                             ? AppColors.goldenBronze.withOpacity(0.3)
//                             : Colors.grey.shade300),
//                   ),
//                   child: Icon(Icons.arrow_forward_ios_rounded,
//                       color: textColor, size: 18),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text("التصنيفات",
//                   style: TextStyle(
//                       color: textColor,
//                       fontSize: 24,
//                       fontWeight: FontWeight.w900)),
//               const SizedBox(width: 8),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 decoration: BoxDecoration(
//                   color: AppColors.goldenBronze.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(
//                       color: AppColors.goldenBronze.withOpacity(0.3)),
//                 ),
//                 child: Text("${_categories.length} قسم",
//                     style: const TextStyle(
//                         color: AppColors.goldenBronze,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold)),
//               ),
//               const Spacer(),
//               // أيقونة تبديل الثيم (يسار في RTL)
//               GestureDetector(
//                 onTap: toggleGlobalTheme,
//                 child: Container(
//                   width: 42,
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color:
//                         isDarkMode ? AppColors.pureWhite : AppColors.deepNavy,
//                     borderRadius: BorderRadius.circular(14),
//                     boxShadow: [
//                       BoxShadow(
//                           color:
//                               (isDarkMode ? Colors.black : AppColors.deepNavy)
//                                   .withOpacity(0.15),
//                           blurRadius: 8,
//                           offset: const Offset(0, 3))
//                     ],
//                   ),
//                   child: Icon(
//                       isDarkMode
//                           ? Icons.wb_sunny_rounded
//                           : Icons.nightlight_round,
//                       color: AppColors.goldenBronze,
//                       size: 20),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ==========================================
//   // كارت التصنيف (مربع كبير + صورة + اسم)
//   // ==========================================
//   Widget _buildCategoryCard(
//       BuildContext context, Map<String, dynamic> category, bool isDarkMode) {
//     final Color cardColor =
//         isDarkMode ? const Color(0xFF072A38) : AppColors.pureWhite;
//     final Color borderColor = isDarkMode
//         ? AppColors.goldenBronze.withOpacity(0.2)
//         : Colors.grey.shade200;

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => CategoryOffersScreen(
//               categoryName: category["name"],
//               categoryImage: category["image"],
//               offerCount: category["count"],
//             ),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: cardColor,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: borderColor, width: 1.2),
//           boxShadow: [
//             BoxShadow(
//               color: (isDarkMode ? Colors.black : AppColors.goldenBronze)
//                   .withOpacity(isDarkMode ? 0.25 : 0.08),
//               blurRadius: 12,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(19),
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               // 1. الصورة
//               Image.network(
//                 category["image"],
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) => Container(
//                   color: AppColors.goldenBronze.withOpacity(0.1),
//                   child: const Icon(Icons.image_not_supported,
//                       color: AppColors.grey, size: 40),
//                 ),
//               ),

//               // 2. التدرج اللوني للحماية
//               Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                     colors: [
//                       AppColors.deepNavy.withOpacity(0.85),
//                       AppColors.deepNavy.withOpacity(0.3),
//                       Colors.transparent,
//                     ],
//                     stops: const [0.0, 0.5, 1.0],
//                   ),
//                 ),
//               ),

//               // 3. المحتوى السفلي (اسم + عدد)
//               Positioned(
//                 bottom: 14,
//                 right: 14,
//                 left: 14,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // اسم التصنيف
//                     Text(
//                       category["name"],
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w900,
//                         height: 1.2,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     // عدد العروض
//                     Row(
//                       children: [
//                         Container(
//                           width: 4,
//                           height: 4,
//                           decoration: const BoxDecoration(
//                             color: AppColors.goldenBronze,
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           "${category["count"]} عرض",
//                           style: TextStyle(
//                             color: AppColors.warmBeige.withOpacity(0.9),
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               // 4. أيقونة السهم (أعلى يسار)
//               Positioned(
//                 top: 10,
//                 left: 10,
//                 child: Container(
//                   width: 30,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     color: AppColors.goldenBronze.withOpacity(0.9),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Icon(
//                     Icons.arrow_back_ios_new_rounded,
//                     color: Colors.white,
//                     size: 14,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../../core/network/api_service.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import 'category_offers_screen.dart';

// ============================================================================
// شاشة التصنيفات / الفئات (Categories Screen) - مربوطة بالـ API
// ============================================================================
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ApiService _api = ApiService();
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final data = await _api.get(ApiConstants.categories, requiresAuth: false);

      final List rawCategories =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);

      if (mounted) {
        setState(() {
          _categories = rawCategories.map<Map<String, dynamic>>((cat) {
            return {
              "id":
                  cat['id']?.toString() ?? cat['category_id']?.toString() ?? '',
              "name": cat['name']?.toString() ?? 'تصنيف',
              "image": cat['image'] != null
                  ? ApiConstants.resolveImageUrl(cat['image'].toString())
                  : 'https://placehold.co/600x600/png?text=No+Image', // صورة بديلة إذا لم توجد
              "count": cat['products_count'] ??
                  0, // عدد المنتجات إن وجد من الباك إند
            };
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('خطأ في جلب شاشة التصنيفات: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor =
        isDarkMode ? AppColors.deepNavy : AppColors.lightBackground;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Column(
            children: [
              // ===== 1. الهيدر (عنوان + بحث + تبديل الثيم) =====
              _buildHeader(context, isDarkMode),

              // ===== 2. شبكة التصنيفات =====
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.goldenBronze))
                    : _categories.isEmpty
                        ? const Center(child: Text("لا توجد تصنيفات حالياً"))
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 100),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                                childAspectRatio: 1.05,
                              ),
                              itemCount: _categories.length,
                              itemBuilder: (context, index) {
                                return _buildCategoryCard(
                                    context, _categories[index], isDarkMode);
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // الهيدر: عنوان + بحث + ثيم
  // ==========================================
  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    final Color textColor =
        isDarkMode ? AppColors.pureWhite : AppColors.lightText;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Row(
        children: [
          // زر الرجوع (يمين في RTL)
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    isDarkMode ? const Color(0xFF072A38) : AppColors.pureWhite,
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
          const SizedBox(width: 12),
          Text("التصنيفات",
              style: TextStyle(
                  color: textColor, fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.goldenBronze.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: AppColors.goldenBronze.withOpacity(0.3)),
            ),
            child: Text("${_categories.length} قسم",
                style: const TextStyle(
                    color: AppColors.goldenBronze,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
          const Spacer(),
          // أيقونة تبديل الثيم (يسار في RTL)
          GestureDetector(
            onTap: toggleGlobalTheme,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.pureWhite : AppColors.deepNavy,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: (isDarkMode ? Colors.black : AppColors.deepNavy)
                          .withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ],
              ),
              child: Icon(
                  isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                  color: AppColors.goldenBronze,
                  size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // كارت التصنيف (مربع كبير + صورة + اسم)
  // ==========================================
  Widget _buildCategoryCard(
      BuildContext context, Map<String, dynamic> category, bool isDarkMode) {
    final Color cardColor =
        isDarkMode ? const Color(0xFF072A38) : AppColors.pureWhite;
    final Color borderColor = isDarkMode
        ? AppColors.goldenBronze.withOpacity(0.2)
        : Colors.grey.shade200;

    return GestureDetector(
      onTap: () {
        // هنا نقوم بتمرير الـ ID والاسم والصورة للشاشة الخاصة بعروض التصنيف
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryOffersScreen(
              categoryId: category["id"], // تمرير الـ ID الجديد للفلترة!
              categoryName: category["name"],
              categoryImage: category["image"],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: (isDarkMode ? Colors.black : AppColors.goldenBronze)
                  .withOpacity(isDarkMode ? 0.25 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. الصورة
              Image.network(
                category["image"],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.goldenBronze.withOpacity(0.1),
                  child: const Icon(Icons.image_not_supported,
                      color: AppColors.grey, size: 40),
                ),
              ),

              // 2. التدرج اللوني للحماية
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.deepNavy.withOpacity(0.85),
                      AppColors.deepNavy.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              // 3. المحتوى السفلي (اسم + عدد)
              Positioned(
                bottom: 14,
                right: 14,
                left: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم التصنيف
                    Text(
                      category["name"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // عدد العروض (إذا كان الصفر، لن نكتب عدد)
                    if (category["count"] > 0)
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: AppColors.goldenBronze,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${category["count"]} عرض",
                            style: TextStyle(
                              color: AppColors.warmBeige.withOpacity(0.9),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              // 4. أيقونة السهم (أعلى يسار)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.goldenBronze.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
