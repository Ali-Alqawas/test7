<div align="center">

<img src="assets/images/side_logo.png" alt="SIDE Logo" width="120"/>

# SIDE — Smart Integrated Deals Engine

**منصة ذكية متكاملة لإدارة العروض والخصومات التجارية**

[![Flutter](https://img.shields.io/badge/Flutter-3.6.1-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.6.1-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Provider](https://img.shields.io/badge/Provider-6.1.2-FF6B35?style=for-the-badge)](https://pub.dev/packages/provider)
[![License](https://img.shields.io/badge/License-Proprietary-red?style=for-the-badge)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-green?style=for-the-badge)](pubspec.yaml)

</div>

---

## 📖 نظرة عامة

**SIDE** هو تطبيق Flutter متقدم يهدف إلى توحيد تجربة التسوق الرقمي من خلال منصة ذكية تجمع عروض وخصومات مئات المتاجر في مكان واحد. يتميز التطبيق بتصميم عصري يعتمد على **Glass Morphism**، ودعم كامل لوضعي الإضاءة (Dark/Light)، وبنية معمارية قابلة للتوسع.

### 🎯 الأهداف الرئيسية

| الهدف | الوصف |
|-------|-------|
| **التجميع الذكي** | عرض جميع العروض من مختلف المتاجر في منصة موحدة |
| **التخصيص** | نظام توصيات مبني على اهتمامات المستخدم |
| **التفاعل** | تواصل مباشر مع التجار ونظام تقييمات شامل |
| **المكافآت** | نظام نقاط وسحوبات لتحفيز المستخدمين |
| **الذكاء الاصطناعي** | مساعد ذكي للبحث والتوصيات |

---

## 📊 إحصائيات المشروع

<div align="center">

| المقياس | القيمة |
|---------|--------|
| 📁 ملفات Dart | **67 ملف** |
| 📱 الشاشات | **38 شاشة** |
| 🧩 المكونات المخصصة | **22 مكون** |
| 📦 التبعيات الخارجية | **6 حزم** |
| 🔗 API Endpoints | **60+ نقطة** |
| 🏗️ طبقات المعمارية | **3 طبقات** |

</div>

---

## ✅ ما تم إنجازه

### 🔐 نظام المصادقة الكامل
- [x] تسجيل الدخول بالبريد الإلكتروني وكلمة المرور
- [x] إنشاء حساب جديد مع التحقق
- [x] التحقق عبر OTP (رمز لمرة واحدة)
- [x] استعادة كلمة المرور (Forgot Password)
- [x] إعادة تعيين كلمة المرور (Reset Password)
- [x] شاشة اختيار الاهتمامات عند التسجيل
- [x] إدارة JWT Tokens (Access + Refresh)
- [x] تخزين آمن للبيانات عبر SharedPreferences
- [x] Auth Guard لحماية الشاشات المحمية

### 🏠 الشاشات الرئيسية
- [x] **Splash Screen** — شاشة البداية مع الشعار
- [x] **Onboarding** — شاشة التعريف بالتطبيق
- [x] **Home Screen** — الشاشة الرئيسية مع عروض ديناميكية وفئات وبانرات
- [x] **Main Layout** — التخطيط الرئيسي مع Bottom Navigation

### 🏷️ شاشات العروض
- [x] **Offers Screen** — عرض شامل لجميع العروض مع فلاتر متقدمة
- [x] **Featured Offers** — العروض المميزة
- [x] **Bundled Offers** — العروض المجمعة
- [x] **Banner Offers** — عروض البانرات الإعلانية
- [x] **All Brochures** — جميع الكتالوجات والبروشورات

### 📂 شاشات الفئات
- [x] **Categories Screen** — تصفح الفئات الرئيسية
- [x] **Category Offers** — عروض فئة محددة مع فلاتر

### 🔍 البحث والمفضلة
- [x] **Search Screen** — بحث متقدم مع فلاتر (السعر، الفئة، المتجر، التقييم)
- [x] **Favorites Screen** — إدارة العروض المحفوظة

### 🏪 المتاجر
- [x] **All Stores Screen** — عرض جميع المتاجر مع البحث

### 📋 شاشات التفاصيل
- [x] **Offer Details** — تفاصيل العرض الكاملة (صور، وصف، سعر، مشاركة)
- [x] **Merchant Profile** — ملف التاجر الكامل مع التقييمات
- [x] **All Comments** — جميع التعليقات والتقييمات
- [x] **Merchant Chat** — محادثة مباشرة مع التاجر

### 👤 شاشات الملف الشخصي
- [x] **Profile Screen** — الملف الشخصي الرئيسي مع الإحصائيات
- [x] **Edit Profile** — تعديل البيانات الشخصية وصورة الملف
- [x] **Rewards Screen** — نظام النقاط والمكافآت
- [x] **Draws Screen** — السحوبات والجوائز
- [x] **Security Screen** — الأمان وتغيير كلمة المرور
- [x] **Notifications Settings** — إعدادات الإشعارات
- [x] **Saved Addresses** — العناوين المحفوظة
- [x] **Inbox Screen** — صندوق الوارد
- [x] **Support Center** — مركز الدعم وتذاكر المساعدة
- [x] **Merchant Upgrade** — الترقية لحساب تاجر
- [x] **Legal Screen** — الشروط والأحكام والسياسات

### 🔔 الإشعارات
- [x] **Notifications Screen** — عرض الإشعارات مع التصنيف

### 🤖 المساعد الذكي
- [x] **Chatbot Screen** — واجهة المحادثة مع المساعد الذكي (UI جاهز)

### 🎨 نظام التصميم
- [x] **Design System Gallery** — معرض عناصر التصميم
- [x] Glass Morphism Effects
- [x] Dark / Light Mode كامل
- [x] ألوان موحدة (Golden Bronze + Deep Navy)
- [x] مكونات قابلة لإعادة الاستخدام (22 مكون)
- [x] AI Floating Action Button

### 🏗️ البنية التقنية
- [x] **Provider** لإدارة الحالة
- [x] **HTTP** مع إدارة متقدمة للـ API
- [x] **Token Manager** لإدارة JWT تلقائياً
- [x] **API Service** مركزي مع معالجة الأخطاء
- [x] **API Constants** — 60+ Endpoint منظم
- [x] **Auth Guard** لحماية المسارات
- [x] نظام استثناءات متكامل (ApiExceptions)
- [x] SharedPreferences للتخزين المحلي

---

## 🔄 قيد التطوير

### 🤖 المساعد الذكي (Chatbot)
- [ ] تكامل API الذكاء الاصطناعي مع Backend
- [ ] معالجة اللغة الطبيعية (NLP)
- [ ] توصيات ذكية مخصصة
- [ ] تاريخ المحادثات

### 🎁 نظام المكافآت
- [ ] تكامل نقاط المكافآت مع Backend
- [ ] آلية السحوبات الفعلية
- [ ] الخصومات الحصرية للأعضاء
- [ ] نظام الإحالة (Referral)

### 🔔 الإشعارات الفورية
- [ ] Firebase Push Notifications
- [ ] إشعارات العروض الجديدة
- [ ] تنبيهات انتهاء العروض
- [ ] إشعارات المكافآت

### 🔗 تكامل Providers
- [ ] OffersProvider
- [ ] FavoritesProvider
- [ ] CategoriesProvider
- [ ] StoresProvider
- [ ] NotificationsProvider
- [ ] ProfileProvider
- [ ] ChatProvider
- [ ] RewardsProvider

---

## 🗺️ خارطة الطريق المستقبلية

### المرحلة الثانية — تطبيق التجار
- [ ] Merchant App منفصل
- [ ] لوحة إدارة العروض
- [ ] إحصائيات المتجر
- [ ] إدارة الطلبات

### المرحلة الثالثة — لوحة الإدارة
- [ ] Admin Panel (Web)
- [ ] إدارة المستخدمين والتجار
- [ ] التحليلات والإحصائيات الشاملة
- [ ] إدارة المحتوى

### المرحلة الرابعة — التوسع
- [ ] نظام الدفع المتكامل
- [ ] تكامل الخرائط (Google Maps)
- [ ] مشاركة العروض عبر وسائل التواصل
- [ ] نسخة الويب (Flutter Web)
- [ ] دعم iOS الكامل

---

## 🗂️ هيكل المشروع

```
lib/
├── core/                              # الطبقة الأساسية
│   ├── helpers/
│   │   └── auth_guard.dart            # حماية المسارات
│   ├── network/
│   │   ├── api_constants.dart         # 60+ Endpoint مركزي
│   │   ├── api_service.dart           # HTTP Client مع interceptors
│   │   ├── api_exceptions.dart        # نظام الاستثناءات
│   │   └── token_manager.dart         # إدارة JWT تلقائياً
│   ├── theme/
│   │   ├── app_colors.dart            # نظام الألوان
│   │   ├── app_theme.dart             # Dark/Light Themes
│   │   └── theme_manager.dart         # ValueNotifier للثيم
│   └── widgets/                       # 22 مكون مخصص
│       ├── ai_floating_button.dart
│       ├── custom_bottom_nav.dart
│       ├── custom_button.dart
│       ├── custom_textfield.dart
│       ├── exclusive_offers_carousel.dart
│       ├── glass_container.dart
│       ├── offer_action_buttons.dart
│       ├── offer_filter_sheet.dart
│       ├── page_background.dart
│       ├── premium_bottom_nav_bar.dart
│       ├── premium_brochures_section.dart
│       ├── premium_bundled_offers.dart
│       ├── premium_categories.dart
│       ├── premium_featured_offers.dart
│       ├── premium_offer_cards.dart
│       ├── premium_quick_services.dart
│       ├── premium_standard_offer_card.dart
│       └── side_header_component.dart
│
├── data/                              # طبقة البيانات
│   ├── providers/
│   │   ├── auth_provider.dart         # إدارة حالة المصادقة
│   │   └── social_provider.dart       # المفضلة، اللايكات، المتابعة
│   └── dummy_data.dart                # بيانات تجريبية
│
├── presentation/                      # طبقة العرض
│   └── screens/                       # 38 شاشة
│       ├── auth/                      # 6 شاشات المصادقة
│       │   ├── login_screen.dart
│       │   ├── signup_screen.dart
│       │   ├── verification_screen.dart
│       │   ├── forgot_password_screen.dart
│       │   ├── reset_password_screen.dart
│       │   └── interests_screen.dart
│       ├── home/
│       │   └── home_screen.dart
│       ├── offers/                    # 5 شاشات العروض
│       │   ├── offers_screen.dart
│       │   ├── featured_offers_screen.dart
│       │   ├── bundled_offers_screen.dart
│       │   ├── banner_offers_screen.dart
│       │   └── all_brochures_screen.dart
│       ├── categories/
│       │   ├── categories_screen.dart
│       │   └── category_offers_screen.dart
│       ├── details/                   # 4 شاشات التفاصيل
│       │   ├── offer_details_screen.dart
│       │   ├── merchant_profile_screen.dart
│       │   ├── all_comments_screen.dart
│       │   └── merchant_chat_screen.dart
│       ├── profile/                   # 10 شاشات الملف الشخصي
│       │   ├── profile_screen.dart
│       │   ├── edit_profile_screen.dart
│       │   ├── rewards_screen.dart
│       │   ├── draws_screen.dart
│       │   ├── security_screen.dart
│       │   ├── notifications_settings_screen.dart
│       │   ├── saved_addresses_screen.dart
│       │   ├── inbox_screen.dart
│       │   ├── support_center_screen.dart
│       │   ├── merchant_upgrade_screen.dart
│       │   └── legal_screen.dart
│       ├── search/
│       │   └── search_screen.dart
│       ├── favorites/
│       │   └── favorites_screen.dart
│       ├── stores/
│       │   └── all_stores_screen.dart
│       ├── chatbot/
│       │   └── chatbot_screen.dart
│       ├── notifications/
│       │   └── notifications_screen.dart
│       ├── splash/
│       │   └── splash_screen.dart
│       ├── onboarding/
│       │   └── onboarding_screen.dart
│       ├── main_layout/
│       │   └── main_layout_screen.dart
│       └── design_system/
│           └── design_system_gallery.dart
│
└── main.dart                          # نقطة الدخول + MultiProvider
```

---

## 🔌 API Architecture

التطبيق يتصل بـ Backend يعمل على Django REST Framework عبر:

```
Base URL: http://<SERVER_IP>:8000/api/v1
```

### نقاط الـ API المدعومة

| المجال | Endpoints |
|--------|-----------|
| 🔐 Auth | login, register, OTP, password reset, token refresh |
| 👤 Profile | profile, account, phones, referral |
| 📂 Catalog | categories, products, product-groups, search |
| 🏪 Merchants | stores, store details |
| ❤️ Social | favorites, likes, comments, ratings, interests |
| 🎁 Rewards | points, draws, redemptions, referral |
| 🔔 Support | notifications, messages, tickets, devices |
| 🤖 Chatbot | sessions, chat, history |
| 📊 Analytics | views, shares, search logs, user stats |
| 🛠️ Core | banners, ads, settings, file upload |

---

## 📦 التبعيات

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8      # أيقونات iOS
  provider: ^6.1.2              # إدارة الحالة
  http: ^1.6.0                  # طلبات HTTP
  shared_preferences: ^2.5.3   # التخزين المحلي
  share_plus: ^10.0.0           # مشاركة المحتوى
  image_picker: ^1.2.0          # اختيار الصور
```

---

## 🎨 نظام التصميم

### الألوان الأساسية

| الاسم | الكود | الاستخدام |
|-------|-------|-----------|
| Golden Bronze | `#C9A84C` | اللون الرئيسي، الأزرار، التمييز |
| Deep Navy | `#0D1B2A` | الخلفية الداكنة |
| Surface Dark | `#1A2332` | بطاقات الوضع الداكن |
| Surface Light | `#F5F5F5` | خلفية الوضع الفاتح |

### المكونات الرئيسية

- **GlassContainer** — حاوية Glass Morphism مع blur effect
- **CustomButton** — زر موحد يدعم loading, outlined, icon
- **CustomTextField** — حقل إدخال مع prefix/suffix icons وكلمة مرور
- **PremiumBottomNavBar** — شريط تنقل سفلي مخصص
- **AIFloatingButton** — زر عائم للمساعد الذكي
- **OfferFilterSheet** — Bottom sheet للفلاتر المتقدمة
- **ExclusiveOffersCarousel** — كاروسيل العروض الحصرية

---

## 🚀 التثبيت والتشغيل

### المتطلبات

- Flutter SDK `3.6.1+`
- Dart SDK `3.6.1+`
- Android Studio / VS Code
- جهاز Android أو محاكي

### خطوات التثبيت

```bash
# 1. استنساخ المشروع
git clone https://github.com/Ali-Alqawas/test6.git
cd test6

# 2. تثبيت التبعيات
flutter pub get

# 3. تشغيل التطبيق
flutter run
```

### إعداد الـ Backend

في ملف `lib/core/network/api_constants.dart`، غيّر عنوان السيرفر:

```dart
static const String baseUrl = 'http://<YOUR_SERVER_IP>:8000/api/v1';
static const String mediaBaseUrl = 'http://<YOUR_SERVER_IP>:8000';
```

---

## 🔐 الأمان

- إدارة JWT Tokens تلقائياً (Auto Refresh)
- تخزين آمن للـ Tokens عبر SharedPreferences
- Auth Guard لحماية الشاشات المحمية
- معالجة شاملة لأخطاء الشبكة والـ API
- لا يتم تخزين كلمات المرور محلياً

---

## 🤝 المساهمة

هذا مشروع خاص. للاستفسار أو التعاون:

- 📧 البريد الإلكتروني: `support@side-app.com`
- 👤 المطور: [Ali-Alqawas](https://github.com/Ali-Alqawas)

---

## 📝 الترخيص

جميع الحقوق محفوظة © 2024 — **Ali-Alqawas**

هذا المشروع محمي بحقوق الملكية الفكرية. لا يُسمح بإعادة الاستخدام أو التوزيع دون إذن صريح.

---

<div align="center">

**صُنع بـ ❤️ باستخدام Flutter**

**SIDE — تجربة تسوق ذكية ومتكاملة**

---

*Developed & Documented by [Ali-Alqawas](https://github.com/Ali-Alqawas)*

</div>
