import 'package:flutter/material.dart';
import '../network/api_service.dart';
import '../network/api_constants.dart';
import '../theme/app_colors.dart';
import '../../presentation/screens/details/offer_details_screen.dart';

// ============================================================================
// كتيبات العروض — تجلب من API
// ============================================================================
class FocusedBrochuresSection extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onSeeAllTap;
  final String? storeId;

  const FocusedBrochuresSection(
      {super.key, required this.isDarkMode, this.onSeeAllTap, this.storeId});

  @override
  State<FocusedBrochuresSection> createState() =>
      _FocusedBrochuresSectionState();
}

class _FocusedBrochuresSectionState extends State<FocusedBrochuresSection> {
  final PageController _pageController =
      PageController(viewportFraction: 0.55, initialPage: 1);
  final ApiService _api = ApiService();

  List<Map<String, dynamic>> _brochures = [];
  bool _isLoading = true;

  // كتيبات احتياطية
  static final List<Map<String, dynamic>> _fallbackBrochures = [
    {
      "title": "عروض التوفير الأسبوعية",
      "store": "هايبر بنده",
      "logo": "https://i.pravatar.cc/150?img=50",
      "image":
          "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSIqN_eJmuaY_Ieg2VxN0Cl3id1t81YfToc4D6KLpRXBrb266wL",
      "pages": 12,
    },
    {
      "title": "مهرجان الإلكترونيات",
      "store": "اكسترا",
      "logo": "https://i.pravatar.cc/150?img=11",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSoxS32kQm0GdKR_xd6svz7kSV2ASWm1P-L_Mo4xUjjbVEfsDDR",
      "pages": 8,
    },
    {
      "title": "أقوى عروض العودة للمدارس",
      "store": "مكتبة جرير",
      "logo": "https://i.pravatar.cc/150?img=33",
      "image":
          "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?auto=format&fit=crop&w=600&q=80",
      "pages": 24,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchBrochures();
  }

  Future<void> _fetchBrochures() async {
    try {
      final params = <String, String>{
        'offer_type': 'Brochure',
        'page_size': '6',
      };
      if (widget.storeId != null) params['store'] = widget.storeId!;
      final data = await _api.get(
        ApiConstants.products,
        queryParams: params,
        requiresAuth: false,
      );

      final List rawBrochures =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);

      if (rawBrochures.isNotEmpty && mounted) {
        setState(() {
          _brochures = rawBrochures.map<Map<String, dynamic>>((b) {
            String storeName = b['store_name']?.toString() ?? 'متجر';

            // استخراج الصور (كل صورة = صفحة من الكتيب)
            var images = b['images'] as List?;
            String coverUrl = '';
            if (images != null && images.isNotEmpty) {
              coverUrl = ApiConstants.resolveImageUrl(
                  images[0]['image_url']?.toString());
            } else if (b['image_url'] != null) {
              coverUrl =
                  ApiConstants.resolveImageUrl(b['image_url'].toString());
            } else if (b['image'] != null) {
              coverUrl = ApiConstants.resolveImageUrl(b['image'].toString());
            }
            if (coverUrl.isEmpty) {
              coverUrl = 'https://placehold.co/400x400/png?text=Brochure';
            }

            // عدد الصفحات = عدد الصور
            int pagesCount = images?.length ?? 1;

            return {
              "id": (b['product_id'] ?? b['id'])?.toString() ?? '',
              "title": b['title']?.toString() ?? 'كتيب عروض',
              "store": storeName,
              "logo": (b['logo'] ?? b['store_logo']) != null
                  ? ApiConstants.resolveImageUrl(
                      (b['logo'] ?? b['store_logo']).toString())
                  : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(storeName)}&background=B8860B&color=fff',
              "image": coverUrl,
              "pages": pagesCount,
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        if (mounted) {
          setState(() {
            _brochures = List.from(_fallbackBrochures);
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('خطأ في جلب الكتيبات: $e');
      if (mounted) {
        setState(() {
          _brochures = List.from(_fallbackBrochures);
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        widget.isDarkMode ? AppColors.pureWhite : AppColors.lightText;

    if (!_isLoading && _brochures.isEmpty) return const SizedBox.shrink();

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
                Row(children: [
                  Text("كتيبات العروض 📑",
                      style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ]),
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
            height: 330,
            child: _isLoading
                ? _buildLoadingShimmer()
                : PageView.builder(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _brochures.length,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double value = 1.0;
                          if (_pageController.position.haveDimensions) {
                            value = _pageController.page! - index;
                            value = (1 - (value.abs() * 0.15)).clamp(0.0, 1.0);
                          } else {
                            value = (index == 1) ? 1.0 : 0.85;
                          }
                          return Transform.scale(
                            scale: Curves.easeOut.transform(value),
                            child: Opacity(
                                opacity: value.clamp(0.5, 1.0), child: child),
                          );
                        },
                        child: _buildBrochureCard(_brochures[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    final Color cardColor =
        widget.isDarkMode ? AppColors.deepNavy : AppColors.pureWhite;
    return Center(
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildBrochureCard(Map<String, dynamic> brochure) {
    final Color paperColor =
        widget.isDarkMode ? AppColors.deepNavy : AppColors.pureWhite;
    final Color borderColor = widget.isDarkMode
        ? AppColors.goldenBronze.withOpacity(0.3)
        : Colors.grey.shade300;

    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OfferDetailsScreen(
                    offerData: brochure, offerType: OfferDetailType.brochure))),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            color: paperColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                  color:
                      Colors.black.withOpacity(widget.isDarkMode ? 0.4 : 0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 8)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(brochure["image"],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        color: AppColors.lightBackground,
                        child: const Icon(Icons.menu_book_rounded,
                            color: AppColors.grey, size: 40))),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        AppColors.deepNavy.withOpacity(0.95),
                        Colors.transparent
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.goldenBronze.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2), blurRadius: 4)
                      ],
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.menu_book_rounded,
                          color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Text("${brochure["pages"]} صفحة",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 12,
                  left: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(brochure["title"],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              height: 1.3),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: CircleAvatar(
                              radius: 10,
                              backgroundColor: AppColors.lightBackground,
                              backgroundImage: NetworkImage(brochure["logo"])),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                            child: Text(brochure["store"],
                                style: const TextStyle(
                                    color: AppColors.softCream,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis)),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
