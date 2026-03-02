import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class LegalScreen extends StatelessWidget {
  final String title;
  final String type; // "about", "privacy", "terms"

  const LegalScreen({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.deepNavy : AppColors.lightBackground;
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    final cardC = isDark ? const Color(0xFF072A38) : Colors.white;
    final borderC = isDark
        ? AppColors.goldenBronze.withOpacity(0.15)
        : Colors.grey.shade200;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          leading: IconButton(
              icon:
                  Icon(Icons.arrow_forward_ios_rounded, color: textC, size: 20),
              onPressed: () => Navigator.pop(context)),
          title: Text(title,
              style: TextStyle(
                  color: textC, fontSize: 18, fontWeight: FontWeight.w900)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (type == "about") ...[
              // Logo + App info
              Center(
                  child: Column(children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: AppColors.goldenBronze.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Icon(Icons.local_offer_rounded,
                      color: AppColors.goldenBronze, size: 40),
                ),
                const SizedBox(height: 12),
                Text("عروضي",
                    style: TextStyle(
                        color: textC,
                        fontSize: 24,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text("الإصدار 1.0.0",
                    style:
                        TextStyle(color: textC.withOpacity(0.4), fontSize: 13)),
                const SizedBox(height: 20),
              ])),
              _section(
                  "من نحن",
                  "عروضي هو تطبيق يهدف إلى تجميع أفضل العروض والخصومات من مختلف المتاجر في مكان واحد، ليسهل عليك الوصول لأفضل الصفقات وتوفير المال.\n\nنسعى لتقديم تجربة تسوق ذكية تربط بين المتاجر والعملاء بطريقة مبتكرة وسلسة.",
                  textC,
                  cardC,
                  borderC),
              _section(
                  "رؤيتنا",
                  "أن نكون المنصة الأولى للعروض والتخفيضات في المنطقة العربية، مع التركيز على الجودة والموثوقية.",
                  textC,
                  cardC,
                  borderC),
              _section(
                  "تواصل معنا",
                  "البريد: support@oroodi.com\nالهاتف: +967 1 234 567\nتويتر: @OoroodiApp",
                  textC,
                  cardC,
                  borderC),
            ] else if (type == "privacy") ...[
              _section(
                  "سياسة الخصوصية",
                  "نحن في تطبيق عروضي نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية. تشرح هذه السياسة كيفية جمع واستخدام وحماية معلوماتك.",
                  textC,
                  cardC,
                  borderC),
              _section(
                  "البيانات التي نجمعها",
                  "• الاسم ورقم الهاتف والبريد الإلكتروني عند التسجيل\n• الموقع الجغرافي لعرض العروض المحلية\n• سجل التصفح والتفضيلات لتحسين التوصيات\n• بيانات الجهاز لأغراض تقنية",
                  textC,
                  cardC,
                  borderC),
              _section(
                  "كيف نستخدم بياناتك",
                  "• تخصيص تجربة الاستخدام\n• إرسال إشعارات العروض المناسبة\n• تحسين خدماتنا وأداء التطبيق\n• لا نشارك بياناتك مع أطراف ثالثة دون إذنك",
                  textC,
                  cardC,
                  borderC),
              _section(
                  "حقوقك",
                  "يحق لك طلب حذف بياناتك أو تعديلها في أي وقت من خلال إعدادات الحساب أو التواصل مع فريق الدعم.",
                  textC,
                  cardC,
                  borderC),
            ] else ...[
              _section(
                  "الشروط والأحكام",
                  "باستخدامك لتطبيق عروضي، فإنك توافق على الالتزام بالشروط والأحكام التالية. يرجى قراءتها بعناية.",
                  textC,
                  cardC,
                  borderC),
              _section(
                  "الاستخدام المقبول",
                  "• يُحظر استخدام التطبيق لأي أغراض غير قانونية\n• يجب تقديم معلومات صحيحة ودقيقة عند التسجيل\n• يُحظر انتحال شخصيات الآخرين أو المتاجر\n• يجب الالتزام بآداب التواصل عند مراسلة المتاجر",
                  textC,
                  cardC,
                  borderC),
              _section(
                  "حقوق الملكية",
                  "جميع المحتويات والتصاميم والعلامات التجارية في التطبيق محفوظة لصالح عروضي. لا يجوز نسخها أو استخدامها دون إذن مسبق.",
                  textC,
                  cardC,
                  borderC),
              _section(
                  "إخلاء المسؤولية",
                  "نحن نعمل كوسيط لعرض العروض ولا نتحمل مسؤولية جودة المنتجات أو صحة الأسعار المعروضة من قبل المتاجر. يُنصح بالتحقق من التفاصيل مباشرة مع المتجر.",
                  textC,
                  cardC,
                  borderC),
              _section(
                  "تحديث الشروط",
                  "نحتفظ بالحق في تحديث هذه الشروط في أي وقت. سيتم إخطارك بأي تغييرات جوهرية عبر إشعار داخل التطبيق.",
                  textC,
                  cardC,
                  borderC),
            ],
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }

  Widget _section(
      String heading, String body, Color textC, Color cardC, Color borderC) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: cardC,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderC)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(heading,
            style: TextStyle(
                color: textC, fontSize: 15, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Text(body,
            style: TextStyle(
                color: textC.withOpacity(0.65), fontSize: 13, height: 1.7)),
      ]),
    );
  }
}
