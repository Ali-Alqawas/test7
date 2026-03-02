import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../screens/details/merchant_chat_screen.dart';
import '../../screens/details/offer_details_screen.dart';

// ============================================================================
// شاشة ملف المتجر — التصميم الجديد
// ============================================================================
class MerchantProfileScreen extends StatefulWidget {
  final String storeName;
  final String storeLogo;

  const MerchantProfileScreen({
    super.key,
    required this.storeName,
    required this.storeLogo,
  });

  @override
  State<MerchantProfileScreen> createState() => _MerchantProfileScreenState();
}

class _MerchantProfileScreenState extends State<MerchantProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  bool _isFollowing = false;

  // -------- بيانات وهمية --------
  final String _category = "هايبر ماركت متكامل";
  final double _rating = 4.8;
  final int _reviewsCount = 1240;
  final String _location = "الرياض، حي العليا";
  final String _coverUrl =
      "https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=1200&q=80";

  final List<Map<String, dynamic>> _contactInfo = [
    {"icon": Icons.phone_rounded, "title": "+966 50 123 4567", "type": "هاتف"},
    {"icon": Icons.email_rounded, "title": "support@store.com", "type": "بريد"},
    {
      "icon": Icons.camera_alt_rounded,
      "title": "@Store_SA",
      "type": "انستقرام"
    },
    {"icon": Icons.facebook_rounded, "title": "Store SA", "type": "فيس بوك"},
    {
      "icon": Icons.chat_rounded,
      "title": "+966 50 123 4567",
      "type": "واتس اب"
    },
  ];

  final List<Map<String, dynamic>> _offers = [
    {
      "title": "سماعة ابل ايربودز برو 2",
      "image":
          "https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?auto=format&fit=crop&w=500&q=80",
      "price": "199\$",
      "oldPrice": "349\$",
      "discount": "43%",
    },
    {
      "title": "ساعة ذكية Amazfit GTS",
      "image":
          "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=500&q=80",
      "price": "89\$",
      "oldPrice": "159\$",
      "discount": "44%",
    },
    {
      "title": "حقيبة ظهر رياضية Nike",
      "image":
          "https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=500&q=80",
      "price": "45\$",
      "oldPrice": "90\$",
      "discount": "50%",
    },
    {
      "title": "نظارة شمسية كلاسيكية",
      "image":
          "https://images.unsplash.com/photo-1572635196237-14b3f281503f?auto=format&fit=crop&w=500&q=80",
      "price": "120\$",
      "oldPrice": "250\$",
      "discount": "52%",
    },
    {
      "title": "كاميرا فورية Instax",
      "image":
          "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?auto=format&fit=crop&w=500&q=80",
      "price": "65\$",
      "oldPrice": "110\$",
      "discount": "40%",
    },
    {
      "title": "سماعة لاسلكية JBL",
      "image":
          "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=500&q=80",
      "price": "35\$",
      "oldPrice": "70\$",
      "discount": "50%",
    },
  ];

  final List<Map<String, dynamic>> _groups = [
    {
      "title": "باقة الصوتيات المتكاملة",
      "items": ["سماعة ايربودز برو", "سماعة JBL", "حامل سماعات"],
      "images": [
        "https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?auto=format&fit=crop&w=300&q=80",
        "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=300&q=80",
        "https://images.unsplash.com/photo-1583394838336-acd977736f90?auto=format&fit=crop&w=300&q=80",
      ],
      "totalPrice": "280\$",
      "oldTotal": "470\$",
      "discount": "40%",
      "itemCount": 3,
    },
    {
      "title": "باقة المسافر الذكي",
      "items": ["حقيبة Nike", "نظارة شمسية", "ساعة ذكية"],
      "images": [
        "https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=300&q=80",
        "https://images.unsplash.com/photo-1572635196237-14b3f281503f?auto=format&fit=crop&w=300&q=80",
        "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=300&q=80",
      ],
      "totalPrice": "199\$",
      "oldTotal": "499\$",
      "discount": "60%",
      "itemCount": 3,
    },
    {
      "title": "باقة الهدايا الفاخرة",
      "items": ["كاميرا فورية", "نظارة شمسية", "سماعة JBL", "علبة هدية"],
      "images": [
        "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?auto=format&fit=crop&w=300&q=80",
        "https://images.unsplash.com/photo-1572635196237-14b3f281503f?auto=format&fit=crop&w=300&q=80",
        "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=300&q=80",
        "https://images.unsplash.com/photo-1513885535751-8b9238bd345a?auto=format&fit=crop&w=300&q=80",
      ],
      "totalPrice": "159\$",
      "oldTotal": "380\$",
      "discount": "58%",
      "itemCount": 4,
    },
  ];

  final List<Map<String, dynamic>> _reviews = [
    {
      "user": "أحمد محمد",
      "avatar": "https://i.pravatar.cc/150?img=1",
      "text": "متجر ممتاز جداً! الأسعار مناسبة والتوصيل سريع 👏",
      "time": "منذ ساعتين",
      "likes": 24,
      "stars": 5
    },
    {
      "user": "فاطمة يوسف",
      "avatar": "https://i.pravatar.cc/150?img=9",
      "text": "تجربة تسوق ممتازة، المنتجات أصلية ومضمونة",
      "time": "منذ 5 ساعات",
      "likes": 15,
      "stars": 5
    },
    {
      "user": "عمر العبدلي",
      "avatar": "https://i.pravatar.cc/150?img=3",
      "text": "خدمة العملاء سريعة في الرد، شكراً لكم",
      "time": "منذ يوم",
      "likes": 7,
      "stars": 4
    },
    {
      "user": "سارة الحربي",
      "avatar": "https://i.pravatar.cc/150?img=5",
      "text": "بعض المنتجات نفذت بسرعة، لكن المتجر بشكل عام ممتاز",
      "time": "منذ 3 أيام",
      "likes": 11,
      "stars": 4
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  // ====================================================================
  // BUILD الرئيسي
  // ====================================================================
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.deepNavy : AppColors.lightBackground;
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    final cardC = isDark ? const Color(0xFF072A38) : Colors.white;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: bg,
          body: NestedScrollView(
            headerSliverBuilder: (ctx, _) => [
              SliverToBoxAdapter(
                  child: _buildHeroHeader(ctx, isDark, textC, cardC)),
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabDelegate(
                  TabBar(
                    controller: _tabCtrl,
                    labelColor: AppColors.goldenBronze,
                    unselectedLabelColor: AppColors.grey,
                    indicatorColor: AppColors.goldenBronze,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.label,
                    isScrollable: true,
                    labelStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    unselectedLabelStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                    tabs: const [
                      Tab(text: "كتيبات 📑"),
                      Tab(text: "العروض 🔥"),
                      Tab(text: "مميزة ⭐"),
                      Tab(text: "باقات 📦"),
                    ],
                  ),
                  isDark,
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabCtrl,
              children: [
                _buildOffersTab(isDark, textC, cardC), // كتيبات
                _buildOffersTab(isDark, textC, cardC), // عروض
                _buildOffersTab(isDark, textC, cardC), // مميزة
                _buildGroupsTab(isDark, textC, cardC), // باقات
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ====================================================================
  // HERO HEADER — Cover + Logo + Trust + Actions
  // ====================================================================
  Widget _buildHeroHeader(
      BuildContext ctx, bool isDark, Color textC, Color cardC) {
    final top = MediaQuery.of(ctx).padding.top;
    const double coverH = 200;
    const double logoR = 50;

    return Column(
      children: [
        // ===== Cover + overlay buttons + logo =====
        SizedBox(
          height: coverH + logoR,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Cover image
              Positioned.fill(
                bottom: logoR,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(_coverUrl, fit: BoxFit.cover),
                    // gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.transparent,
                            Colors.black.withOpacity(0.3)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0, 0.4, 1],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Top buttons
              Positioned(
                top: top + 8,
                right: 16,
                left: 16,
                child: Row(
                  children: [
                    _headerBtn(Icons.arrow_forward_ios_rounded,
                        () => Navigator.pop(ctx)),
                    const Spacer(),
                    _headerBtn(Icons.flag_rounded,
                        () => _showReportSheet(ctx, isDark)),
                  ],
                ),
              ),
              // Circular Logo
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.deepNavy
                          : AppColors.lightBackground,
                      border:
                          Border.all(color: AppColors.goldenBronze, width: 3),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.goldenBronze.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: logoR - 4,
                      backgroundColor:
                          isDark ? AppColors.deepNavy : Colors.white,
                      backgroundImage: NetworkImage(widget.storeLogo),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ===== Trust & Identity =====
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.storeName,
                style: TextStyle(
                    color: textC, fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                  color: Color(0xFF1DA1F2), shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 13),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(_category,
            style: TextStyle(
                color: textC.withOpacity(0.55),
                fontSize: 13,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),

        // Rating + Location row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rating chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      AppColors.goldenBronze.withOpacity(isDark ? 0.18 : 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded,
                        color: AppColors.goldenBronze, size: 16),
                    const SizedBox(width: 4),
                    Text("$_rating",
                        style: const TextStyle(
                            color: AppColors.goldenBronze,
                            fontSize: 14,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(width: 3),
                    Text("($_reviewsCount)",
                        style: TextStyle(
                            color: textC.withOpacity(0.4), fontSize: 11)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Location chip
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on_rounded,
                          color: AppColors.goldenBronze, size: 15),
                      const SizedBox(width: 4),
                      Text(_location,
                          style: TextStyle(
                              color: textC.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ===== Quick Stats =====
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _stat("45K", "متابعين", textC),
                    _vDiv(isDark),
                    _stat("120", "عروض نشطة", textC),
                    _vDiv(isDark),
                    _stat("98%", "سرعة الرد", textC),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ===== Action Buttons (Follow + Chat + Share) =====
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              // Follow
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isFollowing = !_isFollowing),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _isFollowing
                          ? Colors.transparent
                          : AppColors.goldenBronze,
                      borderRadius: BorderRadius.circular(14),
                      border:
                          Border.all(color: AppColors.goldenBronze, width: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            _isFollowing
                                ? Icons.notifications_active_rounded
                                : Icons.person_add_rounded,
                            color: _isFollowing
                                ? AppColors.goldenBronze
                                : AppColors.deepNavy,
                            size: 18),
                        const SizedBox(width: 8),
                        Text(
                          _isFollowing ? "متابَع ✓" : "متابعة",
                          style: TextStyle(
                              color: _isFollowing
                                  ? AppColors.goldenBronze
                                  : AppColors.deepNavy,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Chat
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MerchantChatScreen(
                          storeName: widget.storeName,
                          storeLogo: widget.storeLogo,
                          offerTitle: "استفسار عن المتجر"),
                    )),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: cardC,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.goldenBronze),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded,
                          color: AppColors.goldenBronze, size: 18),
                      SizedBox(width: 6),
                      Text("دردشة",
                          style: TextStyle(
                              color: AppColors.goldenBronze,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Share circle
              GestureDetector(
                onTap: () =>
                    Share.share('تصفح متجر ${widget.storeName} على SIDE'),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: cardC,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: isDark ? Colors.white12 : Colors.grey.shade300),
                  ),
                  child: Icon(Icons.share_rounded,
                      color: textC.withOpacity(0.6), size: 20),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  // ====================================================================
  // أزرار الهيدر الشفافة
  // ====================================================================
  Widget _headerBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 19),
          ),
        ),
      ),
    );
  }

  Widget _stat(String val, String label, Color textC) {
    return Column(children: [
      Text(val,
          style: const TextStyle(
              color: AppColors.goldenBronze,
              fontSize: 16,
              fontWeight: FontWeight.w900)),
      const SizedBox(height: 3),
      Text(label,
          style: TextStyle(
              color: textC.withOpacity(0.5),
              fontSize: 11,
              fontWeight: FontWeight.w600)),
    ]);
  }

  Widget _vDiv(bool isDark) => Container(
      width: 1,
      height: 28,
      color: isDark ? Colors.white24 : Colors.grey.shade300);

  // ====================================================================
  // تبويب العروض — Grid
  // ====================================================================
  Widget _buildOffersTab(bool isDark, Color textC, Color cardC) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: _offers.length,
      itemBuilder: (context, i) {
        final o = _offers[i];
        return GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OfferDetailsScreen(offerData: {
                  ...o,
                  "storeName": widget.storeName,
                  "storeLogo": widget.storeLogo
                }, offerType: OfferDetailType.standard),
              )),
          child: Container(
            decoration: BoxDecoration(
              color: cardC,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: isDark
                      ? AppColors.goldenBronze.withOpacity(0.1)
                      : Colors.grey.shade200),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3)),
              ],
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Stack(fit: StackFit.expand, children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(o["image"], fit: BoxFit.cover),
                  ),
                  if (o["discount"] != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.red.shade600,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text("-${o["discount"]}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(o["title"],
                          style: TextStyle(
                              color: textC,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      Row(children: [
                        Text(o["price"],
                            style: const TextStyle(
                                color: AppColors.goldenBronze,
                                fontSize: 15,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(width: 6),
                        if (o["oldPrice"] != null)
                          Text(o["oldPrice"],
                              style: const TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 10,
                                  decoration: TextDecoration.lineThrough)),
                      ]),
                    ]),
              ),
            ]),
          ),
        );
      },
    );
  }

  // ====================================================================
  // تبويب المجموعات — Bundled Offers
  // ====================================================================
  Widget _buildGroupsTab(bool isDark, Color textC, Color cardC) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _groups.length,
      itemBuilder: (_, i) {
        final g = _groups[i];
        final images = (g["images"] as List).cast<String>();
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: cardC,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: isDark
                    ? AppColors.goldenBronze.withOpacity(0.12)
                    : Colors.grey.shade200),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4)),
            ],
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Images collage
            SizedBox(
              height: 140,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(17)),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Image.network(images[0],
                            fit: BoxFit.cover, height: 140)),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Column(children: [
                        Expanded(
                            child: Image.network(
                                images.length > 1 ? images[1] : images[0],
                                fit: BoxFit.cover,
                                width: double.infinity)),
                        const SizedBox(height: 2),
                        Expanded(
                          child: Stack(fit: StackFit.expand, children: [
                            Image.network(
                                images.length > 2 ? images[2] : images[0],
                                fit: BoxFit.cover),
                            if (images.length > 3)
                              Container(
                                color: Colors.black45,
                                child: Center(
                                    child: Text("+${images.length - 3}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                              ),
                          ]),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(g["title"],
                                style: TextStyle(
                                    color: textC,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800))),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8)),
                          child: Text("-${g["discount"]}",
                              style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Items list
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: (g["items"] as List)
                          .map<Widget>((item) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.goldenBronze
                                      .withOpacity(isDark ? 0.12 : 0.08),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(item,
                                    style: TextStyle(
                                        color: textC.withOpacity(0.7),
                                        fontSize: 11)),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(g["totalPrice"],
                            style: const TextStyle(
                                color: AppColors.goldenBronze,
                                fontSize: 18,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(width: 8),
                        Text(g["oldTotal"],
                            style: const TextStyle(
                                color: AppColors.grey,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                              color: AppColors.goldenBronze,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text("عرض الباقة",
                              style: const TextStyle(
                                  color: AppColors.deepNavy,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ]),
            ),
          ]),
        );
      },
    );
  }

  // ====================================================================
  // تبويب حول المتجر — About + Rating + Contact
  // ====================================================================
  Widget _buildAboutTab(bool isDark, Color textC, Color cardC) {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // ===== وصف المتجر =====
        Text("عن المتجر",
            style: TextStyle(
                color: textC, fontSize: 16, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardC,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: isDark
                    ? AppColors.goldenBronze.withOpacity(0.12)
                    : Colors.grey.shade200),
          ),
          child: Text(
            "متجر ${widget.storeName} هو وجهتك الأولى للحصول على أفضل المنتجات بأفضل الأسعار. نحن نضمن لك جودة المنتجات وسرعة في التجاوب وخدمة عملاء على مدار الساعة.",
            style: TextStyle(
                color: textC.withOpacity(0.7), fontSize: 13, height: 1.7),
          ),
        ),
        const SizedBox(height: 24),

        // ===== تقييم المتجر =====
        Text("تقييم المتجر",
            style: TextStyle(
                color: textC, fontSize: 16, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardC,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.goldenBronze.withOpacity(0.2)),
          ),
          child: Column(children: [
            Text("$_rating",
                style: const TextStyle(
                    color: AppColors.goldenBronze,
                    fontSize: 42,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    5,
                    (i) => Icon(
                          i < _rating.floor()
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: AppColors.goldenBronze,
                          size: 24,
                        ))),
            const SizedBox(height: 6),
            Text("$_reviewsCount تقييم",
                style: TextStyle(color: textC.withOpacity(0.5), fontSize: 13)),
          ]),
        ),
        const SizedBox(height: 12),
        // Write review button
        GestureDetector(
          onTap: () => _showRatingSheet(context, isDark, textC, cardC),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.goldenBronze.withOpacity(isDark ? 0.15 : 0.1),
              borderRadius: BorderRadius.circular(14),
              border:
                  Border.all(color: AppColors.goldenBronze.withOpacity(0.3)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.rate_review_rounded,
                    color: AppColors.goldenBronze, size: 20),
                SizedBox(width: 8),
                Text("قيّم المتجر",
                    style: TextStyle(
                        color: AppColors.goldenBronze,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // ===== ساعات العمل =====
        Text("ساعات العمل",
            style: TextStyle(
                color: textC, fontSize: 16, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardC,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: isDark
                    ? AppColors.goldenBronze.withOpacity(0.12)
                    : Colors.grey.shade200),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.access_time_rounded,
                  color: Colors.green, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text("مفتوح الآن",
                      style: TextStyle(
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                  const SizedBox(height: 3),
                  Text("من 8:00 صباحاً حتى 11:30 مساءً",
                      style: TextStyle(
                          color: textC.withOpacity(0.6), fontSize: 12)),
                ])),
          ]),
        ),

        const SizedBox(height: 24),

        // ===== معلومات التواصل =====
        Text("معلومات التواصل",
            style: TextStyle(
                color: textC, fontSize: 16, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        ..._contactInfo.map((info) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: cardC,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: isDark
                        ? AppColors.goldenBronze.withOpacity(0.12)
                        : Colors.grey.shade200),
              ),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: AppColors.goldenBronze.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(info["icon"],
                      color: AppColors.goldenBronze, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(info["type"],
                          style: TextStyle(
                              color: textC.withOpacity(0.45), fontSize: 11)),
                      const SizedBox(height: 2),
                      Text(info["title"],
                          style: TextStyle(
                              color: textC,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    ])),
                Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.grey.withOpacity(0.5), size: 14),
              ]),
            )),

        const SizedBox(height: 24),

        // ===== موقع المتجر =====
        Text("موقع المتجر",
            style: TextStyle(
                color: textC, fontSize: 16, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: cardC,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: isDark
                    ? AppColors.goldenBronze.withOpacity(0.12)
                    : Colors.grey.shade200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(fit: StackFit.expand, children: [
              Image.network(
                "https://maps.googleapis.com/maps/api/staticmap?center=24.7136,46.6753&zoom=14&size=600x300&maptype=roadmap&key=placeholder",
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color:
                      isDark ? const Color(0xFF0A2A35) : Colors.grey.shade200,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_rounded,
                            color: AppColors.goldenBronze.withOpacity(0.5),
                            size: 40),
                        const SizedBox(height: 8),
                        Text(_location,
                            style: TextStyle(
                                color: textC.withOpacity(0.5), fontSize: 12)),
                      ]),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.deepNavy.withOpacity(0.9)
                        : Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(children: [
                    const Icon(Icons.location_on_rounded,
                        color: AppColors.goldenBronze, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(_location,
                            style: TextStyle(
                                color: textC,
                                fontSize: 13,
                                fontWeight: FontWeight.w600))),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          color: AppColors.goldenBronze,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Text("فتح الخريطة",
                          style: TextStyle(
                              color: AppColors.deepNavy,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ),
                  ]),
                ),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // ===== Rating bar helper =====
  Widget _ratingBar(String label, double pct, Color textC, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        SizedBox(
            width: 55,
            child: Text(label,
                style: TextStyle(color: textC.withOpacity(0.6), fontSize: 11))),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: pct,
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.goldenBronze,
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
            width: 30,
            child: Text("${(pct * 100).toInt()}%",
                style: TextStyle(color: textC.withOpacity(0.5), fontSize: 10))),
      ]),
    );
  }

  // ====================================================================
  // شيت الابلاغ
  // ====================================================================
  void _showReportSheet(BuildContext ctx, bool isDark) {
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    final reports = [
      {"icon": Icons.warning_amber_rounded, "title": "محتوى مضلل أو كاذب"},
      {"icon": Icons.money_off_rounded, "title": "احتيال أو نصب"},
      {"icon": Icons.block_rounded, "title": "محتوى غير لائق"},
      {"icon": Icons.copy_rounded, "title": "انتحال هوية أو تقليد"},
      {"icon": Icons.more_horiz_rounded, "title": "سبب آخر"},
    ];

    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.deepNavy : AppColors.pureWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10))),
          const SizedBox(height: 20),
          Icon(Icons.flag_rounded, color: AppColors.error, size: 44),
          const SizedBox(height: 12),
          Text("الإبلاغ عن هذا المتجر",
              style: TextStyle(
                  color: textC, fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text("اختر سبب البلاغ ليتم مراجعته من فريق الإدارة",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grey, fontSize: 13)),
          const SizedBox(height: 20),
          ...reports.map((r) => GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.04)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: isDark ? Colors.white10 : Colors.grey.shade200),
                  ),
                  child: Row(children: [
                    Icon(r["icon"] as IconData,
                        color: AppColors.error.withOpacity(0.8), size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(r["title"] as String,
                            style: TextStyle(
                                color: textC,
                                fontSize: 14,
                                fontWeight: FontWeight.w600))),
                    Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.grey.withOpacity(0.4), size: 14),
                  ]),
                ),
              )),
          const SizedBox(height: 10),
        ]),
      ),
    );
  }

  // ====================================================================
  // نموذج تقييم بالنجوم
  // ====================================================================
  void _showRatingSheet(
      BuildContext ctx, bool isDark, Color textC, Color cardC) {
    int selectedStars = 0;
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setSheetState) => Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.deepNavy : AppColors.pureWhite,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              Text("قيّم المتجر",
                  style: TextStyle(
                      color: textC, fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text("كيف كانت تجربتك مع ${widget.storeName}؟",
                  style:
                      TextStyle(color: textC.withOpacity(0.5), fontSize: 13)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    5,
                    (i) => GestureDetector(
                          onTap: () =>
                              setSheetState(() => selectedStars = i + 1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              i < selectedStars
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color: AppColors.goldenBronze,
                              size: 44,
                            ),
                          ),
                        )),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  if (selectedStars > 0) {
                    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                      content: Text("شكراً لتقييمك! ($selectedStars نجوم) ✅"),
                      backgroundColor: AppColors.goldenBronze,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ));
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: selectedStars > 0
                        ? AppColors.goldenBronze
                        : AppColors.goldenBronze.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text("إرسال التقييم",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ]),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Sticky Tab Delegate
// ============================================================================
class _StickyTabDelegate extends SliverPersistentHeaderDelegate {
  _StickyTabDelegate(this._tabBar, this.isDark);
  final TabBar _tabBar;
  final bool isDark;

  @override
  double get minExtent => _tabBar.preferredSize.height + 10;
  @override
  double get maxExtent => _tabBar.preferredSize.height + 10;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: isDark ? AppColors.deepNavy : AppColors.pureWhite,
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabDelegate old) => false;
}
