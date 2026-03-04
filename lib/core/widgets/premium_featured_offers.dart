import 'package:flutter/material.dart';
import '../network/api_service.dart';
import '../network/api_constants.dart';
import '../theme/app_colors.dart';
import 'offer_action_buttons.dart';
import '../../presentation/screens/details/merchant_profile_screen.dart';
import '../../presentation/screens/details/offer_details_screen.dart';

// ============================================================================
// العروض المميزة — تجلب من API
// ============================================================================
class PremiumFeaturedOffersSection extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onSeeAllTap;

  const PremiumFeaturedOffersSection(
      {super.key, required this.isDarkMode, this.onSeeAllTap});

  @override
  State<PremiumFeaturedOffersSection> createState() =>
      _PremiumFeaturedOffersSectionState();
}

class _PremiumFeaturedOffersSectionState
    extends State<PremiumFeaturedOffersSection> {
  final ApiService _api = ApiService();
  List<Map<String, dynamic>> _offers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFeaturedOffers();
  }

  Future<void> _fetchFeaturedOffers() async {
    try {
      final data = await _api.get(
        ApiConstants.products,
        queryParams: {'is_featured': 'true', 'page_size': '6'},
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
                : ApiConstants.resolveImageUrl(apiOffer['image']?.toString() ??
                    apiOffer['thumbnail']?.toString());

            String storeName = apiOffer['store_name'] ?? 'متجر غير معروف';
            String storeLogo = apiOffer['store_logo'] != null
                ? ApiConstants.resolveImageUrl(
                    apiOffer['store_logo'].toString())
                : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(storeName)}&background=B8860B&color=fff';

            return {
              "id": apiOffer['product_id']?.toString() ?? "",
              "title": apiOffer['title'] ?? 'بدون عنوان',
              "storeName": storeName,
              "storeLogo": storeLogo,
              "storeId": apiOffer['store']?.toString() ?? "",
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
      debugPrint('خطأ في جلب العروض المميزة: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        widget.isDarkMode ? AppColors.pureWhite : AppColors.lightText;

    // إذا كانت العروض فارغة ولا تحميل → لا نعرض القسم
    if (!_isLoading && _offers.isEmpty) return const SizedBox.shrink();

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
                  Text("عروض مميزة ⭐️",
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
          SizedBox(
            height: 270,
            child: _isLoading
                ? _buildLoadingShimmer()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    itemCount: _offers.length,
                    itemBuilder: (context, index) {
                      return _buildFeaturedCard(context, _offers[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    final Color cardColor =
        widget.isDarkMode ? AppColors.deepNavy : AppColors.pureWhite;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      itemCount: 3,
      itemBuilder: (_, __) => Container(
        width: 160,
        margin: const EdgeInsets.only(left: 15, bottom: 10),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppColors.goldenBronze.withOpacity(0.2), width: 1),
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, Map<String, dynamic> offer) {
    final Color cardColor =
        widget.isDarkMode ? AppColors.deepNavy : AppColors.pureWhite;
    final Color borderColor = widget.isDarkMode
        ? AppColors.goldenBronze.withOpacity(0.8)
        : AppColors.goldenBronze;

    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OfferDetailsScreen(
                    offerData: offer, offerType: OfferDetailType.featured))),
        child: Container(
          width: 160,
          margin: const EdgeInsets.only(left: 15, bottom: 10),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                  color: AppColors.goldenBronze
                      .withOpacity(widget.isDarkMode ? 0.15 : 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4)),
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
                      Image.network(offer["image"],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                              color: AppColors.lightBackground,
                              child: const Icon(Icons.image_not_supported,
                                  color: AppColors.grey))),
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
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4)
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MerchantProfileScreen(
                                        storeName: offer["storeName"] ?? "متجر",
                                        storeLogo: offer["storeLogo"] ??
                                            "https://i.pravatar.cc/150?img=11"))),
                            child: CircleAvatar(
                                radius: 12,
                                backgroundColor: AppColors.lightBackground,
                                backgroundImage:
                                    NetworkImage(offer["storeLogo"])),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                              color: AppColors.goldenBronze,
                              borderRadius: BorderRadius.circular(6)),
                          child: const Text("مميز",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold)),
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
                                    storeName: offer["storeName"] ?? "متجر",
                                    storeLogo: offer["storeLogo"] ??
                                        "https://i.pravatar.cc/150?img=11"))),
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
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(offer["price"],
                                    style: const TextStyle(
                                        color: AppColors.goldenBronze,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900)),
                                if (offer["oldPrice"]?.isNotEmpty ?? false)
                                  Text(offer["oldPrice"],
                                      style: const TextStyle(
                                          color: AppColors.grey,
                                          fontSize: 10,
                                          decoration:
                                              TextDecoration.lineThrough)),
                              ]),
                          OfferActionButtons(
                              isDarkMode: widget.isDarkMode,
                              offerId: offer["id"] ?? "FEAT_${offer["title"]}",
                              initialIsLiked: offer["is_liked"] ?? false,
                              initialIsFavorited:
                                  offer["is_favorited"] ?? false),
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
