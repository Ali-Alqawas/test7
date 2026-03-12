import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../core/widgets/offer_action_buttons.dart';
import '../details/offer_details_screen.dart';

// ============================================================================
// شاشة عروض البنرات الإعلانية (Banner Offers Screen)
// ============================================================================
class BannerOffersScreen extends StatefulWidget {
  const BannerOffersScreen({super.key});

  @override
  State<BannerOffersScreen> createState() => _BannerOffersScreenState();
}

class _BannerOffersScreenState extends State<BannerOffersScreen> {
  final TextEditingController _searchController = TextEditingController();

  // منتجات عروض البنرات فقط
  static final List<Map<String, dynamic>> _bannerProducts = [
    {
      "title": "جاكيت جلد فاخر",
      "storeName": "زارا",
      "storeLogo": "https://i.pravatar.cc/150?img=20",
      "image":
          "https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&w=500&q=80",
      "price": "85\$",
      "oldPrice": "170\$",
      "discount": "50%",
      "category": "أزياء",
    },
    {
      "title": "فستان سهرة أنيق",
      "storeName": "اتش اند ام",
      "storeLogo": "https://i.pravatar.cc/150?img=21",
      "image":
          "https://images.unsplash.com/photo-1595777457583-95e059d581b8?auto=format&fit=crop&w=500&q=80",
      "price": "65\$",
      "oldPrice": "130\$",
      "discount": "50%",
      "category": "أزياء",
    },
    {
      "title": "وجبة سوشي فاخرة",
      "storeName": "مطاعم الذواقة",
      "storeLogo": "https://i.pravatar.cc/150?img=22",
      "image":
          "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=500&q=80",
      "price": "35\$",
      "oldPrice": "70\$",
      "discount": "50%",
      "category": "مطاعم",
    },
    {
      "title": "آيفون 15 برو ماكس",
      "storeName": "موبايل زون",
      "storeLogo": "https://i.pravatar.cc/150?img=23",
      "image":
          "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=500&q=80",
      "price": "899\$",
      "oldPrice": "1199\$",
      "discount": "25%",
      "category": "إلكترونيات",
    },
    {
      "title": "حقيبة يد نسائية",
      "storeName": "سنتربوينت",
      "storeLogo": "https://i.pravatar.cc/150?img=24",
      "image":
          "https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=500&q=80",
      "price": "45\$",
      "oldPrice": "90\$",
      "discount": "50%",
      "category": "أزياء",
    },
    {
      "title": "بيتزا عائلية مع مشروبات",
      "storeName": "بيتزا هت",
      "storeLogo": "https://i.pravatar.cc/150?img=25",
      "image":
          "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=500&q=80",
      "price": "25\$",
      "oldPrice": "50\$",
      "discount": "50%",
      "category": "مطاعم",
    },
    {
      "title": "سماعة بلوتوث JBL",
      "storeName": "اكسترا",
      "storeLogo": "https://i.pravatar.cc/150?img=11",
      "image":
          "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=500&q=80",
      "price": "60\$",
      "oldPrice": "120\$",
      "discount": "50%",
      "category": "إلكترونيات",
    },
    {
      "title": "نظارة شمسية Gucci",
      "storeName": "مغربي للبصريات",
      "storeLogo": "https://i.pravatar.cc/150?img=12",
      "image":
          "https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&w=500&q=80",
      "price": "110\$",
      "oldPrice": "220\$",
      "discount": "50%",
      "category": "إكسسوارات",
    },
  ];

  late List<Map<String, dynamic>> _displayedOffers;

  @override
  void initState() {
    super.initState();
    _displayedOffers = List.from(_bannerProducts)..shuffle();
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _displayedOffers = List.from(_bannerProducts);
      } else {
        _displayedOffers = _bannerProducts.where((o) {
          return o["title"].toString().toLowerCase().contains(query) ||
              o["storeName"].toString().toLowerCase().contains(query) ||
              o["category"].toString().toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor =
        isDarkMode ? AppColors.deepNavy : AppColors.lightBackground;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isDarkMode),
              Expanded(
                child: _displayedOffers.isEmpty
                    ? _buildEmptyState(isDarkMode)
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 5, 16, 100),
                        itemCount: _displayedOffers.length,
                        itemBuilder: (context, index) {
                          return _buildOfferCard(
                              _displayedOffers[index], isDarkMode);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 60, color: AppColors.goldenBronze.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text("لا توجد نتائج",
              style: TextStyle(
                  color: isDarkMode ? AppColors.pureWhite : AppColors.lightText,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text("جرب البحث بكلمات مختلفة",
              style: TextStyle(color: AppColors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    final Color textColor =
        isDarkMode ? AppColors.pureWhite : AppColors.lightText;
    final Color cardColor =
        isDarkMode ? const Color(0xFF072A38) : AppColors.pureWhite;

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
                    color: isDarkMode
                        ? const Color(0xFF072A38)
                        : AppColors.pureWhite,
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
              Expanded(
                child: Text("عروض البنرات 🔥",
                    style: TextStyle(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w900)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.goldenBronze.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.goldenBronze.withOpacity(0.3)),
                ),
                child: Text("${_displayedOffers.length}",
                    style: const TextStyle(
                        color: AppColors.goldenBronze,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: toggleGlobalTheme,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color:
                        isDarkMode ? AppColors.pureWhite : AppColors.deepNavy,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color:
                              (isDarkMode ? Colors.black : AppColors.deepNavy)
                                  .withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child: Icon(
                      isDarkMode
                          ? Icons.wb_sunny_rounded
                          : Icons.nightlight_round,
                      color: AppColors.goldenBronze,
                      size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // محرك البحث الفعّال + فلتر
          Row(children: [
            Expanded(
                child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    color: isDarkMode
                        ? AppColors.goldenBronze.withOpacity(0.3)
                        : AppColors.goldenBronze,
                    width: 1.2),
                boxShadow: [
                  if (!isDarkMode)
                    BoxShadow(
                        color: AppColors.goldenBronze.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(children: [
                Icon(Icons.search_rounded,
                    color: isDarkMode
                        ? AppColors.warmBeige
                        : AppColors.goldenBronze,
                    size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: textColor, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "ابحث في عروض البنرات...",
                      hintStyle: TextStyle(
                          color: isDarkMode
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
                    },
                    child: const Icon(Icons.close_rounded,
                        color: AppColors.grey, size: 18),
                  ),
              ]),
            )),
            const SizedBox(width: 10),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.goldenBronze,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.goldenBronze.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ],
              ),
              child:
                  const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> offer, bool isDarkMode) {
    final Color cardColor =
        isDarkMode ? const Color(0xFF072A38) : AppColors.pureWhite;
    final Color borderColor = isDarkMode
        ? AppColors.goldenBronze.withOpacity(0.2)
        : Colors.grey.shade200;

    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OfferDetailsScreen(
                    offerData: offer, offerType: OfferDetailType.standard))),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 1.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.04),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19),
            child: Row(
              children: [
                SizedBox(
                  width: 130,
                  height: 140,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(offer["image"], fit: BoxFit.cover),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(6)),
                          child: Text("${offer["discount"]}-",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
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
                                    NetworkImage(offer["storeLogo"])),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                              child: Text(offer["storeName"],
                                  style: const TextStyle(
                                      color: AppColors.goldenBronze,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis)),
                        ]),
                        const SizedBox(height: 8),
                        Text(offer["title"],
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
                                  Text(offer["price"],
                                      style: const TextStyle(
                                          color: AppColors.goldenBronze,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900)),
                                  Text(offer["oldPrice"],
                                      style: const TextStyle(
                                          color: AppColors.grey,
                                          fontSize: 11,
                                          decoration:
                                              TextDecoration.lineThrough)),
                                ]),
                            OfferActionButtons(
                                isDarkMode: isDarkMode,
                                offerId: (offer["id"] ?? "").toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
