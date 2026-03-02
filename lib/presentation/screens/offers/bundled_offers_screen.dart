import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../core/widgets/offer_action_buttons.dart';
import '../details/offer_details_screen.dart';

class BundledOffersScreen extends StatefulWidget {
  const BundledOffersScreen({super.key});
  @override
  State<BundledOffersScreen> createState() => _BundledOffersScreenState();
}

class _BundledOffersScreenState extends State<BundledOffersScreen> {
  final TextEditingController _searchController = TextEditingController();

  static final List<Map<String, dynamic>> _allBundles = [
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
        "assets/images/5.jpeg"
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
        "assets/images/1.jpeg"
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
      "images": ["assets/images/2.jpeg", "assets/images/3.jpeg"],
      "isLocalImage": true,
    },
    {
      "title": "باقة العودة للمدارس",
      "store": "مكتبة جرير",
      "storeLogo": "https://i.pravatar.cc/150?img=33",
      "price": "75\$",
      "oldPrice": "120\$",
      "saving": "وفر 45\$",
      "images": [
        "assets/images/4.jpeg",
        "assets/images/5.jpeg",
        "assets/images/6.jpeg",
        "assets/images/7.jpeg"
      ],
      "isLocalImage": true,
    },
    {
      "title": "باقة العناية الشخصية",
      "store": "صيدليات النهدي",
      "storeLogo": "https://i.pravatar.cc/150?img=12",
      "price": "89\$",
      "oldPrice": "140\$",
      "saving": "وفر 51\$",
      "images": [
        "assets/images/1.jpeg",
        "assets/images/3.jpeg",
        "assets/images/5.jpeg"
      ],
      "isLocalImage": true,
    },
    {
      "title": "باقة الرياضة الذهبية",
      "store": "نايك ستور",
      "storeLogo": "https://i.pravatar.cc/150?img=33",
      "price": "250\$",
      "oldPrice": "400\$",
      "saving": "وفر 150\$",
      "images": [
        "assets/images/2.jpeg",
        "assets/images/4.jpeg",
        "assets/images/6.jpeg"
      ],
      "isLocalImage": true,
    },
  ];

  late List<Map<String, dynamic>> _displayed;

  @override
  void initState() {
    super.initState();
    _displayed = List.from(_allBundles);
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final q = _searchController.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _displayed = List.from(_allBundles);
      } else {
        _displayed = _allBundles
            .where((b) =>
                b["title"].toString().toLowerCase().contains(q) ||
                b["store"].toString().toLowerCase().contains(q))
            .toList();
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.deepNavy : AppColors.lightBackground;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: bg,
          body: SafeArea(
              child: Column(children: [
            _buildHeader(context, isDark),
            Expanded(
                child: _displayed.isEmpty
                    ? _empty(isDark)
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 5, 16, 100),
                        itemCount: _displayed.length,
                        itemBuilder: (_, i) =>
                            _buildBundleCard(_displayed[i], isDark))),
          ]))),
    );
  }

  Widget _empty(bool isDark) => Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 60, color: AppColors.goldenBronze.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text("لا توجد باقات",
              style: TextStyle(
                  color: isDark ? AppColors.pureWhite : AppColors.lightText,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
        ],
      ));

  Widget _buildHeader(BuildContext context, bool isDark) {
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    final cardC = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
        child: Column(children: [
          Row(children: [
            GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF072A38)
                            : AppColors.pureWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: isDark
                                ? AppColors.goldenBronze.withOpacity(0.3)
                                : Colors.grey.shade300)),
                    child: Icon(Icons.arrow_forward_ios_rounded,
                        color: textC, size: 18))),
            const SizedBox(width: 12),
            Expanded(
                child: Text("باقات التوفير 🎁",
                    style: TextStyle(
                        color: textC,
                        fontSize: 22,
                        fontWeight: FontWeight.w900))),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: AppColors.goldenBronze.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.goldenBronze.withOpacity(0.3))),
                child: Text("${_displayed.length}",
                    style: const TextStyle(
                        color: AppColors.goldenBronze,
                        fontSize: 12,
                        fontWeight: FontWeight.bold))),
            const SizedBox(width: 8),
            GestureDetector(
                onTap: toggleGlobalTheme,
                child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                        color:
                            isDark ? AppColors.pureWhite : AppColors.deepNavy,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color:
                                  (isDark ? Colors.black : AppColors.deepNavy)
                                      .withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3))
                        ]),
                    child: Icon(
                        isDark
                            ? Icons.wb_sunny_rounded
                            : Icons.nightlight_round,
                        color: AppColors.goldenBronze,
                        size: 20))),
          ]),
          const SizedBox(height: 14),
          Row(children: [
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
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                          color: AppColors.goldenBronze.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4))
                  ]),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(children: [
                Icon(Icons.search_rounded,
                    color:
                        isDark ? AppColors.warmBeige : AppColors.goldenBronze,
                    size: 20),
                const SizedBox(width: 12),
                Expanded(
                    child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: textC, fontSize: 14),
                        decoration: InputDecoration(
                            hintText: "ابحث في باقات التوفير...",
                            hintStyle: TextStyle(
                                color: isDark
                                    ? AppColors.grey
                                    : AppColors.lightText.withOpacity(0.5),
                                fontSize: 13),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero))),
                if (_searchController.text.isNotEmpty)
                  GestureDetector(
                      onTap: () => _searchController.clear(),
                      child: const Icon(Icons.close_rounded,
                          color: AppColors.grey, size: 18)),
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
        ]));
  }

  Widget _buildBundleCard(Map<String, dynamic> bundle, bool isDark) {
    final cardBg = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
    final borderC =
        isDark ? AppColors.goldenBronze.withOpacity(0.3) : Colors.grey.shade200;
    final bool isLocal = bundle["isLocalImage"] ?? false;
    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OfferDetailsScreen(
                    offerData: bundle, offerType: OfferDetailType.bundled))),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderC, width: 1.2),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.25 : 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 5))
              ]),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                width: 155,
                height: 160,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(17),
                        bottomRight: Radius.circular(17))),
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(17),
                        bottomRight: Radius.circular(17)),
                    child: _buildCollage(bundle["images"] as List<String>,
                        isDark ? AppColors.deepNavy : Colors.white, isLocal))),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 12, 12, 12),
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
                                      fontWeight: FontWeight.bold))),
                          const SizedBox(height: 6),
                          Text(bundle["title"],
                              style: TextStyle(
                                  color: isDark
                                      ? AppColors.pureWhite
                                      : AppColors.lightText,
                                  fontSize: 14,
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
                                    border: Border.all(color: borderC)),
                                child: CircleAvatar(
                                    radius: 9,
                                    backgroundColor: AppColors.lightBackground,
                                    backgroundImage:
                                        NetworkImage(bundle["storeLogo"]))),
                            const SizedBox(width: 4),
                            Expanded(
                                child: Text(bundle["store"],
                                    style: const TextStyle(
                                        color: AppColors.grey,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)),
                          ]),
                          const SizedBox(height: 10),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(bundle["price"],
                                          style: const TextStyle(
                                              color: AppColors.goldenBronze,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900)),
                                      Text(bundle["oldPrice"],
                                          style: const TextStyle(
                                              color: AppColors.grey,
                                              fontSize: 10,
                                              decoration:
                                                  TextDecoration.lineThrough)),
                                    ]),
                                OfferActionButtons(
                                    isDarkMode: isDark,
                                    offerId: "BUNDLE_${bundle["title"]}"),
                              ]),
                        ]))),
          ]),
        ));
  }

  Widget _buildCollage(List<String> images, Color sep, bool isLocal) {
    Widget img(String p) {
      ImageProvider prov =
          isLocal ? AssetImage(p) : NetworkImage(p) as ImageProvider;
      return Container(
          foregroundDecoration:
              BoxDecoration(border: Border.all(color: sep, width: 0.5)),
          child: Image(
              image: prov,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, color: Colors.grey))));
    }

    int c = images.length;
    if (c == 1) return img(images[0]);
    if (c == 2)
      return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(child: img(images[0])),
        Expanded(child: img(images[1]))
      ]);
    if (c == 3)
      return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(flex: 3, child: img(images[0])),
        Expanded(
            flex: 2,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: img(images[1])),
                  Expanded(child: img(images[2]))
                ]))
      ]);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Expanded(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(child: img(images[0])),
        Expanded(child: img(images[1]))
      ])),
      Expanded(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(child: img(images[2])),
        Expanded(
            child: Stack(fit: StackFit.expand, children: [
          img(images[3]),
          if (c > 4)
            Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                    child: Text("+${c - 4}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)))),
        ]))
      ]))
    ]);
  }
}
