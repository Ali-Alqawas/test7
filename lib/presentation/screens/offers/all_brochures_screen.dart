import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../details/offer_details_screen.dart';

// ============================================================================
// شاشة جميع كتيبات العروض (All Brochures Screen)
// كل صف = كتيب واحد مع تمرير أفقي لصفحات الكتيب نفسه
// ============================================================================
class AllBrochuresScreen extends StatefulWidget {
  const AllBrochuresScreen({super.key});

  @override
  State<AllBrochuresScreen> createState() => _AllBrochuresScreenState();
}

class _AllBrochuresScreenState extends State<AllBrochuresScreen> {
  final TextEditingController _searchController = TextEditingController();

  // كتيبات العروض مع صفحات كل كتيب
  static final List<Map<String, dynamic>> _allBrochures = [
    {
      "title": "عروض التوفير الأسبوعية",
      "store": "هايبر بنده",
      "logo": "https://i.pravatar.cc/150?img=50",
      "pages": [
        "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSIqN_eJmuaY_Ieg2VxN0Cl3id1t81YfToc4D6KLpRXBrb266wL",
        "https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=600&q=80",
        "https://images.unsplash.com/photo-1604719312566-8912e9227c6a?auto=format&fit=crop&w=600&q=80",
        "https://images.unsplash.com/photo-1534723452862-4c874018d66d?auto=format&fit=crop&w=600&q=80",
        "https://images.unsplash.com/photo-1607082349566-187342175e2f?auto=format&fit=crop&w=600&q=80",
        "https://images.unsplash.com/photo-1601598851547-4302969d0614?auto=format&fit=crop&w=600&q=80",
      ],
    },
    {
      "title": "مهرجان الإلكترونيات",
      "store": "اكسترا",
      "logo": "https://i.pravatar.cc/150?img=11",
      "pages": [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSoxS32kQm0GdKR_xd6svz7kSV2ASWm1P-L_Mo4xUjjbVEfsDDR",
        "https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=600&q=80",
        "https://images.unsplash.com/photo-1517336714731-489689fd1ca4?auto=format&fit=crop&w=600&q=80",
        "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=600&q=80",
      ],
    },
    {
      "title": "أقوى عروض العودة للمدارس",
      "store": "مكتبة جرير",
      "logo": "https://i.pravatar.cc/150?img=33",
      "pages": [
        "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?auto=format&fit=crop&w=600&q=80",
        "https://images.unsplash.com/photo-1456735190827-d1262f71b8a3?auto=format&fit=crop&w=600&q=80",
        "https://images.unsplash.com/photo-1513542789411-b6a5d4f31634?auto=format&fit=crop&w=600&q=80",
        "https://images.unsplash.com/photo-1588072432836-e10032774350?auto=format&fit=crop&w=600&q=80",
        "https://images.unsplash.com/photo-1497633762265-9d179a990aa6?auto=format&fit=crop&w=600&q=80",
      ],
    },
    {
      "title": "تخفيضات نهاية الموسم",
      "store": "سيتي ماكس",
      "logo": "https://i.pravatar.cc/150?img=44",
      "pages": [
        "https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=600&q=80",
        "https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&w=600&q=80",
        "https://images.unsplash.com/photo-1595777457583-95e059d581b8?auto=format&fit=crop&w=600&q=80",
      ],
    },
    {
      "title": "كتالوج عروض الأجهزة المنزلية",
      "store": "ساكو",
      "logo": "https://i.pravatar.cc/150?img=12",
      "pages": [
        "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?auto=format&fit=crop&w=600&q=80",
        "https://images.unsplash.com/photo-1558618666-fcd25c85f82e?auto=format&fit=crop&w=600&q=80",
        "https://images.unsplash.com/photo-1586208958839-06c17cacdf08?auto=format&fit=crop&w=600&q=80",
        "https://images.unsplash.com/photo-1574269909862-7e1d70bb8078?auto=format&fit=crop&w=600&q=80",
      ],
    },
  ];

  late List<Map<String, dynamic>> _displayedBrochures;

  @override
  void initState() {
    super.initState();
    _displayedBrochures = List.from(_allBrochures);
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _displayedBrochures = List.from(_allBrochures);
      } else {
        _displayedBrochures = _allBrochures.where((b) {
          return b["title"].toString().toLowerCase().contains(query) ||
              b["store"].toString().toLowerCase().contains(query);
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
                child: _displayedBrochures.isEmpty
                    ? _buildEmptyState(isDarkMode)
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 5, 16, 100),
                        itemCount: _displayedBrochures.length,
                        itemBuilder: (context, index) {
                          return _buildBrochureRow(
                              _displayedBrochures[index], isDarkMode);
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
          Text("لا توجد كتيبات",
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
                child: Text("كتيبات العروض 📑",
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
                child: Text("${_displayedBrochures.length} كتيب",
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
                      hintText: "ابحث عن كتيب أو متجر...",
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
                    onTap: () => _searchController.clear(),
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

  // ==========================================
  // صف كتيب واحد: هيدر المتجر + تمرير أفقي لصفحات الكتيب
  // ==========================================
  Widget _buildBrochureRow(Map<String, dynamic> brochure, bool isDarkMode) {
    final Color textColor =
        isDarkMode ? AppColors.pureWhite : AppColors.lightText;
    final Color cardBg =
        isDarkMode ? const Color(0xFF072A38) : AppColors.pureWhite;
    final Color borderColor = isDarkMode
        ? AppColors.goldenBronze.withOpacity(0.3)
        : Colors.grey.shade200;
    final List<String> pages = List<String>.from(brochure["pages"]);

    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OfferDetailsScreen(
                    offerData: brochure, offerType: OfferDetailType.brochure))),
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.25 : 0.06),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // هيدر المتجر
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.goldenBronze.withOpacity(0.5)),
                      ),
                      child: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.lightBackground,
                          backgroundImage: NetworkImage(brochure["logo"])),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(brochure["store"],
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800)),
                          const SizedBox(height: 2),
                          Text(brochure["title"],
                              style: TextStyle(
                                  color: textColor.withOpacity(0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.goldenBronze.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.menu_book_rounded,
                            color: AppColors.goldenBronze, size: 14),
                        const SizedBox(width: 4),
                        Text("${pages.length} صفحة",
                            style: const TextStyle(
                                color: AppColors.goldenBronze,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ],
                ),
              ),
              // صفحات الكتيب — تمرير أفقي
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  itemCount: pages.length,
                  itemBuilder: (context, pageIndex) {
                    return _buildBrochurePage(
                        pages[pageIndex], pageIndex, pages.length, isDarkMode);
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildBrochurePage(
      String imageUrl, int pageIndex, int totalPages, bool isDarkMode) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDarkMode
              ? AppColors.goldenBronze.withOpacity(0.2)
              : Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover),
            // رقم الصفحة
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.deepNavy.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${pageIndex + 1} / $totalPages",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
