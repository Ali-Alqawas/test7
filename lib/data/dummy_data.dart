// اسم الملف: dummy_data.dart

// ============================================================================
// 1. نماذج البيانات (DATA MODELS)
// ============================================================================

enum OfferType { standard, featured, brochure }

class OfferModel {
  final String id;
  final String title;
  final String storeName;
  final String storeLogo;
  final String image;
  final String price;
  final String? oldPrice;
  final String discount;
  final OfferType type;
  final int? pagesCount; // خاص بالبروشور
  final int? itemsCount; // خاص بالباقة

  OfferModel({
    required this.id,
    required this.title,
    required this.storeName,
    required this.storeLogo,
    required this.image,
    required this.price,
    this.oldPrice,
    required this.discount,
    this.type = OfferType.standard,
    this.pagesCount,
    this.itemsCount,
  });
}

class FlashOfferModel {
  final String title;
  final String image;
  final String timeLeft;
  final int remainingStock;

  FlashOfferModel({
    required this.title,
    required this.image,
    required this.timeLeft,
    required this.remainingStock,
  });
}

// ============================================================================
// 2. البيانات الوهمية (MOCK DATA)
// ============================================================================

class AppData {
  // بيانات المستخدم
  static const String userName = "حازم";
  static const String userLocation = "صنعاء، حدة";
  static const String userPoints = "1,250";
  static const String userImage = "https://i.pravatar.cc/150?img=11";

  // التصنيفات
  static const List<String> categories = [
    "الكل",
    "ملابس وأزياء",
    "إلكترونيات",
    "مطاعم وكافيهات",
    "هايبر ماركت",
    "صحة وجمال",
    "خدمات"
  ];

  // البنرات العلوية
  static final List<Map<String, String>> banners = [
    {
      "image":
          "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?auto=format&fit=crop&w=800",
      "tag": "عروض الجمعة",
      "title": "تخفيضات كبرى\nعلى الإلكترونيات",
    },
    {
      "image":
          "https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=800",
      "tag": "وصل حديثاً",
      "title": "كولكشن الشتاء\nخصم 40%",
    },
  ];

  // قائمة العروض الرئيسية (المختلطة)
  static final List<OfferModel> mainOffers = [
    OfferModel(
      id: "1",
      title: "MacBook Pro M3 Max",
      storeName: "موبايل زون",
      storeLogo: "https://cdn-icons-png.flaticon.com/512/882/882747.png",
      image:
          "https://images.unsplash.com/photo-1517336714731-489689fd1ca4?auto=format&fit=crop&w=600",
      price: "1,200\$",
      oldPrice: "1,450\$",
      discount: "15%",
      type: OfferType.featured,
    ),
    OfferModel(
      id: "2",
      title: "مهرجان التسوق الشهري",
      storeName: "هايبر المستهلك",
      storeLogo: "https://cdn-icons-png.flaticon.com/512/3081/3081559.png",
      image:
          "https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=600",
      price: "عروض تبدأ من 500 ريال",
      discount: "توفير",
      type: OfferType.brochure,
      pagesCount: 8,
      itemsCount: 150,
    ),
    OfferModel(
      id: "3",
      title: "طقم رجالي رسمي فاخر",
      storeName: "سيتي ماكس",
      storeLogo: "https://cdn-icons-png.flaticon.com/512/1598/1598431.png",
      image:
          "https://images.unsplash.com/photo-1594938298603-c8148c4dae35?auto=format&fit=crop&w=600",
      price: "15,000 ر.ي",
      oldPrice: "22,000",
      discount: "30%",
      type: OfferType.standard,
    ),
    OfferModel(
      id: "4",
      title: "وجبة برجر عائلي (4 أشخاص)",
      storeName: "رويال برجر",
      storeLogo: "https://cdn-icons-png.flaticon.com/512/732/732217.png",
      image:
          "https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?auto=format&fit=crop&w=600",
      price: "6,000 ر.ي",
      oldPrice: "8,500",
      discount: "25%",
      type: OfferType.standard,
    ),
    OfferModel(
      id: "5",
      title: "كتالوج عروض الشاشات",
      storeName: "بست باي اليمن",
      storeLogo: "https://cdn-icons-png.flaticon.com/512/3659/3659899.png",
      image:
          "https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=600",
      price: "خصومات 50%",
      discount: "ناري",
      type: OfferType.brochure,
      pagesCount: 4,
      itemsCount: 20,
    ),
    OfferModel(
      id: "6",
      title: "حذاء نايك رياضي أصلي",
      storeName: "أديداس ستور",
      storeLogo: "https://cdn-icons-png.flaticon.com/512/732/732229.png",
      image:
          "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=600",
      price: "45\$",
      oldPrice: "80\$",
      discount: "45%",
      type: OfferType.standard,
    ),
    OfferModel(
      id: "7",
      title: "عطر عود ملكي فاخر",
      storeName: "عبدالصمد القرشي",
      storeLogo: "https://cdn-icons-png.flaticon.com/512/1940/1940922.png",
      image:
          "https://images.unsplash.com/photo-1594035910387-fea477942698?auto=format&fit=crop&w=600",
      price: "50,000 ر.ي",
      oldPrice: "80,000",
      discount: "40%",
      type: OfferType.featured,
    ),
  ];

  // عروض الفلاش (تنتهي قريباً)
  static final List<FlashOfferModel> flashOffers = [
    FlashOfferModel(
      title: "سماعات Sony",
      image:
          "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=400",
      timeLeft: "01:30:00",
      remainingStock: 3,
    ),
    FlashOfferModel(
      title: "ساعة ذكية",
      image:
          "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=400",
      timeLeft: "04:15:00",
      remainingStock: 1,
    ),
    FlashOfferModel(
      title: "كاميرا Canon",
      image:
          "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=400",
      timeLeft: "00:45:00",
      remainingStock: 2,
    ),
  ];
}
