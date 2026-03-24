import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/api_service.dart';
import '../../../core/widgets/offer_action_buttons.dart';
import '../../../core/helpers/auth_guard.dart';
import '../../../data/providers/social_provider.dart';
import 'all_comments_screen.dart';
import 'merchant_chat_screen.dart';
import 'merchant_profile_screen.dart';

// ============================================================================
// أنواع العروض المدعومة في شاشة التفاصيل
// ============================================================================
enum OfferDetailType { standard, featured, brochure, bundled }

// ============================================================================
// شاشة تفاصيل العرض (Offer Details Screen)
// تتكيف تلقائياً حسب نوع العرض
// ============================================================================
class OfferDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> offerData;
  final OfferDetailType offerType;

  const OfferDetailsScreen({
    super.key,
    required this.offerData,
    this.offerType = OfferDetailType.standard,
  });

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  int _currentImageIndex = 0;
  bool _descExpanded = false;
  final PageController _imagePageController = PageController();
  final TextEditingController _commentController = TextEditingController();

  // بيانات مُستخرجة من API
  late List<String> _images;
  late String _title;
  late String _storeName;
  late String _storeLogo;
  late String _storeId;
  late String _price;
  late String _oldPrice;
  late String _discount;
  late String _productId;
  late String _description;
  late String _categoryName;
  late String _brand;
  late String _size;
  late String _weight;
  late List<Map<String, dynamic>> _bundleItems;
  DateTime? _endDate;
  int _viewsCount = 0;
  int _likesCount = 0;
  int _categoryId = 0;

  // تعليقات من الـ API
  List<Map<String, dynamic>> _comments = [];
  bool _loadingComments = false;
  bool _isSending = false;

  // عروض مشابهة من API
  List<Map<String, dynamic>> _similarOffers = [];
  bool _loadingSimilar = false;
  bool _viewTracked = false;

  /// استخراج رابط صورة آمن من عنصر قد يكون String أو Map
  String _extractImageUrl(dynamic item) {
    if (item is String) return ApiConstants.resolveImageUrl(item);
    if (item is Map) {
      return ApiConstants.resolveImageUrl(
          item['image_url']?.toString() ?? item['image']?.toString());
    }
    return ApiConstants.resolveImageUrl(null);
  }

  @override
  void initState() {
    super.initState();
    final d = widget.offerData;
    // البيانات الخام (للباقات: original_data يحوي بيانات API الأصلية)
    final raw = (d["original_data"] is Map)
        ? d["original_data"] as Map<String, dynamic>
        : d;

    _title = (d["title"] ?? raw["name"] ?? "عرض مميز").toString();
    _storeName = (d["storeName"] ??
            d["store_name"] ??
            raw["store_name"] ??
            d["store"] ??
            "متجر")
        .toString();
    _storeLogo = ApiConstants.resolveImageUrl(
        (d["storeLogo"] ??
                d["logo"] ??
                d["store_logo"] ??
                raw["logo"] ??
                raw["store_logo"])
            ?.toString(),
        fallback: "https://i.pravatar.cc/150?img=11");
    _storeId =
        (d["storeId"] ?? d["store_id"] ?? raw["store_id"] ?? raw["store"] ?? "")
            .toString();
    _price = (d["price"] ?? raw["new_price"] ?? raw["price"] ?? "").toString();
    if (!_price.contains('\$') && _price.isNotEmpty) _price = '$_price\$';
    _oldPrice =
        (d["oldPrice"] ?? d["old_price"] ?? raw["old_price"] ?? "").toString();
    if (_oldPrice.isNotEmpty && !_oldPrice.contains('\$') && _oldPrice != '0') {
      _oldPrice = '$_oldPrice\$';
    } else if (_oldPrice == '0') {
      _oldPrice = '';
    }
    _discount = (d["discount"] ?? d["saving"] ?? "").toString();
    _productId = (d["product_id"] ??
            raw["group_id"] ??
            d["group_id"] ??
            d["id"] ??
            raw["product_id"] ??
            "")
        .toString();

    // === بيانات حقيقية من API ===
    _description = (raw["description"] ?? d["description"] ?? "").toString();
    _categoryName =
        (raw["category_name"] ?? d["category_name"] ?? "").toString();
    _viewsCount = int.tryParse(
            (raw["views_count"] ?? d["views_count"] ?? '0').toString()) ??
        0;
    _likesCount = int.tryParse(
            (raw["likes_count"] ?? d["likes_count"] ?? '0').toString()) ??
        0;
    _categoryId =
        int.tryParse((raw["category"] ?? d["category"] ?? '0').toString()) ?? 0;

    // مواصفات المنتج (تظهر فقط إذا موجودة)
    _brand = (raw["brand"] ?? d["brand"] ?? "").toString().trim();
    _size = (raw["size"] ?? d["size"] ?? "").toString().trim();
    _weight = (raw["weight"] ?? d["weight"] ?? "").toString().trim();

    // تاريخ الانتهاء
    final endStr = (raw["end_date"] ??
            d["end_date"] ??
            raw["valid_until"] ??
            d["valid_until"] ??
            "")
        .toString();
    if (endStr.isNotEmpty) {
      _endDate = DateTime.tryParse(endStr);
    }

    // بناء قائمة الصور — معالجة آمنة لكل الأنواع
    if (widget.offerType == OfferDetailType.brochure && d["pages"] is List) {
      _images = (d["pages"] as List).map((e) => _extractImageUrl(e)).toList();
    } else if (widget.offerType == OfferDetailType.brochure) {
      final main = _extractImageUrl(d["image"]);
      _images = [main];
    } else if (d["images"] != null && d["images"] is List) {
      _images = (d["images"] as List).map((e) => _extractImageUrl(e)).toList();
      if (_images.isEmpty) {
        _images = [_extractImageUrl(d["image"])];
      }
    } else {
      final main = _extractImageUrl(d["image"] ?? d["thumbnail"]);
      _images = [main];
    }

    // محتويات الباقة — من products في original_data أو البيانات المباشرة
    _bundleItems = [];
    if (_isBundled) {
      final products = (raw["group_items"] is List)
          ? raw["group_items"] as List
          : (raw["items"] is List
              ? raw["items"] as List
              : (raw["products"] is List
                  ? raw["products"] as List
                  : (d["products"] is List ? d["products"] as List : [])));
      for (var p in products) {
        // group_items may nest the product inside a 'product' key
        final prod = (p is Map && p['product'] is Map) ? p['product'] : p;
        _bundleItems.add({
          "name": (prod["title"] ?? prod["name"] ?? "منتج").toString(),
          "image": _extractImageUrl(
              prod["images"] is List && (prod["images"] as List).isNotEmpty
                  ? prod["images"][0]
                  : prod["image"]),
          "price": "${prod['new_price'] ?? prod['price'] ?? '0'}\$",
          "isLocal": false,
        });
      }
    }
    // جلب التعليقات (للمنتجات والباقات)
    _fetchComments();
    // جلب بيانات محدّثة + تسجيل مشاهدة + جلب مشابهة
    if (!_isBrochure && _productId.isNotEmpty) {
      _fetchProductDetails();
      _trackView();
    }
    // جلب عروض مشابهة دائماً (حتى للباقات)
    if (_categoryId > 0) {
      _fetchSimilarOffers();
    }
  }

  Future<void> _fetchComments() async {
    if (_productId.isEmpty) return;
    setState(() => _loadingComments = true);
    try {
      final api = ApiService();
      final endpoint = _isBundled
          ? ApiConstants.groupComments(_productId)
          : ApiConstants.productComments(_productId);
      final data = await api.get(endpoint);
      final List raw =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);
      if (mounted) {
        setState(() {
          _comments = raw.cast<Map<String, dynamic>>();
          _loadingComments = false;
        });
      }
    } catch (e) {
      debugPrint('خطأ جلب التعليقات: $e');
      if (mounted) setState(() => _loadingComments = false);
    }
  }

  Future<void> _fetchSimilarOffers() async {
    if (_categoryId == 0) return;
    setState(() => _loadingSimilar = true);
    try {
      final api = ApiService();
      final data = await api.get(
        ApiConstants.products,
        queryParams: {'category': '$_categoryId', 'page_size': '6'},
        requiresAuth: false,
      );
      final List raw =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);
      if (mounted) {
        setState(() {
          _similarOffers = raw
              .cast<Map<String, dynamic>>()
              .where((p) => p['product_id']?.toString() != _productId)
              .take(5)
              .toList();
          _loadingSimilar = false;
        });
      }
    } catch (e) {
      debugPrint('خطأ جلب عروض مشابهة: $e');
      if (mounted) setState(() => _loadingSimilar = false);
    }
  }

  Future<void> _fetchProductDetails() async {
    try {
      final api = ApiService();
      final data = await api.get(
        ApiConstants.productDetails(_productId),
        requiresAuth: false,
      );
      if (data is Map<String, dynamic> && mounted) {
        setState(() {
          _viewsCount = int.tryParse((data['views_count'] ?? '0').toString()) ??
              _viewsCount;
          _likesCount = int.tryParse((data['likes_count'] ?? '0').toString()) ??
              _likesCount;
          if (_categoryId == 0) {
            _categoryId =
                int.tryParse((data['category'] ?? '0').toString()) ?? 0;
          }
          if (_categoryName.isEmpty) {
            _categoryName = (data['category_name'] ?? '').toString();
          }
          if (_description.isEmpty) {
            _description = (data['description'] ?? '').toString();
          }
          if (_brand.isEmpty) _brand = (data['brand'] ?? '').toString().trim();
          if (_size.isEmpty) _size = (data['size'] ?? '').toString().trim();
          if (_weight.isEmpty)
            _weight = (data['weight'] ?? '').toString().trim();
        });
        _fetchSimilarOffers();
      }
    } catch (e) {
      debugPrint('خطأ جلب تفاصيل المنتج: $e');
      _fetchSimilarOffers();
    }
  }

  Future<void> _trackView() async {
    if (_viewTracked) return;
    _viewTracked = true;
    try {
      final api = ApiService();
      await api.post(ApiConstants.logView(_productId), body: {});
    } catch (_) {}
  }

  /// إعادة جلب عدادات المشاهدات والإعجابات
  Future<void> _refreshCounts() async {
    try {
      final api = ApiService();
      final data = await api.get(
        ApiConstants.productDetails(_productId),
        requiresAuth: false,
      );
      if (data is Map<String, dynamic> && mounted) {
        setState(() {
          _viewsCount = int.tryParse((data['views_count'] ?? '0').toString()) ??
              _viewsCount;
          _likesCount = int.tryParse((data['likes_count'] ?? '0').toString()) ??
              _likesCount;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  bool get _isFeatured => widget.offerType == OfferDetailType.featured;
  bool get _isBrochure => widget.offerType == OfferDetailType.brochure;
  bool get _isBundled => widget.offerType == OfferDetailType.bundled;
  bool get _hasSpecs =>
      _brand.isNotEmpty || _size.isNotEmpty || _weight.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.deepNavy : AppColors.lightBackground;
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: bg,
            body: SafeArea(
                child: Column(children: [
              Expanded(
                child: Stack(children: [
                  CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                            child: _buildImageGallery(isDark, textC)),
                        SliverToBoxAdapter(child: _buildContent(isDark, textC)),
                      ]),
                  Positioned(
                      top: 10,
                      right: 16,
                      child: _buildBackButton(isDark, textC)),
                ]),
              ),
            ]))));
  }

  Future<void> _submitComment() async {
    if (!AuthGuard.requireAuth(context)) return;
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    if (_productId.isEmpty) return;

    setState(() => _isSending = true);
    FocusScope.of(context).unfocus();

    try {
      final api = ApiService();
      final endpoint = _isBundled
          ? ApiConstants.groupComments(_productId)
          : ApiConstants.productComments(_productId);
      final result = await api.post(endpoint, body: {'text': text});

      if (mounted) {
        setState(() => _isSending = false);
        if (result != null) {
          _commentController.clear();
          _fetchComments();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("فشل إرسال التعليق",
                style: TextStyle(fontWeight: FontWeight.w600)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  // ==========================================
  // زر الرجوع
  // ==========================================
  Widget _buildBackButton(bool isDark, Color textC) {
    return GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: (isDark ? AppColors.deepNavy : AppColors.pureWhite)
                    .withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isDark
                        ? AppColors.goldenBronze.withOpacity(0.3)
                        : Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.15), blurRadius: 8)
                ]),
            child:
                Icon(Icons.arrow_forward_ios_rounded, color: textC, size: 18)));
  }

  // ==========================================
  // 1. معرض الصور
  // ==========================================
  Widget _buildImageGallery(bool isDark, Color textC) {
    final double galleryH = _isBrochure ? 350 : 280;

    return Container(
      decoration: _isFeatured
          ? BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: AppColors.goldenBronze.withOpacity(0.5),
                      width: 2)),
            )
          : null,
      child: Column(children: [
        // الصورة الكبيرة
        SizedBox(
            height: galleryH,
            child: PageView.builder(
              controller: _imagePageController,
              itemCount: _images.length,
              onPageChanged: (i) => setState(() => _currentImageIndex = i),
              itemBuilder: (_, i) {
                final isLocal = widget.offerData["isLocalImage"] ?? false;
                return GestureDetector(
                  onTap: () => _showFullImage(i),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF072A38)
                          : Colors.grey.shade100,
                    ),
                    child: isLocal && !_images[i].startsWith("http")
                        ? Image.asset(_images[i],
                            fit: _isBrochure ? BoxFit.contain : BoxFit.cover)
                        : Image.network(_images[i],
                            fit: _isBrochure ? BoxFit.contain : BoxFit.cover),
                  ),
                );
              },
            )),
        // بادج مميز
        if (_isFeatured)
          Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              color: AppColors.goldenBronze,
              child: const Center(
                  child: Text("⭐ عرض مميز ⭐",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800)))),
        // مؤشر الصفحات
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    _images.length,
                    (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _currentImageIndex == i ? 20 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                            color: _currentImageIndex == i
                                ? AppColors.goldenBronze
                                : (isDark
                                    ? Colors.white24
                                    : Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(3)))))),
        // مصغرات
        if (_images.length > 1)
          SizedBox(
              height: 55,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _images.length,
                itemBuilder: (_, i) {
                  final sel = i == _currentImageIndex;
                  final isLocal = widget.offerData["isLocalImage"] ?? false;
                  return GestureDetector(
                    onTap: () {
                      _imagePageController.animateToPage(i,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut);
                    },
                    child: Container(
                        width: 55,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: sel
                                    ? AppColors.goldenBronze
                                    : (isDark
                                        ? Colors.white12
                                        : Colors.grey.shade300),
                                width: sel ? 2 : 1)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: isLocal && !_images[i].startsWith("http")
                                ? Image.asset(_images[i], fit: BoxFit.cover)
                                : Image.network(_images[i],
                                    fit: BoxFit.cover))),
                  );
                },
              )),
        if (_isBrochure)
          Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text("صفحة ${_currentImageIndex + 1} من ${_images.length}",
                  style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600))),
      ]),
    );
  }

  void _showFullImage(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => _FullScreenViewer(
                images: _images,
                initial: index,
                isLocal: widget.offerData["isLocalImage"] ?? false)));
  }

  // ==========================================
  // 2. المحتوى
  // ==========================================
  Widget _buildContent(bool isDark, Color textC) {
    final cardBg = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;

    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ======== شريط المتجر ========
          _buildStoreBar(isDark, textC, cardBg),
          const SizedBox(height: 14),

          // ======== العنوان ========
          Text(_title,
              style: TextStyle(
                  color: textC,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  height: 1.3)),
          const SizedBox(height: 10),

          // ======== السعر (مخفي للكتيبات) ========
          if (!_isBrochure) _buildPriceRow(isDark),
          if (!_isBrochure) const SizedBox(height: 8),

          // ======== مدة الصلاحية ========
          _buildExpiryBadge(isDark),
          const SizedBox(height: 16),

          // ======== أزرار التفاعل ========
          _buildActionBar(isDark, textC, cardBg),
          const SizedBox(height: 16),

          // ======== الوصف (مباشرة بعد الأزرار للكل) ========
          _buildDescription(isDark, textC, cardBg),
          const SizedBox(height: 16),

          // ======== المواصفات (فقط إذا فيه بيانات — ليس للباقات والبروشورات) ========
          if (!_isBundled && !_isBrochure && _hasSpecs)
            _buildSpecs(isDark, textC, cardBg),
          if (!_isBundled && !_isBrochure && _hasSpecs)
            const SizedBox(height: 16),

          // ======== الإثبات الاجتماعي ========
          _buildSocialProof(isDark, textC, cardBg),
          const SizedBox(height: 16),

          // ======== محتويات الباقة (للمجمعة فقط — قبل التعليقات) ========
          if (_isBundled) ...[
            _buildBundleContents(isDark, textC, cardBg),
            const SizedBox(height: 16),
          ],

          // ======== التعليقات ========
          _buildCommentsPreview(isDark, textC, cardBg),

          // ======== عروض مشابهة ========
          if (!_isBrochure) ...[
            const SizedBox(height: 20),
            _buildSimilarOffers(isDark, textC),
          ],
        ]));
  }

  // ==========================================
  // شريط المتجر
  // ==========================================
  Widget _buildStoreBar(bool isDark, Color textC, Color cardBg) {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: isDark
                    ? AppColors.goldenBronze.withOpacity(0.15)
                    : Colors.grey.shade200)),
        child: Row(children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MerchantProfileScreen(
                          storeId: _storeId,
                          storeName: _storeName,
                          storeLogo: _storeLogo))),
              child: Row(children: [
                Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.goldenBronze, width: 2)),
                    child: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.softCream,
                        backgroundImage: NetworkImage(_storeLogo))),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Row(children: [
                        Flexible(
                            child: Text(_storeName,
                                style: TextStyle(
                                    color: textC,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: 6),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                                color:
                                    const Color(0xFF4CAF50).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4)),
                            child: const Text("✓ موثوق",
                                style: TextStyle(
                                    color: Color(0xFF4CAF50),
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold))),
                      ]),
                      const SizedBox(height: 3),
                      if (_categoryName.isNotEmpty)
                        Text(_categoryName,
                            style:
                                TextStyle(color: AppColors.grey, fontSize: 11)),
                    ])),
              ]),
            ),
          ),
          GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MerchantProfileScreen(
                          storeId: _storeId,
                          storeName: _storeName,
                          storeLogo: _storeLogo))),
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                      color: AppColors.goldenBronze.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.goldenBronze.withOpacity(0.3))),
                  child: const Text("عروض المتجر",
                      style: TextStyle(
                          color: AppColors.goldenBronze,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)))),
        ]));
  }

  // ==========================================
  // السعر
  // ==========================================
  Widget _buildPriceRow(bool isDark) {
    return Row(children: [
      Text(_price,
          style: const TextStyle(
              color: AppColors.goldenBronze,
              fontSize: 24,
              fontWeight: FontWeight.w900)),
      if (_oldPrice.isNotEmpty) ...[
        const SizedBox(width: 10),
        Text(_oldPrice,
            style: const TextStyle(
                color: AppColors.grey,
                fontSize: 14,
                decoration: TextDecoration.lineThrough)),
      ],
      if (_discount.isNotEmpty) ...[
        const SizedBox(width: 10),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6)),
            child: Text("-$_discount",
                style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 12,
                    fontWeight: FontWeight.bold))),
      ],
    ]);
  }

  // ==========================================
  // مدة الصلاحية
  // ==========================================
  Widget _buildExpiryBadge(bool isDark) {
    String expiryText;
    Color expiryColor;
    IconData expiryIcon;

    if (_endDate != null) {
      final diff = _endDate!.difference(DateTime.now());
      if (diff.isNegative) {
        expiryText = "انتهى العرض";
        expiryColor = AppColors.error;
        expiryIcon = Icons.event_busy_rounded;
      } else if (diff.inDays == 0) {
        expiryText = "ينتهي اليوم";
        expiryColor = AppColors.error;
        expiryIcon = Icons.alarm_rounded;
      } else if (diff.inDays <= 3) {
        expiryText = "ينتهي بعد ${diff.inDays} أيام";
        expiryColor = Colors.orange.shade700;
        expiryIcon = Icons.timer_outlined;
      } else {
        expiryText = "متبقي ${diff.inDays} يوم";
        expiryColor = const Color(0xFF4CAF50);
        expiryIcon = Icons.event_available_rounded;
      }
    } else {
      expiryText = "عرض مستمر";
      expiryColor = const Color(0xFF4CAF50);
      expiryIcon = Icons.all_inclusive_rounded;
    }

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: expiryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(expiryIcon, color: expiryColor, size: 14),
          const SizedBox(width: 4),
          Text(expiryText,
              style: TextStyle(
                  color: expiryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
        ]));
  }

  // ==========================================
  // أزرار التفاعل
  // ==========================================
  Widget _buildActionBar(bool isDark, Color textC, Color cardBg) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: isDark
                    ? AppColors.goldenBronze.withOpacity(0.15)
                    : Colors.grey.shade200)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          OfferActionButtons(
              isDarkMode: isDark,
              offerId: _productId,
              isGroup: widget.offerType == OfferDetailType.bundled),
          _actionBtn(Icons.share_rounded, "مشاركة", isDark, textC,
              () => Share.share('تصفح العرض: $_title على SIDE')),
          _actionBtn(Icons.chat_rounded, "تواصل", isDark, textC, () {
            if (!AuthGuard.requireAuth(context)) return;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => MerchantChatScreen(
                        storeName: _storeName,
                        storeLogo: _storeLogo,
                        offerTitle: _title)));
          }),
          _actionBtn(Icons.support_agent_rounded, "الدعم", isDark, textC, () {
            if (!AuthGuard.requireAuth(context)) return;
            _showSupportSheet(isDark);
          }),
        ]));
  }

  Widget _actionBtn(IconData icon, String label, bool isDark, Color textC,
      VoidCallback onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  color:
                      isDark ? AppColors.deepNavy : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: isDark
                          ? AppColors.goldenBronze.withOpacity(0.1)
                          : Colors.grey.shade100)),
              child: Icon(icon, color: AppColors.goldenBronze, size: 22)),
          const SizedBox(height: 6),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textC.withOpacity(0.7),
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ]));
  }

  // ==========================================
  // محتويات الباقة (Bundled)
  // ==========================================
  Widget _buildBundleContents(bool isDark, Color textC, Color cardBg) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("📦 محتويات الباقة",
          style: TextStyle(
              color: textC, fontSize: 16, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: _bundleItems.length,
        itemBuilder: (_, i) {
          final item = _bundleItems[i];
          final isLocal = item["isLocal"] ?? false;
          return Container(
              decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: isDark
                          ? AppColors.goldenBronze.withOpacity(0.15)
                          : Colors.grey.shade200)),
              child: Column(children: [
                Expanded(
                    child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(11)),
                        child: isLocal
                            ? Image.asset(item["image"],
                                fit: BoxFit.cover, width: double.infinity)
                            : Image.network(item["image"],
                                fit: BoxFit.cover, width: double.infinity))),
                Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(children: [
                      Text(item["name"],
                          style: TextStyle(
                              color: textC,
                              fontSize: 10,
                              fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      Text(item["price"],
                          style: const TextStyle(
                              color: AppColors.goldenBronze,
                              fontSize: 11,
                              fontWeight: FontWeight.w800)),
                    ])),
              ]));
        },
      ),
      if (_discount.isNotEmpty) ...[
        const SizedBox(height: 10),
        // شريط التوفير
        Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              const Icon(Icons.savings_rounded,
                  color: AppColors.error, size: 20),
              const SizedBox(width: 8),
              Expanded(
                  child: Text("🎉 $_discount",
                      style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 14,
                          fontWeight: FontWeight.w800))),
            ])),
      ],
      const SizedBox(height: 16),
    ]);
  }

  // ==========================================
  // الوصف
  // ==========================================
  Widget _buildDescription(bool isDark, Color textC, Color cardBg) {
    final desc = _description.isNotEmpty
        ? _description
        : _isBrochure
            ? "كتيب عروض $_storeName يحتوي على ${_images.length} صفحة من أفضل العروض والتخفيضات."
            : "عرض من $_storeName على $_title.";

    return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: isDark
                    ? AppColors.goldenBronze.withOpacity(0.15)
                    : Colors.grey.shade200)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_isBrochure ? "📄 عن الكتيب" : "📋 تفاصيل العرض",
              style: TextStyle(
                  color: textC, fontSize: 15, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(desc,
              style: TextStyle(
                  color: textC.withOpacity(0.8), fontSize: 13, height: 1.6),
              maxLines: _descExpanded ? null : 3,
              overflow: _descExpanded ? null : TextOverflow.ellipsis),
          GestureDetector(
              onTap: () => setState(() => _descExpanded = !_descExpanded),
              child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(_descExpanded ? "عرض أقل ▲" : "قراءة المزيد ▼",
                      style: const TextStyle(
                          color: AppColors.goldenBronze,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)))),
        ]));
  }

  // ==========================================
  // الإثبات الاجتماعي
  // ==========================================
  Widget _buildSocialProof(bool isDark, Color textC, Color cardBg) {
    return Consumer<SocialProvider>(
      builder: (_, social, __) {
        final userLiked = _isBundled
            ? social.isGroupLiked(_productId)
            : social.isLiked(_productId);
        final displayLikes = _likesCount + (userLiked ? 1 : 0);
        return GestureDetector(
          onTap: _refreshCounts,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: isDark
                        ? AppColors.goldenBronze.withOpacity(0.15)
                        : Colors.grey.shade200)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _proofItem("👁", "$_viewsCount", "مشاهدة", textC),
                  Container(
                      width: 1,
                      height: 30,
                      color: isDark ? Colors.white12 : Colors.grey.shade200),
                  _proofItem("❤️", "$displayLikes", "إعجاب", textC),
                  Container(
                      width: 1,
                      height: 30,
                      color: isDark ? Colors.white12 : Colors.grey.shade200),
                  _proofItem("💬", "${_comments.length}", "تعليق", textC),
                ]),
          ),
        );
      },
    );
  }

  Widget _proofItem(String emoji, String count, String label, Color textC) {
    return Column(children: [
      Text(emoji, style: const TextStyle(fontSize: 18)),
      const SizedBox(height: 4),
      Text(count,
          style: TextStyle(
              color: textC, fontSize: 16, fontWeight: FontWeight.w900)),
      Text(label, style: TextStyle(color: AppColors.grey, fontSize: 10)),
    ]);
  }

  // ==========================================
  // قالب التعليقات (معاينة + إدخال مدمج)
  // ==========================================
  Widget _buildCommentsPreview(bool isDark, Color textC, Color cardBg) {
    final preview = _comments.take(5).toList();
    final isBundled = widget.offerType == OfferDetailType.bundled;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark
                ? AppColors.goldenBronze.withOpacity(0.2)
                : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.15 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(children: [
        // ── هيدر القالب ──
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.goldenBronze.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.chat_rounded,
                    color: AppColors.goldenBronze, size: 16),
              ),
              const SizedBox(width: 8),
              Text("التعليقات",
                  style: TextStyle(
                      color: textC, fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.goldenBronze.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("${_comments.length}",
                    style: const TextStyle(
                        color: AppColors.goldenBronze,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
            ]),
            if (_comments.length > 5)
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AllCommentsScreen(
                            productId: _productId,
                            offerTitle: _title,
                            isGroup: isBundled),
                      ));
                  _fetchComments();
                },
                child: const Row(children: [
                  Text("عرض الكل",
                      style: TextStyle(
                          color: AppColors.goldenBronze,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_back_ios_new_rounded,
                      color: AppColors.goldenBronze, size: 11),
                ]),
              ),
          ]),
        ),

        const SizedBox(height: 10),

        // ── التعليقات (scrollable) ──
        if (_loadingComments)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
                child: CircularProgressIndicator(
                    color: AppColors.goldenBronze, strokeWidth: 2)),
          )
        else if (_comments.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(children: [
              Icon(Icons.chat_bubble_outline_rounded,
                  color: textC.withOpacity(0.12), size: 32),
              const SizedBox(height: 8),
              Text("لا توجد تعليقات بعد",
                  style:
                      TextStyle(color: textC.withOpacity(0.35), fontSize: 13)),
              const SizedBox(height: 2),
              Text("كن أول من يعلّق!",
                  style:
                      TextStyle(color: textC.withOpacity(0.25), fontSize: 11)),
            ]),
          )
        else
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: preview.length,
              itemBuilder: (_, i) =>
                  _buildCommentBubble(preview[i], isDark, textC),
            ),
          ),

        // ── حقل الإدخال المدمج ──
        Container(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
          child: Row(children: [
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color:
                      isDark ? AppColors.deepNavy : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: isDark
                          ? AppColors.goldenBronze.withOpacity(0.15)
                          : Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _commentController,
                  style: TextStyle(color: textC, fontSize: 13),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _submitComment(),
                  decoration: InputDecoration(
                    hintText: "اكتب تعليقك...",
                    hintStyle: TextStyle(
                        color: AppColors.grey.withOpacity(0.6), fontSize: 12),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _isSending ? null : _submitComment,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _isSending
                      ? AppColors.goldenBronze.withOpacity(0.5)
                      : AppColors.goldenBronze,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.goldenBronze.withOpacity(0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: _isSending
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.send_rounded,
                        color: Colors.white, size: 16),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  // ── فقاعة تعليق واحد ──
  Widget _buildCommentBubble(Map<String, dynamic> c, bool isDark, Color textC) {
    final userName = (c['user_name'] ?? c['username'] ?? 'مستخدم').toString();
    final text = (c['text'] ?? '').toString();
    final createdAt = (c['created_at'] ?? '').toString();
    final avatar = (c['user_avatar'] ?? c['avatar'] ?? '').toString();
    final avatarUrl = avatar.isNotEmpty
        ? ApiConstants.resolveImageUrl(avatar)
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(userName)}&background=B8860B&color=fff';
    final timeAgo = _formatTimeAgo(createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.deepNavy.withOpacity(0.5)
            : AppColors.lightBackground.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: AppColors.goldenBronze.withOpacity(0.5), width: 1.5),
          ),
          child: CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.lightBackground,
              backgroundImage: NetworkImage(avatarUrl)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(userName,
                  style: TextStyle(
                      color: AppColors.goldenBronze,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
              const SizedBox(width: 6),
              Container(
                width: 3,
                height: 3,
                decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.5),
                    shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(timeAgo,
                  style: TextStyle(
                      color: AppColors.grey.withOpacity(0.7), fontSize: 10)),
            ]),
            const SizedBox(height: 4),
            Text(text,
                style: TextStyle(
                    color: textC.withOpacity(0.85), fontSize: 13, height: 1.4)),
          ]),
        ),
      ]),
    );
  }

  String _formatTimeAgo(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 1) return 'الآن';
      if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
      if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
      if (diff.inDays < 30) return 'منذ ${diff.inDays} يوم';
      return 'منذ ${(diff.inDays / 30).floor()} شهر';
    } catch (_) {
      return dateStr;
    }
  }

  Widget _buildSimilarOffers(bool isDark, Color textC) {
    if (_loadingSimilar) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
            child: CircularProgressIndicator(
                color: AppColors.goldenBronze, strokeWidth: 2)),
      );
    }
    if (_similarOffers.isEmpty) return const SizedBox.shrink();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("عروض مشابهة 🔄",
          style: TextStyle(
              color: textC, fontSize: 16, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _similarOffers.length,
            itemBuilder: (_, i) {
              final o = _similarOffers[i];
              final cardBg =
                  isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
              final title = (o["title"] ?? "عرض").toString();
              final price = (o["new_price"] ?? o["price"] ?? "0").toString();
              final storeName = (o["store_name"] ?? "متجر").toString();
              String imageUrl =
                  'https://placehold.co/200x200/png?text=No+Image';
              if (o["images"] is List && (o["images"] as List).isNotEmpty) {
                final img = (o["images"] as List)[0];
                imageUrl = ApiConstants.resolveImageUrl(img is Map
                    ? img['image_url']?.toString()
                    : img?.toString());
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => OfferDetailsScreen(
                              offerData: o,
                              offerType: (o["is_featured"] == true)
                                  ? OfferDetailType.featured
                                  : OfferDetailType.standard)));
                },
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color:
                              isDark ? Colors.white10 : Colors.grey.shade200)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(13)),
                                child: Image.network(imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (_, __, ___) => Container(
                                        color: isDark
                                            ? AppColors.deepNavy
                                            : AppColors.lightBackground,
                                        child: const Center(
                                            child: Icon(Icons.image_outlined,
                                                color: AppColors.grey)))))),
                        Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title,
                                      style: TextStyle(
                                          color: textC,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  Text("$price\$",
                                      style: const TextStyle(
                                          color: AppColors.goldenBronze,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900)),
                                  Text(storeName,
                                      style: TextStyle(
                                          color: AppColors.grey, fontSize: 10)),
                                ])),
                      ]),
                ),
              );
            },
          )),
    ]);
  }

  // ==========================================
  // مواصفات المنتج
  // ==========================================
  Widget _buildSpecs(bool isDark, Color textC, Color cardBg) {
    final specs = <MapEntry<String, String>>[];
    if (_brand.isNotEmpty) specs.add(MapEntry('🏷️ العلامة', _brand));
    if (_size.isNotEmpty) specs.add(MapEntry('📏 المقاس', _size));
    if (_weight.isNotEmpty) specs.add(MapEntry('⚖️ الوزن', _weight));
    if (_categoryName.isNotEmpty)
      specs.add(MapEntry('📂 الفئة', _categoryName));

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isDark
                  ? AppColors.goldenBronze.withOpacity(0.15)
                  : Colors.grey.shade200)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("📌 المواصفات",
            style: TextStyle(
                color: textC, fontSize: 15, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        ...specs.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                Text(s.key,
                    style:
                        TextStyle(color: textC.withOpacity(0.6), fontSize: 13)),
                const Spacer(),
                Text(s.value,
                    style: TextStyle(
                        color: textC,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
              ]),
            )),
      ]),
    );
  }

  void _showSupportSheet(bool isDark) {
    final bg = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                decoration: BoxDecoration(
                    color: bg,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24))),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                  color: AppColors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(2)))),
                      const SizedBox(height: 16),
                      Text("الدعم الفني",
                          style: TextStyle(
                              color: textC,
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      Text("تواصل مع إدارة التطبيق للشكاوي أو الاستفسارات",
                          style:
                              TextStyle(color: AppColors.grey, fontSize: 13)),
                      const SizedBox(height: 16),
                      _supportAction(Icons.email_outlined,
                          "إرسال رسالة للإدارة", isDark, textC, () {
                        Navigator.pop(context);
                        _showTicketDialog(isDark);
                      }),
                      _supportAction(Icons.report_problem_outlined,
                          "الإبلاغ عن مشكلة", isDark, textC, () {
                        Navigator.pop(context);
                        _showReportDialog(isDark);
                      }),
                      _supportAction(Icons.help_outline_rounded,
                          "الأسئلة الشائعة", isDark, textC, () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('قريبا..'),
                              duration: Duration(seconds: 1)),
                        );
                      }),
                    ]))));
  }

  Widget _supportAction(IconData icon, String label, bool isDark, Color textC,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            decoration: BoxDecoration(
                color: isDark ? AppColors.deepNavy : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Icon(icon, color: AppColors.goldenBronze, size: 20),
              const SizedBox(width: 12),
              Text(label,
                  style: TextStyle(
                      color: textC, fontSize: 14, fontWeight: FontWeight.w600)),
              const Spacer(),
              Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.grey.withOpacity(0.4), size: 14),
            ])),
      ),
    );
  }

  void _showTicketDialog(bool isDark) {
    final ctrl = TextEditingController();
    final bg = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    String selectedType = 'GENERAL';
    final types = {
      'GENERAL': 'استفسار عام',
      'TECHNICAL': 'مشكلة تقنية',
      'BILLING': 'مشكلة في الفوترة',
      'OTHER': 'أخرى',
    };
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            backgroundColor: bg,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text('رسالة للإدارة',
                style: TextStyle(color: textC, fontWeight: FontWeight.w800)),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                dropdownColor: bg,
                style: TextStyle(color: textC, fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'نوع المشكلة',
                  labelStyle: TextStyle(color: AppColors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.goldenBronze)),
                ),
                items: types.entries
                    .map((e) =>
                        DropdownMenuItem(value: e.key, child: Text(e.value)))
                    .toList(),
                onChanged: (v) => setDialogState(() => selectedType = v!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                maxLines: 4,
                style: TextStyle(color: textC),
                decoration: InputDecoration(
                  hintText: 'اكتب التفاصيل هنا...',
                  hintStyle: TextStyle(color: AppColors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.goldenBronze)),
                ),
              ),
            ]),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('إلغاء', style: TextStyle(color: AppColors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.goldenBronze,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  if (ctrl.text.trim().isEmpty) return;
                  Navigator.pop(context);
                  try {
                    final api = ApiService();
                    await api.post(ApiConstants.tickets, body: {
                      'issue_type': selectedType,
                      'description': ctrl.text.trim(),
                    });
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('تم إرسال رسالتك بنجاح'),
                            backgroundColor: Color(0xFF4CAF50)),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('فشل الإرسال: $e'),
                            backgroundColor: AppColors.error),
                      );
                    }
                  }
                },
                child:
                    const Text('إرسال', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReportDialog(bool isDark) {
    final ctrl = TextEditingController();
    final bg = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    String selectedType = 'SPAM';
    final types = {
      'MISLEADING': 'معلومات مضللة',
      'OFFENSIVE': 'محتوى مسيء',
      'SPAM': 'محتوى مزعج',
      'INAPPROPRIATE': 'محتوى غير لائق',
      'FRAUD': 'احتيال',
      'OTHER': 'أخرى',
    };
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            backgroundColor: bg,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text('الإبلاغ عن مشكلة',
                style: TextStyle(color: textC, fontWeight: FontWeight.w800)),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                dropdownColor: bg,
                style: TextStyle(color: textC, fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'نوع البلاغ',
                  labelStyle: TextStyle(color: AppColors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.goldenBronze)),
                ),
                items: types.entries
                    .map((e) =>
                        DropdownMenuItem(value: e.key, child: Text(e.value)))
                    .toList(),
                onChanged: (v) => setDialogState(() => selectedType = v!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                maxLines: 4,
                style: TextStyle(color: textC),
                decoration: InputDecoration(
                  hintText: 'تفاصيل إضافية (اختياري)...',
                  hintStyle: TextStyle(color: AppColors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.goldenBronze)),
                ),
              ),
            ]),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('إلغاء', style: TextStyle(color: AppColors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    final api = ApiService();
                    final body = <String, dynamic>{
                      'product_id': int.tryParse(_productId) ?? 0,
                      'report_type': 'OFFER',
                      'reason': selectedType,
                    };
                    if (ctrl.text.trim().isNotEmpty) {
                      body['description'] = ctrl.text.trim();
                    }
                    await api.post(ApiConstants.reports, body: body);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('تم إرسال البلاغ بنجاح'),
                            backgroundColor: Color(0xFF4CAF50)),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('فشل الإرسال: $e'),
                            backgroundColor: AppColors.error),
                      );
                    }
                  }
                },
                child:
                    const Text('إبلاغ', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// شاشة عرض الصورة بالحجم الكامل
// ==========================================
class _FullScreenViewer extends StatefulWidget {
  final List<String> images;
  final int initial;
  final bool isLocal;
  const _FullScreenViewer(
      {required this.images, required this.initial, this.isLocal = false});
  @override
  State<_FullScreenViewer> createState() => _FullScreenViewerState();
}

class _FullScreenViewerState extends State<_FullScreenViewer> {
  late int _current;
  @override
  void initState() {
    super.initState();
    _current = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text("${_current + 1} / ${widget.images.length}",
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            centerTitle: true),
        body: PageView.builder(
            itemCount: widget.images.length,
            controller: PageController(initialPage: widget.initial),
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) => InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Center(
                    child:
                        widget.isLocal && !widget.images[i].startsWith("http")
                            ? Image.asset(widget.images[i], fit: BoxFit.contain)
                            : Image.network(widget.images[i],
                                fit: BoxFit.contain)))));
  }
}
