import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';

// ============================================================================
// شاشة الإشعارات (Notifications Screen)
// ============================================================================
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      "title": "خصم 50% على الأزياء!",
      "body": "لا تفوّت عرض نهاية الأسبوع على أشهر الماركات العالمية",
      "time": "منذ 5 دقائق",
      "icon": Icons.local_offer_rounded,
      "color": const Color(0xFFE91E63),
      "isRead": false,
    },
    {
      "title": "طلبك في الطريق 🚚",
      "body": "طلبك رقم #12345 خرج للتوصيل وسيصلك قريباً",
      "time": "منذ 30 دقيقة",
      "icon": Icons.local_shipping_rounded,
      "color": const Color(0xFF4CAF50),
      "isRead": false,
    },
    {
      "title": "كوبون خاص لك! 🎁",
      "body": "حصلت على كوبون خصم 20% صالح لمدة 48 ساعة",
      "time": "منذ ساعة",
      "icon": Icons.card_giftcard_rounded,
      "color": AppColors.goldenBronze,
      "isRead": false,
    },
    {
      "title": "منتج جديد في المفضلة",
      "body": "ساعة رولكس ديتونا المميزة متوفرة الآن بسعر مخفض",
      "time": "منذ 3 ساعات",
      "icon": Icons.favorite_rounded,
      "color": const Color(0xFFF44336),
      "isRead": true,
    },
    {
      "title": "تقييم تجربتك",
      "body": "ما رأيك في آخر طلب؟ شاركنا تقييمك وساعد الآخرين",
      "time": "أمس",
      "icon": Icons.star_rounded,
      "color": const Color(0xFFFF9800),
      "isRead": true,
    },
    {
      "title": "عروض رمضان بدأت! 🌙",
      "body": "خصومات تصل إلى 70% على مئات المنتجات",
      "time": "قبل يومين",
      "icon": Icons.celebration_rounded,
      "color": const Color(0xFF9C27B0),
      "isRead": true,
    },
    {
      "title": "نقاطك زادت!",
      "body": "تهانينا! حصلت على 150 نقطة جديدة من مشترياتك الأخيرة",
      "time": "قبل 3 أيام",
      "icon": Icons.emoji_events_rounded,
      "color": const Color(0xFF2196F3),
      "isRead": true,
    },
  ];

  int get _unreadCount =>
      _notifications.where((n) => n["isRead"] == false).length;

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n["isRead"] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor =
        isDarkMode ? AppColors.deepNavy : AppColors.lightBackground;
    final Color textColor =
        isDarkMode ? AppColors.pureWhite : AppColors.lightText;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Column(
            children: [
              // الهيدر
              _buildHeader(context, isDarkMode, textColor),
              // القائمة
              Expanded(
                child: _notifications.isEmpty
                    ? _buildEmptyState(isDarkMode)
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 5, 16, 100),
                        itemCount: _notifications.length,
                        itemBuilder: (_, i) => _buildNotificationCard(
                            _notifications[i], isDarkMode, textColor),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDarkMode, Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFF072A38)
                        : AppColors.pureWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: isDarkMode
                            ? AppColors.goldenBronze.withOpacity(0.3)
                            : Colors.grey.shade300),
                  ),
                  child: Icon(Icons.arrow_forward_ios_rounded,
                      color: textColor, size: 18),
                ),
              ),
              const SizedBox(width: 12),
              Text("الإشعارات 🔔",
                  style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w900)),
              const SizedBox(width: 8),
              if (_unreadCount > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.error.withOpacity(0.3)),
                  ),
                  child: Text("$_unreadCount جديد",
                      style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              const Spacer(),
              // قراءة الكل
              if (_unreadCount > 0)
                GestureDetector(
                  onTap: _markAllAsRead,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.goldenBronze.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text("قراءة الكل",
                        style: TextStyle(
                            color: AppColors.goldenBronze,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              if (_unreadCount == 0)
                GestureDetector(
                  onTap: toggleGlobalTheme,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color:
                          isDarkMode ? AppColors.pureWhite : AppColors.deepNavy,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color:
                                (isDarkMode ? Colors.black : AppColors.deepNavy)
                                    .withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 3))
                      ],
                    ),
                    child: Icon(
                        isDarkMode
                            ? Icons.wb_sunny_rounded
                            : Icons.nightlight_round,
                        color: AppColors.goldenBronze,
                        size: 20),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_rounded,
              color: AppColors.goldenBronze.withOpacity(0.3), size: 80),
          const SizedBox(height: 20),
          Text("لا توجد إشعارات",
              style: TextStyle(
                  color: isDarkMode
                      ? AppColors.grey
                      : AppColors.lightText.withOpacity(0.5),
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text("ستظهر هنا جميع الإشعارات الواردة",
              style: TextStyle(
                  color: isDarkMode
                      ? AppColors.grey.withOpacity(0.6)
                      : AppColors.lightText.withOpacity(0.3),
                  fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
      Map<String, dynamic> notif, bool isDarkMode, Color textColor) {
    final bool isRead = notif["isRead"] ?? true;
    final Color cardColor =
        isDarkMode ? const Color(0xFF072A38) : AppColors.pureWhite;
    final Color borderColor = isRead
        ? (isDarkMode
            ? AppColors.goldenBronze.withOpacity(0.1)
            : Colors.grey.shade200)
        : (notif["color"] as Color).withOpacity(0.4);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isRead ? 1.0 : 1.5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.15 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // أيقونة
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (notif["color"] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(notif["icon"], color: notif["color"], size: 22),
          ),
          const SizedBox(width: 12),
          // المحتوى
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(notif["title"],
                            style: TextStyle(
                                color: textColor,
                                fontSize: 14,
                                fontWeight: isRead
                                    ? FontWeight.w600
                                    : FontWeight.w900))),
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                            color: AppColors.goldenBronze,
                            shape: BoxShape.circle),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(notif["body"],
                    style: TextStyle(
                        color: textColor.withOpacity(0.6),
                        fontSize: 12,
                        height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text(notif["time"],
                    style: TextStyle(
                        color: AppColors.grey.withOpacity(0.6), fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
