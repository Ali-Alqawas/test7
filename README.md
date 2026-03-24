<div align="center">

<img src="assets/images/side_logo.png" alt="SIDE Logo" width="140"/>

# SIDE — Smart Integrated Deals Engine

### منصة ذكية متكاملة لإدارة العروض والخصومات التجارية

[![Flutter](https://img.shields.io/badge/Flutter-3.6.1-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.6.1-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Provider](https://img.shields.io/badge/Provider-6.1.2-FF6B35?style=for-the-badge)](https://pub.dev/packages/provider)
[![Version](https://img.shields.io/badge/Version-1.0.0-brightgreen?style=for-the-badge)](pubspec.yaml)
[![License](https://img.shields.io/badge/License-Proprietary-red?style=for-the-badge)](LICENSE)

</div>

---

## 📖 نظرة عامة

**SIDE** تطبيق Flutter متقدم يوحّد تجربة التسوق الرقمي من خلال منصة ذكية تجمع عروض وخصومات مئات المتاجر في مكان واحد. يتميز بـ:

- 🎨 تصميم **Glass Morphism** عصري
- 🌗 دعم كامل لـ **Dark / Light Mode**
- 🏗️ بنية معمارية **3 طبقات** قابلة للتوسع
- 🔌 تكامل مع **Django REST Framework** Backend
- 🤖 مساعد ذكي مدمج (AI Chatbot)

---

## 📊 إحصائيات المشروع

<div align="center">

| المقياس | القيمة |
|---------|--------|
| 📁 ملفات Dart | **67 ملف** |
| 📱 الشاشات | **38 شاشة** |
| 🧩 مكونات مخصصة | **22 مكون** |
| 📦 تبعيات خارجية | **6 حزم** |
| 🔗 API Endpoints | **60+ نقطة** |
| 🏗️ طبقات المعمارية | **3 طبقات** |

</div>

---

## 🗂️ هيكل المشروع

```
lib/
├── core/
│   ├── helpers/
│   │   └── auth_guard.dart          # حماية المسارات
│   ├── network/
│   │   ├── api_constants.dart       # 60+ Endpoint
│   │   ├── api_service.dart         # HTTP Client
│   │   ├── api_exceptions.dart      # نظام الاستثناءات
│   │   └── token_manager.dart       # إدارة JWT
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_theme.dart
│   │   └── theme_manager.dart
│   └── widgets/                     # 22 مكون مخصص
│
├── data/
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   └── social_provider.dart
│   └── dummy_data.dart
│
├── presentation/
│   └── screens/                     # 38 شاشة
│       ├── auth/                    # 6 شاشات
│       ├── home/
│       ├── offers/                  # 5 شاشات
│       ├── categories/
│       ├── details/                 # 4 شاشات
│       ├── profile/                 # 10 شاشات
│       ├── search/
│       ├── favorites/
│       ├── stores/
│       ├── chatbot/
│       ├── notifications/
│       ├── splash/
│       ├── onboarding/
│       ├── main_layout/
│       └── design_system/
│
└── main.dart
```

---

## ✅ الميزات المنجزة

### 🔐 نظام المصادقة
- تسجيل الدخول / إنشاء حساب
- التحقق عبر OTP
- استعادة وإعادة تعيين كلمة المرور
- إدارة JWT (Access + Refresh Tokens) تلقائياً
- Auth Guard لحماية الشاشات

### 🏠 الشاشات الرئيسية
- Splash + Onboarding
- Home Screen مع عروض ديناميكية وبانرات وفئات
- Main Layout مع Bottom Navigation

### 🏷️ العروض والفئات
- عرض شامل مع فلاتر متقدمة (سعر، فئة، متجر، تقييم)
- عروض مميزة، مجمعة، بانرات، كتالوجات
- تصفح الفئات وعروض كل فئة

### 📋 التفاصيل والتفاعل
- تفاصيل العرض الكاملة مع مشاركة
- ملف التاجر مع التقييمات والتعليقات
- محادثة مباشرة مع التاجر

### 👤 الملف الشخصي
- تعديل البيانات والصورة الشخصية
- نظام النقاط والمكافآت والسحوبات
- الأمان، الإشعارات، العناوين المحفوظة
- صندوق الوارد، مركز الدعم، الترقية لتاجر

### 🎨 نظام التصميم
- Glass Morphism Effects
- ألوان موحدة: **Golden Bronze** `#C9A84C` + **Deep Navy** `#0D1B2A`
- 22 مكون قابل لإعادة الاستخدام
- AI Floating Action Button

---

## 🔄 قيد التطوير

| الميزة | الحالة |
|--------|--------|
| تكامل AI Chatbot مع Backend | 🔧 جارٍ |
| Firebase Push Notifications | 🔧 جارٍ |
| Providers (Offers, Favorites, Categories...) | 🔧 جارٍ |
| نظام المكافآت الفعلي | 🔧 جارٍ |

---

## 🔌 API Architecture

```
Base URL: http://<SERVER_IP>:8000/api/v1
```

| المجال | Endpoints |
|--------|-----------|
| 🔐 Auth | login, register, OTP, password reset, token refresh |
| 👤 Profile | profile, account, phones, referral |
| 📂 Catalog | categories, products, product-groups, search |
| 🏪 Merchants | stores, store details |
| ❤️ Social | favorites, likes, comments, ratings, interests |
| 🎁 Rewards | points, draws, redemptions |
| 🔔 Support | notifications, messages, tickets |
| 🤖 Chatbot | sessions, chat, history |
| 📊 Analytics | views, shares, search logs |
| 🛠️ Core | banners, ads, settings, file upload |

---

## 📦 التبعيات

```yaml
dependencies:
  provider: ^6.1.2          # إدارة الحالة
  http: ^1.6.0              # طلبات HTTP
  shared_preferences: ^2.5.3 # التخزين المحلي
  share_plus: ^10.0.0       # مشاركة المحتوى
  image_picker: ^1.2.0      # اختيار الصور
  cupertino_icons: ^1.0.8   # أيقونات iOS
```

---

## 🚀 التثبيت والتشغيل

```bash
# 1. استنساخ المشروع
git clone https://github.com/Ali-Alqawas/test7.git
cd test7

# 2. تثبيت التبعيات
flutter pub get

# 3. تشغيل التطبيق
flutter run
```

### إعداد الـ Backend

في `lib/core/network/api_constants.dart`:

```dart
static const String baseUrl = 'http://<YOUR_SERVER_IP>:8000/api/v1';
static const String mediaBaseUrl = 'http://<YOUR_SERVER_IP>:8000';
```

### المتطلبات

- Flutter SDK `3.6.1+`
- Dart SDK `3.6.1+`
- Android Studio أو VS Code
- جهاز Android أو محاكي

---

## 🗺️ خارطة الطريق

| المرحلة | المحتوى |
|---------|---------|
| **المرحلة 2** | Merchant App منفصل + لوحة إدارة العروض |
| **المرحلة 3** | Admin Panel (Web) + تحليلات شاملة |
| **المرحلة 4** | نظام دفع + Google Maps + Flutter Web + iOS |

---

## 🔐 الأمان

- Auto Refresh للـ JWT Tokens
- Auth Guard لحماية المسارات
- معالجة شاملة لأخطاء الشبكة
- لا يتم تخزين كلمات المرور محلياً

---

## 🤝 التواصل

- 📧 `support@side-app.com`
- 👤 [Ali-Alqawas](https://github.com/Ali-Alqawas)

---

## 📝 الترخيص

جميع الحقوق محفوظة © 2024 — **Ali-Alqawas**

هذا المشروع محمي بحقوق الملكية الفكرية. لا يُسمح بإعادة الاستخدام أو التوزيع دون إذن صريح.

---

<div align="center">

**صُنع بـ ❤️ باستخدام Flutter**

*SIDE — تجربة تسوق ذكية ومتكاملة*

</div>
