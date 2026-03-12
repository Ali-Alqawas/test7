import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_service.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../core/widgets/offer_action_buttons.dart';
import '../details/offer_details_screen.dart';
import '../details/merchant_profile_screen.dart';

// ============================================================================
// شاشة البحث الشاملة — بحث حي في المنتجات + الباقات + المتاجر
// ============================================================================
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _api = ApiService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  Timer? _debounce;

  // ── حالات ──
  bool _hasSearched = false;
  bool _loadingResults = false;
  bool _loadingTags = true;

  // ── بيانات ──
  List<String> _recentSearches = [];
  List<String> _popularTags = [];

  // ── نتائج مقسمة حسب النوع ──
  List<Map<String, dynamic>> _productResults = [];
  List<Map<String, dynamic>> _bundleResults = [];
  List<Map<String, dynamic>> _storeResults = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _fetchPopularTags();

    // فتح الكيبورد
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ============================================================
  //  البحث الأخير (SharedPreferences)
  // ============================================================
  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(
          () => _recentSearches = prefs.getStringList('recent_searches') ?? []);
    }
  }

  Future<void> _saveRecentSearch(String term) async {
    if (term.trim().isEmpty) return;
    _recentSearches.remove(term);
    _recentSearches.insert(0, term);
    if (_recentSearches.length > 10)
      _recentSearches = _recentSearches.sublist(0, 10);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_searches', _recentSearches);
  }

  Future<void> _clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_searches', []);
    if (mounted) setState(() => _recentSearches = []);
  }

  void _removeRecentSearch(String term) async {
    _recentSearches.remove(term);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_searches', _recentSearches);
    if (mounted) setState(() {});
  }

  // ============================================================
  //  الكلمات الشائعة
  // ============================================================
  Future<void> _fetchPopularTags() async {
    try {
      final data = await _api.get(ApiConstants.popularTags);
      final List tags = data is List
          ? data
          : (data is Map ? (data['results'] ?? data['tags'] ?? []) : []);
      if (mounted) {
        setState(() {
          _popularTags = tags
              .map<String>(
                  (t) => t is String ? t : (t['name'] ?? '').toString())
              .where((t) => t.isNotEmpty)
              .toList();
          _loadingTags = false;
        });
      }
    } catch (e) {
      debugPrint('خطأ في جلب الكلمات الشائعة: $e');
      if (mounted) setState(() => _loadingTags = false);
    }
  }

  // ============================================================
  //  البحث الحي الشامل
  // ============================================================
  void _onSearchChanged(String val) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    // تحديث UI فوراً (زر X)
    setState(() {});

    final q = val.trim();
    if (q.isEmpty) {
      setState(() {
        _hasSearched = false;
        _productResults = [];
        _bundleResults = [];
        _storeResults = [];
      });
      return;
    }

    // بحث حي بعد 300ms
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _performSearch(q);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _loadingResults = true;
      _hasSearched = true;
    });

    // بحث متوازي: منتجات + باقات + متاجر
    await Future.wait([
      _searchProducts(query),
      _searchBundles(query),
      _searchStores(query),
    ]);

    if (mounted) {
      // حفظ فقط إذا 3+ حروف وفيه نتائج
      final hasResults = _productResults.isNotEmpty ||
          _bundleResults.isNotEmpty ||
          _storeResults.isNotEmpty;
      if (query.length >= 3 && hasResults) {
        _saveRecentSearch(query);
      }
      setState(() => _loadingResults = false);
    }
  }

  // ── بحث المنتجات ──
  Future<void> _searchProducts(String query) async {
    try {
      final data = await _api.get(
        ApiConstants.products,
        queryParams: {'search': query},
      );
      final List raw =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);
      if (mounted) {
        setState(() {
          _productResults =
              raw.map<Map<String, dynamic>>((p) => _mapProduct(p)).toList();
        });
      }
    } catch (e) {
      debugPrint('خطأ بحث المنتجات: $e');
      if (mounted) setState(() => _productResults = []);
    }
  }

  // ── بحث الباقات ──
  Future<void> _searchBundles(String query) async {
    try {
      final data = await _api.get(
        ApiConstants.productGroups,
        queryParams: {'search': query},
        requiresAuth: false,
      );
      final List raw =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);
      if (mounted) {
        setState(() {
          _bundleResults = raw
              .where((b) {
                final name = (b['name'] ?? '').toString().toLowerCase();
                return name.contains(query.toLowerCase());
              })
              .map<Map<String, dynamic>>((b) => _mapBundle(b))
              .toList();
        });
      }
    } catch (e) {
      debugPrint('خطأ بحث الباقات: $e');
      if (mounted) setState(() => _bundleResults = []);
    }
  }

  // ── بحث المتاجر ──
  Future<void> _searchStores(String query) async {
    try {
      final data = await _api.get(
        ApiConstants.stores,
        queryParams: {'search': query},
      );
      final List raw =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);
      if (mounted) {
        setState(() {
          _storeResults = raw
              .map<Map<String, dynamic>>((s) => Map<String, dynamic>.from(s))
              .toList();
        });
      }
    } catch (e) {
      debugPrint('خطأ بحث المتاجر: $e');
      if (mounted) setState(() => _storeResults = []);
    }
  }

  // ============================================================
  //  تحويل بيانات المنتج → صيغة الكرت
  // ============================================================
  Map<String, dynamic> _mapProduct(Map<String, dynamic> p) {
    var images = p['images'] as List?;
    String imageUrl = (images != null && images.isNotEmpty)
        ? ApiConstants.resolveImageUrl(images[0] is Map
            ? images[0]['image_url']?.toString()
            : images[0]?.toString())
        : ApiConstants.resolveImageUrl(
            p['image']?.toString() ?? p['thumbnail']?.toString());

    String storeName = (p['store_name'] ?? p['store'] ?? 'متجر').toString();
    String storeLogo = p['store_logo'] != null
        ? ApiConstants.resolveImageUrl(p['store_logo'].toString())
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(storeName)}&background=random&color=fff';

    double price = double.tryParse(p['price']?.toString() ?? '0') ?? 0;
    double oldPrice = double.tryParse(p['old_price']?.toString() ?? '0') ?? 0;

    return {
      "id": (p['product_id'] ?? p['id'] ?? '').toString(),
      "title": p['title'] ?? 'بدون عنوان',
      "storeName": storeName,
      "storeLogo": storeLogo,
      "image": imageUrl,
      "price": "${price.toStringAsFixed(price == price.toInt() ? 0 : 2)}\$",
      "oldPrice": oldPrice > 0 ? "${oldPrice.toInt()}\$" : "",
      "isFeatured": p['is_featured'] ?? false,
      "offerType": (p['offer_type'] ?? 'Individual').toString(),
      "original_data": p,
    };
  }

  // ============================================================
  //  تحويل بيانات الباقة → صيغة الكرت (نفس premium_bundled_offers)
  // ============================================================
  Map<String, dynamic> _mapBundle(Map<String, dynamic> b) {
    String storeName = b['store_name']?.toString().trim() ?? '';
    if (storeName.isEmpty &&
        b['products'] is List &&
        (b['products'] as List).isNotEmpty) {
      storeName = b['products'][0]['store_name']?.toString().trim() ?? 'متجر';
    }
    if (storeName.isEmpty || storeName == 'null') storeName = 'متجر';

    double bundlePrice = double.tryParse(b['price']?.toString() ?? '0') ?? 0;
    double sumOfIndividualPrices = 0;
    List<String> images = [];

    if (b['products'] is List) {
      for (var p in b['products']) {
        double pPrice = double.tryParse(p['price']?.toString() ?? '0') ?? 0;
        sumOfIndividualPrices += pPrice;
        if (p['images'] is List && (p['images'] as List).isNotEmpty) {
          images.add(ApiConstants.resolveImageUrl(
              p['images'][0]['image_url']?.toString()));
        } else if (p['image'] != null) {
          images.add(ApiConstants.resolveImageUrl(p['image'].toString()));
        }
      }
    }
    if (images.isEmpty && b['image_url'] != null) {
      images.add(ApiConstants.resolveImageUrl(b['image_url'].toString()));
    }
    if (images.isEmpty)
      images.add('https://placehold.co/400x400/png?text=Bundle');

    double saving = 0;
    double displayOldPrice = 0;
    if (sumOfIndividualPrices > bundlePrice && bundlePrice > 0) {
      saving = sumOfIndividualPrices - bundlePrice;
      displayOldPrice = sumOfIndividualPrices;
    }

    return {
      "id": (b['group_id'] ?? b['id'] ?? '').toString(),
      "title": b['name']?.toString() ?? 'باقة',
      "store": storeName,
      "storeName": storeName,
      "storeLogo": b['store_logo'] != null
          ? ApiConstants.resolveImageUrl(b['store_logo'].toString())
          : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(storeName)}&background=B8860B&color=fff',
      "price": bundlePrice > 0 ? "${bundlePrice.toInt()}\$" : "0\$",
      "oldPrice": displayOldPrice > 0 ? "${displayOldPrice.toInt()}\$" : "",
      "saving": saving > 0 ? "وفر ${saving.toInt()}\$" : "",
      "images": images,
      "isLocalImage": false,
      "original_data": b,
    };
  }

  // ============================================================
  //  تحديد نوع العرض
  // ============================================================
  OfferDetailType _resolveOfferType(String type) {
    final t = type.toLowerCase();
    if (t == 'featured') return OfferDetailType.featured;
    if (t == 'bundle' || t == 'bundled') return OfferDetailType.bundled;
    if (t == 'brochure') return OfferDetailType.brochure;
    return OfferDetailType.standard;
  }

  // ============================================================
  //  البناء الرئيسي
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? AppColors.deepNavy : AppColors.lightBackground;
    final Color textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    final Color cardC = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
    final Color borderC = isDark
        ? AppColors.goldenBronze.withOpacity(0.15)
        : Colors.grey.shade200;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: Column(children: [
            _buildSearchBar(isDark, textC, cardC),
            Expanded(
              child: _hasSearched
                  ? _buildSearchResults(isDark, textC, cardC, borderC)
                  : _buildDefaultContent(isDark, textC, cardC),
            ),
          ]),
        ),
      ),
    );
  }

  // ============================================================
  //  شريط البحث
  // ============================================================
  Widget _buildSearchBar(bool isDark, Color textC, Color cardC) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cardC,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: isDark
                      ? AppColors.goldenBronze.withOpacity(0.3)
                      : Colors.grey.shade300),
            ),
            child:
                Icon(Icons.arrow_forward_ios_rounded, color: textC, size: 18),
          ),
        ),
        const SizedBox(width: 10),
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
                  color: isDark ? AppColors.warmBeige : AppColors.goldenBronze,
                  size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocus,
                  style: TextStyle(color: textC, fontSize: 14),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (q) {
                    final trimmed = q.trim();
                    if (trimmed.isNotEmpty) {
                      _searchFocus.unfocus();
                      _performSearch(trimmed);
                    }
                  },
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: "ابحث عن منتج، متجر، أو باقة...",
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
                  onTap: () {
                    _searchController.clear();
                    setState(() {
                      _hasSearched = false;
                      _productResults = [];
                      _bundleResults = [];
                      _storeResults = [];
                    });
                    _searchFocus.requestFocus();
                  },
                  child: const Icon(Icons.close_rounded,
                      color: AppColors.grey, size: 18),
                ),
            ]),
          ),
        ),
        const SizedBox(width: 10),
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
      ]),
    );
  }

  // ============================================================
  //  المحتوى الافتراضي (قبل البحث)
  // ============================================================
  Widget _buildDefaultContent(bool isDark, Color textC, Color cardC) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── بحث أخير ──
        if (_recentSearches.isNotEmpty) ...[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("عمليات البحث الأخيرة",
                style: TextStyle(
                    color: textC, fontSize: 16, fontWeight: FontWeight.w800)),
            GestureDetector(
              onTap: _clearRecentSearches,
              child: Text("مسح الكل",
                  style: TextStyle(
                      color: AppColors.goldenBronze.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 12),
          ..._recentSearches.map((term) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    _searchController.text = term;
                    _performSearch(term);
                  },
                  child: Row(children: [
                    Icon(Icons.history_rounded,
                        color: AppColors.grey.withOpacity(0.5), size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(term,
                            style: TextStyle(
                                color: textC.withOpacity(0.8), fontSize: 14))),
                    GestureDetector(
                      onTap: () => _removeRecentSearch(term),
                      child: Icon(Icons.close_rounded,
                          color: AppColors.grey.withOpacity(0.4), size: 16),
                    ),
                  ]),
                ),
              )),
          const SizedBox(height: 25),
        ],

        // ── الأكثر بحثاً ──
        Text("الأكثر بحثاً 🔥",
            style: TextStyle(
                color: textC, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        if (_loadingTags)
          const Center(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(
                      color: AppColors.goldenBronze, strokeWidth: 2)))
        else if (_popularTags.isEmpty)
          Padding(
              padding: const EdgeInsets.all(20),
              child: Text("لا توجد كلمات شائعة",
                  style:
                      TextStyle(color: textC.withOpacity(0.4), fontSize: 13)))
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popularTags
                .map((tag) => GestureDetector(
                      onTap: () {
                        _searchController.text = tag;
                        _performSearch(tag);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: cardC,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.goldenBronze.withOpacity(0.3)),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.local_fire_department_rounded,
                              color: AppColors.goldenBronze, size: 16),
                          const SizedBox(width: 6),
                          Text(tag,
                              style: TextStyle(
                                  color: textC,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ]),
                      ),
                    ))
                .toList(),
          ),
      ]),
    );
  }

  // ============================================================
  //  نتائج البحث (مقسمة حسب النوع)
  // ============================================================
  Widget _buildSearchResults(
      bool isDark, Color textC, Color cardC, Color borderC) {
    if (_loadingResults &&
        _productResults.isEmpty &&
        _bundleResults.isEmpty &&
        _storeResults.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(
              color: AppColors.goldenBronze, strokeWidth: 2));
    }

    final int totalCount =
        _productResults.length + _bundleResults.length + _storeResults.length;

    if (totalCount == 0 && !_loadingResults) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.search_off_rounded,
              color: textC.withOpacity(0.15), size: 64),
          const SizedBox(height: 16),
          Text("لا توجد نتائج",
              style: TextStyle(
                  color: textC.withOpacity(0.5),
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text("جرّب كلمات بحث مختلفة",
              style: TextStyle(color: textC.withOpacity(0.3), fontSize: 13)),
        ]),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── عداد النتائج ──
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Row(children: [
            Text("$totalCount نتيجة",
                style: TextStyle(
                    color: textC.withOpacity(0.5),
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
            if (_loadingResults) ...[
              const SizedBox(width: 8),
              const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                      color: AppColors.goldenBronze, strokeWidth: 1.5)),
            ],
          ]),
        ),

        // ── 🏪 المتاجر ──
        if (_storeResults.isNotEmpty) ...[
          _buildSectionHeader("المتاجر 🏪", _storeResults.length, textC),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _storeResults.length,
              itemBuilder: (_, i) =>
                  _buildStoreCard(_storeResults[i], isDark, textC),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // ── 📦 الباقات ──
        if (_bundleResults.isNotEmpty) ...[
          _buildSectionHeader("باقات التوفير 📦", _bundleResults.length, textC),
          SizedBox(
            height: 168,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              itemCount: _bundleResults.length,
              itemBuilder: (_, i) =>
                  _buildBundleCard(_bundleResults[i], isDark),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // ── 🛍️ العروض ──
        if (_productResults.isNotEmpty) ...[
          _buildSectionHeader("العروض 🛍️", _productResults.length, textC),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              itemCount: _productResults.length,
              itemBuilder: (_, i) =>
                  _buildProductCard(_productResults[i], isDark),
            ),
          ),
        ],
      ]),
    );
  }

  // ── عنوان القسم ──
  Widget _buildSectionHeader(String title, int count, Color textC) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Row(children: [
        Text(title,
            style: TextStyle(
                color: textC, fontSize: 15, fontWeight: FontWeight.w800)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.goldenBronze.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text("$count",
              style: const TextStyle(
                  color: AppColors.goldenBronze,
                  fontSize: 11,
                  fontWeight: FontWeight.bold)),
        ),
      ]),
    );
  }

  // ============================================================
  //  🏪 كرت المتجر
  // ============================================================
  Widget _buildStoreCard(Map<String, dynamic> store, bool isDark, Color textC) {
    final String name = (store['name'] ?? 'متجر').toString();
    final String location = (store['location'] ?? '').toString();
    final String? logoUrl = store['logo']?.toString();
    final String logo = (logoUrl != null &&
            logoUrl.isNotEmpty &&
            logoUrl != 'null')
        ? ApiConstants.resolveImageUrl(logoUrl)
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=B8860B&color=fff';
    final double rating =
        double.tryParse(store['average_rating']?.toString() ?? '0') ?? 0;

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                MerchantProfileScreen(storeName: name, storeLogo: logo),
          )),
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(left: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.deepNavy : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isDark
                  ? AppColors.goldenBronze.withOpacity(0.3)
                  : Colors.grey.shade200),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3)),
          ],
        ),
        child: Row(children: [
          CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.lightBackground,
              backgroundImage: NetworkImage(logo)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name,
                      style: TextStyle(
                          color: textC,
                          fontSize: 13,
                          fontWeight: FontWeight.w800),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  if (location.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(location,
                        style: TextStyle(
                            color: textC.withOpacity(0.5), fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                  if (rating > 0) ...[
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.star_rounded,
                          color: AppColors.goldenBronze, size: 14),
                      const SizedBox(width: 2),
                      Text(rating.toStringAsFixed(1),
                          style: const TextStyle(
                              color: AppColors.goldenBronze,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ]),
                  ],
                ]),
          ),
        ]),
      ),
    );
  }

  // ============================================================
  //  📦 كرت الباقة — نفس premium_bundled_offers._buildBundleCard
  // ============================================================
  Widget _buildBundleCard(Map<String, dynamic> bundle, bool isDark) {
    final Color cardBg = isDark ? AppColors.deepNavy : AppColors.pureWhite;
    final Color borderColor =
        isDark ? AppColors.goldenBronze.withOpacity(0.3) : Colors.grey.shade200;

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OfferDetailsScreen(
                offerData: bundle, offerType: OfferDetailType.bundled),
          )),
      child: Container(
        width: 330,
        height: 160,
        margin: const EdgeInsets.only(left: 15, bottom: 8),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                  color: AppColors.goldenBronze.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 5)),
          ],
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
              child: _buildDynamicCollage(
                  (bundle["images"] as List).cast<String>(),
                  isDark ? AppColors.deepNavy : Colors.white),
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
                            color: isDark
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
                        child: CircleAvatar(
                            radius: 9,
                            backgroundColor: AppColors.lightBackground,
                            backgroundImage: NetworkImage(bundle["storeLogo"])),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                          child: Text(
                              bundle["store"] ?? bundle["storeName"] ?? "متجر",
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
                              isDarkMode: isDark,
                              offerId: (bundle["id"] ?? "").toString(),
                              isGroup: true),
                        ]),
                  ]),
            ),
          ),
        ]),
      ),
    );
  }

  // ============================================================
  //  🛍️ كرت المنتج — نفس premium_standard_offer_card._buildStandardCard
  // ============================================================
  Widget _buildProductCard(Map<String, dynamic> offer, bool isDark) {
    final Color cardColor = isDark ? AppColors.deepNavy : AppColors.pureWhite;
    final Color borderColor =
        isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200;

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OfferDetailsScreen(
              offerData: offer["original_data"] ?? offer,
              offerType: _resolveOfferType(offer["offerType"] ?? "Individual"),
            ),
          )),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(left: 15, bottom: 10),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Stack(fit: StackFit.expand, children: [
                Image.network(offer["image"],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported,
                            color: Colors.grey))),
                // لوقو المتجر
                Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.deepNavy : Colors.white,
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
                                  storeLogo: offer["storeLogo"]),
                            )),
                        child: CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.lightBackground,
                            backgroundImage: NetworkImage(offer["storeLogo"])),
                      ),
                    )),
                // بادج مميز
                if (offer["isFeatured"] == true)
                  Positioned(
                      top: 8,
                      left: 8,
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
                                fontWeight: FontWeight.bold)),
                      )),
              ]),
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
                                storeLogo: offer["storeLogo"]),
                          )),
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
                            color: isDark
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(offer["price"],
                                    style: const TextStyle(
                                        color: AppColors.goldenBronze,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900)),
                                if ((offer["oldPrice"] ?? '')
                                    .toString()
                                    .isNotEmpty)
                                  Text(offer["oldPrice"],
                                      style: const TextStyle(
                                          color: AppColors.grey,
                                          fontSize: 10,
                                          decoration:
                                              TextDecoration.lineThrough)),
                              ]),
                          OfferActionButtons(
                              isDarkMode: isDark,
                              offerId: offer["id"]?.toString() ?? ''),
                        ]),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }

  // ============================================================
  //  كولاج الصور الديناميكي — نفس premium_bundled_offers
  // ============================================================
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

    if (count == 1) return imageBox(images[0]);
    if (count == 2) {
      return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(child: imageBox(images[0])),
        Expanded(child: imageBox(images[1]))
      ]);
    }
    if (count == 3) {
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
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Expanded(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(child: imageBox(images[0])),
        Expanded(child: imageBox(images[1]))
      ])),
      Expanded(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                          fontSize: 18)),
                )),
        ])),
      ])),
    ]);
  }
}
