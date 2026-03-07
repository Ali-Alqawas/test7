# 🛍️ SIDE - Smart Integrated Deals Engine

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.6.1-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.6.1-0175C2?style=for-the-badge&logo=dart)
![Provider](https://img.shields.io/badge/Provider-6.1.2-orange?style=for-the-badge)
![Lines of Code](https://img.shields.io/badge/Lines%20of%20Code-25.5K-blue?style=for-the-badge)
![Files](https://img.shields.io/badge/Dart%20Files-67-green?style=for-the-badge)
![License](https://img.shields.io/badge/License-Private-red?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-In%20Development-yellow?style=for-the-badge)

**منصة ذكية متكاملة لإدارة العروض والخصومات التجارية**

[المميزات](#-المميزات-الرئيسية) • [لقطات الشاشة](#-لقطات-الشاشة) • [البنية التقنية](#️-البنية-التقنية) • [التثبيت](#-التثبيت-والإعداد) • [الاستخدام](#-الاستخدام) • [المساهمة](#-المساهمة)

</div>

---

## 📋 نظرة عامة

**SIDE** (Smart Integrated Deals Engine) هو تطبيق Flutter متقدم يهدف إلى إحداث ثورة في تجربة التسوق الإلكتروني من خلال توفير منصة موحدة وذكية لإدارة العروض والخصومات التجارية.

### 🎯 الهدف من المشروع

توفير تجربة تسوق سلسة ومتكاملة تجمع بين:
- **التجميع الذكي**: عرض جميع العروض والخصومات من مختلف المتاجر في مكان واحد
- **التخصيص**: نظام توصيات ذكي مبني على اهتمامات وسلوك المستخدم
- **التفاعل**: تواصل مباشر مع التجار ونظام تقييمات شامل
- **المكافآت**: نظام نقاط ومكافآت لتحفيز المستخدمين
- **الذكاء الاصطناعي**: مساعد ذكي للإجابة على الاستفسارات ومساعدة المستخدمين

### 📊 إحصائيات المشروع

| المقياس | القيمة |
|---------|--------|
| إجمالي الأسطر البرمجية | 25,525 سطر |
| عدد ملفات Dart | 67 ملف |
| عدد الشاشات | 37+ شاشة |
| المكونات القابلة لإعادة الاستخدام | 18 مكون |
| الفئات الرئيسية | 15 فئة |

---

## ✨ المميزات الرئيسية

### 🎨 واجهة المستخدم المتقدمة
- ✅ **نظام تصميم موحد** مع 18 مكون مخصص
- ✅ **Glass Morphism Effects** - تأثيرات زجاجية عصرية
- ✅ **Responsive Design** - تصميم متجاوب لجميع الأجهزة
- ✅ **Dark/Light Mode** - نظام ثيمات متكامل
- ✅ **Custom Animations** - رسوم متحركة سلسة

### 🔐 نظام المصادقة المتقدم
- ✅ **JWT Token Management** - إدارة متقدمة للتوكنات
- ✅ **OTP Verification** - التحقق عبر رمز OTP
- ✅ **Password Recovery** - استعادة كلمة المرور
- ✅ **Auto Token Refresh** - تجديد تلقائي للتوكنات
- ✅ **Secure Storage** - تخزين آمن للبيانات

### 🛒 إدارة العروض الذكية
- ✅ **عروض حصرية** مع عرض دوار تفاعلي
- ✅ **عروض مجمعة** (باقات) لتوفير أكبر
- ✅ **تصفية متقدمة** حسب الفئة والسعر والموقع
- ✅ **بحث ذكي** مع اقتراحات فورية
- ✅ **نظام تقييمات** شامل للعروض والتجار

### 🤖 المساعد الذكي
- ✅ **Chatbot متقدم** للإجابة على الاستفسارات
- ✅ **توصيات شخصية** مبنية على سلوك المستخدم
- ✅ **دعم متعدد اللغات** (العربية والإنجليزية)

### 🎁 نظام المكافآت
- ✅ **نقاط الولاء** مع كل عملية شراء
- ✅ **سحوبات ومسابقات** دورية
- ✅ **خصومات حصرية** للأعضاء المميزين

---

## 📱 لقطات الشاشة

<div align="center">

### الشاشة الرئيسية والتنقل
| الشاشة الرئيسية | الفئات | العروض المميزة |
|:---:|:---:|:---:|
| ![Home](screenshots/home.png) | ![Categories](screenshots/categories.png) | ![Offers](screenshots/offers.png) |

### المصادقة والملف الشخصي
| تسجيل الدخول | الملف الشخصي | المكافآت |
|:---:|:---:|:---:|
| ![Login](screenshots/login.png) | ![Profile](screenshots/profile.png) | ![Rewards](screenshots/rewards.png) |

### تفاصيل العروض والتفاعل
| تفاصيل العرض | ملف التاجر | المحادثة |
|:---:|:---:|:---:|
| ![Offer Details](screenshots/offer_details.png) | ![Merchant](screenshots/merchant.png) | ![Chat](screenshots/chat.png) |

</div>

---

## 🏗️ البنية التقنية

### 📱 التقنيات المستخدمة

| التقنية | الإصدار | الغرض |
|---------|---------|-------|
| Flutter | 3.6.1 | إطار العمل الأساسي |
| Dart | 3.6.1 | لغة البرمجة |
| Provider | ^6.1.2 | إدارة الحالة |
| HTTP | ^1.6.0 | طلبات الشبكة |
| SharedPreferences | ^2.5.3 | التخزين المحلي |

### 🗂️ هيكل المشروع

```
lib/
├── core/                          # الملفات الأساسية
│   ├── constants/                 # الثوابت والإعدادات
│   ├── network/                   # إدارة الشبكة والAPI
│   ├── theme/                     # نظام الثيمات
│   └── widgets/                   # المكونات المشتركة (18 مكون)
├── data/                          # طبقة البيانات
│   ├── models/                    # نماذج البيانات
│   ├── providers/                 # مزودي البيانات
│   └── repositories/              # مستودعات البيانات
├── presentation/                  # طبقة العرض
│   ├── screens/                   # الشاشات (37+ شاشة)
│   │   ├── auth/                  # شاشات المصادقة (6)
│   │   ├── home/                  # الشاشة الرئيسية
│   │   ├── offers/                # شاشات العروض (5)
│   │   ├── categories/            # شاشات الفئات (2)
│   │   ├── details/               # شاشات التفاصيل (4)
│   │   ├── profile/               # شاشات الملف الشخصي (10)
│   │   └── others/                # شاشات أخرى
│   └── widgets/                   # مكونات العرض المخصصة
└── utils/                         # الأدوات المساعدة
```

### 🔄 إدارة الحالة

يستخدم المشروع **Provider** لإدارة الحالة مع التقسيم التالي:

- **AuthProvider**: إدارة حالة المصادقة والمستخدم
- **OffersProvider**: إدارة العروض والفلترة
- **ThemeProvider**: إدارة نظام الثيمات
- **CategoriesProvider**: إدارة الفئات والتصنيفات
- **ChatProvider**: إدارة المحادثات والمساعد الذكي

---

## 🚀 التثبيت والإعداد

### المتطلبات الأساسية

- Flutter SDK 3.6.1 أو أحدث
- Dart SDK 3.6.1 أو أحدث
- Android Studio / VS Code
- Git

### خطوات التثبيت

1. **استنساخ المشروع**
```bash
git clone https://github.com/your-username/side-app.git
cd side-app
```

2. **تثبيت التبعيات**
```bash
flutter pub get
```

3. **إعداد متغيرات البيئة**
```bash
# إنشاء ملف .env في الجذر
cp .env.example .env
# تحديث المتغيرات حسب بيئة التطوير
```

4. **تشغيل التطبيق**
```bash
# للتطوير
flutter run

# للإنتاج
flutter run --release
```

### إعداد Backend API

```dart
// في ملف lib/core/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'https://your-api-domain.com/api';
  static const String authEndpoint = '/auth';
  static const String offersEndpoint = '/offers';
  // باقي endpoints...
}
```

---

## 📖 الاستخدام

### تشغيل التطبيق للمطورين

```bash
# تشغيل في وضع التطوير مع Hot Reload
flutter run --debug

# تشغيل مع profiling
flutter run --profile

# بناء للإنتاج
flutter build apk --release
flutter build ios --release
```

### اختبار المكونات

```bash
# تشغيل جميع الاختبارات
flutter test

# اختبار مكون معين
flutter test test/widgets/custom_button_test.dart
```

### إضافة شاشة جديدة

1. إنشاء ملف الشاشة في `lib/presentation/screens/`
2. إضافة Provider إذا لزم الأمر
3. تحديث نظام التنقل في `lib/core/navigation/`
4. إضافة الاختبارات المناسبة

---

## 📈 حالة المشروع

### ✅ المكتمل

- [x] نظام المصادقة الكامل مع JWT
- [x] الشاشة الرئيسية الديناميكية
- [x] إدارة العروض والفئات
- [x] نظام الثيمات (Dark/Light)
- [x] المكونات القابلة لإعادة الاستخدام
- [x] تكامل Backend API
- [x] نظام التنقل المتقدم

### 🔄 قيد التطوير

- [ ] المساعد الذكي (Chatbot)
- [ ] نظام المكافآت والنقاط
- [ ] الإشعارات Push
- [ ] التحليلات والإحصائيات
- [ ] نظام الدفع المتكامل

### 🔮 مخطط له

- [ ] تطبيق للتجار (Merchant App)
- [ ] لوحة تحكم الإدارة (Admin Panel)
- [ ] تطبيق الويب (Web Version)
- [ ] API متقدم للذكاء الاصطناعي

---

## 🗺️ خارطة الطريق

### المرحلة الأولى (Q1 2024) ✅
- [x] إكمال نظام المصادقة
- [x] تطوير الشاشات الأساسية
- [x] تكامل Backend API الأساسي

### المرحلة الثانية (Q2 2024) 🔄
- [ ] إطلاق المساعد الذكي
- [ ] نظام المكافآت والولاء
- [ ] تحسينات الأداء والأمان

### المرحلة الثالثة (Q3 2024) 📋
- [ ] تطبيق التجار
- [ ] لوحة تحكم الإدارة
- [ ] نظام التحليلات المتقدم

### المرحلة الرابعة (Q4 2024) 🎯
- [ ] إطلاق تطبيق الويب
- [ ] توسيع الذكاء الاصطناعي
- [ ] دعم المدفوعات الرقمية

---

## 🤝 المساهمة

نرحب بمساهماتكم لتطوير المشروع! يرجى اتباع الإرشادات التالية:

### قواعد المساهمة

1. **Fork** المشروع
2. إنشاء **branch** جديد للميزة (`git checkout -b feature/amazing-feature`)
3. **Commit** التغييرات (`git commit -m 'Add amazing feature'`)
4. **Push** إلى البرانش (`git push origin feature/amazing-feature`)
5. فتح **Pull Request**

### معايير الكود

- اتباع [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- إضافة تعليقات باللغة العربية للوضوح
- كتابة اختبارات للميزات الجديدة
- تحديث التوثيق عند الحاجة

### أنواع المساهمات المرحب بها

- 🐛 إصلاح الأخطاء (Bug Fixes)
- ✨ ميزات جديدة (New Features)
- 📚 تحسين التوثيق (Documentation)
- 🎨 تحسينات UI/UX
- ⚡ تحسينات الأداء (Performance)
- 🔒 تحسينات الأمان (Security)

---

## 📄 الترخيص

هذا المشروع محمي بحقوق الطبع والنشر وهو ملكية خاصة. جميع الحقوق محفوظة.

```
Copyright (c) 2024 SIDE Development Team
All rights reserved.

This software is proprietary and confidential.
Unauthorized copying, distribution, or use is strictly prohibited.
```

---

## 📞 التواصل والدعم

### فريق التطوير

- **المطور الرئيسي**: [اسم المطور]
- **مصمم UI/UX**: [اسم المصمم]
- **مطور Backend**: [اسم المطور]

### قنوات التواصل

- 📧 **البريد الإلكتروني**: support@side-app.com
- 💬 **Discord**: [رابط الخادم]
- 📱 **تليجرام**: [@SIDESupport]
- 🐦 **تويتر**: [@SIDEApp]

### الإبلاغ عن المشاكل

لإبلاغ عن خطأ أو طلب ميزة جديدة، يرجى:
1. التحقق من [Issues](https://github.com/your-username/side-app/issues) الموجودة
2. إنشاء Issue جديد مع وصف مفصل
3. إرفاق لقطات شاشة إذا أمكن

---

<div align="center">

**صُنع بـ ❤️ في المملكة العربية السعودية**

[![Flutter](https://img.shields.io/badge/Built%20with-Flutter-blue?style=flat-square&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Language-Dart-blue?style=flat-square&logo=dart)](https://dart.dev)

**SIDE - Smart Integrated Deals Engine**

*تجربة تسوق ذكية ومتكاملة*

</div>