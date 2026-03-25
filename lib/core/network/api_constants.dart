// ============================================================================
// ثوابت الـ API — نقطة مركزية واحدة لجميع الـ Endpoints
// ============================================================================

class ApiConstants {
  // ⚠️ تنبيه: غيّر الـ IP حسب جهازك (السيرفر يعمل محلياً)
  // لينكس/ماك: ifconfig | grep inet
  // ويندوز: ipconfig
  static const String baseUrl = 'http://192.168.1.103:8001/api/v1';

  /// عنوان السيرفر الأساسي (بدون /api/v1) — لتركيب روابط الصور
  static const String mediaBaseUrl = 'http://192.168.1.103:8001';

  /// تحويل رابط الصورة إلى رابط كامل قابل للتحميل
  /// يعالج كل الحالات:
  /// - رابط كامل (https://...) → يعود كما هو
  /// - مسار نسبي (/media/...) → يضاف عنوان السيرفر
  /// - localhost/127.0.0.1 → يُستبدل بالـ IP الفعلي
  /// - null أو فارغ → صورة افتراضية
  static String resolveImageUrl(String? url, {String? fallback}) {
    if (url == null || url.isEmpty) {
      return fallback ?? 'https://placehold.co/400x400/png?text=No+Image';
    }

    // رابط كامل بالفعل
    if (url.startsWith('http://') || url.startsWith('https://')) {
      // استبدال localhost بالـ IP الحقيقي
      return url
          .replaceAll('http://localhost:8000', mediaBaseUrl)
          .replaceAll('http://127.0.0.1:8000', mediaBaseUrl)
          .replaceAll('http://localhost:8001', mediaBaseUrl)
          .replaceAll('http://127.0.0.1:8001', mediaBaseUrl)
          .replaceAll('http://10.0.2.2:8000', mediaBaseUrl)
          .replaceAll('http://10.0.2.2:8001', mediaBaseUrl);
    }

    // مسار نسبي → إضافة عنوان السيرفر
    if (url.startsWith('/')) {
      return '$mediaBaseUrl$url';
    }

    return '$mediaBaseUrl/$url';
  }

  // ──────────────────────────────────────────────────────────────
  // 🔐 Auth | Access
  // ──────────────────────────────────────────────────────────────
  static const String login = '/auth/login/';
  static const String register = '/auth/register/';
  static const String logout = '/auth/logout/';
  static const String verifyOtp = '/auth/verify-otp/';
  static const String resendOtp = '/auth/resend-otp/';
  static const String sendOtp = '/auth/send-otp/';
  static const String verifyEmail = '/auth/verify-email/';
  static const String passwordResetRequest = '/auth/password-reset/request/';
  static const String passwordResetConfirm = '/auth/password-reset/confirm/';
  static const String tokenRefresh = '/auth/token/refresh/';
  static const String changePassword = '/auth/change-password/';

  // ──────────────────────────────────────────────────────────────
  // 👤 Auth | Profile
  // ──────────────────────────────────────────────────────────────
  static const String profile = '/auth/profile/';
  static const String account = '/auth/account/';
  static const String phones = '/auth/phones/';
  static const String referralCode = '/auth/referral-code/';
  static const String referralStats = '/auth/referral-stats/';

  // ──────────────────────────────────────────────────────────────
  // 📂 Catalog | Categories
  // ──────────────────────────────────────────────────────────────
  static const String categories = '/catalog/categories/';

  // ──────────────────────────────────────────────────────────────
  // 📦 Catalog | Products
  // ──────────────────────────────────────────────────────────────
  static const String products = '/catalog/products/';
  static const String popularProducts = '/catalog/products/popular/';
  static const String productGroups = '/catalog/product-groups/';
  static String productDetails(String id) => '/catalog/products/$id/';
  static const String compareProducts = '/catalog/products/compare/';

  // ──────────────────────────────────────────────────────────────
  // 🔍 Catalog | Search
  // ──────────────────────────────────────────────────────────────
  static const String searchProducts = '/catalog/search/products/';
  static const String searchStores = '/catalog/search/stores/';
  static const String quickSearch = '/catalog/search/quick_search/';
  static const String searchSuggestions = '/catalog/search/suggestions/';
  static const String searchFilters = '/catalog/search/filters/';
  static const String popularTags = '/catalog/search/popular_tags/';
  static const String advancedSearch = '/catalog/search/advanced/';
  static const String imageSearch = '/catalog/advanced-search/image/';
  static const String voiceSearch = '/catalog/advanced-search/voice/';

  // ──────────────────────────────────────────────────────────────
  // 🏪 Merchants | Stores
  // ──────────────────────────────────────────────────────────────
  static const String stores = '/merchants/stores/';
  static String storeDetails(String id) => '/merchants/stores/$id/';

  // ──────────────────────────────────────────────────────────────
  // ❤️ Social | Interactions
  // ──────────────────────────────────────────────────────────────
  static const String favorites = '/social/favorites/';
  static const String likes = '/social/likes/';
  // REST pattern:
  //   إضافة: POST /social/favorites/ body: {"product": id}
  //   حذف:  DELETE /social/favorites/{record_id}/
  //   نفس الشيء لللايكات عبر /social/likes/
  static String deleteFavorite(int recordId) => '/social/favorites/$recordId/';
  static String deleteLike(int recordId) => '/social/likes/$recordId/';
  // للتوافق مع الكود القديم (لا تستخدمها — استخدم SocialProvider)
  static String toggleFavorite(String productId) =>
      '/social/products/$productId/favorite/';
  static String toggleLike(String productId) =>
      '/social/products/$productId/like/';
  static String followStore(String storeId) =>
      '/social/stores/$storeId/follow/';
  static String rateStore(String storeId) => '/social/stores/$storeId/rate/';
  static const String follows = '/social/follows/';
  static String deleteFollow(int recordId) => '/social/follows/$recordId/';

  // ──────────────────────────────────────────────────────────────
  // 💬 Social | Comments
  // ──────────────────────────────────────────────────────────────
  static const String comments = '/social/comments/';
  static String deleteComment(int commentId) => '/social/comments/$commentId/';
  static String productComments(String productId) =>
      '/social/products/$productId/comments/';
  static String groupComments(String groupId) =>
      '/social/groups/$groupId/comments/';

  // ──────────────────────────────────────────────────────────────
  // ⭐ Social | Reviews & Ratings
  // ──────────────────────────────────────────────────────────────
  static const String ratings = '/social/ratings/';
  static const String reports = '/social/reports/';

  // ──────────────────────────────────────────────────────────────
  // 📋 Social | Interests
  // ──────────────────────────────────────────────────────────────
  static const String interests = '/social/interests/';

  // ──────────────────────────────────────────────────────────────
  // 🎁 Rewards
  // ──────────────────────────────────────────────────────────────
  static const String rewardsPoints = '/rewards/points/';
  static const String pointsBalance = '/rewards/points/balance/';
  static const String pointsHistory = '/rewards/points/history/';
  static const String rewardsTransactions = '/rewards/transactions/';
  static const String draws = '/rewards/draws/';
  static const String currentDraw = '/rewards/draws/current/';
  static String enterDraw(String id) => '/rewards/draws/$id/enter/';
  static String drawDetails(String id) => '/rewards/draws/$id/';
  static String drawEntries(String id) => '/rewards/draws/$id/entries/';
  static const String rewardsReferralCode = '/rewards/referral-code/';
  static const String rewardsReferralStats = '/rewards/referral-stats/';
  static const String rewardItems = '/rewards/items/';
  static const String redeemPoints = '/rewards/redeem/';
  static const String redemptions = '/rewards/redemptions/';

  // ──────────────────────────────────────────────────────────────
  // 🔔 Support | Notifications
  // ──────────────────────────────────────────────────────────────
  static const String notifications = '/support/notifications/';
  static String markNotificationRead(String id) =>
      '/support/notifications/$id/read/';
  static const String markAllNotificationsRead =
      '/support/notifications/mark-all-read/';
  static const String unreadNotificationCount =
      '/support/notifications/unread-count/';
  static String deleteNotification(String id) =>
      '/support/notifications/$id/delete/';
  static const String archiveNotifications = '/support/notifications/archive/';
  static const String notificationPreferences =
      '/support/notification-preferences/';
  static const String devices = '/support/devices/';

  // ──────────────────────────────────────────────────────────────
  // ✉️ Support | Messages
  // ──────────────────────────────────────────────────────────────
  static const String directMessages = '/support/messages/';

  // ──────────────────────────────────────────────────────────────
  // 🎫 Support | Tickets
  // ──────────────────────────────────────────────────────────────
  static const String tickets = '/support/tickets/';
  static String ticketDetails(String id) => '/support/tickets/$id/';
  static String replyTicket(String id) => '/support/tickets/$id/reply/';
  static String closeTicket(String id) => '/support/tickets/$id/close/';
  static const String ticketStats = '/support/tickets/stats/';

  // ──────────────────────────────────────────────────────────────
  // 🤖 Chatbot
  // ──────────────────────────────────────────────────────────────
  static const String chatSessions = '/chatbot/sessions/';
  static const String chatSend = '/chatbot/sessions/chat/';
  static String chatHistory(String id) => '/chatbot/sessions/$id/history/';
  static String clearChat(String id) => '/chatbot/sessions/$id/clear/';

  // ──────────────────────────────────────────────────────────────
  // 📊 Analytics
  // ──────────────────────────────────────────────────────────────
  static String logView(String productId) =>
      '/analytics/products/$productId/view/';
  static String logShare(String productId) =>
      '/analytics/products/$productId/share/';
  static const String logSearch = '/analytics/search/';
  static const String userStats = '/analytics/user-stats/';

  // ──────────────────────────────────────────────────────────────
  // 🛠️ Core | Utilities
  // ──────────────────────────────────────────────────────────────
  static const String banners = '/core/banners/';
  static const String ads = '/core/ads/';
  static const String settings = '/core/settings/';
  static const String uploadFile = '/core/upload/';
  static const String uploadProfileImage = '/core/upload/profile/';
}
