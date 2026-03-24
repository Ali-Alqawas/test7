// import 'package:flutter/material.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/theme_manager.dart';
// import '../../../core/widgets/offer_action_buttons.dart';
// import '../details/offer_details_screen.dart';

// class FeaturedOffersScreen extends StatefulWidget {
//   const FeaturedOffersScreen({super.key});
//   @override
//   State<FeaturedOffersScreen> createState() => _FeaturedOffersScreenState();
// }

// class _FeaturedOffersScreenState extends State<FeaturedOffersScreen> {
//   final TextEditingController _searchController = TextEditingController();

//   static final List<Map<String, dynamic>> _featuredOffers = [
//     {
//       "title": "ساعة رولكس ديتونا",
//       "storeName": "مجوهرات الفخامة",
//       "storeLogo": "https://i.pravatar.cc/150?img=11",
//       "image":
//           "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=500&q=80",
//       "price": "12,500\$",
//       "oldPrice": "15,000\$",
//       "discount": "17%",
//       "category": "مجوهرات",
//     },
//     {
//       "title": "حذاء رياضي نايك اير",
//       "storeName": "نايك ستور",
//       "storeLogo": "https://i.pravatar.cc/150?img=33",
//       "image":
//           "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=500&q=80",
//       "price": "120\$",
//       "oldPrice": "180\$",
//       "discount": "33%",
//       "category": "أزياء",
//     },
//     {
//       "title": "عطر شانيل بلو",
//       "storeName": "وجوه للعطور",
//       "storeLogo": "https://i.pravatar.cc/150?img=44",
//       "image":
//           "https://images.unsplash.com/photo-1528701800487-ad01fc8b1828?auto=format&fit=crop&w=500&q=80",
//       "price": "150\$",
//       "oldPrice": "200\$",
//       "discount": "25%",
//       "category": "عطور",
//     },
//     {
//       "title": "نظارة ريبان أصلية",
//       "storeName": "مغربي للبصريات",
//       "storeLogo": "https://i.pravatar.cc/150?img=12",
//       "image":
//           "https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&w=500&q=80",
//       "price": "95\$",
//       "oldPrice": "130\$",
//       "discount": "27%",
//       "category": "إكسسوارات",
//     },
//     {
//       "title": "MacBook Pro M3",
//       "storeName": "آبل ستور",
//       "storeLogo": "https://i.pravatar.cc/150?img=15",
//       "image":
//           "https://images.unsplash.com/photo-1517336714731-489689fd1ca4?auto=format&fit=crop&w=500&q=80",
//       "price": "1,200\$",
//       "oldPrice": "1,450\$",
//       "discount": "17%",
//       "category": "إلكترونيات",
//     },
//     {
//       "title": "عطر عود ملكي فاخر",
//       "storeName": "عبدالصمد القرشي",
//       "storeLogo": "https://i.pravatar.cc/150?img=14",
//       "image":
//           "https://images.unsplash.com/photo-1594035910387-fea477942698?auto=format&fit=crop&w=600",
//       "price": "50,000 ر.ي",
//       "oldPrice": "80,000 ر.ي",
//       "discount": "40%",
//       "category": "عطور",
//     },
//     {
//       "title": "طقم ذهب عيار 21",
//       "storeName": "مجوهرات لازوردي",
//       "storeLogo": "https://i.pravatar.cc/150?img=16",
//       "image":
//           "https://images.unsplash.com/photo-1515562141589-67f0d999b7f3?auto=format&fit=crop&w=500&q=80",
//       "price": "2,500\$",
//       "oldPrice": "3,200\$",
//       "discount": "22%",
//       "category": "مجوهرات",
//     },
//     {
//       "title": "iPad Pro 12.9 بوصة",
//       "storeName": "آبل ستور",
//       "storeLogo": "https://i.pravatar.cc/150?img=15",
//       "image":
//           "https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=500&q=80",
//       "price": "799\$",
//       "oldPrice": "1,099\$",
//       "discount": "27%",
//       "category": "إلكترونيات",
//     },
//   ];

//   late List<Map<String, dynamic>> _displayedOffers;
//   String _selectedCategory = "الكل";
//   final List<String> _categories = [
//     "الكل",
//     "إلكترونيات",
//     "أزياء",
//     "عطور",
//     "مجوهرات",
//     "إكسسوارات"
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _displayedOffers = List.from(_featuredOffers);
//     _searchController.addListener(_applyFilters);
//   }

//   void _applyFilters() {
//     final query = _searchController.text.trim().toLowerCase();
//     setState(() {
//       _displayedOffers = _featuredOffers.where((o) {
//         final matchSearch = query.isEmpty ||
//             o["title"].toString().toLowerCase().contains(query) ||
//             o["storeName"].toString().toLowerCase().contains(query);
//         final matchCat =
//             _selectedCategory == "الكل" || o["category"] == _selectedCategory;
//         return matchSearch && matchCat;
//       }).toList();
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final bgColor = isDark ? AppColors.deepNavy : AppColors.lightBackground;
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//           backgroundColor: bgColor,
//           body: SafeArea(
//             child: Column(children: [
//               _buildHeader(context, isDark),
//               _buildCategoryChips(isDark),
//               Expanded(
//                   child: _displayedOffers.isEmpty
//                       ? _emptyState(isDark)
//                       : ListView.builder(
//                           physics: const BouncingScrollPhysics(),
//                           padding: const EdgeInsets.fromLTRB(16, 5, 16, 100),
//                           itemCount: _displayedOffers.length,
//                           itemBuilder: (_, i) =>
//                               _buildCard(_displayedOffers[i], isDark),
//                         )),
//             ]),
//           )),
//     );
//   }

//   Widget _emptyState(bool isDark) => Center(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.search_off_rounded,
//               size: 60, color: AppColors.goldenBronze.withOpacity(0.4)),
//           const SizedBox(height: 16),
//           Text("لا توجد عروض مميزة",
//               style: TextStyle(
//                   color: isDark ? AppColors.pureWhite : AppColors.lightText,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700)),
//         ],
//       ));

//   Widget _buildCategoryChips(bool isDark) {
//     final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
//     return SizedBox(
//         height: 44,
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           physics: const BouncingScrollPhysics(),
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           itemCount: _categories.length,
//           itemBuilder: (_, i) {
//             final cat = _categories[i];
//             final sel = cat == _selectedCategory;
//             return GestureDetector(
//                 onTap: () {
//                   _selectedCategory = cat;
//                   _applyFilters();
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.only(left: 8, bottom: 6),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   decoration: BoxDecoration(
//                       color: sel
//                           ? AppColors.goldenBronze
//                           : (isDark
//                               ? const Color(0xFF072A38)
//                               : AppColors.pureWhite),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                           color: sel
//                               ? AppColors.goldenBronze
//                               : AppColors.goldenBronze.withOpacity(0.3))),
//                   child: Text(cat,
//                       style: TextStyle(
//                           color: sel ? Colors.white : textC,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w700)),
//                 ));
//           },
//         ));
//   }

//   Widget _buildHeader(BuildContext context, bool isDark) {
//     final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
//     final cardC = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
//     return Padding(
//         padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
//         child: Column(children: [
//           Row(children: [
//             GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                         color: isDark
//                             ? const Color(0xFF072A38)
//                             : AppColors.pureWhite,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                             color: isDark
//                                 ? AppColors.goldenBronze.withOpacity(0.3)
//                                 : Colors.grey.shade300)),
//                     child: Icon(Icons.arrow_forward_ios_rounded,
//                         color: textC, size: 18))),
//             const SizedBox(width: 12),
//             Expanded(
//                 child: Text("عروض مميزة ⭐",
//                     style: TextStyle(
//                         color: textC,
//                         fontSize: 22,
//                         fontWeight: FontWeight.w900))),
//             Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 decoration: BoxDecoration(
//                     color: AppColors.goldenBronze.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                         color: AppColors.goldenBronze.withOpacity(0.3))),
//                 child: Text("${_displayedOffers.length}",
//                     style: const TextStyle(
//                         color: AppColors.goldenBronze,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold))),
//             const SizedBox(width: 8),
//             GestureDetector(
//                 onTap: toggleGlobalTheme,
//                 child: Container(
//                     width: 42,
//                     height: 42,
//                     decoration: BoxDecoration(
//                         color:
//                             isDark ? AppColors.pureWhite : AppColors.deepNavy,
//                         borderRadius: BorderRadius.circular(14),
//                         boxShadow: [
//                           BoxShadow(
//                               color:
//                                   (isDark ? Colors.black : AppColors.deepNavy)
//                                       .withOpacity(0.15),
//                               blurRadius: 8,
//                               offset: const Offset(0, 3))
//                         ]),
//                     child: Icon(
//                         isDark
//                             ? Icons.wb_sunny_rounded
//                             : Icons.nightlight_round,
//                         color: AppColors.goldenBronze,
//                         size: 20))),
//           ]),
//           const SizedBox(height: 14),
//           Row(children: [
//             Expanded(
//                 child: Container(
//               height: 42,
//               decoration: BoxDecoration(
//                   color: cardC,
//                   borderRadius: BorderRadius.circular(25),
//                   border: Border.all(
//                       color: isDark
//                           ? AppColors.goldenBronze.withOpacity(0.3)
//                           : AppColors.goldenBronze,
//                       width: 1.2),
//                   boxShadow: [
//                     if (!isDark)
//                       BoxShadow(
//                           color: AppColors.goldenBronze.withOpacity(0.1),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4))
//                   ]),
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: Row(children: [
//                 Icon(Icons.search_rounded,
//                     color:
//                         isDark ? AppColors.warmBeige : AppColors.goldenBronze,
//                     size: 20),
//                 const SizedBox(width: 12),
//                 Expanded(
//                     child: TextField(
//                         controller: _searchController,
//                         style: TextStyle(color: textC, fontSize: 14),
//                         decoration: InputDecoration(
//                             hintText: "ابحث في العروض المميزة...",
//                             hintStyle: TextStyle(
//                                 color: isDark
//                                     ? AppColors.grey
//                                     : AppColors.lightText.withOpacity(0.5),
//                                 fontSize: 13),
//                             border: InputBorder.none,
//                             isDense: true,
//                             contentPadding: EdgeInsets.zero))),
//                 if (_searchController.text.isNotEmpty)
//                   GestureDetector(
//                       onTap: () => _searchController.clear(),
//                       child: const Icon(Icons.close_rounded,
//                           color: AppColors.grey, size: 18)),
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
//         ]));
//   }

//   Widget _buildCard(Map<String, dynamic> offer, bool isDark) {
//     final cardC = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
//     final borderC = isDark
//         ? AppColors.goldenBronze.withOpacity(0.6)
//         : AppColors.goldenBronze;
//     return GestureDetector(
//         onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) => OfferDetailsScreen(
//                     offerData: offer, offerType: OfferDetailType.featured))),
//         child: Container(
//           margin: const EdgeInsets.only(bottom: 14),
//           decoration: BoxDecoration(
//               color: cardC,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: borderC, width: 1.5),
//               boxShadow: [
//                 BoxShadow(
//                     color:
//                         AppColors.goldenBronze.withOpacity(isDark ? 0.1 : 0.15),
//                     blurRadius: 12,
//                     offset: const Offset(0, 5))
//               ]),
//           child: ClipRRect(
//               borderRadius: BorderRadius.circular(19),
//               child: Row(children: [
//                 SizedBox(
//                     width: 130,
//                     height: 140,
//                     child: Stack(fit: StackFit.expand, children: [
//                       Image.network(offer["image"], fit: BoxFit.cover),
//                       Positioned(
//                           top: 8,
//                           right: 8,
//                           child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 7, vertical: 3),
//                               decoration: BoxDecoration(
//                                   color: AppColors.error,
//                                   borderRadius: BorderRadius.circular(6)),
//                               child: Text("${offer["discount"]}-",
//                                   style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.bold)))),
//                       Positioned(
//                           bottom: 8,
//                           right: 8,
//                           child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 6, vertical: 3),
//                               decoration: BoxDecoration(
//                                   color: AppColors.goldenBronze,
//                                   borderRadius: BorderRadius.circular(6)),
//                               child: const Text("مميز ⭐",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 9,
//                                       fontWeight: FontWeight.bold)))),
//                     ])),
//                 Expanded(
//                     child: Padding(
//                         padding: const EdgeInsets.all(12),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Row(children: [
//                               Container(
//                                   padding: const EdgeInsets.all(1.5),
//                                   decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       border: Border.all(
//                                           color: AppColors.goldenBronze
//                                               .withOpacity(0.5))),
//                                   child: CircleAvatar(
//                                       radius: 10,
//                                       backgroundColor:
//                                           AppColors.lightBackground,
//                                       backgroundImage:
//                                           NetworkImage(offer["storeLogo"]))),
//                               const SizedBox(width: 6),
//                               Expanded(
//                                   child: Text(offer["storeName"],
//                                       style: const TextStyle(
//                                           color: AppColors.goldenBronze,
//                                           fontSize: 11,
//                                           fontWeight: FontWeight.w700),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis)),
//                             ]),
//                             const SizedBox(height: 8),
//                             Text(offer["title"],
//                                 style: TextStyle(
//                                     color: isDark
//                                         ? AppColors.pureWhite
//                                         : AppColors.lightText,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w900,
//                                     height: 1.3),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis),
//                             const SizedBox(height: 10),
//                             Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(offer["price"],
//                                             style: const TextStyle(
//                                                 color: AppColors.goldenBronze,
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w900)),
//                                         Text(offer["oldPrice"],
//                                             style: const TextStyle(
//                                                 color: AppColors.grey,
//                                                 fontSize: 11,
//                                                 decoration: TextDecoration
//                                                     .lineThrough)),
//                                       ]),
//                                   OfferActionButtons(
//                                       isDarkMode: isDark,
//                                       offerId: "FEAT_${offer["title"]}"),
//                                 ]),
//                           ],
//                         ))),
//               ])),
//         ));
//   }
// }

import 'package:flutter/material.dart';
import '../../../core/network/api_service.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../core/widgets/offer_action_buttons.dart';
import '../details/offer_details_screen.dart';

// ============================================================================
// شاشة العروض المميزة — مربوطة بالـ API بالكامل
// ============================================================================
class FeaturedOffersScreen extends StatefulWidget {
  const FeaturedOffersScreen({super.key});
  @override
  State<FeaturedOffersScreen> createState() => _FeaturedOffersScreenState();
}

class _FeaturedOffersScreenState extends State<FeaturedOffersScreen> {
  final ApiService _api = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _offers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFeaturedOffers();
    _searchController.addListener(() => setState(() {}));
  }

  // ==========================================
  // دالة جلب العروض المميزة من الباك إند
  // ==========================================
  Future<void> _fetchFeaturedOffers() async {
    try {
      // نرسل طلب للباك إند ونجلب المنتجات المحددة كـ "مميزة"
      // ملاحظة: تأكد أن الباك إند يقبل الفلترة بـ is_featured=true
      final data = await _api.get(
        ApiConstants.products,
        queryParams: {'is_featured': 'true'},
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
                : ApiConstants.resolveImageUrl(
                    product['image_url']?.toString() ??
                        product['image']?.toString());

            // معالجة المتجر
            String storeName = product['store_name']?.toString() ?? 'متجر';
            String storeLogo = (product['logo'] ?? product['store_logo']) !=
                    null
                ? ApiConstants.resolveImageUrl(
                    (product['logo'] ?? product['store_logo']).toString())
                : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(storeName)}&background=B8860B&color=fff';

            // حساب السعر والخصم
            double price = double.tryParse(product['new_price']?.toString() ??
                    product['price']?.toString() ??
                    '0') ??
                0;
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
              "original_data": product, // للاستخدام في شاشة التفاصيل
            };
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('خطأ في جلب العروض المميزة: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // فلترة محلية لشريط البحث
  List<Map<String, dynamic>> get _filteredOffers {
    if (_searchController.text.isEmpty) return _offers;
    final query = _searchController.text.toLowerCase();
    return _offers
        .where((o) =>
            (o["title"] as String).toLowerCase().contains(query) ||
            (o["storeName"] as String).toLowerCase().contains(query))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.deepNavy : AppColors.lightBackground;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isDark),
              // تم إزالة شريط التصنيفات المتحرك (_buildCategoryChips) من هنا
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.goldenBronze))
                    : _filteredOffers.isEmpty
                        ? _emptyState(isDark)
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 5, 16, 100),
                            itemCount: _filteredOffers.length,
                            itemBuilder: (_, i) =>
                                _buildCard(_filteredOffers[i], isDark),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState(bool isDark) => Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 60, color: AppColors.goldenBronze.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text("لا توجد عروض مميزة حالياً",
              style: TextStyle(
                  color: isDark ? AppColors.pureWhite : AppColors.lightText,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
        ],
      ));

  Widget _buildHeader(BuildContext context, bool isDark) {
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    final cardC = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
        child: Column(children: [
          Row(children: [
            GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF072A38)
                            : AppColors.pureWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: isDark
                                ? AppColors.goldenBronze.withOpacity(0.3)
                                : Colors.grey.shade300)),
                    child: Icon(Icons.arrow_forward_ios_rounded,
                        color: textC, size: 18))),
            const SizedBox(width: 12),
            Expanded(
                child: Text("عروض مميزة ⭐",
                    style: TextStyle(
                        color: textC,
                        fontSize: 22,
                        fontWeight: FontWeight.w900))),
            if (!_isLoading)
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: AppColors.goldenBronze.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.goldenBronze.withOpacity(0.3))),
                  child: Text("${_offers.length}",
                      style: const TextStyle(
                          color: AppColors.goldenBronze,
                          fontSize: 12,
                          fontWeight: FontWeight.bold))),
            const SizedBox(width: 8),
            GestureDetector(
                onTap: toggleGlobalTheme,
                child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                        color:
                            isDark ? AppColors.pureWhite : AppColors.deepNavy,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color:
                                  (isDark ? Colors.black : AppColors.deepNavy)
                                      .withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3))
                        ]),
                    child: Icon(
                        isDark
                            ? Icons.wb_sunny_rounded
                            : Icons.nightlight_round,
                        color: AppColors.goldenBronze,
                        size: 20))),
          ]),
          const SizedBox(height: 14),
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
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                          color: AppColors.goldenBronze.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4))
                  ]),
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
                            hintText: "ابحث في العروض المميزة...",
                            hintStyle: TextStyle(
                                color: isDark
                                    ? AppColors.grey
                                    : AppColors.lightText.withOpacity(0.5),
                                fontSize: 13),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero))),
                if (_searchController.text.isNotEmpty)
                  GestureDetector(
                      onTap: () => _searchController.clear(),
                      child: const Icon(Icons.close_rounded,
                          color: AppColors.grey, size: 18)),
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
        ]));
  }

  Widget _buildCard(Map<String, dynamic> offer, bool isDark) {
    final cardC = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
    final borderC = isDark
        ? AppColors.goldenBronze.withOpacity(0.6)
        : AppColors.goldenBronze;
    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OfferDetailsScreen(
                    offerData: offer["original_data"] ?? offer,
                    offerType: OfferDetailType.featured))),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
              color: cardC,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderC, width: 1.5),
              boxShadow: [
                BoxShadow(
                    color:
                        AppColors.goldenBronze.withOpacity(isDark ? 0.1 : 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 5))
              ]),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: Row(children: [
                SizedBox(
                    width: 130,
                    height: 140,
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
                                        fontWeight: FontWeight.bold)))),
                      Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                  color: AppColors.goldenBronze,
                                  borderRadius: BorderRadius.circular(6)),
                              child: const Text("مميز ⭐",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold)))),
                    ])),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(children: [
                              Container(
                                  padding: const EdgeInsets.all(1.5),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.goldenBronze
                                              .withOpacity(0.5))),
                                  child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor:
                                          AppColors.lightBackground,
                                      backgroundImage:
                                          NetworkImage(offer["storeLogo"]))),
                              const SizedBox(width: 6),
                              Expanded(
                                  child: Text(offer["storeName"],
                                      style: const TextStyle(
                                          color: AppColors.goldenBronze,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis)),
                            ]),
                            const SizedBox(height: 8),
                            Text(offer["title"],
                                style: TextStyle(
                                    color: isDark
                                        ? AppColors.pureWhite
                                        : AppColors.lightText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    height: 1.3),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 10),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                  decoration: TextDecoration
                                                      .lineThrough)),
                                      ]),
                                  OfferActionButtons(
                                    isDarkMode: isDark,
                                    offerId: offer["id"].toString(),
                                  ),
                                ]),
                          ],
                        ))),
              ])),
        ));
  }
}
