// import 'package:flutter/material.dart';
// import '../theme/app_colors.dart';
// import 'offer_action_buttons.dart';
// import '../../presentation/screens/details/offer_details_screen.dart';
// import '../../presentation/screens/details/merchant_profile_screen.dart';

// class PremiumStandardOffersSection extends StatelessWidget {
//   final bool isDarkMode;
//   final VoidCallback? onSeeAllTap;

//   const PremiumStandardOffersSection(
//       {super.key, required this.isDarkMode, this.onSeeAllTap});

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> standardOffers = [
//       {
//         "title": "سماعة ابل ايربودز برو",
//         "storeName": "اكسترا",
//         "storeLogo": "https://i.pravatar.cc/150?img=11",
//         "image":
//             "https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?auto=format&fit=crop&w=500&q=80",
//         "price": "199\$",
//         "oldPrice": "250\$",
//       },
//       {
//         "title": "ماكينة قهوة ديلونجي",
//         "storeName": "ساكو",
//         "storeLogo": "https://i.pravatar.cc/150?img=12",
//         "image":
//             "https://images.unsplash.com/photo-1517068865886-443faf53e4fb?auto=format&fit=crop&w=500&q=80",
//         "price": "299\$",
//         "oldPrice": "350\$",
//       },
//       {
//         "title": "تيشيرت بولو كلاسيك",
//         "storeName": "سنتربوينت",
//         "storeLogo": "https://i.pravatar.cc/150?img=13",
//         "image":
//             "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=500&q=80",
//         "price": "25\$",
//         "oldPrice": "40\$",
//       },
//       {
//         "title": "طقم عطور شرقية",
//         "storeName": "العربية للعود",
//         "storeLogo": "https://i.pravatar.cc/150?img=14",
//         "image":
//             "https://images.unsplash.com/photo-1594035910387-fea47794261f?auto=format&fit=crop&w=500&q=80",
//         "price": "85\$",
//         "oldPrice": "120\$",
//       },
//     ];

//     final Color textColor =
//         isDarkMode ? AppColors.pureWhite : AppColors.lightText;

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(children: [
//                   Text("العروض",
//                       style: TextStyle(
//                           color: textColor,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold)),
//                 ]),
//                 GestureDetector(
//                   onTap: onSeeAllTap,
//                   child: const Row(children: [
//                     Text("عرض الكل",
//                         style: TextStyle(
//                             color: AppColors.goldenBronze,
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600)),
//                     SizedBox(width: 4),
//                     Icon(Icons.arrow_back_ios_new_rounded,
//                         color: AppColors.goldenBronze, size: 12),
//                   ]),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 270,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               physics: const BouncingScrollPhysics(),
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
//               itemCount: standardOffers.length,
//               itemBuilder: (context, index) {
//                 return _buildStandardCard(context, standardOffers[index]);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStandardCard(BuildContext context, Map<String, dynamic> offer) {
//     final Color cardColor =
//         isDarkMode ? AppColors.deepNavy : AppColors.pureWhite;
//     final Color borderColor =
//         isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade200;

//     return GestureDetector(
//         onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) => OfferDetailsScreen(
//                     offerData: offer, offerType: OfferDetailType.standard))),
//         child: Container(
//           width: 160,
//           margin: const EdgeInsets.only(left: 15, bottom: 10),
//           decoration: BoxDecoration(
//             color: cardColor,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: borderColor, width: 1.0),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4))
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       Image.network(offer["image"], fit: BoxFit.cover),
//                       Positioned(
//                         top: 8,
//                         right: 8,
//                         child: Container(
//                           padding: const EdgeInsets.all(2),
//                           decoration: BoxDecoration(
//                             color:
//                                 isDarkMode ? AppColors.deepNavy : Colors.white,
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                   color: Colors.black.withOpacity(0.15),
//                                   blurRadius: 4)
//                             ],
//                           ),
//                           child: GestureDetector(
//                             onTap: () => Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (_) => MerchantProfileScreen(
//                                         storeName: offer["storeName"] ?? "متجر",
//                                         storeLogo: offer["storeLogo"] ??
//                                             "https://i.pravatar.cc/150?img=11"))),
//                             child: CircleAvatar(
//                                 radius: 12,
//                                 backgroundColor: AppColors.lightBackground,
//                                 backgroundImage:
//                                     NetworkImage(offer["storeLogo"])),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       GestureDetector(
//                         onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => MerchantProfileScreen(
//                                     storeName: offer["storeName"] ?? "متجر",
//                                     storeLogo: offer["storeLogo"] ??
//                                         "https://i.pravatar.cc/150?img=11"))),
//                         child: Text(offer["storeName"],
//                             style: const TextStyle(
//                                 color: AppColors.goldenBronze,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.bold),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(offer["title"],
//                           style: TextStyle(
//                               color: isDarkMode
//                                   ? AppColors.pureWhite
//                                   : AppColors.lightText,
//                               fontSize: 13,
//                               fontWeight: FontWeight.w800),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis),
//                       const SizedBox(height: 6),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(offer["price"],
//                                       style: const TextStyle(
//                                           color: AppColors.goldenBronze,
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w900)),
//                                   Text(offer["oldPrice"],
//                                       style: const TextStyle(
//                                           color: AppColors.grey,
//                                           fontSize: 10,
//                                           decoration:
//                                               TextDecoration.lineThrough)),
//                                 ]),
//                           ),
//                           OfferActionButtons(
//                               isDarkMode: isDarkMode,
//                               offerId: "STD_${offer["title"]}",
//                               initialIsLiked: false,
//                               initialIsFavorited: false),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }

import 'package:flutter/material.dart';
import '../network/api_service.dart';
import '../network/api_constants.dart';
import '../theme/app_colors.dart';
import 'offer_action_buttons.dart';
import '../../presentation/screens/details/offer_details_screen.dart';
import '../../presentation/screens/details/merchant_profile_screen.dart';

// 1. تحويل الكلاس إلى StatefulWidget
class PremiumStandardOffersSection extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onSeeAllTap;

  const PremiumStandardOffersSection({
    super.key,
    required this.isDarkMode,
    this.onSeeAllTap,
  });

  @override
  State<PremiumStandardOffersSection> createState() =>
      _PremiumStandardOffersSectionState();
}

class _PremiumStandardOffersSectionState
    extends State<PremiumStandardOffersSection> {
  // 2. متغيرات الحالة
  List<Map<String, dynamic>> _offers = [];
  bool _isLoading = true;
  final ApiService _api = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchOffers(); // جلب العروض فور بناء القسم
  }

  // جلب العروض عبر ApiService
  Future<void> _fetchOffers() async {
    try {
      final data = await _api.get(
        ApiConstants.products,
        queryParams: {'page_size': '10'},
        requiresAuth: false,
      );

      final List rawOffers =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);

      if (mounted) {
        setState(() {
          _offers = rawOffers.map<Map<String, dynamic>>((apiOffer) {
            var images = apiOffer['images'] as List?;
            String imageUrl = (images != null && images.isNotEmpty)
                ? ApiConstants.resolveImageUrl(
                    images[0]['image_url']?.toString())
                : ApiConstants.resolveImageUrl(null);

            // صورة المنتج المباشرة (بعض APIs ترسلها كحقل مباشر)
            if (images == null || images.isEmpty) {
              imageUrl = ApiConstants.resolveImageUrl(
                apiOffer['image']?.toString() ??
                    apiOffer['thumbnail']?.toString(),
              );
            }

            String storeName = apiOffer['store_name'] ?? 'متجر غير معروف';
            String storeLogo =
                'https://ui-avatars.com/api/?name=${Uri.encodeComponent(storeName)}&background=random&color=fff';

            return {
              "id": (apiOffer['product_id'] ?? apiOffer['id'] ?? '').toString(),
              "title": apiOffer['title'] ?? 'بدون عنوان',
              "storeName": storeName,
              "storeLogo": storeLogo,
              "image": imageUrl,
              "price": "${apiOffer['price'] ?? '0'}\$",
              "oldPrice": apiOffer['old_price'] != null
                  ? "${apiOffer['old_price']}\$"
                  : "",
              "is_liked": apiOffer['is_liked'] ?? false,
              "is_favorited": apiOffer['is_favorited'] ?? false,
            };
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('خطأ في جلب العروض: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        widget.isDarkMode ? AppColors.pureWhite : AppColors.lightText;

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
                Row(children: [
                  Text("أحدث العروض",
                      style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ]),
                GestureDetector(
                  onTap: widget.onSeeAllTap,
                  child: const Row(children: [
                    Text("عرض الكل",
                        style: TextStyle(
                            color: AppColors.goldenBronze,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.goldenBronze, size: 12),
                  ]),
                ),
              ],
            ),
          ),

          // 5. بناء واجهة التحميل أو قائمة العروض
          SizedBox(
            height: 270,
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.goldenBronze))
                : _offers.isEmpty
                    ? Center(
                        child: Text("لا توجد عروض حالياً",
                            style: TextStyle(color: textColor)))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        itemCount: _offers.length,
                        itemBuilder: (context, index) {
                          return _buildStandardCard(context, _offers[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardCard(BuildContext context, Map<String, dynamic> offer) {
    final Color cardColor =
        widget.isDarkMode ? AppColors.deepNavy : AppColors.pureWhite;
    final Color borderColor = widget.isDarkMode
        ? Colors.white.withOpacity(0.05)
        : Colors.grey.shade200;

    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OfferDetailsScreen(
                    offerData: offer, offerType: OfferDetailType.standard))),
        child: Container(
          width: 160,
          margin: const EdgeInsets.only(left: 15, bottom: 10),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.0),
            boxShadow: [
              BoxShadow(
                  color:
                      Colors.black.withOpacity(widget.isDarkMode ? 0.2 : 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4))
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // استخدمنا NetworkImage مع معالجة خطأ تحميل الصورة (ErrorBuilder)
                      Image.network(
                        offer["image"],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image_not_supported,
                                color: Colors.grey)),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: widget.isDarkMode
                                ? AppColors.deepNavy
                                : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 4)
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MerchantProfileScreen(
                                        storeName: offer["storeName"],
                                        storeLogo: offer["storeLogo"]))),
                            child: CircleAvatar(
                                radius: 12,
                                backgroundColor: AppColors.lightBackground,
                                backgroundImage:
                                    NetworkImage(offer["storeLogo"])),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
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
                        child: Text(offer["storeName"],
                            style: const TextStyle(
                                color: AppColors.goldenBronze,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(height: 2),
                      Text(offer["title"],
                          style: TextStyle(
                              color: widget.isDarkMode
                                  ? AppColors.pureWhite
                                  : AppColors.lightText,
                              fontSize: 13,
                              fontWeight: FontWeight.w800),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(offer["price"],
                                      style: const TextStyle(
                                          color: AppColors.goldenBronze,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900)),
                                  // إخفاء السعر القديم إذا كان فارغاً
                                  if (offer["oldPrice"].isNotEmpty)
                                    Text(offer["oldPrice"],
                                        style: const TextStyle(
                                            color: AppColors.grey,
                                            fontSize: 10,
                                            decoration:
                                                TextDecoration.lineThrough)),
                                ]),
                          ),
                          // تمرير الـ ID الحقيقي لأزرار التفاعل والإعجاب
                          OfferActionButtons(
                              isDarkMode: widget.isDarkMode,
                              offerId: offer["id"]),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
