import 'dart:async';
import 'package:flutter/material.dart';
import '../network/api_service.dart';
import '../network/api_constants.dart';
import '../theme/app_colors.dart';

// ============================================================================
// كاروسيل البانرات — يجلب من API
// ============================================================================
class ExclusiveOffersCarousel extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onBrowseTap;
  const ExclusiveOffersCarousel(
      {super.key, required this.isDarkMode, this.onBrowseTap});

  @override
  State<ExclusiveOffersCarousel> createState() =>
      _ExclusiveOffersCarouselState();
}

class _ExclusiveOffersCarouselState extends State<ExclusiveOffersCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.93);
  final ApiService _api = ApiService();
  int _currentPage = 0;
  Timer? _timer;
  bool _isLoading = true;

  List<Map<String, String>> _offers = [];

  // بانرات احتياطية في حال فشل الـ API
  static const List<Map<String, String>> _fallbackOffers = [
    {
      "title": "خصم 50% على الأزياء",
      "subtitle": "ينتهي قريباً",
      "image":
          "https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=800",
    },
    {
      "title": "وجبتك الثانية مجاناً",
      "subtitle": "مطاعم الذواقة",
      "image":
          "https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800",
    },
    {
      "title": "أحدث الجوالات",
      "subtitle": "الكمية محدودة",
      "image":
          "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800",
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchBanners();
  }

  Future<void> _fetchBanners() async {
    try {
      final data = await _api.get(
        ApiConstants.banners,
        requiresAuth: false,
      );

      final List rawBanners =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);

      if (rawBanners.isNotEmpty && mounted) {
        setState(() {
          _offers = rawBanners.map<Map<String, String>>((banner) {
            return {
              "title": banner['title']?.toString() ?? 'عرض حصري',
              "subtitle": banner['subtitle']?.toString() ??
                  banner['description']?.toString() ??
                  '',
              "image": ApiConstants.resolveImageUrl(
                  banner['image']?.toString() ??
                      banner['image_url']?.toString()),
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        // لا توجد بانرات — استخدام الاحتياطي
        if (mounted) {
          setState(() {
            _offers = List.from(_fallbackOffers);
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('خطأ في جلب البانرات: $e');
      if (mounted) {
        setState(() {
          _offers = List.from(_fallbackOffers);
          _isLoading = false;
        });
      }
    }

    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_pageController.hasClients && _offers.isNotEmpty) {
        int nextPage = _currentPage + 1;
        if (nextPage >= _offers.length) nextPage = 0;
        _pageController.animateToPage(nextPage,
            duration: const Duration(milliseconds: 800),
            curve: Curves.fastOutSlowIn);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: 180,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? AppColors.deepNavy
                  : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );
    }

    if (_offers.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _offers.length,
            onPageChanged: (int index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) =>
                _buildBannerItem(context, _offers[index]),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_offers.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _currentPage == index ? 20 : 6,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.goldenBronze
                    : (widget.isDarkMode
                        ? Colors.white24
                        : Colors.grey.shade300),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBannerItem(BuildContext context, Map<String, String> offer) {
    return GestureDetector(
        onTap: widget.onBrowseTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color:
                      Colors.black.withOpacity(widget.isDarkMode ? 0.3 : 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5))
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(offer["image"]!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        color: AppColors.deepNavy,
                        child: const Icon(Icons.image_not_supported,
                            color: AppColors.grey, size: 40))),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.deepNavy.withOpacity(0.95),
                        AppColors.deepNavy.withOpacity(0.7),
                        Colors.transparent
                      ],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 20, left: 80, top: 15, bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.goldenBronze.withOpacity(0.2),
                            border: Border.all(
                                color: AppColors.goldenBronze.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text("حصري 🔥",
                              style: TextStyle(
                                  color: AppColors.goldenBronze,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 10),
                        Text(offer["title"]!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                height: 1.2),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(offer["subtitle"]!,
                            style: const TextStyle(
                                color: AppColors.softCream, fontSize: 12)),
                        const SizedBox(height: 14),
                        GestureDetector(
                          onTap: widget.onBrowseTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.goldenBronze,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        AppColors.goldenBronze.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3))
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("تصفح العرض",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white, size: 12),
                              ],
                            ),
                          ),
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
