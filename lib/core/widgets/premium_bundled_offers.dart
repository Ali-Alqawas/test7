import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'offer_action_buttons.dart';
import '../../presentation/screens/details/merchant_profile_screen.dart';
import '../../presentation/screens/details/offer_details_screen.dart';

class PremiumBundledOffersSection extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback? onSeeAllTap;

  const PremiumBundledOffersSection(
      {super.key, required this.isDarkMode, this.onSeeAllTap});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> bundles = [
      {
        "title": "باقة التوفير العملاقة",
        "store": "هايبر بنده",
        "storeLogo": "https://i.pravatar.cc/150?img=50",
        "price": "199\$",
        "oldPrice": "350\$",
        "saving": "وفر 151\$",
        "images": [
          "assets/images/1.jpeg",
          "assets/images/2.jpeg",
          "assets/images/3.jpeg",
          "assets/images/4.jpeg",
          "assets/images/5.jpeg",
        ],
        "isLocalImage": true,
      },
      {
        "title": "مجموعة الجمال",
        "store": "سيفورا",
        "storeLogo": "https://i.pravatar.cc/150?img=44",
        "price": "120\$",
        "oldPrice": "180\$",
        "saving": "وفر 60\$",
        "images": [
          "assets/images/6.jpeg",
          "assets/images/7.jpeg",
          "assets/images/1.jpeg",
        ],
        "isLocalImage": true,
      },
      {
        "title": "ثنائي الأجهزة",
        "store": "اكسترا",
        "storeLogo": "https://i.pravatar.cc/150?img=11",
        "price": "999\$",
        "oldPrice": "1200\$",
        "saving": "وفر 200\$",
        "images": [
          "assets/images/2.jpeg",
          "assets/images/3.jpeg",
        ],
        "isLocalImage": true,
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
                Text("باقات التوفير 🎁",
                    style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
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
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              itemCount: bundles.length,
              itemBuilder: (context, index) {
                return _buildBundleCard(context, bundles[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBundleCard(BuildContext context, Map<String, dynamic> bundle) {
    final Color cardBg = isDarkMode ? AppColors.deepNavy : AppColors.pureWhite;
    final Color borderColor = isDarkMode
        ? AppColors.goldenBronze.withOpacity(0.3)
        : Colors.grey.shade200;
    final bool isLocal = bundle["isLocalImage"] ?? false;

    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OfferDetailsScreen(
                    offerData: bundle, offerType: OfferDetailType.bundled))),
        child: Container(
          width: 330,
          height: 160,
          margin: const EdgeInsets.only(left: 15, bottom: 8),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              if (!isDarkMode)
                BoxShadow(
                    color: AppColors.goldenBronze.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 5)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 155,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  child: _buildRobustDynamicCollage(
                    bundle["images"] as List<String>,
                    isDarkMode ? AppColors.deepNavy : Colors.white,
                    isLocal,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4)),
                        child: Text(bundle["saving"],
                            style: const TextStyle(
                                color: AppColors.error,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 6),
                      Text(bundle["title"],
                          style: TextStyle(
                              color: isDarkMode
                                  ? AppColors.pureWhite
                                  : AppColors.lightText,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              height: 1.2),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      Row(children: [
                        Container(
                            padding: const EdgeInsets.all(1.5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: borderColor)),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => MerchantProfileScreen(
                                          storeName: bundle["store"] ?? "متجر",
                                          storeLogo: bundle["storeLogo"] ??
                                              "https://i.pravatar.cc/150?img=11"))),
                              child: CircleAvatar(
                                  radius: 9,
                                  backgroundColor: AppColors.lightBackground,
                                  backgroundImage:
                                      NetworkImage(bundle["storeLogo"])),
                            )),
                        const SizedBox(width: 4),
                        Expanded(
                            child: GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MerchantProfileScreen(
                                      storeName: bundle["store"] ?? "متجر",
                                      storeLogo: bundle["storeLogo"] ??
                                          "https://i.pravatar.cc/150?img=11"))),
                          child: Text(bundle["store"],
                              style: const TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        )),
                      ]),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(bundle["price"],
                                    style: const TextStyle(
                                        color: AppColors.goldenBronze,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900)),
                                Text(bundle["oldPrice"],
                                    style: const TextStyle(
                                        color: AppColors.grey,
                                        fontSize: 10,
                                        decoration:
                                            TextDecoration.lineThrough)),
                              ]),
                          OfferActionButtons(
                              isDarkMode: isDarkMode, offerId: "BUNDLE_XXX"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildRobustDynamicCollage(
      List<String> images, Color separatorColor, bool isLocal) {
    int count = images.length;

    Widget imageBox(String path) {
      ImageProvider imgProvider =
          isLocal ? AssetImage(path) : NetworkImage(path) as ImageProvider;
      return Container(
        foregroundDecoration: BoxDecoration(
            border: Border.all(color: separatorColor, width: 0.5)),
        child: Image(
            image: imgProvider,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (ctx, _, __) => Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.broken_image, color: Colors.grey))),
      );
    }

    if (count == 1) {
      return imageBox(images[0]);
    } else if (count == 2) {
      return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(child: imageBox(images[0])),
        Expanded(child: imageBox(images[1]))
      ]);
    } else if (count == 3) {
      return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(flex: 3, child: imageBox(images[0])),
        Expanded(
            flex: 2,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: imageBox(images[1])),
                  Expanded(child: imageBox(images[2]))
                ])),
      ]);
    } else {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              Expanded(child: imageBox(images[0])),
              Expanded(child: imageBox(images[1]))
            ])),
        Expanded(
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(child: imageBox(images[2])),
          Expanded(
              child: Stack(fit: StackFit.expand, children: [
            imageBox(images[3]),
            if (count > 4)
              Container(
                  color: Colors.black.withOpacity(0.6),
                  child: Center(
                      child: Text("+${count - 4}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)))),
          ])),
        ])),
      ]);
    }
  }
}
