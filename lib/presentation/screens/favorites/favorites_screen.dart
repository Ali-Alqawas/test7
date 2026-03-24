import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/network/api_service.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../core/widgets/offer_action_buttons.dart';
import '../../../data/providers/social_provider.dart';
import '../details/offer_details_screen.dart';
import '../details/merchant_profile_screen.dart';

// ============================================================================
// شاشة المفضلة — تجلب من API
// ============================================================================
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ApiService _api = ApiService();
  List<Map<String, dynamic>> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    try {
      List<Map<String, dynamic>> items = [];

      // ── 1. جلب المفضلة (منتجات فردية) ──
      final data = await _api.get(ApiConstants.favorites);
      final List rawFavorites =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);

      for (var item in rawFavorites) {
        final productField = item['product'];
        final productMap = await _fetchProductDetails(productField);
        final String productId = (productField is int || productField is String)
            ? productField.toString()
            : (productMap?['product_id']?.toString() ??
                productMap?['id']?.toString() ??
                '');

        items.add(_buildFavItem(productId, productMap, isGroup: false));
      }

      // ── 2. جلب المفضلة (مجموعات / باقات) ──
      try {
        final groupData = await _api.get('/social/group-favorites/');
        final List rawGroupFavs = groupData is Map
            ? (groupData['results'] ?? [])
            : (groupData is List ? groupData : []);

        if (rawGroupFavs.isNotEmpty) {
          // جلب كل المجموعات دفعة واحدة (لا يوجد detail endpoint)
          Map<String, Map<String, dynamic>> allGroups = {};
          try {
            final allGroupsData = await _api.get(
              ApiConstants.productGroups,
              queryParams: {'page_size': '100'},
              requiresAuth: false,
            );
            final List groupsList = allGroupsData is Map
                ? (allGroupsData['results'] ?? [])
                : (allGroupsData is List ? allGroupsData : []);
            for (var g in groupsList) {
              final gId = (g['group_id'] ?? g['id'] ?? '').toString();
              if (gId.isNotEmpty) allGroups[gId] = Map<String, dynamic>.from(g);
            }
          } catch (e) {
            debugPrint('⚠️ فشل جلب قائمة المجموعات: $e');
          }

          for (var item in rawGroupFavs) {
            final groupField = item['product_group'];
            String groupId = (groupField ?? '').toString();
            final b = allGroups[groupId]; // b = بيانات المجموعة الكاملة

            if (b == null) {
              // إذا ما لقينا المجموعة → نتخطاها
              continue;
            }

            // ── نفس منطق premium_bundled_offers.dart بالضبط ──

            // 1. اسم المتجر
            String storeName = b['store_name']?.toString().trim() ?? '';
            if (storeName.isEmpty &&
                b['products'] is List &&
                (b['products'] as List).isNotEmpty) {
              storeName =
                  b['products'][0]['store_name']?.toString().trim() ?? 'متجر';
            }
            if (storeName.isEmpty || storeName == 'null') storeName = 'متجر';

            // 2. السعر والصور
            double bundlePrice =
                double.tryParse(b['price']?.toString() ?? '0') ?? 0;
            double sumOfIndividualPrices = 0;
            List<String> images = [];
            if (b['products'] is List) {
              for (var p in b['products']) {
                double pPrice =
                    double.tryParse(p['price']?.toString() ?? '0') ?? 0;
                sumOfIndividualPrices += pPrice;
                if (p['images'] is List && (p['images'] as List).isNotEmpty) {
                  images.add(ApiConstants.resolveImageUrl(
                      p['images'][0]['image_url']?.toString()));
                } else if (p['image'] != null) {
                  images
                      .add(ApiConstants.resolveImageUrl(p['image'].toString()));
                }
              }
            }
            // صورة المجموعة نفسها كبديل
            if (images.isEmpty && b['image_url'] != null) {
              images
                  .add(ApiConstants.resolveImageUrl(b['image_url'].toString()));
            }
            if (images.isEmpty)
              images.add('https://placehold.co/400x400/png?text=Bundle');

            // 3. حساب التوفير
            double displayOldPrice = 0;
            String discount = '';
            if (sumOfIndividualPrices > bundlePrice && bundlePrice > 0) {
              displayOldPrice = sumOfIndividualPrices;
              discount =
                  '${((displayOldPrice - bundlePrice) / displayOldPrice * 100).toStringAsFixed(0)}%';
            }

            String storeLogo = (b['logo'] ?? b['store_logo']) != null
                ? ApiConstants.resolveImageUrl(
                    (b['logo'] ?? b['store_logo']).toString())
                : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(storeName)}&background=B8860B&color=fff';

            items.add({
              "id": groupId,
              "title": '📦 ${b['name']?.toString() ?? 'باقة'}',
              "store": storeName,
              "storeName": storeName,
              "storeLogo": storeLogo,
              "image": images.first,
              "images": images,
              "isLocalImage": false,
              "price": bundlePrice > 0 ? "${bundlePrice.toInt()}\$" : "0\$",
              "oldPrice":
                  displayOldPrice > 0 ? "${displayOldPrice.toInt()}\$" : "",
              "saving": displayOldPrice > bundlePrice
                  ? "وفر ${(displayOldPrice - bundlePrice).toInt()}\$"
                  : "",
              "discount": discount,
              "products": b['products'] ?? [],
              "category": '',
              "offerType": 'bundled',
              "isGroup": true,
              "original_data": b,
            });
          }
        }
      } catch (e) {
        debugPrint('⚠️ خطأ في جلب مفضلة المجموعات: $e');
      }

      if (mounted) {
        setState(() {
          _favorites = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('خطأ في جلب المفضلة: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// جلب بيانات المنتج الكاملة
  Future<Map<String, dynamic>?> _fetchProductDetails(
      dynamic productField) async {
    if (productField is int || productField is String) {
      try {
        final productData = await _api.get('/catalog/products/$productField/',
            requiresAuth: false);
        if (productData != null && productData is Map) {
          return Map<String, dynamic>.from(productData);
        }
      } catch (e) {
        debugPrint('⚠️ فشل جلب المنتج $productField: $e');
      }
    } else if (productField is Map) {
      return Map<String, dynamic>.from(productField);
    }
    return null;
  }

  /// بناء عنصر مفضلة لمنتج فردي
  Map<String, dynamic> _buildFavItem(
      String productId, Map<String, dynamic>? product,
      {required bool isGroup}) {
    String imageUrl = '';
    String storeName = 'متجر';
    String storeLogo = '';
    String title = 'منتج #$productId';
    String priceStr = '0\$';
    String oldPriceStr = '';
    String discount = '';

    if (product != null) {
      var images = product['images'];
      if (images is List && images.isNotEmpty) {
        final firstImg = images[0];
        if (firstImg is Map) {
          imageUrl = ApiConstants.resolveImageUrl(
              firstImg['image_url']?.toString() ??
                  firstImg['image']?.toString());
        } else if (firstImg is String) {
          imageUrl = ApiConstants.resolveImageUrl(firstImg);
        }
      } else if (product['image'] != null) {
        imageUrl = ApiConstants.resolveImageUrl(product['image'].toString());
      }

      title = product['title']?.toString() ?? title;
      storeName = product['store_name']?.toString() ?? 'متجر';
      if (product['logo'] != null || product['store_logo'] != null) {
        storeLogo = ApiConstants.resolveImageUrl(
            (product['logo'] ?? product['store_logo']).toString());
      }

      double price = double.tryParse(product['new_price']?.toString() ??
              product['price']?.toString() ??
              '0') ??
          0;
      double oldPrice =
          double.tryParse(product['old_price']?.toString() ?? '0') ?? 0;
      priceStr = '${price.toStringAsFixed(price == price.toInt() ? 0 : 2)}\$';
      if (oldPrice > 0) {
        oldPriceStr =
            '${oldPrice.toStringAsFixed(oldPrice == oldPrice.toInt() ? 0 : 2)}\$';
      }
      if (oldPrice > price && oldPrice > 0) {
        discount =
            '${((oldPrice - price) / oldPrice * 100).toStringAsFixed(0)}%';
      }
    }

    if (storeLogo.isEmpty) {
      storeLogo =
          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(storeName)}&background=B8860B&color=fff';
    }
    if (imageUrl.isEmpty) {
      imageUrl = 'https://placehold.co/400x400/png?text=No+Image';
    }

    return {
      "id": productId,
      "title": title,
      "storeName": storeName,
      "storeLogo": storeLogo,
      "image": imageUrl,
      "price": priceStr,
      "oldPrice": oldPriceStr,
      "discount": discount,
      "category": product?['category_name']?.toString() ?? '',
      "offerType": product?['is_featured'] == true ? 'featured' : 'standard',
      "isGroup": isGroup,
    };
  }

  Future<void> _removeItem(int index) async {
    final item = _favorites[index];
    final itemId = item['id']?.toString() ?? '';
    final bool isGroup = item['isGroup'] == true;
    setState(() => _favorites.removeAt(index));

    if (itemId.isNotEmpty && mounted) {
      final social = context.read<SocialProvider>();
      final success = isGroup
          ? await social.toggleGroupFavorite(itemId)
          : await social.toggleFavorite(itemId);
      if (!success) {
        debugPrint('خطأ في إزالة المفضلة');
      }
    }
  }

  OfferDetailType _mapType(String type) {
    switch (type) {
      case 'featured':
        return OfferDetailType.featured;
      case 'bundled':
        return OfferDetailType.bundled;
      case 'brochure':
        return OfferDetailType.brochure;
      default:
        return OfferDetailType.standard;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor =
        isDarkMode ? AppColors.deepNavy : AppColors.lightBackground;
    final Color textColor =
        isDarkMode ? AppColors.pureWhite : AppColors.lightText;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isDarkMode, textColor),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.goldenBronze))
                    : _favorites.isEmpty
                        ? _buildEmptyState(isDarkMode)
                        : RefreshIndicator(
                            color: AppColors.goldenBronze,
                            onRefresh: _fetchFavorites,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              padding:
                                  const EdgeInsets.fromLTRB(16, 5, 16, 100),
                              itemCount: _favorites.length,
                              itemBuilder: (context, index) {
                                return _buildFavoriteCard(
                                    _favorites[index], isDarkMode, index);
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

  Widget _buildHeader(BuildContext context, bool isDarkMode, Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Row(
        children: [
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
          Text("المفضلة ❤️",
              style: TextStyle(
                  color: textColor, fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.error.withOpacity(0.3)),
            ),
            child: Text("${_favorites.length} عنصر",
                style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
          const Spacer(),
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

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border_rounded,
              color: AppColors.goldenBronze.withOpacity(0.3), size: 80),
          const SizedBox(height: 20),
          Text("لا توجد عناصر في المفضلة",
              style: TextStyle(
                  color: isDarkMode
                      ? AppColors.grey
                      : AppColors.lightText.withOpacity(0.5),
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text("أضف عروضك المفضلة للوصول إليها بسهولة",
              style: TextStyle(
                  color: isDarkMode
                      ? AppColors.grey.withOpacity(0.6)
                      : AppColors.lightText.withOpacity(0.3),
                  fontSize: 13)),
        ],
      ),
    );
  }

  // ── نفس _buildRobustDynamicCollage من premium_bundled_offers.dart بالضبط ──
  Widget _buildDynamicCollage(List<String> images, Color separatorColor) {
    int count = images.length;

    Widget imageBox(String path) {
      return Container(
        foregroundDecoration: BoxDecoration(
            border: Border.all(color: separatorColor, width: 0.5)),
        child: Image.network(path,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (_, __, ___) => Container(
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

  // ── كرت الباقة المفضلة — نفس premium_bundled_offers._buildBundleCard ──
  Widget _buildBundleFavoriteCard(
      Map<String, dynamic> bundle, bool isDarkMode, int index) {
    final Color cardBg = isDarkMode ? AppColors.deepNavy : AppColors.pureWhite;
    final Color borderColor = isDarkMode
        ? AppColors.goldenBronze.withOpacity(0.3)
        : Colors.grey.shade200;

    return Dismissible(
      key: Key("bundle_${bundle["id"]}_$index"),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 30),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
            SizedBox(height: 4),
            Text("حذف",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      onDismissed: (_) => _removeItem(index),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OfferDetailsScreen(
                    offerData: bundle, offerType: OfferDetailType.bundled))),
        child: Container(
          height: 160,
          margin: const EdgeInsets.only(bottom: 14),
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 155,
                  child: _buildDynamicCollage(
                    (bundle["images"] as List).cast<String>(),
                    isDarkMode ? AppColors.deepNavy : Colors.white,
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
                                            storeId: (bundle["storeId"] ??
                                                    bundle["store_id"] ??
                                                    "")
                                                .toString(),
                                            storeName:
                                                bundle["store"] ?? "متجر",
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
                              child: Text(
                                  bundle["store"] ??
                                      bundle["storeName"] ??
                                      "متجر",
                                  style: const TextStyle(
                                      color: AppColors.grey,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis)),
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
                                isDarkMode: isDarkMode,
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
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(
      Map<String, dynamic> item, bool isDarkMode, int index) {
    // ── باقة؟ → نفس كرت الرئيسية بالضبط ──
    if (item["isGroup"] == true) {
      return _buildBundleFavoriteCard(item, isDarkMode, index);
    }

    final Color cardC =
        isDarkMode ? const Color(0xFF072A38) : AppColors.pureWhite;
    final Color borderC = isDarkMode
        ? AppColors.goldenBronze.withOpacity(0.2)
        : Colors.grey.shade200;
    final bool isFeatured = item["offerType"] == "featured";

    return Dismissible(
      key: Key("${item["id"]}_$index"),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 30),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
            SizedBox(height: 4),
            Text("حذف",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      onDismissed: (_) => _removeItem(index),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OfferDetailsScreen(
                    offerData: item,
                    offerType: _mapType(item["offerType"] ?? "standard")))),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: cardC,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: isFeatured
                    ? AppColors.goldenBronze.withOpacity(isDarkMode ? 0.6 : 1)
                    : borderC,
                width: isFeatured ? 1.5 : 1.0),
            boxShadow: [
              BoxShadow(
                  color: isFeatured
                      ? AppColors.goldenBronze
                          .withOpacity(isDarkMode ? 0.1 : 0.15)
                      : Colors.black.withOpacity(isDarkMode ? 0.2 : 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 5)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19),
            child: Row(
              children: [
                SizedBox(
                  width: 130,
                  height: 140,
                  child: Stack(fit: StackFit.expand, children: [
                    Image.network(item["image"],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                            color: AppColors.lightBackground,
                            child: const Icon(Icons.image_not_supported,
                                color: AppColors.grey))),
                    if ((item["discount"] ?? '').isNotEmpty)
                      Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                  color: AppColors.error,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text("${item["discount"]}-",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)))),
                    if (isFeatured)
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
                  ]),
                ),
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
                                  backgroundColor: AppColors.lightBackground,
                                  backgroundImage:
                                      NetworkImage(item["storeLogo"]))),
                          const SizedBox(width: 6),
                          Expanded(
                              child: Text(item["storeName"],
                                  style: const TextStyle(
                                      color: AppColors.goldenBronze,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis)),
                        ]),
                        const SizedBox(height: 8),
                        Text(item["title"],
                            style: TextStyle(
                                color: isDarkMode
                                    ? AppColors.pureWhite
                                    : AppColors.lightText,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                height: 1.3),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item["price"],
                                      style: const TextStyle(
                                          color: AppColors.goldenBronze,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900)),
                                  if ((item["oldPrice"] ?? '').isNotEmpty)
                                    Text(item["oldPrice"],
                                        style: const TextStyle(
                                            color: AppColors.grey,
                                            fontSize: 11,
                                            decoration:
                                                TextDecoration.lineThrough)),
                                ]),
                            OfferActionButtons(
                                isDarkMode: isDarkMode,
                                offerId: (item["id"] ?? "").toString(),
                                isGroup: item["isGroup"] == true),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
