import 'package:flutter/material.dart';
import '../../../core/network/api_service.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../core/widgets/offer_action_buttons.dart';
import '../details/offer_details_screen.dart';

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
      final data = await _api.get(ApiConstants.favorites);

      final List rawFavorites =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);

      if (mounted) {
        setState(() {
          _favorites = rawFavorites.map<Map<String, dynamic>>((item) {
            // قد تكون البيانات embedded أو مرجعية
            final product = item['product'] ?? item;

            var images = product['images'] as List?;
            String imageUrl = (images != null && images.isNotEmpty)
                ? ApiConstants.resolveImageUrl(
                    images[0]['image_url']?.toString())
                : ApiConstants.resolveImageUrl(product['image']?.toString() ??
                    product['thumbnail']?.toString());

            String storeName = product['store_name'] ?? 'متجر غير معروف';
            String storeLogo = product['store_logo'] != null
                ? ApiConstants.resolveImageUrl(product['store_logo'].toString())
                : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(storeName)}&background=B8860B&color=fff';

            // حساب الخصم
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
              "id": product['product_id']?.toString() ??
                  product['id']?.toString() ??
                  '',
              "title": product['title'] ?? 'بدون عنوان',
              "storeName": storeName,
              "storeLogo": storeLogo,
              "image": imageUrl,
              "price": "${product['price'] ?? '0'}\$",
              "oldPrice": oldPrice > 0 ? "${product['old_price']}\$" : "",
              "discount": discount,
              "category": product['category_name'] ?? '',
              "offerType":
                  product['is_featured'] == true ? 'featured' : 'standard',
              "is_liked": product['is_liked'] ?? false,
              "is_favorited": true,
            };
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('خطأ في جلب المفضلة: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _removeItem(int index) async {
    final item = _favorites[index];
    final productId = item['id'];
    setState(() => _favorites.removeAt(index));

    if (productId.isNotEmpty) {
      try {
        await _api.post(ApiConstants.toggleFavorite(productId));
      } catch (e) {
        debugPrint('خطأ في إزالة المفضلة: $e');
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

  Widget _buildFavoriteCard(
      Map<String, dynamic> item, bool isDarkMode, int index) {
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
                                offerId: item["id"] ?? "FAV_${item["title"]}",
                                initialIsFavorited: true),
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
