# SIDE App — تقرير تكامل API الكامل
**تاريخ التقرير:** 2026-03-21  
**الإصدار:** 1.0.0  
**Base URL:** `http://<SERVER_IP>:8000/api/v1`  
**Auth Header:** `Authorization: Bearer <access_token>`  
**Content-Type:** `application/json` (إلا عند رفع الملفات)

---

## 📌 ملاحظات عامة

- التطبيق يستخدم **JWT Tokens** (Access + Refresh)
- عند انتهاء الـ Access Token يتم تجديده تلقائياً عبر `/auth/token/refresh/`
- إذا فشل التجديد يتم تسجيل خروج المستخدم تلقائياً
- الـ Timeout المضبوط = **15 ثانية**
- جميع الـ Endpoints التي تحتاج Auth ترسل الـ Token في الـ Header
- الـ Endpoints التي لا تحتاج Auth تُستدعى بدون Header

---

## 🔐 1. المصادقة (Auth)

### 1.1 تسجيل الدخول
```
POST /auth/login/
Auth: ❌ لا يحتاج
```
**Request:**
```json
{
  "email": "user@example.com",
  "password": "string"
}
```
**Response (200):**
```json
{
  "access": "eyJ...",
  "refresh": "eyJ..."
}
```
**الاستخدام:** شاشة تسجيل الدخول — يُحفظ التوكن في SharedPreferences

---

### 1.2 إنشاء حساب جديد
```
POST /auth/register/
Auth: ❌ لا يحتاج
```
**Request:**
```json
{
  "username": "string",
  "full_name": "string",
  "email": "user@example.com",
  "phone_number": "+966xxxxxxxxx",
  "password": "string",
  "confirm_password": "string"
}
```
**Response (201):** بيانات المستخدم المنشأ (لا يُرجع tokens — يذهب لشاشة OTP)  
**الاستخدام:** شاشة التسجيل

---

### 1.3 التحقق من OTP
```
POST /auth/verify-otp/
Auth: ❌ لا يحتاج
```
**Request:**
```json
{
  "email": "user@example.com",
  "otp_code": "123456"
}
```
**Response (200):** تأكيد نجاح التحقق  
**الاستخدام:** شاشة التحقق بعد التسجيل

---

### 1.4 إعادة إرسال OTP
```
POST /auth/resend-otp/
Auth: ❌ لا يحتاج
```
**Request:**
```json
{
  "email": "user@example.com"
}
```
**Response (200):** تأكيد الإرسال  
**الاستخدام:** زر "إعادة الإرسال" في شاشة التحقق

---

### 1.5 طلب إعادة تعيين كلمة المرور
```
POST /auth/password-reset/request/
Auth: ❌ لا يحتاج
```
**Request:**
```json
{
  "email": "user@example.com"
}
```
**Response (200):** تأكيد إرسال OTP  
**الاستخدام:** شاشة "نسيت كلمة المرور"

---

### 1.6 تأكيد إعادة تعيين كلمة المرور
```
POST /auth/password-reset/confirm/
Auth: ❌ لا يحتاج
```
**Request:**
```json
{
  "email": "user@example.com",
  "otp_code": "123456",
  "new_password": "string",
  "confirm_password": "string"
}
```
**Response (200):** تأكيد نجاح إعادة التعيين  
**الاستخدام:** شاشة إعادة تعيين كلمة المرور

---

### 1.7 تجديد Access Token (تلقائي)
```
POST /auth/token/refresh/
Auth: ❌ لا يحتاج
```
**Request:**
```json
{
  "refresh": "eyJ..."
}
```
**Response (200):**
```json
{
  "access": "eyJ..."
}
```
**الاستخدام:** يُستدعى تلقائياً من `ApiService` عند استقبال 401

---

### 1.8 تغيير كلمة المرور (مسجّل دخول)
```
POST /auth/change-password/
Auth: ✅ يحتاج
```
**Request:**
```json
{
  "old_password": "string",
  "new_password": "string",
  "new_password2": "string"
}
```
**Response (200):** تأكيد نجاح التغيير  
**الاستخدام:** شاشة الأمان والخصوصية

---

### 1.9 تسجيل الخروج
```
POST /auth/logout/
Auth: ✅ يحتاج
```
**Request:** `{}`  
**Response:** يُتجاهل — يتم مسح التوكنات محلياً بغض النظر عن النتيجة  
**الاستخدام:** زر تسجيل الخروج في شاشة الحساب

---

## 👤 2. الملف الشخصي (Profile)

### 2.1 جلب بيانات البروفايل
```
GET /auth/profile/
Auth: ✅ يحتاج
```
**Response (200):**
```json
{
  "full_name": "string",
  "username": "string",
  "profile_image": "url",
  "avatar": "url",
  "is_verified": true,
  "account": {
    "email": "user@example.com",
    "account_type": "Personal",
    "points_balance": 150
  },
  "phones": [
    {
      "id": 1,
      "phone_number": "+966xxxxxxxxx",
      "type": "Mobile",
      "is_primary": true
    }
  ]
}
```
**الاستخدام:** عند بدء التطبيق، الشاشة الرئيسية (اسم المستخدم + صورته)، شاشة الحساب

---

### 2.2 تحديث البروفايل — بدون صورة
```
PATCH /auth/profile/
Auth: ✅ يحتاج
Content-Type: application/json
```
**Request:**
```json
{
  "username": "string",
  "full_name": "string"
}
```
**Response (200):** بيانات البروفايل المحدّثة  
**الاستخدام:** شاشة تعديل الملف الشخصي

---

### 2.3 تحديث البروفايل — مع صورة
```
PATCH /auth/profile/
Auth: ✅ يحتاج
Content-Type: multipart/form-data
```
**Request Fields:**
```
profile_image: <file>
username: string (اختياري)
full_name: string (اختياري)
```
**Response (200):** بيانات البروفايل المحدّثة  
**الاستخدام:** شاشة تعديل الملف الشخصي عند اختيار صورة من المعرض

---

### 2.4 جلب بيانات الحساب
```
GET /auth/account/
Auth: ✅ يحتاج
```
**Response (200):**
```json
{
  "email": "user@example.com",
  "account_type": "Personal",
  "points_balance": 150
}
```
**الاستخدام:** `AuthProvider.fetchAccount()`

---

### 2.5 جلب أرقام الهاتف
```
GET /auth/phones/
Auth: ✅ يحتاج
```
**Response (200):**
```json
{
  "results": [
    {
      "id": 1,
      "phone_number": "+966xxxxxxxxx",
      "type": "Mobile",
      "is_primary": true
    }
  ]
}
```
**الاستخدام:** شاشة الأمان والخصوصية

---

### 2.6 إضافة رقم هاتف
```
POST /auth/phones/
Auth: ✅ يحتاج
```
**Request:**
```json
{
  "phone_number": "+966xxxxxxxxx",
  "type": "Mobile",
  "is_primary": false
}
```
**Response (201):** بيانات الرقم المضاف  
**الاستخدام:** شاشة الأمان والخصوصية

---

## 📂 3. الكتالوج (Catalog)

### 3.1 جلب الفئات
```
GET /catalog/categories/
Auth: ❌ لا يحتاج
```
**Response (200):**
```json
{
  "results": [
    {
      "id": 1,
      "category_id": 1,
      "name": "إلكترونيات",
      "image": "url"
    }
  ]
}
```
**الاستخدام:** شريط الفئات في الشاشة الرئيسية، شاشة الفئات الكاملة

---

### 3.2 جلب المنتجات / العروض
```
GET /catalog/products/
Auth: ❌ لا يحتاج
```
**Query Params المستخدمة:**

| Param | القيمة | الاستخدام |
|---|---|---|
| `page_size` | `6` أو `10` | تحديد عدد النتائج |
| `is_featured` | `true` | العروض المميزة فقط |
| `product_type` | `brochure` | كتيبات العروض فقط |
| `store` | `<store_id>` | عروض متجر محدد |
| `category` | `<category_id>` | عروض فئة محددة |
| `search` | `<query>` | البحث النصي |

**Response (200):**
```json
{
  "count": 100,
  "next": "url",
  "previous": null,
  "results": [
    {
      "product_id": 1,
      "id": 1,
      "title": "string",
      "description": "string",
      "price": "99.99",
      "old_price": "149.99",
      "store": 5,
      "store_name": "string",
      "store_logo": "url",
      "store_id": 5,
      "images": [
        { "image_url": "url" }
      ],
      "image": "url",
      "thumbnail": "url",
      "is_featured": true,
      "is_liked": false,
      "is_favorited": false,
      "views_count": 120,
      "likes_count": 45,
      "category": 3,
      "category_name": "إلكترونيات",
      "brand": "string",
      "size": "string",
      "weight": "string",
      "end_date": "2026-04-01T00:00:00Z",
      "valid_until": "2026-04-01T00:00:00Z",
      "pages_count": 12,
      "offer_type": "Individual"
    }
  ]
}
```
**الاستخدام:**
- `premium_standard_offer_card.dart` — أحدث العروض (page_size=10)
- `premium_featured_offers.dart` — العروض المميزة (is_featured=true, page_size=6)
- `premium_brochures_section.dart` — الكتيبات (product_type=brochure, page_size=6)
- `search_screen.dart` — البحث (search=query)
- `category_offers_screen.dart` — عروض فئة (category=id)
- `merchant_profile_screen.dart` — عروض متجر (store=id)

---

### 3.3 جلب تفاصيل منتج محدد
```
GET /catalog/products/<product_id>/
Auth: ❌ لا يحتاج
```
**Response (200):** نفس حقول المنتج في 3.2 بالتفصيل الكامل  
**الاستخدام:** `offer_details_screen.dart` — لتحديث عدادات المشاهدات والإعجابات والوصف

---

### 3.4 جلب مجموعات المنتجات (باقات التوفير)
```
GET /catalog/product-groups/
Auth: ❌ لا يحتاج
```
**Query Params المستخدمة:**

| Param | القيمة | الاستخدام |
|---|---|---|
| `type` | `bundle` | الباقات فقط |
| `page_size` | `6` أو `100` | تحديد عدد النتائج |
| `store` | `<store_id>` | باقات متجر محدد |
| `search` | `<query>` | البحث |

**Response (200):**
```json
{
  "results": [
    {
      "group_id": 1,
      "id": 1,
      "name": "باقة التوفير الكبرى",
      "price": "199.00",
      "old_price": "350.00",
      "store": 5,
      "store_name": "string",
      "store_logo": "url",
      "store_id": 5,
      "image": "url",
      "products": [
        {
          "product_id": 10,
          "title": "string",
          "price": "99.00",
          "store_name": "string",
          "images": [{ "image_url": "url" }],
          "image": "url"
        }
      ]
    }
  ]
}
```
**الاستخدام:**
- `premium_bundled_offers.dart` — باقات الشاشة الرئيسية
- `search_screen.dart` — بحث الباقات
- `favorites_screen.dart` — جلب كل الباقات لمطابقة المفضلة (page_size=100)
- `merchant_profile_screen.dart` — باقات متجر محدد

---

### 3.5 الكلمات الشائعة في البحث
```
GET /catalog/search/popular_tags/
Auth: ✅ يحتاج
```
**Response (200):**
```json
["إلكترونيات", "أزياء", "مطاعم"]
```
أو:
```json
{
  "results": ["string"],
  "tags": ["string"]
}
```
**الاستخدام:** `search_screen.dart` — عرض الكلمات الشائعة قبل البحث

---

## 🏪 4. المتاجر (Merchants)

### 4.1 جلب قائمة المتاجر
```
GET /merchants/stores/
Auth: ❌ لا يحتاج
```
**Query Params المستخدمة:**

| Param | القيمة | الاستخدام |
|---|---|---|
| `page_size` | `50` | جلب كل المتاجر |
| `search` | `<query>` | البحث عن متجر |
| `ordering` | `-average_rating` | ترتيب حسب التقييم |

**Response (200):**
```json
{
  "results": [
    {
      "store_id": 1,
      "id": 1,
      "name": "string",
      "logo": "url",
      "activity_type": "RETAIL",
      "average_rating": "4.5",
      "verification_status": "VERIFIED",
      "description": "string",
      "location": "string",
      "working_hours": "string",
      "cover_image": "url",
      "rating_count": 120
    }
  ]
}
```
**قيم `activity_type`:** `RETAIL` | `SERVICE` | `FOOD` | `OTHER`  
**قيم `verification_status`:** `VERIFIED` | غير ذلك  
**الاستخدام:** `all_stores_screen.dart`

---

### 4.2 جلب تفاصيل متجر محدد
```
GET /merchants/stores/<store_id>/
Auth: ❌ لا يحتاج
```
**Response (200):**
```json
{
  "name": "string",
  "description": "string",
  "location": "string",
  "activity_type": "RETAIL",
  "working_hours": "9AM - 10PM",
  "cover_image": "url",
  "average_rating": "4.5",
  "rating_count": 120,
  "verification_status": "VERIFIED"
}
```
**الاستخدام:** `merchant_profile_screen.dart` — تبويب "حول المتجر"

---

## ❤️ 5. التفاعلات الاجتماعية (Social)

### 5.1 جلب المفضلة — منتجات فردية
```
GET /social/favorites/
Auth: ✅ يحتاج
```
**Response (200):**
```json
{
  "results": [
    {
      "id": 10,
      "product": 5
    }
  ]
}
```
**الاستخدام:** `social_provider.dart` عند بدء التطبيق، `favorites_screen.dart`

---

### 5.2 إضافة منتج للمفضلة
```
POST /social/favorites/
Auth: ✅ يحتاج
```
**Request:**
```json
{
  "product": 5
}
```
**Response (201):**
```json
{
  "id": 10,
  "product": 5
}
```
**الاستخدام:** زر القلب في كل بطاقة عرض

---

### 5.3 حذف منتج من المفضلة
```
DELETE /social/favorites/<record_id>/
Auth: ✅ يحتاج
```
**⚠️ ملاحظة:** الـ `record_id` هو `id` السجل في جدول المفضلة، **وليس** `product_id`  
**Response:** `204 No Content`  
**الاستخدام:** زر القلب عند إلغاء المفضلة

---

### 5.4 جلب المفضلة — مجموعات (باقات)
```
GET /social/group-favorites/
Auth: ✅ يحتاج
```
**Response (200):**
```json
{
  "results": [
    {
      "id": 3,
      "product_group": 7
    }
  ]
}
```
**الاستخدام:** `social_provider.dart`, `favorites_screen.dart`

---

### 5.5 إضافة مجموعة للمفضلة
```
POST /social/group-favorites/
Auth: ✅ يحتاج
```
**Request:**
```json
{
  "product_group": 7
}
```
**Response (201):**
```json
{
  "id": 3,
  "product_group": 7
}
```

---

### 5.6 حذف مجموعة من المفضلة
```
DELETE /social/group-favorites/<record_id>/
Auth: ✅ يحتاج
```
**Response:** `204 No Content`

---

### 5.7 جلب الإعجابات — منتجات فردية
```
GET /social/likes/
Auth: ✅ يحتاج
```
**Response (200):**
```json
{
  "results": [
    {
      "id": 20,
      "product": 5
    }
  ]
}
```
**الاستخدام:** `social_provider.dart` عند بدء التطبيق

---

### 5.8 إضافة إعجاب — منتج
```
POST /social/likes/
Auth: ✅ يحتاج
```
**Request:**
```json
{
  "product": 5
}
```
**Response (201):**
```json
{
  "id": 20,
  "product": 5
}
```

---

### 5.9 حذف إعجاب — منتج
```
DELETE /social/likes/<record_id>/
Auth: ✅ يحتاج
```
**Response:** `204 No Content`

---

### 5.10 جلب إعجابات المجموعات
```
GET /social/group-likes/
Auth: ✅ يحتاج
```
**Response (200):**
```json
{
  "results": [
    {
      "id": 8,
      "product_group": 7
    }
  ]
}
```

---

### 5.11 إضافة إعجاب — مجموعة
```
POST /social/group-likes/
Auth: ✅ يحتاج
```
**Request:**
```json
{
  "product_group": 7
}
```
**Response (201):**
```json
{
  "id": 8,
  "product_group": 7
}
```

---

### 5.12 حذف إعجاب — مجموعة
```
DELETE /social/group-likes/<record_id>/
Auth: ✅ يحتاج
```
**Response:** `204 No Content`

---

### 5.13 جلب المتابعات
```
GET /social/follows/
Auth: ✅ يحتاج
```
**Response (200):**
```json
{
  "results": [
    {
      "id": 15,
      "store": 3
    }
  ]
}
```
**الاستخدام:** `merchant_profile_screen.dart` — زر المتابعة

---

### 5.14 متابعة متجر
```
POST /social/follows/
Auth: ✅ يحتاج
```
**Request:**
```json
{
  "store": 3
}
```
**Response (201):**
```json
{
  "id": 15,
  "store": 3
}
```

---

### 5.15 إلغاء متابعة متجر
```
DELETE /social/follows/<record_id>/
Auth: ✅ يحتاج
```
**Response:** `204 No Content`

---

### 5.16 جلب تعليقات منتج
```
GET /social/products/<product_id>/comments/
Auth: ✅ يحتاج
```
**Response (200):**
```json
{
  "results": [
    {
      "id": 1,
      "text": "string",
      "user": "string",
      "user_image": "url",
      "created_at": "2026-03-01T10:00:00Z"
    }
  ]
}
```
**الاستخدام:** `offer_details_screen.dart`, `all_comments_screen.dart`

---

### 5.17 إضافة تعليق على منتج
```
POST /social/products/<product_id>/comments/
Auth: ✅ يحتاج
```
**Request:**
```json
{
  "text": "string"
}
```
**Response (201):**
```json
{
  "id": 1,
  "text": "string",
  "user": "string",
  "created_at": "datetime"
}
```
**الاستخدام:** حقل التعليق في شاشة تفاصيل العرض وشاشة كل التعليقات

---

### 5.18 جلب تعليقات مجموعة (باقة)
```
GET /social/groups/<group_id>/comments/
Auth: ✅ يحتاج
```
**Response:** نفس تعليقات المنتجات  
**الاستخدام:** `offer_details_screen.dart` عند نوع العرض `bundled`

---

### 5.19 إضافة تعليق على مجموعة (باقة)
```
POST /social/groups/<group_id>/comments/
Auth: ✅ يحتاج
```
**Request:**
```json
{
  "text": "string"
}
```
**Response (201):** نفس تعليقات المنتجات

---

### 5.20 حذف تعليق
```
DELETE /social/comments/<comment_id>/
Auth: ✅ يحتاج
```
**Response:** `204 No Content`  
**الاستخدام:** `all_comments_screen.dart` — حذف تعليق المستخدم الخاص

---

### 5.21 جلب التقييمات
```
GET /social/ratings/
Auth: ✅ يحتاج
Query: store=<store_id>&page_size=20
```
**Response (200):**
```json
{
  "results": [
    {
      "id": 1,
      "rating": 5,
      "review": "string",
      "user": "string",
      "user_image": "url",
      "created_at": "datetime"
    }
  ]
}
```
**الاستخدام:** `merchant_profile_screen.dart` — تبويب التقييمات

---

### 5.22 اهتمامات المستخدم
```
POST /social/interests/
Auth: ✅ يحتاج
```
**Request:**
```json
{
  "interests": [1, 3, 5]
}
```
**الاستخدام:** `interests_screen.dart` — بعد التسجيل مباشرة

---

## 🎁 6. المكافآت (Rewards)

### 6.1 جلب رصيد النقاط
```
GET /rewards/points/balance/
Auth: ✅ يحتاج
```
**Response (200):**
```json
{
  "balance": 150
}
```
أو: `{ "points_balance": 150 }` أو `{ "points": 150 }`  
**الاستخدام:** `rewards_screen.dart` — بطاقة رصيد النقاط

---

### 6.2 جلب سجل النقاط
```
GET /rewards/points/history/
Auth: ✅ يحتاج
```
**Response (200):**
```json
{
  "results": [
    {
      "id": 1,
      "points": 50,
      "type": "EARNED",
      "description": "مشاهدة عرض",
      "created_at": "2026-03-01T10:00:00Z"
    }
  ]
}
```
**الاستخدام:** `rewards_screen.dart` — قائمة سجل العمليات

---

### 6.3 جلب رمز الإحالة
```
GET /rewards/referral-code/
Auth: ✅ يحتاج
```
**Response (200):**
```json
{
  "referral_code": "SIDE-ABC123"
}
```
أو: `{ "code": "SIDE-ABC123" }`  
**⚠️ ملاحظة:** إذا فشل هذا الـ Endpoint يُجرب التطبيق تلقائياً `GET /auth/referral-code/`  
**الاستخدام:** `rewards_screen.dart`, `profile_screen.dart`

---

### 6.4 جلب إحصائيات الإحالة
```
GET /rewards/referral-stats/
Auth: ✅ يحتاج
```
**Response (200):**
```json
{
  "total_referrals": 5,
  "earned_points": 250
}
```
**⚠️ ملاحظة:** إذا فشل يُجرب `GET /auth/referral-stats/`  
**الاستخدام:** `AuthProvider.fetchReferralStats()`

---

### 6.5 جلب السحوبات
```
GET /rewards/draws/
Auth: ✅ يحتاج
```
**Response (200):**
```json
{
  "results": [
    {
      "draw_id": 1,
      "id": 1,
      "title": "سحب الجائزة الكبرى",
      "description": "string",
      "prize": "سيارة",
      "points_required": 100,
      "status": "ACTIVE",
      "end_date": "2026-04-01T00:00:00Z",
      "image": "url"
    }
  ]
}
```
**قيم `status`:** `ACTIVE` | `UPCOMING` | `ENDED` | `CANCELLED`  
**الاستخدام:** `draws_screen.dart`, `profile_screen.dart`

---

### 6.6 الدخول في سحب
```
POST /rewards/draws/<draw_id>/enter/
Auth: ✅ يحتاج
```
**Request:** `{}`  
**Response (200):** تأكيد الدخول  
**الاستخدام:** `draws_screen.dart` — زر "دخول السحب" (يخصم النقاط المطلوبة)

---

## 🔔 7. الإشعارات والدعم (Support)

### 7.1 جلب الإشعارات
```
GET /support/notifications/
Auth: ✅ يحتاج
```
**Response (200):**
```json
{
  "results": [
    {
      "id": 1,
      "title": "عرض جديد!",
      "message": "string",
      "body": "string",
      "notification_type": "offer",
      "type": "offer",
      "is_read": false,
      "created_at_display": "منذ ساعتين",
      "time": "string"
    }
  ]
}
```
**قيم `notification_type`:** `offer` | `order` | `coupon` | `favorite` | `review` | `points` | `promotion`  
**الاستخدام:** `notifications_screen.dart`

---

### 7.2 جلب تذاكر الدعم
```
GET /support/tickets/
Auth: ✅ يحتاج
```
**Response (200):**
```json
{
  "results": [
    {
      "id": 1,
      "title": "string",
      "subject": "string",
      "issue_type": "string",
      "status": "OPEN",
      "description": "string",
      "created_at": "datetime"
    }
  ]
}
```
**قيم `status`:** `OPEN` | `CLOSED` | ...  
**الاستخدام:** `support_center_screen.dart`

---

### 7.3 إنشاء تذكرة دعم — بدون صورة
```
POST /support/tickets/
Auth: ✅ يحتاج
Content-Type: application/json
```
**Request:**
```json
{
  "description": "string",
  "issue_type": "string",
  "status": "OPEN"
}
```
**Response (201):** بيانات التذكرة المنشأة  
**الاستخدام:** `support_center_screen.dart` — نموذج إنشاء تذكرة

---

### 7.4 إنشاء تذكرة دعم — مع صورة
```
POST /support/tickets/
Auth: ✅ يحتاج
Content-Type: multipart/form-data
```
**Request Fields:**
```
image_url: <file>
description: string
issue_type: string
status: OPEN
```
**الاستخدام:** `support_center_screen.dart` عند إرفاق صورة

---

### 7.5 الرد على تذكرة
```
POST /support/tickets/<ticket_id>/reply/
Auth: ✅ يحتاج
```
**Request:**
```json
{
  "message": "string"
}
```
**Response (200):** تأكيد الرد  
**الاستخدام:** `support_center_screen.dart` — الرد على تذكرة مفتوحة

---

### 7.6 إغلاق تذكرة
```
POST /support/tickets/<ticket_id>/close/
Auth: ✅ يحتاج
```
**Request:** `{}`  
**Response (200):** تأكيد الإغلاق  
**الاستخدام:** `support_center_screen.dart`

---

## 📊 8. الأنالتيكس (Analytics)

### 8.1 تسجيل مشاهدة منتج
```
POST /analytics/products/<product_id>/view/
Auth: ✅ يحتاج
```
**Request:** `{}`  
**Response (200):** تأكيد  
**⚠️ ملاحظة:** يُستدعى **مرة واحدة فقط** عند فتح شاشة تفاصيل العرض (محمي بـ flag `_viewTracked`)  
**الاستخدام:** `offer_details_screen.dart` → `_trackView()`

---

## 🛠️ 9. الأساسيات (Core)

### 9.1 جلب البانرات الإعلانية
```
GET /core/banners/
Auth: ❌ لا يحتاج
```
**Response (200):**
```json
{
  "results": [
    {
      "id": 1,
      "title": "خصم 50%",
      "subtitle": "ينتهي قريباً",
      "description": "string",
      "image": "url",
      "image_url": "url"
    }
  ]
}
```
**الاستخدام:** الكاروسيل الإعلاني في الشاشة الرئيسية — يتحرك تلقائياً كل 4 ثوانٍ

---

## 📋 ملخص جميع الـ Endpoints المستخدمة

| # | Endpoint | Method | Auth | الشاشة |
|---|---|---|---|---|
| 1 | `/auth/login/` | POST | ❌ | تسجيل الدخول |
| 2 | `/auth/register/` | POST | ❌ | إنشاء حساب |
| 3 | `/auth/verify-otp/` | POST | ❌ | التحقق OTP |
| 4 | `/auth/resend-otp/` | POST | ❌ | إعادة إرسال OTP |
| 5 | `/auth/password-reset/request/` | POST | ❌ | نسيت كلمة المرور |
| 6 | `/auth/password-reset/confirm/` | POST | ❌ | إعادة تعيين كلمة المرور |
| 7 | `/auth/token/refresh/` | POST | ❌ | تلقائي (تجديد التوكن) |
| 8 | `/auth/change-password/` | POST | ✅ | الأمان والخصوصية |
| 9 | `/auth/logout/` | POST | ✅ | شاشة الحساب |
| 10 | `/auth/profile/` | GET | ✅ | الشاشة الرئيسية + الحساب |
| 11 | `/auth/profile/` | PATCH | ✅ | تعديل الملف الشخصي |
| 12 | `/auth/account/` | GET | ✅ | الحساب |
| 13 | `/auth/phones/` | GET | ✅ | الأمان |
| 14 | `/auth/phones/` | POST | ✅ | الأمان |
| 15 | `/auth/referral-code/` | GET | ✅ | المكافآت (fallback) |
| 16 | `/auth/referral-stats/` | GET | ✅ | المكافآت (fallback) |
| 17 | `/catalog/categories/` | GET | ❌ | الشاشة الرئيسية + الفئات |
| 18 | `/catalog/products/` | GET | ❌ | الشاشة الرئيسية + البحث + الفئات |
| 19 | `/catalog/products/<id>/` | GET | ❌ | تفاصيل العرض |
| 20 | `/catalog/product-groups/` | GET | ❌ | الشاشة الرئيسية + البحث + المفضلة |
| 21 | `/catalog/search/popular_tags/` | GET | ✅ | البحث |
| 22 | `/merchants/stores/` | GET | ❌ | شاشة المتاجر |
| 23 | `/merchants/stores/<id>/` | GET | ❌ | ملف المتجر |
| 24 | `/social/favorites/` | GET | ✅ | المفضلة + بدء التطبيق |
| 25 | `/social/favorites/` | POST | ✅ | زر المفضلة |
| 26 | `/social/favorites/<id>/` | DELETE | ✅ | زر المفضلة |
| 27 | `/social/group-favorites/` | GET | ✅ | المفضلة + بدء التطبيق |
| 28 | `/social/group-favorites/` | POST | ✅ | زر مفضلة الباقة |
| 29 | `/social/group-favorites/<id>/` | DELETE | ✅ | زر مفضلة الباقة |
| 30 | `/social/likes/` | GET | ✅ | بدء التطبيق |
| 31 | `/social/likes/` | POST | ✅ | زر الإعجاب |
| 32 | `/social/likes/<id>/` | DELETE | ✅ | زر الإعجاب |
| 33 | `/social/group-likes/` | GET | ✅ | بدء التطبيق |
| 34 | `/social/group-likes/` | POST | ✅ | زر إعجاب الباقة |
| 35 | `/social/group-likes/<id>/` | DELETE | ✅ | زر إعجاب الباقة |
| 36 | `/social/follows/` | GET | ✅ | ملف المتجر |
| 37 | `/social/follows/` | POST | ✅ | زر المتابعة |
| 38 | `/social/follows/<id>/` | DELETE | ✅ | زر إلغاء المتابعة |
| 39 | `/social/products/<id>/comments/` | GET | ✅ | تفاصيل العرض + التعليقات |
| 40 | `/social/products/<id>/comments/` | POST | ✅ | إضافة تعليق |
| 41 | `/social/groups/<id>/comments/` | GET | ✅ | تفاصيل الباقة |
| 42 | `/social/groups/<id>/comments/` | POST | ✅ | تعليق على باقة |
| 43 | `/social/comments/<id>/` | DELETE | ✅ | حذف تعليق |
| 44 | `/social/ratings/` | GET | ✅ | ملف المتجر |
| 45 | `/social/interests/` | POST | ✅ | شاشة الاهتمامات |
| 46 | `/rewards/points/balance/` | GET | ✅ | المكافآت |
| 47 | `/rewards/points/history/` | GET | ✅ | المكافآت |
| 48 | `/rewards/referral-code/` | GET | ✅ | المكافآت |
| 49 | `/rewards/referral-stats/` | GET | ✅ | المكافآت |
| 50 | `/rewards/draws/` | GET | ✅ | السحوبات + الحساب |
| 51 | `/rewards/draws/<id>/enter/` | POST | ✅ | السحوبات |
| 52 | `/support/notifications/` | GET | ✅ | الإشعارات |
| 53 | `/support/tickets/` | GET | ✅ | مركز الدعم |
| 54 | `/support/tickets/` | POST | ✅ | إنشاء تذكرة |
| 55 | `/support/tickets/<id>/reply/` | POST | ✅ | الرد على تذكرة |
| 56 | `/support/tickets/<id>/close/` | POST | ✅ | إغلاق تذكرة |
| 57 | `/analytics/products/<id>/view/` | POST | ✅ | تفاصيل العرض |
| 58 | `/core/banners/` | GET | ❌ | الشاشة الرئيسية |

**الإجمالي: 58 Endpoint مستخدم فعلياً**

---

## ⚠️ ملاحظات مهمة للباك اند

### 1. نظام المفضلة والإعجابات
- التطبيق يستخدم **REST pattern** وليس toggle endpoint
- عند الإضافة: `POST` → يُرجع `{ "id": <record_id>, "product": <product_id> }`
- عند الحذف: `DELETE /social/favorites/<record_id>/` — الـ `record_id` هو `id` السجل
- **مهم:** إذا أرجع الـ POST خطأ `duplicate key` أو `already exists` يقوم التطبيق بجلب القائمة وحذف السجل الموجود

### 2. صور المنتجات
- التطبيق يتوقع `images: [{ "image_url": "url" }]` أو `image: "url"` أو `thumbnail: "url"`
- يتم تحويل المسارات النسبية تلقائياً: `/media/...` → `http://<SERVER_IP>:8000/media/...`

### 3. Pagination
- التطبيق يقرأ `data['results']` إذا كان الرد `Map`، أو يستخدم الـ List مباشرة
- لا يوجد تطبيق للـ pagination (infinite scroll) حالياً — يُجلب كل شيء دفعة واحدة

### 4. الـ IDs
- المنتجات: يُقرأ `product_id` أولاً ثم `id`
- المجموعات: يُقرأ `group_id` أولاً ثم `id`
- المتاجر: يُقرأ `store_id` أولاً ثم `id`
- السحوبات: يُقرأ `draw_id` أولاً ثم `id`

### 5. الـ Endpoints غير المربوطة بعد (UI جاهز فقط)
- `/chatbot/sessions/` — واجهة الشات بوت جاهزة لكن بدون ربط
- `/support/messages/` — صندوق الوارد UI جاهز
- `/support/notification-preferences/` — إعدادات الإشعارات UI جاهز
- `/support/devices/` — لم يُربط
- `/analytics/products/<id>/share/` — لم يُربط
- `/rewards/redeem/` — لم يُربط

---

*تم إعداد هذا التقرير بتاريخ 2026-03-21 بناءً على تحليل كامل لكود التطبيق*
