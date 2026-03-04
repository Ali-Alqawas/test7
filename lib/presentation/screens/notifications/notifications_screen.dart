import 'package:flutter/material.dart';
import '../../../core/network/api_service.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';

// ============================================================================
// شاشة الإشعارات — تجلب من API
// ============================================================================
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ApiService _api = ApiService();
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  // تعيين أيقونة ولون حسب نوع الإشعار
  static IconData _iconForType(String? type) {
    switch (type) {
      case 'offer':
        return Icons.local_offer_rounded;
      case 'order':
        return Icons.local_shipping_rounded;
      case 'coupon':
        return Icons.card_giftcard_rounded;
      case 'favorite':
        return Icons.favorite_rounded;
      case 'review':
        return Icons.star_rounded;
      case 'points':
        return Icons.emoji_events_rounded;
      case 'promotion':
        return Icons.celebration_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  static Color _colorForType(String? type) {
    switch (type) {
      case 'offer':
        return const Color(0xFFE91E63);
      case 'order':
        return const Color(0xFF4CAF50);
      case 'coupon':
        return const Color(0xFFB8860B);
      case 'favorite':
        return const Color(0xFFF44336);
      case 'review':
        return const Color(0xFFFF9800);
      case 'points':
        return const Color(0xFF2196F3);
      case 'promotion':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF607D8B);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final data = await _api.get(ApiConstants.notifications);

      final List rawNotifications =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);

      if (mounted) {
        setState(() {
          _notifications = rawNotifications.map<Map<String, dynamic>>((notif) {
            final type = notif['notification_type']?.toString() ??
                notif['type']?.toString();
            return {
              "id": notif['id']?.toString() ?? '',
              "title": notif['title']?.toString() ?? 'إشعار',
              "body": notif['message']?.toString() ??
                  notif['body']?.toString() ??
                  '',
              "time": notif['created_at_display']?.toString() ??
                  notif['time']?.toString() ??
                  '',
              "icon": _iconForType(type),
              "color": _colorForType(type),
              "isRead": notif['is_read'] ?? false,
            };
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('خطأ في جلب الإشعارات: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  int get _unreadCount =>
      _notifications.where((n) => n["isRead"] == false).length;

  Future<void> _markAllAsRead() async {
    setState(() {
      for (var n in _notifications) {
        n["isRead"] = true;
      }
    });

    // إرسال طلب قراءة الكل للـ API
    for (var n in _notifications) {
      final id = n['id'];
      if (id != null && id.isNotEmpty) {
        try {
          await _api.post(ApiConstants.markNotificationRead(id));
        } catch (_) {}
      }
    }
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
              _buildHeader(context, isDarkMode, textColor),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.goldenBronze))
                    : _notifications.isEmpty
                        ? _buildEmptyState(isDarkMode)
                        : RefreshIndicator(
                            color: AppColors.goldenBronze,
                            onRefresh: _fetchNotifications,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              padding:
                                  const EdgeInsets.fromLTRB(16, 5, 16, 100),
                              itemCount: _notifications.length,
                              itemBuilder: (_, i) => _buildNotificationCard(
                                  _notifications[i], isDarkMode, textColor),
                            ),
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
