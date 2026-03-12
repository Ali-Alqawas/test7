// import 'package:flutter/material.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/theme_manager.dart';
// import '../../../core/widgets/offer_action_buttons.dart';
// import '../details/offer_details_screen.dart';
// import '../details/merchant_profile_screen.dart';

// // ============================================================================
// // شاشة عروض التصنيف — تعرض العروض المفلترة حسب التصنيف المختار
// // ============================================================================
// class CategoryOffersScreen extends StatefulWidget {
//   final String categoryName;
//   final String categoryImage;
//   final int offerCount;

//   const CategoryOffersScreen({
//     super.key,
//     required this.categoryName,
//     required this.categoryImage,
//     required this.offerCount,
//   });

//   @override
//   State<CategoryOffersScreen> createState() => _CategoryOffersScreenState();
// }

// class _CategoryOffersScreenState extends State<CategoryOffersScreen> {
//   final TextEditingController _searchController = TextEditingController();

//   // بيانات محاكاة للعروض حسب التصنيف
//   late List<Map<String, dynamic>> _offers;

//   @override
//   void initState() {
//     super.initState();
//     _offers = _generateOffersForCategory(widget.categoryName);
//     _searchController.addListener(() => setState(() {}));
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   List<Map<String, dynamic>> _generateOffersForCategory(String category) {
//     // محاكاة عروض حسب التصنيف
//     final Map<String, List<Map<String, dynamic>>> categoryOffers = {
//       "إلكترونيات": [
//         {
//           "title": "MacBook Pro M3 Max",
//           "storeName": "آبل ستور",
//           "storeLogo": "https://i.pravatar.cc/150?img=15",
//           "image":
//               "https://images.unsplash.com/photo-1517336714731-489689fd1ca4?auto=format&fit=crop&w=500&q=80",
//           "price": "1,200\$",
//           "oldPrice": "1,450\$",
//           "discount": "17%"
//         },
//         {
//           "title": "سماعة ابل ايربودز برو",
//           "storeName": "اكسترا",
//           "storeLogo": "https://i.pravatar.cc/150?img=11",
//           "image":
//               "https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?auto=format&fit=crop&w=500&q=80",
//           "price": "199\$",
//           "oldPrice": "250\$",
//           "discount": "20%"
//         },
//         {
//           "title": "آيباد إير الجديد",
//           "storeName": "جرير",
//           "storeLogo": "https://i.pravatar.cc/150?img=16",
//           "image":
//               "https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=500&q=80",
//           "price": "450\$",
//           "oldPrice": "550\$",
//           "discount": "18%"
//         },
//         {
//           "title": "شاشة سامسونج 4K",
//           "storeName": "ساكو",
//           "storeLogo": "https://i.pravatar.cc/150?img=12",
//           "image":
//               "https://images.unsplash.com/photo-1593640408182-31c70c8268f5?auto=format&fit=crop&w=500&q=80",
//           "price": "320\$",
//           "oldPrice": "400\$",
//           "discount": "20%"
//         },
//       ],
//       "أزياء رجالية": [
//         {
//           "title": "بدلة رسمية فاخرة",
//           "storeName": "زارا",
//           "storeLogo": "https://i.pravatar.cc/150?img=33",
//           "image":
//               "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=500&q=80",
//           "price": "250\$",
//           "oldPrice": "350\$",
//           "discount": "29%"
//         },
//         {
//           "title": "حذاء رياضي نايك",
//           "storeName": "نايك ستور",
//           "storeLogo": "https://i.pravatar.cc/150?img=34",
//           "image":
//               "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=500&q=80",
//           "price": "120\$",
//           "oldPrice": "180\$",
//           "discount": "33%"
//         },
//         {
//           "title": "ساعة كاسيو كلاسيك",
//           "storeName": "ذا ووتش هاوس",
//           "storeLogo": "https://i.pravatar.cc/150?img=35",
//           "image":
//               "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=500&q=80",
//           "price": "85\$",
//           "oldPrice": "120\$",
//           "discount": "29%"
//         },
//       ],
//     };

//     return categoryOffers[category] ??
//         [
//           {
//             "title": "عرض ${widget.categoryName} 1",
//             "storeName": "متجر عام",
//             "storeLogo": "https://i.pravatar.cc/150?img=20",
//             "image": widget.categoryImage,
//             "price": "99\$",
//             "oldPrice": "150\$",
//             "discount": "34%"
//           },
//           {
//             "title": "عرض ${widget.categoryName} 2",
//             "storeName": "متجر مميز",
//             "storeLogo": "https://i.pravatar.cc/150?img=21",
//             "image": widget.categoryImage,
//             "price": "149\$",
//             "oldPrice": "200\$",
//             "discount": "26%"
//           },
//           {
//             "title": "عرض ${widget.categoryName} 3",
//             "storeName": "متجر آخر",
//             "storeLogo": "https://i.pravatar.cc/150?img=22",
//             "image": widget.categoryImage,
//             "price": "75\$",
//             "oldPrice": "100\$",
//             "discount": "25%"
//           },
//         ];
//   }

//   List<Map<String, dynamic>> get _filteredOffers {
//     if (_searchController.text.isEmpty) return _offers;
//     final q = _searchController.text.toLowerCase();
//     return _offers
//         .where((o) =>
//             (o["title"] as String).toLowerCase().contains(q) ||
//             (o["storeName"] as String).toLowerCase().contains(q))
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final bg = isDark ? AppColors.deepNavy : AppColors.lightBackground;
//     final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
//     final cardC = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: bg,
//         body: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(isDark, textC, cardC),
//               Expanded(
//                 child: _filteredOffers.isEmpty
//                     ? _buildEmptyState(isDark)
//                     : ListView.builder(
//                         physics: const BouncingScrollPhysics(),
//                         padding: const EdgeInsets.fromLTRB(16, 5, 16, 100),
//                         itemCount: _filteredOffers.length,
//                         itemBuilder: (_, i) =>
//                             _buildOfferCard(_filteredOffers[i], isDark),
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(bool isDark, Color textC, Color cardC) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
//       child: Column(
//         children: [
//           Row(
//             children: [
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
//                       color: textC, size: 18),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text(widget.categoryName,
//                   style: TextStyle(
//                       color: textC, fontSize: 22, fontWeight: FontWeight.w900)),
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
//                 child: Text("${widget.offerCount} عرض",
//                     style: const TextStyle(
//                         color: AppColors.goldenBronze,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold)),
//               ),
//               const Spacer(),
//               GestureDetector(
//                 onTap: toggleGlobalTheme,
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
//                       color: AppColors.goldenBronze,
//                       size: 20),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 14),
//           // شريط بحث + فلتر
//           Row(children: [
//             Expanded(
//                 child: Container(
//               height: 42,
//               decoration: BoxDecoration(
//                 color: cardC,
//                 borderRadius: BorderRadius.circular(25),
//                 border: Border.all(
//                     color: isDark
//                         ? AppColors.goldenBronze.withOpacity(0.3)
//                         : AppColors.goldenBronze,
//                     width: 1.2),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: Row(children: [
//                 Icon(Icons.search_rounded,
//                     color:
//                         isDark ? AppColors.warmBeige : AppColors.goldenBronze,
//                     size: 20),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: TextField(
//                     controller: _searchController,
//                     style: TextStyle(color: textC, fontSize: 14),
//                     decoration: InputDecoration(
//                       hintText: "ابحث في ${widget.categoryName}...",
//                       hintStyle: TextStyle(
//                           color: isDark
//                               ? AppColors.grey
//                               : AppColors.lightText.withOpacity(0.5),
//                           fontSize: 13),
//                       border: InputBorder.none,
//                       isDense: true,
//                       contentPadding: EdgeInsets.zero,
//                     ),
//                   ),
//                 ),
//                 if (_searchController.text.isNotEmpty)
//                   GestureDetector(
//                     onTap: () => _searchController.clear(),
//                     child: const Icon(Icons.close_rounded,
//                         color: AppColors.grey, size: 18),
//                   ),
//               ]),
//             )),
//             const SizedBox(width: 10),
//             Container(
//               width: 42,
//               height: 42,
//               decoration: BoxDecoration(
//                 color: AppColors.goldenBronze,
//                 borderRadius: BorderRadius.circular(14),
//                 boxShadow: [
//                   BoxShadow(
//                       color: AppColors.goldenBronze.withOpacity(0.3),
//                       blurRadius: 8,
//                       offset: const Offset(0, 3))
//                 ],
//               ),
//               child:
//                   const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
//             ),
//           ]),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState(bool isDark) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.search_off_rounded,
//               color: AppColors.goldenBronze.withOpacity(0.3), size: 70),
//           const SizedBox(height: 16),
//           Text("لا توجد نتائج",
//               style: TextStyle(
//                   color: isDark
//                       ? AppColors.grey
//                       : AppColors.lightText.withOpacity(0.5),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600)),
//         ],
//       ),
//     );
//   }

//   Widget _buildOfferCard(Map<String, dynamic> offer, bool isDark) {
//     final cardC = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
//     final borderC =
//         isDark ? AppColors.goldenBronze.withOpacity(0.2) : Colors.grey.shade200;

//     return GestureDetector(
//       onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (_) => OfferDetailsScreen(
//                   offerData: offer, offerType: OfferDetailType.standard))),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 14),
//         decoration: BoxDecoration(
//           color: cardC,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: borderC),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
//                 blurRadius: 12,
//                 offset: const Offset(0, 5)),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(19),
//           child: Row(children: [
//             SizedBox(
//               width: 130,
//               height: 130,
//               child: Stack(fit: StackFit.expand, children: [
//                 Image.network(offer["image"], fit: BoxFit.cover),
//                 if (offer["discount"] != null)
//                   Positioned(
//                       top: 8,
//                       right: 8,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 7, vertical: 3),
//                         decoration: BoxDecoration(
//                             color: AppColors.error,
//                             borderRadius: BorderRadius.circular(6)),
//                         child: Text("${offer["discount"]}-",
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.bold)),
//                       )),
//               ]),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     GestureDetector(
//                       onTap: () => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (_) => MerchantProfileScreen(
//                                   storeName: offer["storeName"],
//                                   storeLogo: offer["storeLogo"]))),
//                       child: Row(children: [
//                         CircleAvatar(
//                             radius: 10,
//                             backgroundImage: NetworkImage(offer["storeLogo"])),
//                         const SizedBox(width: 6),
//                         Text(offer["storeName"],
//                             style: const TextStyle(
//                                 color: AppColors.goldenBronze,
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w700)),
//                       ]),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(offer["title"],
//                         style: TextStyle(
//                             color: isDark
//                                 ? AppColors.pureWhite
//                                 : AppColors.lightText,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w900),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis),
//                     const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(offer["price"],
//                                   style: const TextStyle(
//                                       color: AppColors.goldenBronze,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w900)),
//                               Text(offer["oldPrice"],
//                                   style: const TextStyle(
//                                       color: AppColors.grey,
//                                       fontSize: 11,
//                                       decoration: TextDecoration.lineThrough)),
//                             ]),
//                         OfferActionButtons(
//                             isDarkMode: isDark,
//                             offerId: "CAT_${offer["title"]}"),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ]),
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
import '../../../core/widgets/offer_action_buttons.dart';
import '../details/offer_details_screen.dart';
import '../details/merchant_profile_screen.dart';

// ============================================================================
// شاشة عروض التصنيف — مربوطة بالـ API للفلترة الحقيقية
// ============================================================================
class CategoryOffersScreen extends StatefulWidget {
  final String categoryId; // أضفنا هذا المعامل المهم جداً للفلترة
  final String categoryName;
  final String categoryImage;

  const CategoryOffersScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
  });

  @override
  State<CategoryOffersScreen> createState() => _CategoryOffersScreenState();
}

class _CategoryOffersScreenState extends State<CategoryOffersScreen> {
  final ApiService _api = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _offers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategoryOffers(); // جلب البيانات عند فتح الشاشة
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ==========================================
  // دالة جلب العروض من الباك إند حسب التصنيف
  // ==========================================
  Future<void> _fetchCategoryOffers() async {
    try {
      // نرسل طلب للباك إند ونخبره: "أعطنا المنتجات التي تتبع هذا التصنيف فقط"
      final data = await _api.get(
        ApiConstants.products,
        queryParams: {'category': widget.categoryId}, // الفلترة تتم هنا!
        requiresAuth: false,
      );

      final List rawOffers =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);

      if (mounted) {
        setState(() {
          _offers = rawOffers.map<Map<String, dynamic>>((product) {
            // معالجة الصور
            var images = product['images'] as List?;
            String imageUrl = (images != null && images.isNotEmpty)
                ? ApiConstants.resolveImageUrl(
                    images[0]['image_url']?.toString())
                : ApiConstants.resolveImageUrl(product['image']?.toString());

            // معالجة المتجر
            String storeName = product['store_name']?.toString() ?? 'متجر';
            String storeLogo = product['store_logo'] != null
                ? ApiConstants.resolveImageUrl(product['store_logo'].toString())
                : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(storeName)}&background=B8860B&color=fff';

            // حساب السعر والخصم
            double price =
                double.tryParse(product['price']?.toString() ?? '0') ?? 0;
            double oldPrice =
                double.tryParse(product['old_price']?.toString() ?? '0') ?? 0;
            String discount = '';
            if (oldPrice > price && oldPrice > 0) {
              discount =
                  '${((oldPrice - price) / oldPrice * 100).toStringAsFixed(0)}%';
            }

            return {
              "id": (product['product_id'] ?? product['id'] ?? '').toString(),
              "title": product['title'] ?? 'بدون عنوان',
              "storeName": storeName,
              "storeLogo": storeLogo,
              "image": imageUrl,
              "price": "$price\$",
              "oldPrice": oldPrice > 0 ? "$oldPrice\$" : "",
              "discount": discount.isNotEmpty ? discount : null,
              "is_liked": product['is_liked'] ?? false,
              "is_favorited": product['is_favorited'] ?? false,
              "original_data":
                  product, // نحتفظ بالبيانات الأصلية لشاشة التفاصيل
            };
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('خطأ في جلب عروض التصنيف: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // فلترة محلية لشريط البحث
  List<Map<String, dynamic>> get _filteredOffers {
    if (_searchController.text.isEmpty) return _offers;
    final q = _searchController.text.toLowerCase();
    return _offers
        .where((o) =>
            (o["title"] as String).toLowerCase().contains(q) ||
            (o["storeName"] as String).toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.deepNavy : AppColors.lightBackground;
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    final cardC = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(isDark, textC, cardC),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.goldenBronze))
                    : _filteredOffers.isEmpty
                        ? _buildEmptyState(isDark)
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 5, 16, 100),
                            itemCount: _filteredOffers.length,
                            itemBuilder: (_, i) =>
                                _buildOfferCard(_filteredOffers[i], isDark),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, Color textC, Color cardC) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Column(
        children: [
          Row(
            children: [
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
                      color: textC, size: 18),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(widget.categoryName,
                    style: TextStyle(
                        color: textC,
                        fontSize: 22,
                        fontWeight: FontWeight.w900),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 8),
              if (!_isLoading)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.goldenBronze.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.goldenBronze.withOpacity(0.3)),
                  ),
                  child: Text("${_offers.length} عرض",
                      style: const TextStyle(
                          color: AppColors.goldenBronze,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: toggleGlobalTheme,
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
                      color: AppColors.goldenBronze,
                      size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // شريط بحث + فلتر
          Row(children: [
            Expanded(
                child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: cardC,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    color: isDark
                        ? AppColors.goldenBronze.withOpacity(0.3)
                        : AppColors.goldenBronze,
                    width: 1.2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(children: [
                Icon(Icons.search_rounded,
                    color:
                        isDark ? AppColors.warmBeige : AppColors.goldenBronze,
                    size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: textC, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "ابحث في ${widget.categoryName}...",
                      hintStyle: TextStyle(
                          color: isDark
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
                    onTap: () => _searchController.clear(),
                    child: const Icon(Icons.close_rounded,
                        color: AppColors.grey, size: 18),
                  ),
              ]),
            )),
            const SizedBox(width: 10),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.goldenBronze,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.goldenBronze.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ],
              ),
              child:
                  const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              color: AppColors.goldenBronze.withOpacity(0.3), size: 70),
          const SizedBox(height: 16),
          Text("لا توجد منتجات في هذا التصنيف",
              style: TextStyle(
                  color: isDark
                      ? AppColors.grey
                      : AppColors.lightText.withOpacity(0.5),
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> offer, bool isDark) {
    final cardC = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
    final borderC =
        isDark ? AppColors.goldenBronze.withOpacity(0.2) : Colors.grey.shade200;

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => OfferDetailsScreen(
                  offerData: offer["original_data"] ?? offer,
                  offerType: OfferDetailType.standard))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: cardC,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderC),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                blurRadius: 12,
                offset: const Offset(0, 5)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: Row(children: [
            SizedBox(
              width: 130,
              height: 130,
              child: Stack(fit: StackFit.expand, children: [
                Image.network(offer["image"], fit: BoxFit.cover),
                if (offer["discount"] != null)
                  Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text("${offer["discount"]}-",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      )),
              ]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => MerchantProfileScreen(
                                  storeName: offer["storeName"],
                                  storeLogo: offer["storeLogo"]))),
                      child: Row(children: [
                        CircleAvatar(
                            radius: 10,
                            backgroundImage: NetworkImage(offer["storeLogo"])),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(offer["storeName"],
                              style: const TextStyle(
                                  color: AppColors.goldenBronze,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 8),
                    Text(offer["title"],
                        style: TextStyle(
                            color: isDark
                                ? AppColors.pureWhite
                                : AppColors.lightText,
                            fontSize: 14,
                            fontWeight: FontWeight.w900),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(offer["price"],
                                  style: const TextStyle(
                                      color: AppColors.goldenBronze,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900)),
                              if (offer["oldPrice"].isNotEmpty)
                                Text(offer["oldPrice"],
                                    style: const TextStyle(
                                        color: AppColors.grey,
                                        fontSize: 11,
                                        decoration:
                                            TextDecoration.lineThrough)),
                            ]),
                        // تم حل مشكلة الـ ID الوهمي هنا بنجاح!
                        OfferActionButtons(
                          isDarkMode: isDark,
                          offerId: offer["id"].toString(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
