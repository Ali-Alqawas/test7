import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../presentation/screens/details/offer_details_screen.dart';

// =========================================================================
// 1. قالب العرض المميز (Featured Offer Card)
// يُستخدم للمنتجات الحصرية والفخمة (مثل الساعات، العطور الغالية)
// =========================================================================
class FeaturedOfferCard extends StatelessWidget {
  final Map<String, dynamic> offer;
  final double height;

  const FeaturedOfferCard(
      {super.key, required this.offer, required this.height});

  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OfferDetailsScreen(
                    offerData: offer, offerType: OfferDetailType.featured))),
        child: Container(
          height: height,
          // 1. الإطار الذهبي المتدرج (السر في جعل الحاوية الأب ملونة بتدرج ذهبي مع حواف)
          padding: const EdgeInsets.all(2.5), // سُمك الإطار الذهبي
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                AppColors.goldenBronze,
                AppColors.goldenBronze.withOpacity(0.2), // لمعان في المنتصف
                AppColors.goldenBronze
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            // ظل ذهبي خفيف يعطي إيحاء بالفخامة
            boxShadow: [
              BoxShadow(
                  color: AppColors.goldenBronze.withOpacity(0.25),
                  blurRadius: 15,
                  spreadRadius: 1),
            ],
          ),
          // 2. الحاوية الداخلية (التي تحمل الصورة)
          child: Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(18), // أصغر قليلاً من الأب ليظهر الإطار
              image: DecorationImage(
                  image: NetworkImage(offer['image']), fit: BoxFit.cover),
            ),
            child: Stack(
              children: [
                // 3. التدرج الأسود (Overlay) لضمان وضوح النصوص البيضاء والذهبية
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.deepNavy.withOpacity(0.95)
                          ]),
                    ),
                  ),
                ),

                // 4. نصوص المنتج (في الأسفل)
                Positioned(
                  bottom: 15,
                  left: 15,
                  right: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(offer['store'],
                          style: const TextStyle(
                              color: AppColors.goldenBronze,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(offer['title'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                          maxLines: 2),
                      const SizedBox(height: 6),
                      Text("${offer['price']} ر.ي",
                          style: const TextStyle(
                              color: AppColors.goldenBronze,
                              fontSize: 15,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),

                // 5. شريطة "حصري النخبة" (في الزاوية العلوية)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: const BoxDecoration(
                      color: AppColors.goldenBronze,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          topRight: Radius.circular(17) // تطابق زاوية الكارت
                          ),
                    ),
                    child: const Text("حصري النخبة",
                        style: TextStyle(
                            color: AppColors.deepNavy,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

// =========================================================================
// 2. قالب البروشور / الكتالوج (Brochure Offer Card)
// يُستخدم لعروض السوبرماركت والمحلات التي تنشر مجلات عروض
// =========================================================================
class BrochureOfferCard extends StatelessWidget {
  final Map<String, dynamic> offer;
  final double height;

  const BrochureOfferCard(
      {super.key, required this.offer, required this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OfferDetailsScreen(
                    offerData: offer, offerType: OfferDetailType.brochure)));
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          // 1. شكل الكتاب: زوايا يمنى دائرية، وزوايا يسرى حادة
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomLeft: Radius.circular(4),
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16)),
          // 2. كعب الكتاب: خط رمادي سميك من جهة اليسار فقط
          border:
              Border(left: BorderSide(color: Colors.grey.shade400, width: 6)),
          image: DecorationImage(
              image: NetworkImage(offer['image']), fit: BoxFit.cover),
          // 3. ظل قوي ليعطي إحساس الورقة المرفوعة
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(5, 5))
          ],
        ),
        child: Stack(
          children: [
            // التدرج الأسود السفلي
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8)
                      ]),
                ),
              ),
            ),

            // نصوص الكتالوج
            Positioned(
              bottom: 12,
              right: 10,
              left: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(offer['store'],
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 11)),
                  Text(offer['title'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                  const SizedBox(height: 4),
                  const Text("تصفح الكتالوج",
                      style: TextStyle(
                          color: AppColors.goldenBronze,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // أيقونة عدد الصفحات (في الأعلى)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColors.deepNavy.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Icon(Icons.menu_book,
                        color: AppColors.goldenBronze, size: 14),
                    const SizedBox(width: 4),
                    Text("${offer['pages'].length} ص",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// 3. شاشة عارض البروشور (The Interactive Brochure Viewer)
// شاشة سينمائية سوداء تفتح عند الضغط على قالب البروشور
// =========================================================================
class BrochureViewerScreen extends StatefulWidget {
  final List<String> pages; // يستقبل قائمة من روابط الصور (صفحات المجلة)
  const BrochureViewerScreen({super.key, required this.pages});

  @override
  State<BrochureViewerScreen> createState() => _BrochureViewerScreenState();
}

class _BrochureViewerScreenState extends State<BrochureViewerScreen> {
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // خلفية سوداء لتركيز النظر على العرض
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        // عرض رقم الصفحة الحالية من إجمالي الصفحات
        title: Text("صفحة $_currentPage من ${widget.pages.length}",
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        centerTitle: true,
      ),
      // 1. PageView: يسمح بسحب الصور يميناً ويساراً (تقليب الصفحات)
      body: PageView.builder(
        itemCount: widget.pages.length,
        onPageChanged: (index) => setState(() => _currentPage = index + 1),
        itemBuilder: (context, index) {
          // 2. InteractiveViewer: ويدجت سحرية تسمح للمستخدم بعمل Zoom (تكبير/تصغير) للصورة بإصبعيه
          return InteractiveViewer(
            minScale: 1.0,
            maxScale: 4.0, // أقصى حد للتكبير
            child: Image.network(widget.pages[index], fit: BoxFit.contain),
          );
        },
      ),
    );
  }
}
