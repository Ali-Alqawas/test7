import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../details/merchant_profile_screen.dart';

// ============================================================================
// شاشة جميع المتاجر (All Stores Screen)
// ============================================================================
class AllStoresScreen extends StatefulWidget {
  const AllStoresScreen({super.key});

  @override
  State<AllStoresScreen> createState() => _AllStoresScreenState();
}

class _AllStoresScreenState extends State<AllStoresScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _stores = [
    {
      "name": "آبل ستور",
      "logo": "https://i.pravatar.cc/150?img=15",
      "category": "إلكترونيات",
      "rating": 4.8,
      "offers": 32
    },
    {
      "name": "نايك ستور",
      "logo": "https://i.pravatar.cc/150?img=33",
      "category": "أزياء رجالية",
      "rating": 4.5,
      "offers": 18
    },
    {
      "name": "زارا",
      "logo": "https://i.pravatar.cc/150?img=34",
      "category": "أزياء نسائية",
      "rating": 4.6,
      "offers": 45
    },
    {
      "name": "اكسترا",
      "logo": "https://i.pravatar.cc/150?img=11",
      "category": "إلكترونيات",
      "rating": 4.3,
      "offers": 67
    },
    {
      "name": "ساكو",
      "logo": "https://i.pravatar.cc/150?img=12",
      "category": "أجهزة منزلية",
      "rating": 4.2,
      "offers": 23
    },
    {
      "name": "سنتربوينت",
      "logo": "https://i.pravatar.cc/150?img=13",
      "category": "أزياء",
      "rating": 4.4,
      "offers": 55
    },
    {
      "name": "العربية للعود",
      "logo": "https://i.pravatar.cc/150?img=14",
      "category": "عطور",
      "rating": 4.7,
      "offers": 12
    },
    {
      "name": "مغربي للبصريات",
      "logo": "https://i.pravatar.cc/150?img=16",
      "category": "إكسسوارات",
      "rating": 4.1,
      "offers": 8
    },
    {
      "name": "جرير",
      "logo": "https://i.pravatar.cc/150?img=17",
      "category": "إلكترونيات",
      "rating": 4.6,
      "offers": 41
    },
    {
      "name": "باث آند بودي",
      "logo": "https://i.pravatar.cc/150?img=18",
      "category": "صحة وجمال",
      "rating": 4.5,
      "offers": 15
    },
    {
      "name": "لولو هايبر",
      "logo": "https://i.pravatar.cc/150?img=19",
      "category": "سوبرماركت",
      "rating": 4.0,
      "offers": 92
    },
    {
      "name": "ايكيا",
      "logo": "https://i.pravatar.cc/150?img=20",
      "category": "أثاث ومنزل",
      "rating": 4.4,
      "offers": 38
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    if (_searchController.text.isEmpty) return _stores;
    final q = _searchController.text.toLowerCase();
    return _stores
        .where((s) =>
            (s["name"] as String).toLowerCase().contains(q) ||
            (s["category"] as String).toLowerCase().contains(q))
        .toList();
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 10, bottom: 100),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) =>
                        _buildStoreCard(_filtered[i], isDark, textC, cardC),
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
                  onTap: () => _searchController.clear(),
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

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MerchantProfileScreen(
                  storeName: store["name"], storeLogo: store["logo"]))),
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
                backgroundImage: NetworkImage(store["logo"]),
              ),
            ),
            const SizedBox(height: 12),
            // الاسم
            Text(store["name"],
                style: TextStyle(
                    color: textC, fontSize: 14, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center),
            const SizedBox(height: 4),
            // التصنيف
            Text(store["category"],
                style: TextStyle(
                    color: AppColors.goldenBronze.withOpacity(0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            // التقييم + عدد العروض
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.star_rounded,
                  color: AppColors.goldenBronze, size: 14),
              const SizedBox(width: 3),
              Text("${store["rating"]}",
                  style: const TextStyle(
                      color: AppColors.goldenBronze,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Icon(Icons.local_offer_outlined,
                  color: textC.withOpacity(0.4), size: 13),
              const SizedBox(width: 3),
              Text("${store["offers"]} عرض",
                  style: TextStyle(
                      color: textC.withOpacity(0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ]),
          ],
        ),
      ),
    );
  }
}
