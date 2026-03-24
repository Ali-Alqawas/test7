import 'package:flutter/material.dart';
import '../network/api_service.dart';
import '../network/api_constants.dart';
import '../theme/app_colors.dart';
import 'offer_action_buttons.dart';
import '../../presentation/screens/details/merchant_profile_screen.dart';
import '../../presentation/screens/details/offer_details_screen.dart';

// ============================================================================
// باقات التوفير — تجلب من API
// ============================================================================
class PremiumBundledOffersSection extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onSeeAllTap;
  final String? storeId;

  const PremiumBundledOffersSection(
      {super.key, required this.isDarkMode, this.onSeeAllTap, this.storeId});

  @override
  State<PremiumBundledOffersSection> createState() =>
      _PremiumBundledOffersSectionState();
}

class _PremiumBundledOffersSectionState
    extends State<PremiumBundledOffersSection> {
  final ApiService _api = ApiService();
  List<Map<String, dynamic>> _bundles = [];
  bool _isLoading = true;

  // بيانات احتياطية
  static final List<Map<String, dynamic>> _fallbackBundles = [
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

  @override
  void initState() {
    super.initState();
    _fetchBundles();
  }

  Future<void> _fetchBundles() async {
    try {
      final params = <String, String>{'type': 'bundle', 'page_size': '6'};
      if (widget.storeId != null) params['store'] = widget.storeId!;
      final data = await _api.get(
        ApiConstants.productGroups,
        queryParams: params,
        requiresAuth: false,
      );

      final List rawBundles =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);

      if (rawBundles.isNotEmpty && mounted) {
        setState(() {
          _bundles = rawBundles.map<Map<String, dynamic>>((b) {
            // 1. استخراج اسم المتجر بقوة أكبر
            String storeName = b['store_name']?.toString().trim() ?? '';
            if (storeName.isEmpty &&
                b['products'] != null &&
                (b['products'] as List).isNotEmpty) {
              storeName =
                  b['products'][0]['store_name']?.toString().trim() ?? 'متجر';
            }
            if (storeName.isEmpty || storeName == 'null') storeName = 'متجر';

            // 2. سعر الباقة المعروض للعميل
            double bundlePrice =
                double.tryParse(b['price']?.toString() ?? '0') ?? 0;
            double sumOfIndividualPrices = 0;
            // 2. جمع صور المنتجات + حساب المجموع الفردي
            List<String> images = [];

            // الباك اند يرجع items (كل item يحتوي product nested)
            // نحوّلها لقائمة products مسطّحة
            List<dynamic> products = [];
            if (b['items'] is List) {
              for (var item in b['items']) {
                if (item['product'] is Map) products.add(item['product']);
              }
            } else if (b['products'] is List) {
              products = b['products'] as List;
            }

            if (products.isNotEmpty) {
              for (var p in products) {
                // 💡 السر هنا: نجمع سعر كل منتج
                double pPrice = double.tryParse(p['new_price']?.toString() ??
                        p['price']?.toString() ??
                        '0') ??
                    0;
                sumOfIndividualPrices += pPrice;

                if (p['images'] is List && (p['images'] as List).isNotEmpty) {
                  images.add(ApiConstants.resolveImageUrl(
                      p['images'][0]['image_url']?.toString()));
                } else if (p['image_url'] != null) {
                  images.add(
                      ApiConstants.resolveImageUrl(p['image_url'].toString()));
                } else if (p['image'] != null) {
                  images
                      .add(ApiConstants.resolveImageUrl(p['image'].toString()));
                }
              }
            }
            if (images.isEmpty && b['image'] != null) {
              images.add(ApiConstants.resolveImageUrl(b['image'].toString()));
            }
            if (images.isEmpty) {
              images.add('https://placehold.co/400x400/png?text=No+Image');
            }

            // 3. الحساب الديناميكي للتوفير
            double saving = 0;
            double displayOldPrice = 0;

            // إذا كان المجموع الفردي أكبر من سعر الباقة، هذا توفير حقيقي
            if (sumOfIndividualPrices > bundlePrice && bundlePrice > 0) {
              saving = sumOfIndividualPrices - bundlePrice;
              displayOldPrice = sumOfIndividualPrices;
            } else {
              // خطة بديلة من الباك إند
              double explicitOldPrice =
                  double.tryParse(b['old_price']?.toString() ?? '0') ?? 0;
              if (explicitOldPrice > bundlePrice) {
                saving = explicitOldPrice - bundlePrice;
                displayOldPrice = explicitOldPrice;
              }
            }

            return {
              // المعرف الحقيقي للمجموعة
              "id": (b['group_id'] ?? b['id'] ?? '').toString(),

              // الباك إند يرسل الاسم باسم name وليس title
              "title":
                  b['name']?.toString() ?? b['title']?.toString() ?? 'باقة',
              "store": storeName, // تركناها لكي لا يتأثر تصميمك القديم
              "storeName": storeName, // أضفناها لكي تعمل شاشة التفاصيل بامتياز
              "storeLogo": (b['logo'] ?? b['store_logo']) != null
                  ? ApiConstants.resolveImageUrl(
                      (b['logo'] ?? b['store_logo']).toString())
                  : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(storeName)}&background=B8860B&color=fff',
              "storeId": (b["store"] ?? b["store_id"] ?? "").toString(),
              // عرض الأسعار بعد الحساب الديناميكي
              // تم إزالة الأصفار العشرية هنا
              "price": bundlePrice > 0 ? "${bundlePrice.toInt()}\$" : "0\$",
              "oldPrice":
                  displayOldPrice > 0 ? "${displayOldPrice.toInt()}\$" : "",
              "saving": saving > 0 ? "وفر ${saving.toInt()}\$" : "",
              "images": images,
              "isLocalImage": false,
              "original_data":
                  b, // 🛡️ حماية من الشاشة الحمراء عند الدخول للتفاصيل
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        if (mounted) {
          setState(() {
            _bundles = List.from(_fallbackBundles);
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('خطأ في جلب الباقات الرئيسية: $e');
      if (mounted) {
        setState(() {
          _bundles = List.from(_fallbackBundles);
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        widget.isDarkMode ? AppColors.pureWhite : AppColors.lightText;

    if (!_isLoading && _bundles.isEmpty) return const SizedBox.shrink();

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
            height: 160,
            child: _isLoading
                ? _buildLoadingShimmer()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    itemCount: _bundles.length,
                    itemBuilder: (context, index) {
                      return _buildBundleCard(context, _bundles[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    final Color cardBg =
        widget.isDarkMode ? AppColors.deepNavy : AppColors.pureWhite;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      itemCount: 2,
      itemBuilder: (_, __) => Container(
        width: 330,
        height: 160,
        margin: const EdgeInsets.only(left: 15, bottom: 8),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildBundleCard(BuildContext context, Map<String, dynamic> bundle) {
    final Color cardBg =
        widget.isDarkMode ? AppColors.deepNavy : AppColors.pureWhite;
    final Color borderColor = widget.isDarkMode
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
              if (!widget.isDarkMode)
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
                    (bundle["images"] as List).cast<String>(),
                    widget.isDarkMode ? AppColors.deepNavy : Colors.white,
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
                      if ((bundle["saving"] ?? '').isNotEmpty)
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
                              color: widget.isDarkMode
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
                                          storeId: (bundle["storeId"] ?? '')
                                              .toString(),
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
                                      storeId:
                                          (bundle["storeId"] ?? '').toString(),
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
                                if ((bundle["oldPrice"] ?? '').isNotEmpty)
                                  Text(bundle["oldPrice"],
                                      style: const TextStyle(
                                          color: AppColors.grey,
                                          fontSize: 10,
                                          decoration:
                                              TextDecoration.lineThrough)),
                              ]),
                          OfferActionButtons(
                              isDarkMode: widget.isDarkMode,
                              offerId: (bundle["id"] ?? "").toString(),
                              isGroup: true),
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
