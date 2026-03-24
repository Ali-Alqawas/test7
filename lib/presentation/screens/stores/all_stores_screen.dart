import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../core/network/api_service.dart';
import '../../../core/network/api_constants.dart';
import '../details/merchant_profile_screen.dart';

// ============================================================================
// شاشة جميع المتاجر (All Stores Screen) — مربوطة بالـ API
// ============================================================================
class AllStoresScreen extends StatefulWidget {
  const AllStoresScreen({super.key});

  @override
  State<AllStoresScreen> createState() => _AllStoresScreenState();
}

class _AllStoresScreenState extends State<AllStoresScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _api = ApiService();

  List<Map<String, dynamic>> _stores = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchStores();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final q = _searchController.text.trim();
    if (q != _searchQuery) {
      _searchQuery = q;
      _fetchStores();
    }
  }

  Future<void> _fetchStores() async {
    setState(() => _isLoading = true);
    try {
      final params = <String, String>{'page_size': '50'};
      if (_searchQuery.isNotEmpty) params['search'] = _searchQuery;
      params['ordering'] = '-average_rating';

      final data = await _api.get(
        ApiConstants.stores,
        queryParams: params,
        requiresAuth: false,
      );

      final List raw =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);

      if (mounted) {
        setState(() {
          _stores = raw.cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('خطأ جلب المتاجر: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.deepNavy : AppColors.lightBackground;
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    final cardC = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(isDark, textC, cardC),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.goldenBronze))
                    : _stores.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.store_mall_directory_outlined,
                                    color: textC.withOpacity(0.3), size: 60),
                                const SizedBox(height: 12),
                                Text("لا توجد متاجر",
                                    style: TextStyle(
                                        color: textC.withOpacity(0.5),
                                        fontSize: 16)),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            color: AppColors.goldenBronze,
                            onRefresh: _fetchStores,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: GridView.builder(
                                physics: const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics()),
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 100),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 14,
                                  crossAxisSpacing: 14,
                                  childAspectRatio: 0.85,
                                ),
                                itemCount: _stores.length,
                                itemBuilder: (_, i) => _buildStoreCard(
                                    _stores[i], isDark, textC, cardC),
                              ),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, Color textC, Color cardC) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                        isDark ? const Color(0xFF072A38) : AppColors.pureWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: isDark
                            ? AppColors.goldenBronze.withOpacity(0.3)
                            : Colors.grey.shade300),
                  ),
                  child: Icon(Icons.arrow_forward_ios_rounded,
                      color: textC, size: 18),
                ),
              ),
              const SizedBox(width: 12),
              Text("المتاجر 🏪",
                  style: TextStyle(
                      color: textC, fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(width: 8),
              if (!_isLoading)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.goldenBronze.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.goldenBronze.withOpacity(0.3)),
                  ),
                  child: Text("${_stores.length} متجر",
                      style: const TextStyle(
                          color: AppColors.goldenBronze,
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
            ],
          ),
          const SizedBox(height: 14),
          // شريط بحث
          Container(
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
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: textC, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "ابحث عن متجر...",
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
                    _searchQuery = '';
                    _fetchStores();
                  },
                  child: const Icon(Icons.close_rounded,
                      color: AppColors.grey, size: 18),
                ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(
      Map<String, dynamic> store, bool isDark, Color textC, Color cardC) {
    final borderC =
        isDark ? AppColors.goldenBronze.withOpacity(0.2) : Colors.grey.shade200;

    final String name = store['name'] ?? 'متجر';
    final String storeId = (store['store_id'] ?? store['id'] ?? '').toString();
    final String logo = store['logo'] != null &&
            store['logo'].toString().isNotEmpty
        ? ApiConstants.resolveImageUrl(store['logo'].toString())
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=random&color=fff';
    final String activityType = _activityLabel(store['activity_type']);
    final double rating =
        double.tryParse(store['average_rating']?.toString() ?? '0') ?? 0;
    final bool isVerified = store['verification_status'] == 'VERIFIED';

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MerchantProfileScreen(
                  storeId: storeId, storeName: name, storeLogo: logo))),
      child: Container(
        decoration: BoxDecoration(
          color: cardC,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderC, width: 1.2),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                blurRadius: 12,
                offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الشعار
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.goldenBronze.withOpacity(0.5), width: 2),
              ),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.lightBackground,
                backgroundImage: NetworkImage(logo),
              ),
            ),
            const SizedBox(height: 12),
            // الاسم + التوثيق
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(name,
                      style: TextStyle(
                          color: textC,
                          fontSize: 14,
                          fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                if (isVerified) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.all(1.5),
                    decoration: const BoxDecoration(
                        color: Color(0xFF1DA1F2), shape: BoxShape.circle),
                    child:
                        const Icon(Icons.check, color: Colors.white, size: 10),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            // التصنيف
            Text(activityType,
                style: TextStyle(
                    color: AppColors.goldenBronze.withOpacity(0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            // التقييم
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.star_rounded,
                  color: AppColors.goldenBronze, size: 14),
              const SizedBox(width: 3),
              Text(rating > 0 ? rating.toStringAsFixed(1) : "—",
                  style: const TextStyle(
                      color: AppColors.goldenBronze,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ]),
          ],
        ),
      ),
    );
  }

  String _activityLabel(String? type) {
    switch (type) {
      case 'RETAIL':
        return 'تجزئة';
      case 'SERVICE':
        return 'خدمات';
      case 'FOOD':
        return 'مطاعم ومشروبات';
      case 'OTHER':
        return 'أخرى';
      default:
        return 'متجر';
    }
  }
}
