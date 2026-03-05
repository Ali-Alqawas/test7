# 🛍️ SIDE - Smart Integrated Deals Engine

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.6.1-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.6.1-0175C2?style=for-the-badge&logo=dart)
![Lines of Code](https://img.shields.io/badge/Lines%20of%20Code-24.7K-blue?style=for-the-badge)
![Files](https://img.shields.io/badge/Dart%20Files-66-green?style=for-the-badge)
![License](https://img.shields.io/badge/License-Private-red?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-In%20Development-yellow?style=for-the-badge)

**منصة ذكية متكاملة لإدارة العروض والخصومات التجارية**

[المميزات](#-المميزات-الرئيسية) • [البنية التقنية](#️-البنية-التقنية) • [التثبيت](#-التثبيت-والإعداد) • [الحالة](#-حالة-المشروع) • [المساهمة](#-المساهمة)

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

- **إجمالي الأسطر البرمجية**: 24,787 سطر
- **عدد ملفات Dart**: 66 ملف
- **عدد الشاشات**: 37+ شاشة
- **عدد المكونات القابلة لإعادة الاستخدام**: 18 مكون
- **عدد الفئات الرئيسية**: 15 فئة (Auth, Home, Profile, Offers, إلخ)

---

## ✨ المميزات الرئيسية

### 🎨 واجهة المستخدم (UI/UX)

#### Design System متكامل
- **نظام تصميم موحد** مع مكونات قابلة لإعادة الاستخدام
- **18 مكون مخصص** (Custom Widgets) لضمان الاتساق
- **Glass Morphism Effects** - تأثيرات زجاجية عصرية
- **Responsive Design** - تصميم متجاوب يعمل على جميع أحجام الشاشات
- **Custom Animations** - رسوم متحركة سلسة لتحسين تجربة المستخدم

#### نظام الثيمات (Theming)
- ✅ **Dark Mode** - وضع ليلي كامل مع ألوان متناسقة
- ✅ **Light Mode** - وضع نهاري مريح للعين
- ✅ **Smooth Transitions** - انتقالات سلسة بين الأوضاع
- ✅ **Persistent Theme** - حفظ تفضيلات المستخدم

#### المكونات المخصصة (Custom Widgets)
```
lib/core/widgets/
├── ai_floating_button.dart           # زر المساعد الذكي العائم
├── custom_bottom_nav.dart            # شريط التنقل السفلي
├── custom_button.dart                # أزرار مخصصة
├── custom_textfield.dart             # حقول إدخال مخصصة
├── exclusive_offers_carousel.dart    # عرض دوار للعروض الحصرية
├── glass_container.dart              # حاوية بتأثير زجاجي
├── offer_action_buttons.dart         # أزرار إجراءات العروض
├── offer_filter_sheet.dart           # ورقة تصفية العروض
├── page_background.dart              # خلفية الصفحات
├── premium_bottom_nav_bar.dart       # شريط تنقل متقدم
├── premium_brochures_section.dart    # قسم البروشورات
├── premium_bundled_offers.dart       # العروض المجمعة
├── premium_categories.dart           # عرض الفئات
├── premium_featured_offers.dart      # العروض المميزة
├── premium_offer_cards.dart          # بطاقات العروض
├── premium_quick_services.dart       # الخدمات السريعة
├── premium_standard_offer_card.dart  # بطاقة عرض قياسية
└── side_header_component.dart        # هيدر التطبيق
```

---

### 🔐 نظام المصادقة (Authentication System)

نظام مصادقة متقدم وآمن مع تكامل كامل مع Backend:

#### الميزات الأساسية
- ✅ **تسجيل الدخول** (Login) - مع التحقق من البيانات
- ✅ **التسجيل** (Sign Up) - إنشاء حساب جديد
- ✅ **التحقق من OTP** - رمز التحقق عبر البريد/الهاتف
- ✅ **استعادة كلمة المرور** - عبر البريد الإلكتروني
- ✅ **إعادة تعيين كلمة المرور** - بعد التحقق
- ✅ **اختيار الاهتمامات** - لتخصيص تجربة المستخدم

#### الأمان والتوكنات
- ✅ **JWT Token Management** - إدارة متقدمة للتوكنات
- ✅ **Access & Refresh Tokens** - نظام توكنات مزدوج
- ✅ **Auto Token Refresh** - تجديد تلقائي للتوكنات
- ✅ **Secure Storage** - تخزين آمن باستخدام SharedPreferences
- ✅ **Session Management** - إدارة الجلسات
- ✅ **Auto Logout** - تسجيل خروج تلقائي عند انتهاء الصلاحية

#### الملفات المسؤولة
```dart
lib/data/providers/auth_provider.dart      // مزود المصادقة الرئيسي
lib/core/network/token_manager.dart        // إدارة التوكنات
lib/presentation/screens/auth/
├── login_screen.dart                      // شاشة تسجيل الدخول
├── signup_screen.dart                     // شاشة التسجيل
├── verification_screen.dart               // شاشة التحقق من OTP
├── forgot_password_screen.dart            // شاشة نسيت كلمة المرور
├── reset_password_screen.dart             // شاشة إعادة تعيين كلمة المرور
└── interests_screen.dart                  // شاشة اختيار الاهتمامات
```

---

### 🏠 الشاشة الرئيسية (Home Screen)

شاشة رئيسية ديناميكية وغنية بالمحتوى:

#### المكونات الرئيسية
1. **Dynamic Header** - هيدر ديناميكي يتغير حسب حالة المستخدم
2. **Search Bar** - شريط بحث متقدم مع اقتراحات
3. **Categories Grid** - شبكة الفئات مع أيقونات جذابة
4. **Exclusive Offers Carousel** - عرض دوار للعروض الحصرية
5. **Featured Offers Section** - قسم العروض المميزة
6. **Bundled Offers** - العروض المجمعة (باقات)
7. **Brochures Section** - قسم البروشورات التجارية
8. **Quick Services** - خدمات سريعة (مفضلة، إشعارات، إلخ)
9. **AI Chatbot Button** - زر عائم للمساعد الذكي

#### الميزات التفاعلية
- **Pull to Refresh** - سحب للتحديث
- **Infinite Scroll** - تمرير لا نهائي للعروض
- **Quick Actions** - إجراءات سريعة على العروض
- **Real-time Updates** - تحديثات فورية (مخطط)

---

### 📱 الشاشات الرئيسية (Main Screens)

التطبيق يحتوي على **37+ شاشة** موزعة على **15 فئة**:

#### 1. شاشات البداية (Startup)
- **Splash Screen** - شاشة البداية مع رسوم متحركة
- **Onboarding** - 3 شاشات تعريفية بالتطبيق

#### 2. شاشات المصادقة (Authentication) - 6 شاشات
- Login, Sign Up, OTP Verification
- Forgot Password, Reset Password
- Interests Selection

#### 3. الشاشة الرئيسية والتنقل (Main Layout)
- **Home Screen** - الشاشة الرئيسية الكاملة
- **Main Layout** - التخطيط الرئيسي مع Bottom Navigation

#### 4. شاشات العروض (Offers) - 5 شاشات
- **All Offers** - جميع العروض
- **Featured Offers** - العروض المميزة
- **Bundled Offers** - العروض المجمعة
- **Banner Offers** - عروض البانر
- **All Brochures** - جميع البروشورات

#### 5. شاشات الفئات (Categories) - 2 شاشات
- **Categories Screen** - عرض جميع الفئات
- **Category Offers** - عروض فئة معينة

#### 6. شاشات التفاصيل (Details) - 4 شاشات
- **Offer Details** - تفاصيل العرض الكاملة
- **Merchant Profile** - ملف التاجر
- **Merchant Chat** - محادثة مع التاجر
- **All Comments** - جميع التعليقات والتقييمات

#### 7. شاشات الملف الشخصي (Profile) - 10 شاشات
- **Profile Screen** - الملف الشخصي الرئيسي
- **Edit Profile** - تعديل المعلومات الشخصية
- **Rewards** - نظام المكافآت والنقاط
- **Saved Addresses** - العناوين المحفوظة
- **Security Settings** - إعدادات الأمان
- **Notifications Settings** - إعدادات الإشعارات
- **Support Center** - مركز الدعم
- **Merchant Upgrade** - الترقية لحساب تاجر
- **Inbox** - صندوق الرسائل
- **Draws** - السحوبات والمسابقات
- **Legal** - الشروط والأحكام

#### 8. شاشات أخرى
- **Search Screen** - البحث المتقدم
- **Favorites** - المفضلات
- **Notifications** - الإشعارات
- **All Stores** - جميع المتاجر
- **Chatbot** - المساعد الذكي
- **Design System Gallery** - معرض نظام التصميم (للتطوير)

---

### 🌐 التكامل مع Backend

نظام متقدم للتواصل مع الـ Backend API:

#### البنية المعمارية
```
lib/core/network/
├── api_service.dart       # خدمة API الموحدة (Singleton)
├── api_constants.dart     # ثوابت الـ Endpoints
├── api_exceptions.dart    # معالجة الأخطاء المخصصة
└── token_manager.dart     # إدارة التوكنات
```

#### الميزات الرئيسية

##### 1. ApiService - خدمة API موحدة
- **Singleton Pattern** - نسخة واحدة في التطبيق
- **HTTP Client** مخصص مع Retry Logic
- **Timeout Handling** - معالجة انتهاء المهلة (15 ثانية)
- **Auto Token Refresh** - تجديد تلقائي للتوكنات
- **Request/Response Interceptors** - اعتراض الطلبات والردود

##### 2. TokenManager - إدارة التوكنات
- **Secure Storage** - تخزين آمن للتوكنات
- **Auto Refresh** - تجديد تلقائي عند الحاجة
- **Token Validation** - التحقق من صلاحية التوكنات
- **Concurrent Request Handling** - معالجة الطلبات المتزامنة

##### 3. ApiConstants - ثوابت API
- **Centralized Endpoints** - نقطة مركزية لجميع الـ Endpoints
- **Image URL Resolver** - معالج ذكي لروابط الصور
- **Environment Configuration** - تكوين البيئة (Dev/Prod)

##### 4. ApiExceptions - معالجة الأخطاء
- **Custom Exceptions** - استثناءات مخصصة لكل نوع خطأ
- **User-Friendly Messages** - رسائل واضحة للمستخدم
- **Error Logging** - تسجيل الأخطاء للتطوير

#### الـ Endpoints المتاحة

```dart
// 🔐 Authentication
/auth/login/
/auth/register/
/auth/logout/
/auth/verify-otp/
/auth/resend-otp/
/auth/send-otp/
/auth/verify-email/
/auth/reset-password/
/auth/change-password/
/auth/refresh-token/

// 👤 User Profile
/users/profile/
/users/update-profile/
/users/interests/
/users/addresses/
/users/rewards/

// 🛍️ Offers
/offers/
/offers/{id}/
/offers/featured/
/offers/bundled/
/offers/exclusive/
/offers/search/

// 📂 Categories
/categories/
/categories/{id}/offers/

// 🏪 Merchants
/merchants/
/merchants/{id}/
/merchants/{id}/offers/

// 💬 Comments & Reviews
/comments/
/reviews/

// 🔔 Notifications
/notifications/
/notifications/mark-read/

// ⭐ Favorites
/favorites/
/favorites/add/
/favorites/remove/

// 📄 Brochures
/brochures/
/brochures/{id}/
```

#### معالج روابط الصور (Image URL Resolver)

```dart
// يعالج جميع حالات روابط الصور:
// ✅ روابط كاملة (https://...)
// ✅ مسارات نسبية (/media/...)
// ✅ استبدال localhost بالـ IP الفعلي
// ✅ صورة افتراضية للروابط الفارغة

String imageUrl = ApiConstants.resolveImageUrl(offer.image);
```

---

### 📦 إدارة الحالة (State Management)

استخدام **Provider Pattern** لإدارة الحالة بشكل فعال:

#### المزودات الحالية (Providers)

##### 1. AuthProvider - مزود المصادقة
```dart
lib/data/providers/auth_provider.dart

الميزات:
- إدارة حالة المصادقة (مسجل دخول/خارج)
- تسجيل الدخول والتسجيل
- التحقق من OTP
- استعادة كلمة المرور
- إدارة بيانات المستخدم
- تحديث الملف الشخصي
- تسجيل الخروج
```

##### 2. ThemeManager - إدارة الثيم
```dart
lib/core/theme/theme_manager.dart

الميزات:
- التبديل بين الوضع الليلي والنهاري
- حفظ تفضيلات المستخدم
- تطبيق الثيم على التطبيق بالكامل
```

#### المزودات المخططة (Planned)
- **OffersProvider** - إدارة العروض
- **CategoriesProvider** - إدارة الفئات
- **FavoritesProvider** - إدارة المفضلات
- **CartProvider** - إدارة السلة
- **NotificationsProvider** - إدارة الإشعارات
- **SearchProvider** - إدارة البحث

---

## 🏗️ البنية التقنية

### هيكل المشروع (Project Structure)

```
test/
├── android/                          # ملفات Android الأصلية
├── ios/                              # ملفات iOS الأصلية
├── assets/                           # الأصول (صور، أيقونات)
│   └── images/                       # الصور
│       ├── logo_side_dark.png
│       ├── logo_side_light.png
│       └── *.jpeg                    # صور العروض والفئات
│
├── lib/                              # الكود الرئيسي
│   ├── main.dart                     # نقطة البداية
│   │
│   ├── core/                         # الوظائف الأساسية المشتركة
│   │   ├── theme/                    # نظام الثيمات
│   │   │   ├── app_theme.dart        # تعريف الثيمات
│   │   │   ├── app_colors.dart       # الألوان
│   │   │   └── theme_manager.dart    # إدارة الثيم
│   │   │
│   │   ├── widgets/                  # المكونات القابلة لإعادة الاستخدام (18 مكون)
│   │   │   ├── ai_floating_button.dart
│   │   │   ├── custom_bottom_nav.dart
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_textfield.dart
│   │   │   ├── exclusive_offers_carousel.dart
│   │   │   ├── glass_container.dart
│   │   │   ├── offer_action_buttons.dart
│   │   │   ├── offer_filter_sheet.dart
│   │   │   ├── page_background.dart
│   │   │   ├── premium_bottom_nav_bar.dart
│   │   │   ├── premium_brochures_section.dart
│   │   │   ├── premium_bundled_offers.dart
│   │   │   ├── premium_categories.dart
│   │   │   ├── premium_featured_offers.dart
│   │   │   ├── premium_offer_cards.dart
│   │   │   ├── premium_quick_services.dart
│   │   │   ├── premium_standard_offer_card.dart
│   │   │   └── side_header_component.dart
│   │   │
│   │   └── network/                  # طبقة الشبكة والـ API
│   │       ├── api_service.dart      # خدمة API الموحدة
│   │       ├── api_constants.dart    # ثوابت الـ Endpoints
│   │       ├── api_exceptions.dart   # معالجة الأخطاء
│   │       └── token_manager.dart    # إدارة التوكنات
│   │
│   ├── data/                         # طبقة البيانات
│   │   ├── providers/                # مزودات الحالة (State Providers)
│   │   │   └── auth_provider.dart    # مزود المصادقة
│   │   └── dummy_data.dart           # بيانات تجريبية للتطوير
│   │
│   └── presentation/                 # طبقة العرض (UI)
│       └── screens/                  # الشاشات (37+ شاشة)
│           ├── auth/                 # شاشات المصادقة (6 شاشات)
│           │   ├── login_screen.dart
│           │   ├── signup_screen.dart
│           │   ├── verification_screen.dart
│           │   ├── forgot_password_screen.dart
│           │   ├── reset_password_screen.dart
│           │   └── interests_screen.dart
│           │
│           ├── splash/               # شاشة البداية
│           │   └── splash_screen.dart
│           │
│           ├── onboarding/           # شاشات التعريف
│           │   └── onboarding_screen.dart
│           │
│           ├── main_layout/          # التخطيط الرئيسي
│           │   └── main_layout_screen.dart
│           │
│           ├── home/                 # الشاشة الرئيسية
│           │   └── home_screen.dart
│           │
│           ├── offers/               # شاشات العروض (5 شاشات)
│           │   ├── offers_screen.dart
│           │   ├── featured_offers_screen.dart
│           │   ├── bundled_offers_screen.dart
│           │   ├── banner_offers_screen.dart
│           │   └── all_brochures_screen.dart
│           │
│           ├── categories/           # شاشات الفئات (2 شاشات)
│           │   ├── categories_screen.dart
│           │   └── category_offers_screen.dart
│           │
│           ├── details/              # شاشات التفاصيل (4 شاشات)
│           │   ├── offer_details_screen.dart
│           │   ├── merchant_profile_screen.dart
│           │   ├── merchant_chat_screen.dart
│           │   └── all_comments_screen.dart
│           │
│           ├── profile/              # شاشات الملف الشخصي (10 شاشات)
│           │   ├── profile_screen.dart
│           │   ├── edit_profile_screen.dart
│           │   ├── rewards_screen.dart
│           │   ├── saved_addresses_screen.dart
│           │   ├── security_screen.dart
│           │   ├── notifications_settings_screen.dart
│           │   ├── support_center_screen.dart
│           │   ├── merchant_upgrade_screen.dart
│           │   ├── inbox_screen.dart
│           │   ├── draws_screen.dart
│           │   └── legal_screen.dart
│           │
│           ├── search/               # شاشة البحث
│           │   └── search_screen.dart
│           │
│           ├── favorites/            # شاشة المفضلات
│           │   └── favorites_screen.dart
│           │
│           ├── notifications/        # شاشة الإشعارات
│           │   └── notifications_screen.dart
│           │
│           ├── stores/               # شاشة المتاجر
│           │   └── all_stores_screen.dart
│           │
│           ├── chatbot/              # شاشة المساعد الذكي
│           │   └── chatbot_screen.dart
│           │
│           └── design_system/        # معرض نظام التصميم
│               └── design_system_gallery.dart
│
├── pubspec.yaml                      # ملف التبعيات
└── README.md                         # هذا الملف

```

### المعمارية (Architecture)

المشروع يتبع **Clean Architecture** مع فصل واضح للطبقات:

```
┌─────────────────────────────────────────────────────────┐
│                   Presentation Layer                     │
│  (UI Screens, Widgets, State Management - Provider)     │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│                     Data Layer                           │
│        (Providers, Models, Dummy Data)                   │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│                     Core Layer                           │
│  (Network, API Service, Theme, Reusable Widgets)        │
└─────────────────────────────────────────────────────────┘
```

#### الطبقات الرئيسية:

1. **Presentation Layer** (طبقة العرض)
   - جميع الشاشات (37+ شاشة)
   - المكونات المخصصة (18 مكون)
   - إدارة الحالة باستخدام Provider

2. **Data Layer** (طبقة البيانات)
   - Providers للحالة
   - Models للبيانات
   - Dummy Data للتطوير

3. **Core Layer** (الطبقة الأساسية)
   - خدمات الشبكة (API Service)
   - نظام الثيمات
   - المكونات القابلة لإعادة الاستخدام
   - إدارة التوكنات

---

## 🛠️ التقنيات المستخدمة

### Frontend (Flutter)

| التقنية | الإصدار | الاستخدام |
|---------|---------|-----------|
| **Flutter** | 3.6.1 | إطار العمل الرئيسي |
| **Dart** | 3.6.1 | لغة البرمجة |
| **Provider** | ^6.1.2 | إدارة الحالة |
| **HTTP** | ^1.6.0 | طلبات الشبكة |
| **SharedPreferences** | ^2.5.3 | التخزين المحلي |
| **Share Plus** | ^10.0.0 | مشاركة المحتوى |
| **Cupertino Icons** | ^1.0.8 | أيقونات iOS |

### Backend API

- **Django REST Framework** (مفترض)
- **JWT Authentication**
- **PostgreSQL/MySQL** (قاعدة البيانات)

### الأدوات والمكتبات

- **Git** - نظام التحكم بالإصدارات
- **GitHub** - استضافة الكود
- **VS Code / Android Studio** - بيئة التطوير

---

## 📥 التثبيت والإعداد

### المتطلبات الأساسية

قبل البدء، تأكد من تثبيت:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.6.1 أو أحدث)
- [Dart SDK](https://dart.dev/get-dart) (3.6.1 أو أحدث)
- [Android Studio](https://developer.android.com/studio) أو [VS Code](https://code.visualstudio.com/)
- [Git](https://git-scm.com/)

### خطوات التثبيت

#### 1. استنساخ المشروع

```bash
git clone https://github.com/Ali-Alqawas/test3.git
cd test3
```

#### 2. تثبيت التبعيات

```bash
flutter pub get
```

#### 3. إعداد الـ Backend API

قم بتعديل عنوان الـ API في ملف `lib/core/network/api_constants.dart`:

```dart
// غيّر الـ IP حسب عنوان السيرفر الخاص بك
static const String baseUrl = 'http://YOUR_IP:8000/api/v1';
static const String mediaBaseUrl = 'http://YOUR_IP:8000';
```

**للحصول على عنوان IP الخاص بك:**

- **Linux/Mac**: 
  ```bash
  ifconfig | grep inet
  ```
- **Windows**: 
  ```bash
  ipconfig
  ```

#### 4. تشغيل التطبيق

```bash
# تشغيل على Android
flutter run

# تشغيل على iOS
flutter run

# تشغيل على الويب
flutter run -d chrome
```

### إعداد بيئة التطوير

#### Android Studio

1. افتح Android Studio
2. اختر `Open an Existing Project`
3. حدد مجلد المشروع
4. انتظر حتى يتم تحميل التبعيات
5. اضغط على `Run` أو `Shift + F10`

#### VS Code

1. افتح VS Code
2. اختر `File > Open Folder`
3. حدد مجلد المشروع
4. افتح Terminal واكتب `flutter run`

---

## 🚀 البناء والنشر

### بناء التطبيق للإنتاج

#### Android (APK)

```bash
# بناء APK
flutter build apk --release

# بناء App Bundle (للنشر على Google Play)
flutter build appbundle --release
```

الملف الناتج: `build/app/outputs/flutter-apk/app-release.apk`

#### iOS (IPA)

```bash
flutter build ios --release
```

#### الويب

```bash
flutter build web --release
```

الملفات الناتجة: `build/web/`

---

## 🧪 الاختبار

### تشغيل الاختبارات

```bash
# تشغيل جميع الاختبارات
flutter test

# تشغيل اختبارات محددة
flutter test test/widget_test.dart

# تشغيل مع تقرير التغطية
flutter test --coverage
```

### أنواع الاختبارات

- **Unit Tests** - اختبار الوظائف الفردية
- **Widget Tests** - اختبار المكونات
- **Integration Tests** - اختبار التكامل الكامل

---

## 📊 حالة المشروع

### ✅ المكتمل

- [x] نظام المصادقة الكامل (Login, Signup, OTP, Password Reset)
- [x] إدارة التوكنات (JWT)
- [x] الشاشة الرئيسية الديناميكية
- [x] نظام الثيمات (Dark/Light Mode)
- [x] 18 مكون قابل لإعادة الاستخدام
- [x] 37+ شاشة
- [x] تكامل API كامل
- [x] نظام التصفية والبحث
- [x] شاشات العروض والفئات
- [x] شاشات الملف الشخصي

### 🚧 قيد التطوير

- [ ] تكامل المساعد الذكي (AI Chatbot)
- [ ] نظام الإشعارات الفورية (Push Notifications)
- [ ] نظام المكافآت والنقاط
- [ ] نظام الدفع الإلكتروني
- [ ] تكامل الخرائط (Google Maps)
- [ ] نظام التقييمات والمراجعات
- [ ] المحادثة المباشرة مع التجار
- [ ] نظام السحوبات والمسابقات

### 📋 المخطط

- [ ] تطبيق للتجار (Merchant App)
- [ ] لوحة تحكم إدارية (Admin Dashboard)
- [ ] تحليلات متقدمة (Analytics)
- [ ] تكامل مع وسائل التواصل الاجتماعي
- [ ] نظام الإحالة والعمولات
- [ ] دعم متعدد اللغات (i18n)
- [ ] وضع عدم الاتصال (Offline Mode)

---

## 🤝 المساهمة

نرحب بالمساهمات! إذا كنت ترغب في المساهمة في المشروع:

### خطوات المساهمة

1. **Fork** المشروع
2. أنشئ **Branch** جديد للميزة (`git checkout -b feature/AmazingFeature`)
3. **Commit** التغييرات (`git commit -m 'Add some AmazingFeature'`)
4. **Push** إلى الـ Branch (`git push origin feature/AmazingFeature`)
5. افتح **Pull Request**

### معايير الكود

- اتبع [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- استخدم أسماء واضحة ومعبرة
- أضف تعليقات للكود المعقد
- اكتب اختبارات للميزات الجديدة

---

## 📝 الترخيص

هذا المشروع **خاص** (Private) وغير متاح للاستخدام العام.

---

## 👥 الفريق

- **Ali Alqawas** - المطور الرئيسي - [@Ali-Alqawas](https://github.com/Ali-Alqawas)

---

## 📞 التواصل

للاستفسارات والدعم:

- **GitHub**: [@Ali-Alqawas](https://github.com/Ali-Alqawas)
- **Repository**: [test3](https://github.com/Ali-Alqawas/test3)

---

## 🙏 شكر وتقدير

شكراً لجميع المساهمين والمكتبات مفتوحة المصدر التي جعلت هذا المشروع ممكناً:

- [Flutter Team](https://flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [HTTP Package](https://pub.dev/packages/http)
- [SharedPreferences](https://pub.dev/packages/shared_preferences)

---

## 📚 موارد إضافية

### Flutter Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)
- [Provider Documentation](https://pub.dev/packages/provider)

### Design Resources

- [Material Design](https://material.io/design)
- [Cupertino Design](https://developer.apple.com/design/human-interface-guidelines/ios)

---

<div align="center">

**صُنع بـ ❤️ باستخدام Flutter**

⭐ إذا أعجبك المشروع، لا تنسَ إضافة نجمة!

</div>
