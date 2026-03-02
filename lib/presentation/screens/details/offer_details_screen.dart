import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/offer_action_buttons.dart';
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

  // بيانات مُولّدة داخلياً
  late List<String> _images;
  late String _title;
  late String _storeName;
  late String _storeLogo;
  late String _price;
  late String _oldPrice;
  late String _discount;
  late List<Map<String, dynamic>> _bundleItems;

  // تعليقات مختصرة (3 فقط)
  final List<Map<String, dynamic>> _previewComments = [
    {
      "user": "أحمد محمد",
      "avatar": "https://i.pravatar.cc/150?img=1",
      "text": "عرض ممتاز جداً! 👏",
      "time": "منذ ساعتين",
      "likes": 24,
      "mood": "😍"
    },
    {
      "user": "فاطمة يوسف",
      "avatar": "https://i.pravatar.cc/150?img=9",
      "text": "السعر مناسب مقارنة بالمحلات",
      "time": "منذ 5 ساعات",
      "likes": 15,
      "mood": "😊"
    },
    {
      "user": "عمر العبدلي",
      "avatar": "https://i.pravatar.cc/150?img=3",
      "text": "جربته وكان عادي صراحة",
      "time": "منذ يوم",
      "likes": 7,
      "mood": "😐"
    },
  ];

  // عروض مشابهة
  final List<Map<String, dynamic>> _similarOffers = [
    {
      "title": "سماعة ابل ايربودز",
      "image":
          "https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?auto=format&fit=crop&w=500&q=80",
      "price": "199\$",
      "store": "اكسترا"
    },
    {
      "title": "ساعة ذكية Amazfit",
      "image":
          "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=500&q=80",
      "price": "89\$",
      "store": "نون"
    },
    {
      "title": "حقيبة ظهر رياضية",
      "image":
          "https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=500&q=80",
      "price": "45\$",
      "store": "نايك"
    },
  ];

  @override
  void initState() {
    super.initState();
    final d = widget.offerData;
    _title = d["title"] ?? "عرض مميز";
    _storeName = d["storeName"] ?? d["store"] ?? "متجر";
    _storeLogo =
        d["storeLogo"] ?? d["logo"] ?? "https://i.pravatar.cc/150?img=11";
    _price = d["price"] ?? "";
    _oldPrice = d["oldPrice"] ?? "";
    _discount = d["discount"] ?? d["saving"] ?? "";

    // بناء قائمة الصور
    if (widget.offerType == OfferDetailType.brochure && d["pages"] is List) {
      _images = List<String>.from(d["pages"]);
    } else if (widget.offerType == OfferDetailType.brochure) {
      // pages is int (page count) — use single image
      final main = d["image"] ?? "";
      _images = [main];
    } else if (d["images"] != null) {
      _images = List<String>.from(d["images"]);
    } else {
      final main = d["image"] ?? "";
      _images = [main, main, main]; // صورة واحدة مكررة كعرض وهمي
    }

    // محتويات الباقة
    _bundleItems = [];
    if (widget.offerType == OfferDetailType.bundled && d["images"] != null) {
      final imgs = List<String>.from(d["images"]);
      for (int i = 0; i < imgs.length; i++) {
        _bundleItems.add({
          "name": "منتج ${i + 1}",
          "image": imgs[i],
          "price": "${(i + 1) * 50}\$",
          "isLocal": d["isLocalImage"] ?? false
        });
      }
    }
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  bool get _isFeatured => widget.offerType == OfferDetailType.featured;
  bool get _isBrochure => widget.offerType == OfferDetailType.brochure;
  bool get _isBundled => widget.offerType == OfferDetailType.bundled;

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
                child: Stack(children: [
              CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // 1. معرض الصور
                    SliverToBoxAdapter(
                        child: _buildImageGallery(isDark, textC)),
                    // 2. المحتوى
                    SliverToBoxAdapter(child: _buildContent(isDark, textC)),
                  ]),
              // زر الرجوع العائم
              Positioned(
                  top: 10, right: 16, child: _buildBackButton(isDark, textC)),
            ]))));
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // شريط المتجر
          _buildStoreBar(isDark, textC, cardBg),
          const SizedBox(height: 14),
          // العنوان
          Text(_title,
              style: TextStyle(
                  color: textC,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  height: 1.3)),
          const SizedBox(height: 10),
          // السعر (مخفي للكتيبات)
          if (!_isBrochure) _buildPriceRow(isDark),
          if (!_isBrochure) const SizedBox(height: 6),
          // مدة الصلاحية
          _buildExpiryBadge(isDark),
          const SizedBox(height: 16),
          // أزرار التفاعل
          _buildActionBar(isDark, textC, cardBg),
          const SizedBox(height: 16),
          // محتويات الباقة (للمجمعة فقط)
          if (_isBundled) _buildBundleContents(isDark, textC, cardBg),
          // الوصف
          _buildDescription(isDark, textC, cardBg),
          const SizedBox(height: 16),
          // الإثبات الاجتماعي
          _buildSocialProof(isDark, textC, cardBg),
          const SizedBox(height: 16),
          // التعليقات
          _buildCommentsPreview(isDark, textC, cardBg),
          const SizedBox(height: 20),
          // عروض مشابهة
          _buildSimilarOffers(isDark, textC),
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
                          storeName: _storeName, storeLogo: _storeLogo))),
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
                        Text(_storeName,
                            style: TextStyle(
                                color: textC,
                                fontSize: 14,
                                fontWeight: FontWeight.w800)),
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
                      Text("12 عرض نشط",
                          style:
                              TextStyle(color: AppColors.grey, fontSize: 11)),
                    ])),
              ]),
            ),
          ),
          GestureDetector(
              onTap: () => _showStoreOffers(isDark),
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
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: isDark
                ? Colors.orange.withOpacity(0.1)
                : Colors.orange.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.timer_outlined, color: Colors.orange.shade700, size: 14),
          const SizedBox(width: 4),
          Text("ينتهي بعد 3 أيام",
              style: TextStyle(
                  color: Colors.orange.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
        ]));
  }

  // ==========================================
  // أزرار التفاعل
  // ==========================================
  Widget _buildActionBar(bool isDark, Color textC, Color cardBg) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: isDark
                    ? AppColors.goldenBronze.withOpacity(0.15)
                    : Colors.grey.shade200)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          OfferActionButtons(isDarkMode: isDark, offerId: "DETAIL_$_title"),
          _actionBtn(Icons.share_rounded, "مشاركة", isDark, textC,
              () => Share.share('تصفح العرض: $_title على SIDE')),
          _actionBtn(Icons.chat_rounded, "تواصل\nمع التاجر", isDark, textC, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => MerchantChatScreen(
                        storeName: _storeName,
                        storeLogo: _storeLogo,
                        offerTitle: _title)));
          }),
          _actionBtn(Icons.support_agent_rounded, "الدعم\nالفني", isDark, textC,
              () => _showSupportSheet(isDark)),
        ]));
  }

  Widget _actionBtn(IconData icon, String label, bool isDark, Color textC,
      VoidCallback onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  color:
                      isDark ? AppColors.deepNavy : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: AppColors.goldenBronze, size: 20)),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  color: textC, fontSize: 10, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
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
      const SizedBox(height: 10),
      // شريط التوفير
      Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            const Icon(Icons.savings_rounded, color: AppColors.error, size: 20),
            const SizedBox(width: 8),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text("توفير $_discount",
                      style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 14,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                          value: 0.43,
                          backgroundColor: Colors.grey.shade200,
                          valueColor:
                              const AlwaysStoppedAnimation(AppColors.error),
                          minHeight: 6)),
                ])),
          ])),
      const SizedBox(height: 16),
    ]);
  }

  // ==========================================
  // الوصف
  // ==========================================
  Widget _buildDescription(bool isDark, Color textC, Color cardBg) {
    final desc = _isBrochure
        ? "كتيب عروض $_storeName يحتوي على ${_images.length} صفحة من أفضل العروض والتخفيضات. تصفح جميع الصفحات واكتشف عروض لا تُفوَّت!"
        : "عرض حصري من $_storeName على $_title. استفد من هذا العرض المميز قبل انتهاء المدة. العرض يشمل ضمان الجودة والأصالة. الكمية محدودة، سارع بالاستفادة واحصل على أفضل قيمة مقابل السعر.";

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
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: isDark
                    ? AppColors.goldenBronze.withOpacity(0.15)
                    : Colors.grey.shade200)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _proofItem("👁", "247", "مشاهدة", textC),
          Container(
              width: 1,
              height: 30,
              color: isDark ? Colors.white12 : Colors.grey.shade200),
          _proofItem("❤️", "89", "إعجاب", textC),
          Container(
              width: 1,
              height: 30,
              color: isDark ? Colors.white12 : Colors.grey.shade200),
          _proofItem("💬", "23", "تعليق", textC),
        ]));
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
  // التعليقات (3 فقط)
  // ==========================================
  Widget _buildCommentsPreview(bool isDark, Color textC, Color cardBg) {
    // إحصائيات المشاعر
    final moods = [
      {
        "emoji": "😍",
        "label": "مبهر",
        "pct": 0.40,
        "color": const Color(0xFF4CAF50)
      },
      {
        "emoji": "😊",
        "label": "جيد",
        "pct": 0.35,
        "color": AppColors.goldenBronze
      },
      {"emoji": "😐", "label": "عادي", "pct": 0.20, "color": Colors.orange},
      {"emoji": "😤", "label": "سيء", "pct": 0.05, "color": AppColors.error},
    ];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text("التعليقات 💬",
            style: TextStyle(
                color: textC, fontSize: 16, fontWeight: FontWeight.w800)),
        GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AllCommentsScreen(offerTitle: _title))),
            child: const Row(children: [
              Text("عرض الكل (23)",
                  style: TextStyle(
                      color: AppColors.goldenBronze,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
              SizedBox(width: 4),
              Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.goldenBronze, size: 12)
            ])),
      ]),
      const SizedBox(height: 10),
      // إحصائيات المشاعر
      Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: isDark
                      ? AppColors.goldenBronze.withOpacity(0.15)
                      : Colors.grey.shade200)),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: moods
                  .map((m) => Column(children: [
                        Text(m["emoji"] as String,
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(height: 4),
                        Text("${((m["pct"] as double) * 100).toInt()}%",
                            style: TextStyle(
                                color: textC,
                                fontSize: 13,
                                fontWeight: FontWeight.w800)),
                        Text(m["label"] as String,
                            style:
                                TextStyle(color: AppColors.grey, fontSize: 10)),
                      ]))
                  .toList())),
      const SizedBox(height: 10),
      // 3 تعليقات
      ..._previewComments.map((c) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: isDark
                      ? AppColors.goldenBronze.withOpacity(0.15)
                      : Colors.grey.shade200)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CircleAvatar(
                radius: 16, backgroundImage: NetworkImage(c["avatar"])),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Text(c["user"],
                        style: TextStyle(
                            color: textC,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(width: 6),
                    Text(c["mood"], style: const TextStyle(fontSize: 12)),
                    const Spacer(),
                    Text(c["time"],
                        style: TextStyle(color: AppColors.grey, fontSize: 10)),
                  ]),
                  const SizedBox(height: 4),
                  Text(c["text"],
                      style: TextStyle(
                          color: textC.withOpacity(0.8), fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.thumb_up_alt_outlined,
                        color: AppColors.grey, size: 14),
                    const SizedBox(width: 4),
                    Text("${c["likes"]}",
                        style: TextStyle(color: AppColors.grey, fontSize: 11)),
                  ]),
                ])),
          ]))),
    ]);
  }

  // ==========================================
  // عروض مشابهة
  // ==========================================
  Widget _buildSimilarOffers(bool isDark, Color textC) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("عروض مشابهة 🔄",
          style: TextStyle(
              color: textC, fontSize: 16, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _similarOffers.length,
            itemBuilder: (_, i) {
              final o = _similarOffers[i];
              final cardBg =
                  isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
              return GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => OfferDetailsScreen(
                              offerData: o,
                              offerType: OfferDetailType.standard)));
                },
                child: Container(
                  width: 130,
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
                                child: Image.network(o["image"],
                                    fit: BoxFit.cover,
                                    width: double.infinity))),
                        Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(o["title"],
                                      style: TextStyle(
                                          color: textC,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  Text(o["price"],
                                      style: const TextStyle(
                                          color: AppColors.goldenBronze,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900)),
                                  Text(o["store"],
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
                      Text("الدعم الفني 🛟",
                          style: TextStyle(
                              color: textC,
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      Text("تواصل مع إدارة التطبيق للشكاوي أو الاستفسارات",
                          style:
                              TextStyle(color: AppColors.grey, fontSize: 13)),
                      const SizedBox(height: 16),
                      _supportOption(Icons.email_outlined,
                          "إرسال رسالة للإدارة", isDark, textC),
                      _supportOption(Icons.report_problem_outlined,
                          "الإبلاغ عن مشكلة", isDark, textC),
                      _supportOption(Icons.help_outline_rounded,
                          "الأسئلة الشائعة", isDark, textC),
                    ]))));
  }

  Widget _supportOption(IconData icon, String label, bool isDark, Color textC) {
    return Padding(
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
            ])));
  }

  void _showStoreOffers(bool isDark) {
    final bg = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                    color: bg,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24))),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
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
                      Row(children: [
                        CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(_storeLogo)),
                        const SizedBox(width: 10),
                        Text("عروض $_storeName",
                            style: TextStyle(
                                color: textC,
                                fontSize: 18,
                                fontWeight: FontWeight.w800)),
                      ]),
                      const SizedBox(height: 16),
                      Expanded(
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: _similarOffers.length,
                              itemBuilder: (_, i) {
                                final o = _similarOffers[i];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => OfferDetailsScreen(
                                                offerData: o,
                                                offerType:
                                                    OfferDetailType.standard)));
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: isDark
                                              ? AppColors.deepNavy
                                              : AppColors.lightBackground,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Row(children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(o["image"],
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover)),
                                        const SizedBox(width: 10),
                                        Expanded(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                              Text(o["title"],
                                                  style: TextStyle(
                                                      color: textC,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                              Text(o["price"],
                                                  style: const TextStyle(
                                                      color: AppColors
                                                          .goldenBronze,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w900)),
                                            ])),
                                      ])),
                                );
                              })),
                    ]))));
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
