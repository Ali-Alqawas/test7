import 'package:flutter/material.dart';
import '../../../core/network/api_service.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../details/offer_details_screen.dart';
import '../details/merchant_profile_screen.dart';

// ============================================================================
// شاشة الإشعارات — متكاملة مع API
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

  // ──────────────────────────────────────────────────────────────
  // أيقونة ولون حسب نوع الإشعار (يطابق NotificationType بالباك إند)
  // ──────────────────────────────────────────────────────────────
  static IconData _iconForType(String? type) {
    switch (type?.toUpperCase()) {
      case 'PRODUCT':
        return Icons.local_offer_rounded;
      case 'ORDER':
        return Icons.local_shipping_rounded;
      case 'PAYMENT':
        return Icons.payment_rounded;
      case 'SOCIAL':
        return Icons.favorite_rounded;
      case 'REWARD':
        return Icons.emoji_events_rounded;
      case 'PROMOTION':
        return Icons.celebration_rounded;
      case 'SUPPORT':
        return Icons.support_agent_rounded;
      case 'SECURITY':
        return Icons.security_rounded;
      case 'MERCHANT':
        return Icons.store_rounded;
      case 'SYSTEM':
      default:
        return Icons.notifications_rounded;
    }
  }

  static Color _colorForType(String? type) {
    switch (type?.toUpperCase()) {
      case 'PRODUCT':
        return const Color(0xFFE91E63);
      case 'ORDER':
        return const Color(0xFF4CAF50);
      case 'PAYMENT':
        return const Color(0xFFB8860B);
      case 'SOCIAL':
        return const Color(0xFFF44336);
      case 'REWARD':
        return const Color(0xFFFF9800);
      case 'PROMOTION':
        return const Color(0xFF9C27B0);
      case 'SUPPORT':
        return const Color(0xFF00BCD4);
      case 'SECURITY':
        return const Color(0xFFFF5722);
      case 'MERCHANT':
        return const Color(0xFF3F51B5);
      case 'SYSTEM':
      default:
        return const Color(0xFF607D8B);
    }
  }

  // ──────────────────────────────────────────────────────────────
  // تنسيق الوقت — "منذ 5 دقائق"
  // ──────────────────────────────────────────────────────────────
  static String _formatTimeAgo(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '';
    try {
      final date = DateTime.parse(isoDate);
      final diff = DateTime.now().difference(date);

      if (diff.inSeconds < 60) return 'الآن';
      if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
      if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
      if (diff.inDays == 1) return 'أمس';
      if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
      if (diff.inDays < 30) return 'منذ ${(diff.inDays / 7).floor()} أسبوع';
      if (diff.inDays < 365) return 'منذ ${(diff.inDays / 30).floor()} شهر';
      return 'منذ ${(diff.inDays / 365).floor()} سنة';
    } catch (_) {
      return isoDate;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  // ──────────────────────────────────────────────────────────────
  // جلب الإشعارات
  // ──────────────────────────────────────────────────────────────
  Future<void> _fetchNotifications() async {
    try {
      final data = await _api.get(ApiConstants.notifications);
      debugPrint('📥 Notifications API raw response type: ${data.runtimeType}');

      final List rawNotifications;
      if (data is Map) {
        rawNotifications = data['results'] ?? [];
        debugPrint(
            '📥 Paginated: count=${data['count']}, results=${(data['results'] as List?)?.length ?? 0}');
      } else if (data is List) {
        rawNotifications = data;
        debugPrint('📥 List: ${data.length} notifications');
      } else {
        rawNotifications = [];
        debugPrint('📥 Unexpected format: $data');
      }

      if (mounted) {
        setState(() {
          _notifications = rawNotifications.map<Map<String, dynamic>>((notif) {
            final type = notif['type']?.toString();
            final Map<String, dynamic> extraData = (notif['extra_data'] is Map)
                ? Map<String, dynamic>.from(notif['extra_data'])
                : {};
            return {
              "id": (notif['notification_id'] ?? notif['id'])?.toString() ?? '',
              "title": notif['title']?.toString() ?? 'إشعار',
              "body": notif['body']?.toString() ?? '',
              "time": _formatTimeAgo(notif['created_at']?.toString()),
              "type": type,
              "icon": _iconForType(type),
              "color": _colorForType(type),
              "isRead": notif['is_read'] ?? false,
              "image_url": notif['image_url']?.toString(),
              "priority": notif['priority']?.toString() ?? 'normal',
              // Deep Linking
              "action_type": notif['action_type']?.toString() ?? '',
              "action_id": notif['action_id']?.toString() ?? '',
              "action_url": notif['action_url']?.toString() ?? '',
              // بيانات إضافية (تحتوي على أسماء المتاجر/المنتجات)
              "extra_data": extraData,
            };
          }).toList();
          _isLoading = false;
          debugPrint('✅ Loaded ${_notifications.length} notifications');
        });
      }
    } catch (e, stack) {
      debugPrint('❌ خطأ في جلب الإشعارات: $e');
      debugPrint('$stack');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  int get _unreadCount =>
      _notifications.where((n) => n["isRead"] == false).length;

  // ──────────────────────────────────────────────────────────────
  // قراءة الكل — استدعاء واحد
  // ──────────────────────────────────────────────────────────────
  Future<void> _markAllAsRead() async {
    setState(() {
      for (var n in _notifications) {
        n["isRead"] = true;
      }
    });

    try {
      await _api.post(ApiConstants.markAllNotificationsRead);
    } catch (e) {
      debugPrint('خطأ في تعليم الكل كمقروء: $e');
    }
  }

  // ──────────────────────────────────────────────────────────────
  // قراءة إشعار واحد
  // ──────────────────────────────────────────────────────────────
  Future<void> _markAsRead(Map<String, dynamic> notif) async {
    if (notif['isRead'] == true) return;
    setState(() => notif['isRead'] = true);

    final id = notif['id'];
    if (id != null && id.isNotEmpty) {
      try {
        await _api.post(ApiConstants.markNotificationRead(id));
      } catch (_) {}
    }
  }

  // ──────────────────────────────────────────────────────────────
  // حذف إشعار
  // ──────────────────────────────────────────────────────────────
  Future<void> _deleteNotification(Map<String, dynamic> notif) async {
    final id = notif['id'];
    setState(() => _notifications.remove(notif));

    if (id != null && id.isNotEmpty) {
      try {
        await _api.delete(ApiConstants.deleteNotification(id));
      } catch (_) {}
    }
  }

  // ──────────────────────────────────────────────────────────────
  // Deep Linking — الضغط على إشعار
  // ──────────────────────────────────────────────────────────────
  void _handleNotificationTap(Map<String, dynamic> notif) {
    _markAsRead(notif);

    final actionType = notif['action_type'] ?? '';
    final actionId = notif['action_id'] ?? '';
    final Map<String, dynamic> extra = notif['extra_data'] ?? {};

    if (actionType.isEmpty && actionId.isEmpty) return;

    switch (actionType.toLowerCase()) {
      case 'product':
      case 'offer':
        if (actionId.isNotEmpty) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => OfferDetailsScreen(offerData: {
                        'product_id': actionId,
                        'title': extra['product_name'] ??
                            extra['title'] ??
                            notif['body'] ??
                            '',
                      }, offerType: OfferDetailType.standard)));
        }
        break;
      case 'store':
      case 'merchant':
        if (actionId.isNotEmpty) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => MerchantProfileScreen(
                      storeId: actionId,
                      storeName: extra['store_name'] ?? extra['name'] ?? 'متجر',
                      storeLogo: extra['store_logo'] ?? '')));
        }
        break;
      default:
        break;
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
                              itemBuilder: (_, i) =>
                                  _buildDismissibleNotification(
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

  // ──────────────────────────────────────────────────────────────
  // كارت الإشعار مع Swipe-to-Delete
  // ──────────────────────────────────────────────────────────────
  Widget _buildDismissibleNotification(
      Map<String, dynamic> notif, bool isDarkMode, Color textColor) {
    return Dismissible(
      key: Key(notif["id"]),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.delete_rounded, color: AppColors.error, size: 24),
            SizedBox(width: 8),
            Text("حذف",
                style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w700,
                    fontSize: 14)),
          ],
        ),
      ),
      confirmDismiss: (_) async => true,
      onDismissed: (_) => _deleteNotification(notif),
      child: _buildNotificationCard(notif, isDarkMode, textColor),
    );
  }

  Widget _buildNotificationCard(
      Map<String, dynamic> notif, bool isDarkMode, Color textColor) {
    final bool isRead = notif["isRead"] ?? true;
    final Color cardColor =
        isDarkMode ? const Color(0xFF072A38) : AppColors.pureWhite;
    final Color notifColor = notif["color"] as Color;
    final Color borderColor = isRead
        ? (isDarkMode
            ? AppColors.goldenBronze.withOpacity(0.1)
            : Colors.grey.shade200)
        : notifColor.withOpacity(0.4);

    final String? priority = notif["priority"];
    final bool isUrgent = priority == 'urgent' || priority == 'high';

    return GestureDetector(
      onTap: () => _handleNotificationTap(notif),
      child: Container(
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
            // أيقونة النوع
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: notifColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Stack(
                children: [
                  Center(
                      child: Icon(notif["icon"], color: notifColor, size: 22)),
                  // مؤشر الأولوية العالية
                  if (isUrgent)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(color: cardColor, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
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
                  Row(
                    children: [
                      Text(notif["time"],
                          style: TextStyle(
                              color: AppColors.grey.withOpacity(0.6),
                              fontSize: 10)),
                      // سهم للتوجيه إذا فيه deep link
                      if ((notif["action_type"] ?? '').isNotEmpty) ...[
                        const Spacer(),
                        Icon(Icons.arrow_back_ios_rounded,
                            size: 10,
                            color: AppColors.goldenBronze.withOpacity(0.5)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
