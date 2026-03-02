import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'offer_action_buttons.dart';
import '../../presentation/screens/details/merchant_profile_screen.dart';
import '../../presentation/screens/details/offer_details_screen.dart';

class PremiumFeaturedOffersSection extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback? onSeeAllTap;

  const PremiumFeaturedOffersSection(
      {super.key, required this.isDarkMode, this.onSeeAllTap});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> featuredOffers = [
      {
        "title": "ساعة رولكس ديتونا",
        "storeName": "مجوهرات الفخامة",
        "storeLogo": "https://i.pravatar.cc/150?img=11",
        "image":
            "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=500&q=80",
        "price": "12,500\$",
        "oldPrice": "15,000\$",
      },
      {
        "title": "حذاء رياضي نايك اير",
        "storeName": "نايك ستور",
        "storeLogo": "https://i.pravatar.cc/150?img=33",
        "image":
            "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=500&q=80",
        "price": "120\$",
        "oldPrice": "180\$",
      },
      {
        "title": "عطر شانيل بلو",
        "storeName": "وجوه للعطور",
        "storeLogo": "https://i.pravatar.cc/150?img=44",
        "image":
            "https://images.unsplash.com/photo-1528701800487-ad01fc8b1828?auto=format&fit=crop&w=500&q=80",
        "price": "150\$",
        "oldPrice": "200\$",
      },
      {
        "title": "نظارة ريبان أصلية",
        "storeName": "مغربي للبصريات",
        "storeLogo": "https://i.pravatar.cc/150?img=12",
        "image":
            "https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&w=500&q=80",
        "price": "95\$",
        "oldPrice": "130\$",
      },
    ];

    final Color textColor =
        isDarkMode ? AppColors.pureWhite : AppColors.lightText;

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
                  onTap: onSeeAllTap,
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
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              itemCount: featuredOffers.length,
              itemBuilder: (context, index) {
                return _buildFeaturedCard(context, featuredOffers[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, Map<String, dynamic> offer) {
    final Color cardColor =
        isDarkMode ? AppColors.deepNavy : AppColors.pureWhite;
    final Color borderColor = isDarkMode
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
                      .withOpacity(isDarkMode ? 0.15 : 0.2),
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
                      Image.network(offer["image"], fit: BoxFit.cover),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color:
                                isDarkMode ? AppColors.deepNavy : Colors.white,
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
                              color: isDarkMode
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
                                Text(offer["oldPrice"],
                                    style: const TextStyle(
                                        color: AppColors.grey,
                                        fontSize: 10,
                                        decoration:
                                            TextDecoration.lineThrough)),
                              ]),
                          OfferActionButtons(
                              isDarkMode: isDarkMode,
                              offerId: "FEAT_${offer["title"]}",
                              initialIsLiked: false,
                              initialIsFavorited: false),
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
