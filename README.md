# 🛍️ SIDE - Smart Integrated Deals Engine

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.6.1-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.6.1-0175C2?style=for-the-badge&logo=dart)
![License](https://img.shields.io/badge/License-Private-red?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-In%20Development-yellow?style=for-the-badge)

**منصة ذكية متكاملة لإدارة العروض والخصومات التجارية**

[المميزات](#-المميزات-الرئيسية) • [البنية التقنية](#-البنية-التقنية) • [التثبيت](#-التثبيت-والإعداد) • [الحالة](#-حالة-المشروع) • [المساهمة](#-المساهمة)

</div>

---

## 📋 نظرة عامة

**SIDE** هو تطبيق Flutter متقدم يهدف إلى توفير تجربة تسوق ذكية ومتكاملة من خلال:
- عرض العروض والخصومات من مختلف المتاجر في مكان واحد
- نظام توصيات ذكي مبني على اهتمامات المستخدم
- واجهة مستخدم عصرية تدعم الوضع الليلي والنهاري
- تكامل كامل مع Backend API
- نظام مصادقة متقدم مع JWT

---

## ✨ المميزات الرئيسية

### 🎨 واجهة المستخدم
- ✅ **Design System متكامل** - نظام تصميم موحد مع مكونات قابلة لإعادة الاستخدام
- ✅ **Dark/Light Mode** - دعم كامل للوضع الليلي والنهاري مع انتقالات سلسة
- ✅ **Glass Morphism Effects** - تأثيرات زجاجية عصرية
- ✅ **Responsive Design** - تصميم متجاوب يعمل على جميع أحجام الشاشات
- ✅ **Custom Animations** - رسوم متحركة مخصصة لتحسين تجربة المستخدم

### 🔐 نظام المصادقة (Authentication)
- ✅ **تسجيل الدخول والتسجيل** - نظام كامل مع التحقق من البيانات
- ✅ **OTP Verification** - التحقق عبر رمز OTP المرسل للبريد/الهاتف
- ✅ **JWT Token Management** - إدارة متقدمة للتوكنات مع التجديد التلقائي
- ✅ **Password Recovery** - استعادة كلمة المرور عبر البريد الإلكتروني
- ✅ **Interests Selection** - اختيار الاهتمامات بعد التسجيل لتخصيص التجربة
- ✅ **Secure Storage** - تخزين آمن للبيانات الحساسة

### 🏠 الشاشة الرئيسية
- ✅ **Dynamic Header** - هيدر ديناميكي يتغير حسب حالة المستخدم
- ✅ **Search Engine** - محرك بحث متقدم
- ✅ **Categories Grid** - عرض الفئات بشكل منظم
- ✅ **Exclusive Offers Carousel** - عرض دوار للعروض الحصرية
- ✅ **Featured Offers** - العروض المميزة
- ✅ **Bundled Offers** - العروض المجمعة (باقات)
- ✅ **Brochures Section** - قسم البروشورات التجارية
- ✅ **Quick Services** - خدمات سريعة (مفضلة، إشعارات، إلخ)
- ✅ **AI Chatbot Button** - زر عائم للمساعد الذكي

### 📱 الشاشات الرئيسية
- ✅ **Splash Screen** - شاشة البداية مع رسوم متحركة
- ✅ **Onboarding** - شاشات التعريف بالتطبيق
- ✅ **Home Screen** - الشاشة الرئيسية الكاملة
- ✅ **Categories** - عرض وتصفح الفئات
- ✅ **Offers Screens** - شاشات متعددة لأنواع العروض المختلفة
- ✅ **Search** - شاشة البحث المتقدم
- ✅ **Favorites** - المفضلات
- ✅ **Profile** - الملف الشخصي مع جميع الإعدادات
- ✅ **Notifications** - الإشعارات
- ✅ **Chatbot** - المساعد الذكي

### 👤 إدارة الملف الشخصي
- ✅ **Profile Management** - إدارة البيانات الشخصية
- ✅ **Edit Profile** - تعديل المعلومات
- ✅ **Rewards System** - نظام المكافآت والنقاط
- ✅ **Saved Addresses** - العناوين المحفوظة
- ✅ **Security Settings** - إعدادات الأمان
- ✅ **Notifications Settings** - إعدادات الإشعارات
- ✅ **Support Center** - مركز الدعم
- ✅ **Merchant Upgrade** - الترقية لحساب تاجر
- ✅ **Inbox** - صندوق الرسائل
- ✅ **Draws** - السحوبات والمسابقات
- ✅ **Legal** - الشروط والأحكام

### 🛒 العروض والمتاجر
- ✅ **Offer Details** - تفاصيل العرض الكاملة
- ✅ **Merchant Profile** - ملف التاجر
- ✅ **Merchant Chat** - محادثة مع التاجر
- ✅ **Comments & Reviews** - التعليقات والتقييمات
- ✅ **All Stores** - عرض جميع المتاجر
- ✅ **Store Filtering** - تصفية المتاجر

### 🌐 التكامل مع Backend
- ✅ **API Service Layer** - طبقة خدمات API موحدة
- ✅ **Token Manager** - إدارة التوكنات مع التجديد التلقائي
- ✅ **API Constants** - ثوابت API مركزية
- ✅ **Exception Handling** - معالجة الأخطاء بشكل احترافي
- ✅ **HTTP Client** - عميل HTTP مخصص مع Retry Logic
- ✅ **Image URL Resolver** - معالج ذكي لروابط الصور

### 📦 إدارة الحالة
- ✅ **Provider Pattern** - استخدام Provider لإدارة الحالة
- ✅ **Auth Provider** - مزود المصادقة المركزي
- ✅ **Theme Manager** - إدارة الثيم بشكل عام

---

## 🏗️ البنية التقنية

### 📂 هيكل المشروع

```
lib/
├── core/                          # المكونات الأساسية المشتركة
│   ├── network/                   # طبقة الشبكة والاتصال بالـ API
│   │   ├── api_service.dart       # خدمة API الموحدة
│   │   ├── api_constants.dart     # ثوابت الـ Endpoints
│   │   ├── api_exceptions.dart    # معالجة الأخطاء
│   │   └── token_manager.dart     # إدارة JWT Tokens
│   ├── theme/                     # نظام الثيمات
│   │   ├── app_theme.dart         # تعريف الثيمات
│   │   ├── app_colors.dart        # الألوان المستخدمة
│   │   └── theme_manager.dart     # إدارة الثيم العام
│   └── widgets/                   # المكونات القابلة لإعادة الاستخدام
│       ├── custom_button.dart
│       ├── custom_textfield.dart
│       ├── glass_container.dart
│       ├── premium_*.dart         # مكونات العروض المتقدمة
│       └── ...
├── data/                          # طبقة البيانات
│   ├── providers/                 # مزودات الحالة (State Management)
│   │   └── auth_provider.dart     # مزود المصادقة
│   └── dummy_data.dart            # بيانات تجريبية
├── presentation/                  # طبقة العرض (UI)
│   ├── screens/                   # جميع شاشات التطبيق
│   │   ├── auth/                  # شاشات المصادقة
│   │   ├── home/                  # الشاشة الرئيسية
│   │   ├── profile/               # شاشات الملف الشخصي
│   │   ├── offers/                # شاشات العروض
│   │   ├── categories/            # شاشات الفئات
│   │   ├── search/                # شاشة البحث
│   │   ├── favorites/             # المفضلات
│   │   ├── notifications/         # الإشعارات
│   │   ├── chatbot/               # المساعد الذكي
│   │   ├── stores/                # المتاجر
│   │   ├── details/               # تفاصيل العروض والتجار
│   │   ├── splash/                # شاشة البداية
│   │   ├── onboarding/            # شاشات التعريف
│   │   └── main_layout/           # التخطيط الرئيسي
│   └── widgets/                   # ويدجتات خاصة بالعرض
└── main.dart                      # نقطة البداية
```

### 🔧 التقنيات المستخدمة

#### Frontend (Flutter)
- **Flutter SDK**: 3.6.1
- **Dart**: 3.6.1
- **State Management**: Provider 6.1.2
- **HTTP Client**: http 1.6.0
- **Local Storage**: shared_preferences 2.5.3
- **Sharing**: share_plus 10.0.0

#### Backend Integration
- **API Architecture**: RESTful API
- **Authentication**: JWT (Access + Refresh Tokens)
- **Base URL**: `http://192.168.1.103:8000/api/v1`
- **Media Server**: `http://192.168.1.103:8000`

#### Design Patterns
- **Clean Architecture** - فصل واضح بين الطبقات
- **Repository Pattern** - لإدارة البيانات
- **Provider Pattern** - لإدارة الحالة
- **Singleton Pattern** - للخدمات المشتركة (ApiService, TokenManager)

---

## 🚀 التثبيت والإعداد

### المتطلبات الأساسية
```bash
Flutter SDK: >=3.6.1
Dart SDK: >=3.6.1
Android Studio / VS Code
```

### خطوات التثبيت

1. **استنساخ المشروع**
```bash
git clone https://github.com/Ali-Alqawas/test2.git
cd test2
```

2. **تثبيت الحزم**
```bash
flutter pub get
```

3. **تكوين الـ API**
   - افتح ملف `lib/core/network/api_constants.dart`
   - عدّل `baseUrl` و `mediaBaseUrl` حسب عنوان السيرفر الخاص بك:
   ```dart
   static const String baseUrl = 'http://YOUR_IP:8000/api/v1';
   static const String mediaBaseUrl = 'http://YOUR_IP:8000';
   ```

4. **تشغيل التطبيق**
```bash
flutter run
```

### معرفة عنوان IP الخاص بك
```bash
# Linux/Mac
ifconfig | grep inet

# Windows
ipconfig
```

---

## 📊 حالة المشروع

### ✅ ما تم إنجازه (85%)

#### 🎨 UI/UX - مكتمل 100%
- [x] Design System كامل
- [x] جميع الشاشات الرئيسية
- [x] جميع شاشات المصادقة
- [x] جميع شاشات الملف الشخصي
- [x] شاشات العروض والتفاصيل
- [x] نظام الثيمات (Dark/Light)
- [x] المكونات القابلة لإعادة الاستخدام
- [x] الرسوم المتحركة والانتقالات

#### 🔐 Authentication - مكتمل 90%
- [x] تسجيل الدخول
- [x] التسجيل
- [x] التحقق من OTP
- [x] استعادة كلمة المرور
- [x] اختيار الاهتمامات
- [x] JWT Token Management
- [x] Auto Token Refresh
- [ ] Social Login (Google/Apple) - قيد التطوير

#### 🌐 Backend Integration - مكتمل 70%
- [x] API Service Layer
- [x] Token Manager
- [x] Exception Handling
- [x] Auth Endpoints
- [x] Image URL Resolver
- [ ] جميع Endpoints الأخرى - قيد التكامل
- [ ] Offline Caching - مخطط
- [ ] Real-time Updates - مخطط

#### 📦 State Management - مكتمل 60%
- [x] Auth Provider
- [x] Theme Manager
- [ ] Offers Provider - قيد التطوير
- [ ] Cart Provider - مخطط
- [ ] Favorites Provider - مخطط
- [ ] Notifications Provider - مخطط

---

## 🔄 ما هو قيد التطوير

### المرحلة الحالية: Backend Integration

#### 🎯 الأولويات الحالية
1. **تكامل API الكامل**
   - ربط جميع الشاشات بالـ Backend
   - معالجة البيانات الحقيقية بدلاً من Dummy Data
   - تطبيق Pagination للقوائم الطويلة

2. **State Management المتقدم**
   - إنشاء Providers لجميع الميزات
   - إدارة الحالة العامة للتطبيق
   - Caching للبيانات المتكررة

3. **تحسينات الأداء**
   - Image Caching
   - Lazy Loading
   - Memory Management

---

## 📝 ما هو مخطط (Roadmap)

### المرحلة القادمة (v1.1)
- [ ] **Push Notifications** - إشعارات فورية
- [ ] **Deep Linking** - روابط عميقة للعروض
- [ ] **Share Functionality** - مشاركة العروض
- [ ] **Favorites Sync** - مزامنة المفضلات مع السيرفر
- [ ] **Cart System** - نظام السلة
- [ ] **Order Tracking** - تتبع الطلبات

### المرحلة المستقبلية (v2.0)
- [ ] **AI Chatbot Integration** - تكامل المساعد الذكي
- [ ] **AR Product Preview** - معاينة المنتجات بالواقع المعزز
- [ ] **Voice Search** - البحث الصوتي
- [ ] **Image Search** - البحث بالصورة
- [ ] **Social Features** - ميزات اجتماعية (متابعة، تعليقات)
- [ ] **Gamification** - نظام النقاط والإنجازات
- [ ] **Multi-language** - دعم لغات متعددة
- [ ] **Payment Gateway** - بوابة الدفع الإلكتروني

---

## 🐛 المشاكل المعروفة

### مشاكل بسيطة
- بعض الصور قد لا تظهر إذا كان السيرفر غير متصل
- بعض الانتقالات قد تكون بطيئة على الأجهزة القديمة
- بعض النصوص قد تحتاج لتحسين في الترجمة

### قيد الحل
- تحسين أداء التمرير في القوائم الطويلة
- معالجة حالات الخطأ في الشبكة بشكل أفضل
- تحسين استهلاك الذاكرة

---

## 🧪 الاختبار

### اختبارات مطلوبة
```bash
# Unit Tests
flutter test

# Integration Tests
flutter test integration_test/

# Widget Tests
flutter test test/widget_test.dart
```

> ⚠️ **ملاحظة**: الاختبارات قيد التطوير حالياً

---

## 📱 لقطات الشاشة

> 🚧 سيتم إضافة لقطات الشاشة قريباً

---

## 🤝 المساهمة

هذا مشروع خاص حالياً. للاستفسارات:
- البريد الإلكتروني: [your-email@example.com]
- GitHub: [@Ali-Alqawas](https://github.com/Ali-Alqawas)

---

## 📄 الترخيص

هذا المشروع خاص وغير متاح للاستخدام العام حالياً.

---

## 👨‍💻 الفريق

- **المطور الرئيسي**: Ali Alqawas
- **التصميم**: [اسم المصمم]
- **Backend**: [اسم مطور Backend]

---

## 📞 التواصل

- **GitHub**: [Ali-Alqawas](https://github.com/Ali-Alqawas)
- **Repository**: [test2](https://github.com/Ali-Alqawas/test2)

---

## 🙏 شكر وتقدير

- Flutter Team لتوفير إطار عمل رائع
- جميع مطوري الحزم المستخدمة في المشروع
- المجتمع العربي للمطورين

---

<div align="center">

**صُنع بـ ❤️ باستخدام Flutter**

⭐ إذا أعجبك المشروع، لا تنسَ إضافة نجمة!

</div>
