# SIDE — Backend API Documentation
> **Base URL:** `http://<SERVER_IP>:8000/api/v1`
> **Auth:** Bearer Token (JWT) — `Authorization: Bearer <access_token>`
> **Last Updated:** 2025

---

## 📑 فهرس المحتويات

1. [Authentication — `/api/v1/auth/`](#1-authentication)
2. [Catalog — `/api/v1/catalog/`](#2-catalog)
3. [Social — `/api/v1/social/`](#3-social)
4. [Merchants — `/api/v1/merchants/`](#4-merchants)
5. [Rewards — `/api/v1/rewards/`](#5-rewards)
6. [Support — `/api/v1/support/`](#6-support)
7. [Analytics — `/api/v1/analytics/`](#7-analytics)
8. [Core — `/api/v1/core/`](#8-core)
9. [Chatbot — `/api/v1/chatbot/`](#9-chatbot)
10. [Payments — `/api/v1/payments/`](#10-payments)

---

## 1. Authentication
**Prefix:** `/api/v1/auth/`

---

### POST `/auth/simple/register/`
تسجيل مبسط (للفرونت)

**Request:**
```json
{
  "username": "string",
  "email": "user@example.com",
  "password": "string"
}
```
**Response 201:**
```json
{
  "access": "jwt_token",
  "refresh": "jwt_token",
  "user": { "id": 1, "username": "string", "email": "user@example.com" }
}
```

---

### POST `/auth/simple/login/`
تسجيل دخول مبسط (للفرونت)

**Request:**
```json
{ "email": "user@example.com", "password": "string" }
```
**Response 200:**
```json
{
  "access": "jwt_token",
  "refresh": "jwt_token",
  "user": { "id": 1, "username": "string", "email": "user@example.com" }
}
```

---

### POST `/auth/register/`
تسجيل كامل

**Request:**
```json
{
  "username": "string",
  "email": "user@example.com",
  "password": "string",
  "first_name": "string",
  "last_name": "string",
  "phone": "string"
}
```
**Response 201:** مثل `simple/register/`

---

### POST `/auth/login/`
تسجيل دخول (JWT)

**Request:**
```json
{ "email": "user@example.com", "password": "string" }
```
**Response 200:**
```json
{ "access": "jwt_token", "refresh": "jwt_token" }
```

---

### POST `/auth/logout/`
🔒 Auth Required

**Request:**
```json
{ "refresh": "jwt_refresh_token" }
```
**Response 200:** `{ "detail": "Logged out successfully" }`

---

### POST `/auth/token/refresh/`
تجديد الـ Access Token

**Request:**
```json
{ "refresh": "jwt_refresh_token" }
```
**Response 200:**
```json
{ "access": "new_jwt_token" }
```

---

### POST `/auth/send-otp/`
إرسال OTP

**Request:**
```json
{ "email": "user@example.com" }
```
**Response 200:** `{ "detail": "OTP sent" }`

---

### POST `/auth/resend-otp/`
إعادة إرسال OTP

**Request:**
```json
{ "email": "user@example.com" }
```
**Response 200:** `{ "detail": "OTP resent" }`

---

### POST `/auth/verify-otp/`
التحقق من OTP

**Request:**
```json
{ "email": "user@example.com", "otp": "123456" }
```
**Response 200:** `{ "detail": "OTP verified" }`

---

### POST `/auth/verify-email/`
التحقق من البريد الإلكتروني

**Request:**
```json
{ "token": "string" }
```
**Response 200:** `{ "detail": "Email verified" }`

---

### POST `/auth/password-reset/request/`
طلب إعادة تعيين كلمة المرور

**Request:**
```json
{ "email": "user@example.com" }
```
**Response 200:** `{ "detail": "Reset email sent" }`

---

### POST `/auth/password-reset/confirm/`
تأكيد إعادة تعيين كلمة المرور

**Request:**
```json
{ "token": "string", "new_password": "string" }
```
**Response 200:** `{ "detail": "Password reset successful" }`

---

### GET `/auth/profile/`
🔒 Auth Required — جلب الملف الشخصي

**Response 200:**
```json
{
  "id": 1,
  "username": "string",
  "email": "user@example.com",
  "first_name": "string",
  "last_name": "string",
  "phone": "string",
  "avatar": "url",
  "bio": "string",
  "interests": [1, 2, 3]
}
```

### PATCH `/auth/profile/`
🔒 Auth Required — تعديل الملف الشخصي

**Request:** أي حقل من حقول الـ profile (multipart/form-data للصور)

---

### GET/PATCH `/auth/account/`
🔒 Auth Required — بيانات الحساب (email, username, password)

---

### GET/POST `/auth/phones/`
🔒 Auth Required — أرقام الهاتف

**POST Request:**
```json
{ "phone": "+966501234567", "is_primary": true }
```

---

### POST `/auth/change-password/`
🔒 Auth Required

**Request:**
```json
{ "old_password": "string", "new_password": "string" }
```
**Response 200:** `{ "detail": "Password changed" }`

---

### GET `/auth/referral-code/`
🔒 Auth Required — جلب كود الإحالة

**Response 200:**
```json
{ "code": "ABC123", "url": "https://..." }
```

---

### GET `/auth/referral-stats/`
🔒 Auth Required — إحصائيات الإحالة

**Response 200:**
```json
{ "total_referrals": 5, "earned_points": 500 }
```

---

## 2. Catalog
**Prefix:** `/api/v1/catalog/`

---

### GET `/catalog/categories/`
جلب جميع الفئات

**Query Params:** `?parent=<id>` للفئات الفرعية

**Response 200:**
```json
[
  {
    "id": 1,
    "name": "string",
    "icon": "url",
    "image": "url",
    "parent": null,
    "subcategories": []
  }
]
```

### POST `/catalog/categories/`
🔒 Auth Required (Admin) — إنشاء فئة

---

### GET `/catalog/products/`
جلب المنتجات/العروض

**Query Params:**
- `?category=<id>` — فلتر بالفئة
- `?store=<id>` — فلتر بالمتجر
- `?search=<text>` — بحث
- `?min_price=<num>&max_price=<num>` — فلتر بالسعر
- `?ordering=<field>` — ترتيب (`-created_at`, `new_price`, `-likes_count`)
- `?page=<num>` — pagination

**Response 200:**
```json
{
  "count": 100,
  "next": "url",
  "previous": null,
  "results": [
    {
      "id": 1,
      "name": "string",
      "description": "string",
      "old_price": "99.99",
      "new_price": "49.99",
      "discount_percentage": 50,
      "store": 1,
      "store_name": "string",
      "category": 1,
      "category_name": "string",
      "images": [{ "id": 1, "image": "url", "is_primary": true }],
      "views_count": 100,
      "shares_count": 10,
      "likes_count": 25,
      "is_liked": false,
      "is_favorited": false,
      "start_date": "2025-01-01T00:00:00Z",
      "end_date": "2025-12-31T00:00:00Z",
      "is_active": true,
      "is_featured": false,
      "product_type": "offer"
    }
  ]
}
```

---

### GET `/catalog/products/popular/`
العروض الأكثر مشاهدة/تفاعلاً

**Response 200:** نفس شكل قائمة المنتجات

---

### POST `/catalog/products/compare/`
مقارنة منتجات

**Request:**
```json
{ "product_ids": [1, 2, 3] }
```
**Response 200:** قائمة بتفاصيل المنتجات المطلوبة

---

### GET `/catalog/products/<id>/`
تفاصيل منتج واحد

**Response 200:** نفس شكل ProductSerializer (مع كل الحقول)

---

### POST `/catalog/products/create/`
🔒 Auth Required (Merchant) — إنشاء منتج

**Request (multipart/form-data):**
```
name, description, old_price, new_price, category, start_date, end_date, images[]
```

---

### PATCH `/catalog/products/<id>/manage/`
🔒 Auth Required (Merchant) — تعديل منتج

---

### GET/POST `/catalog/product-groups/`
مجموعات المنتجات (Bundled Offers)

**Response 200:**
```json
[
  {
    "id": 1,
    "name": "string",
    "description": "string",
    "products": [ /* ProductSerializer */ ]
  }
]
```

---

### GET `/catalog/search/advanced/`
بحث متقدم

**Query Params:** `?q=<text>&category=<id>&min_price=<num>&max_price=<num>&store=<id>&rating=<num>`

**Response 200:** نفس شكل قائمة المنتجات

---

### GET `/catalog/search/`
(SearchEnhancementViewSet — router)

**Actions:** `list`, `retrieve`
**Query Params:** `?q=<text>`

---

### GET `/catalog/advanced-search/`
(AdvancedSearchViewSet — router)

**Actions:** `list`, `retrieve`, `suggestions`, `filters`

---

## 3. Social
**Prefix:** `/api/v1/social/`

---

### GET/POST `/social/products/<id>/comments/`
تعليقات منتج

**POST Request (🔒):**
```json
{ "content": "string", "rating": 4 }
```
**Response 200:**
```json
[
  {
    "id": 1,
    "user": { "id": 1, "username": "string", "avatar": "url" },
    "content": "string",
    "rating": 4,
    "created_at": "2025-01-01T00:00:00Z"
  }
]
```

---

### GET/POST `/social/groups/<id>/comments/`
تعليقات مجموعة منتجات

---

### POST `/social/products/<id>/like/`
🔒 Auth Required — لايك/إلغاء لايك (toggle)

**Response 200:**
```json
{ "liked": true, "likes_count": 26 }
```

---

### POST `/social/products/<id>/favorite/`
🔒 Auth Required — مفضلة/إلغاء مفضلة (toggle)

**Response 200:**
```json
{ "favorited": true }
```

---

### POST `/social/stores/<id>/follow/`
🔒 Auth Required — متابعة/إلغاء متابعة متجر (toggle)

**Response 200:**
```json
{ "following": true }
```

---

### POST `/social/stores/<id>/rate/`
🔒 Auth Required — تقييم متجر

**Request:**
```json
{ "rating": 4, "review": "string" }
```

---

### GET/POST `/social/interests/`
🔒 Auth Required — اهتمامات المستخدم

**POST Request:**
```json
{ "category_ids": [1, 2, 3] }
```

---

### Router ViewSets (CRUD كامل):
| Endpoint | الوصف |
|----------|-------|
| `/social/comments/` | إدارة التعليقات |
| `/social/likes/` | إدارة اللايكات |
| `/social/favorites/` | إدارة المفضلة |
| `/social/follows/` | إدارة المتابعات |
| `/social/ratings/` | إدارة التقييمات |
| `/social/reports/` | الإبلاغ عن محتوى |
| `/social/group-likes/` | لايكات المجموعات |
| `/social/group-favorites/` | مفضلة المجموعات |

---

## 4. Merchants
**Prefix:** `/api/v1/merchants/`

---

### GET `/merchants/packages/`
باقات الاشتراك المتاحة

**Response 200:**
```json
[
  {
    "id": 1,
    "name": "Basic",
    "price": "99.00",
    "duration_days": 30,
    "max_products": 10,
    "features": ["feature1", "feature2"]
  }
]
```

---

### GET `/merchants/stores/`
جميع المتاجر

**Query Params:** `?search=<text>&category=<id>&page=<num>`

**Response 200:**
```json
{
  "count": 50,
  "results": [
    {
      "id": 1,
      "name": "string",
      "logo": "url",
      "cover_image": "url",
      "description": "string",
      "category": 1,
      "rating": 4.5,
      "followers_count": 100,
      "products_count": 25,
      "is_verified": true,
      "is_following": false
    }
  ]
}
```

---

### GET `/merchants/stores/<id>/`
تفاصيل متجر واحد

**Response 200:** نفس الشكل + `products: []`

---

### POST `/merchants/stores/<id>/verification-documents/`
🔒 Auth Required (Merchant) — رفع وثائق التحقق

**Request (multipart/form-data):**
```
document_type, file
```

---

### GET/POST `/merchants/subscriptions/`
🔒 Auth Required (Merchant) — الاشتراكات

**POST Request:**
```json
{ "package": 1 }
```

---

### GET `/merchants/subscription/usage/`
🔒 Auth Required (Merchant) — استخدام الاشتراك الحالي

**Response 200:**
```json
{
  "package": "Basic",
  "products_used": 5,
  "products_limit": 10,
  "expires_at": "2025-12-31"
}
```

---

### POST `/merchants/subscription/upgrade-request/`
🔒 Auth Required (Merchant) — طلب ترقية الاشتراك

**Request:**
```json
{ "requested_package": 2, "reason": "string" }
```

---

### GET `/merchants/stats/`
🔒 Auth Required (Merchant) — إحصائيات المتجر

**Response 200:**
```json
{
  "total_products": 25,
  "total_views": 1500,
  "total_likes": 300,
  "total_followers": 100
}
```

---

### GET `/merchants/dashboard/`
🔒 Auth Required (Merchant) — لوحة التحكم

---

### GET `/merchants/dashboard/reports/`
🔒 Auth Required (Merchant) — تقارير المتجر

---

### GET `/merchants/products/<id>/interactions/`
🔒 Auth Required (Merchant) — تفاعلات منتج معين

---

### Router: `/merchants/verification/`
🔒 Auth Required — إدارة طلبات التحقق

---

## 5. Rewards
**Prefix:** `/api/v1/rewards/`

---

### GET `/rewards/points/`
🔒 Auth Required — رصيد النقاط

**Response 200:**
```json
{ "balance": 1500, "lifetime_earned": 3000, "lifetime_spent": 1500 }
```

---

### GET `/rewards/points/history/`
🔒 Auth Required — تاريخ النقاط (= `/rewards/transactions/`)

**Response 200:**
```json
[
  {
    "id": 1,
    "type": "earned",
    "amount": 100,
    "description": "string",
    "created_at": "2025-01-01T00:00:00Z"
  }
]
```

---

### GET `/rewards/items/`
كتالوج المكافآت القابلة للاستبدال

**Response 200:**
```json
[
  {
    "id": 1,
    "name": "string",
    "points_required": 500,
    "image": "url",
    "description": "string",
    "stock": 10
  }
]
```

---

### POST `/rewards/redeem/`
🔒 Auth Required — استبدال نقاط بمكافأة

**Request:**
```json
{ "item_id": 1, "quantity": 1 }
```
**Response 200:**
```json
{ "success": true, "remaining_balance": 1000 }
```

---

### GET `/rewards/redemptions/`
🔒 Auth Required — سجل الاستبدالات

---

### GET `/rewards/referral-code/`
🔒 Auth Required — كود الإحالة (نفس `/auth/referral-code/`)

### GET `/rewards/referral-stats/`
🔒 Auth Required — إحصائيات الإحالة

---

### Router: `/rewards/draws/`
السحوبات والجوائز

| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/rewards/draws/` | قائمة السحوبات |
| GET | `/rewards/draws/<id>/` | تفاصيل سحب |
| POST | `/rewards/draws/<id>/enter/` | الاشتراك في سحب |

---

## 6. Support
**Prefix:** `/api/v1/support/`

---

### GET `/support/notifications/`
🔒 Auth Required — قائمة الإشعارات

**Response 200:**
```json
[
  {
    "id": 1,
    "title": "string",
    "body": "string",
    "type": "offer|system|reward",
    "is_read": false,
    "created_at": "2025-01-01T00:00:00Z"
  }
]
```

---

### POST `/support/notifications/<id>/read/`
🔒 Auth Required — تحديد إشعار كمقروء

**Response 200:** `{ "detail": "Marked as read" }`

---

### GET/POST `/support/messages/`
🔒 Auth Required — الرسائل المباشرة

**POST Request:**
```json
{ "recipient": 1, "content": "string" }
```

---

### Router ViewSets:

#### `/support/devices/`
🔒 Auth Required — أجهزة Push Notifications

**POST (register device):**
```json
{ "token": "fcm_token", "platform": "android|ios" }
```

#### `/support/notification-preferences/`
🔒 Auth Required — إعدادات الإشعارات

**PATCH:**
```json
{
  "offers": true,
  "rewards": true,
  "messages": true,
  "system": false
}
```

#### `/support/tickets/`
🔒 Auth Required — تذاكر الدعم

**POST:**
```json
{ "subject": "string", "description": "string", "category": "technical|billing|other" }
```

**Response 200:**
```json
{
  "id": 1,
  "subject": "string",
  "status": "open|in_progress|closed",
  "created_at": "2025-01-01T00:00:00Z"
}
```

---

## 7. Analytics
**Prefix:** `/api/v1/analytics/`

---

### POST `/analytics/search/`
تسجيل عملية بحث

**Request:**
```json
{ "query": "string", "results_count": 10 }
```

---

### POST `/analytics/products/<id>/view/`
تسجيل مشاهدة منتج

**Response 200:** `{ "views_count": 101 }`

---

### POST `/analytics/products/<id>/share/`
تسجيل مشاركة منتج

**Response 200:** `{ "shares_count": 11 }`

---

### GET `/analytics/stats/`
🔒 Auth Required (Admin) — إحصائيات عامة

---

### GET `/analytics/user-stats/`
🔒 Auth Required — إحصائيات المستخدم

**Response 200:**
```json
{
  "total_views": 50,
  "total_favorites": 12,
  "total_likes": 30,
  "searches": 25
}
```

---

## 8. Core
**Prefix:** `/api/v1/core/`

---

### GET `/core/ads/`
الإعلانات النشطة

**Response 200:**
```json
[
  {
    "id": 1,
    "title": "string",
    "image": "url",
    "link": "url",
    "position": "home_top|home_middle",
    "is_active": true
  }
]
```

---

### GET `/core/settings/`
إعدادات التطبيق العامة

**Response 200:**
```json
{
  "app_name": "SIDE",
  "maintenance_mode": false,
  "min_app_version": "1.0.0",
  "contact_email": "support@side-app.com"
}
```

---

### POST `/core/upload/`
🔒 Auth Required — رفع ملف عام

**Request (multipart/form-data):**
```
file: <binary>
```
**Response 200:**
```json
{ "url": "http://<SERVER_IP>:8000/media/uploads/file.jpg" }
```

---

### POST `/core/upload/profile/`
🔒 Auth Required — رفع صورة الملف الشخصي

**Request (multipart/form-data):**
```
image: <binary>
```
**Response 200:**
```json
{ "avatar": "url" }
```

---

### GET `/core/health/`
فحص حالة السيرفر (لا يحتاج auth)

**Response 200:**
```json
{ "status": "ok", "timestamp": "2025-01-01T00:00:00Z" }
```

---

### Router ViewSets:

#### `/core/banners/`
البانرات الإعلانية

**Response 200:**
```json
[
  {
    "id": 1,
    "title": "string",
    "image": "url",
    "link": "url",
    "is_active": true,
    "order": 1
  }
]
```

#### `/core/image-library/`
🔒 Auth Required (Admin) — مكتبة الصور

---

## 9. Chatbot
**Prefix:** `/api/v1/chatbot/`

---

### Router: `/chatbot/sessions/`
🔒 Auth Required

| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/chatbot/sessions/` | قائمة الجلسات |
| POST | `/chatbot/sessions/` | إنشاء جلسة جديدة |
| GET | `/chatbot/sessions/<id>/` | تفاصيل جلسة |
| POST | `/chatbot/sessions/<id>/chat/` | إرسال رسالة |
| GET | `/chatbot/sessions/<id>/history/` | تاريخ المحادثة |

**POST `/chatbot/sessions/<id>/chat/` Request:**
```json
{ "message": "string" }
```

**Response 200:**
```json
{
  "reply": "string",
  "suggestions": ["string"],
  "products": [ /* ProductSerializer */ ]
}
```

---

## 10. Payments
**Prefix:** `/api/v1/payments/`

---

### Router: `/payments/payments/`
🔒 Auth Required

| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/payments/payments/` | قائمة المدفوعات |
| POST | `/payments/payments/` | إنشاء دفعة |
| GET | `/payments/payments/<id>/` | تفاصيل دفعة |

**POST Request:**
```json
{ "amount": "99.00", "currency": "SAR", "method": "card|wallet", "reference": "string" }
```

---

### Router: `/payments/refunds/`
🔒 Auth Required

| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/payments/refunds/` | قائمة المسترجعات |
| POST | `/payments/refunds/` | طلب استرجاع |

---

## ⚠️ ملاحظات مهمة

### Endpoints موجودة في الفرونت لكن غير موثقة في الباك اند
| Endpoint (Frontend) | الحالة |
|---------------------|--------|
| `GET /catalog/products/?type=brochure` | يعتمد على `product_type` field |
| `GET /catalog/products/?featured=true` | يعتمد على `is_featured` field |
| `GET /merchants/stores/<id>/products/` | غير موجود كـ endpoint مستقل — استخدم `/catalog/products/?store=<id>` |

### Endpoints موجودة في الباك اند لكن غير مربوطة في الفرونت
| Endpoint | الوصف |
|----------|-------|
| `POST /auth/verify-email/` | التحقق من البريد |
| `GET /analytics/user-stats/` | إحصائيات المستخدم |
| `POST /analytics/products/<id>/share/` | تسجيل المشاركة |
| `/payments/payments/` | نظام الدفع كامل |
| `/support/tickets/` | تذاكر الدعم |
| `/chatbot/sessions/` | الشات بوت (UI جاهز، API غير مربوط) |
| `/rewards/draws/` | السحوبات (UI جاهز، API غير مربوط) |

### Auth Endpoints المكررة
- `/auth/referral-code/` = `/rewards/referral-code/` — نفس الـ view
- `/auth/referral-stats/` = `/rewards/referral-stats/` — نفس الـ view

### Media URLs
- الصور تُرجع كـ relative path: `/media/...`
- الـ Full URL: `http://<SERVER_IP>:8000/media/...`
- استخدم `mediaBaseUrl` في `api_constants.dart`

### Pagination
- الـ endpoints التي تدعم pagination تُرجع:
```json
{ "count": 100, "next": "url|null", "previous": "url|null", "results": [] }
```

### Error Responses
```json
{ "detail": "string" }           // 401, 403, 404
{ "field_name": ["error msg"] }  // 400 Validation
{ "non_field_errors": ["msg"] }  // 400 General
```
