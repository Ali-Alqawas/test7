import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/network/api_service.dart';
import '../../../core/network/api_constants.dart';
import '../details/merchant_chat_screen.dart';

// ============================================================================
// صندوق الوارد — مربوط بـ /support/messages/
// ============================================================================
class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final ApiService _api = ApiService();
  List<Map<String, dynamic>> _conversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchConversations();
  }

  Future<void> _fetchConversations() async {
    try {
      final data = await _api.get(
        ApiConstants.directMessages,
        queryParams: {'ordering': '-timestamp', 'page_size': '100'},
      );
      final List raw =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);

      // تحديد ID المستخدم الحالي: الشخص الذي يظهر كمرسل في أي رسالة
      // كل رسالة فيها sender + receiver — نحتاج نعرف مين "أنا" ومين "الآخر"
      final allMessages = raw.cast<Map<String, dynamic>>();

      // نحدد user ID الحالي من أول رسالة أرسلها المستخدم
      int? myId;
      final senderCounts = <int, int>{};
      for (final m in allMessages) {
        final s = m['sender'] as int? ?? 0;
        senderCounts[s] = (senderCounts[s] ?? 0) + 1;
      }
      // المستخدم الحالي هو الأكثر ظهوراً كمرسل (أو الوحيد)
      if (senderCounts.isNotEmpty) {
        myId = senderCounts.entries
            .reduce((a, b) => a.value >= b.value ? a : b)
            .key;
      }

      // تجميع المحادثات حسب الطرف الآخر
      final Map<int, Map<String, dynamic>> grouped = {};
      for (final msg in allMessages) {
        final sender = msg['sender'] as int? ?? 0;
        final receiver = msg['receiver'] as int? ?? 0;
        // الطرف الآخر = إذا أنا المرسل فالآخر هو المستلم والعكس
        final otherId = (sender == myId) ? receiver : sender;
        final otherName = (sender == myId)
            ? (msg['receiver_name']?.toString() ?? 'مستخدم')
            : (msg['sender_name']?.toString() ?? 'مستخدم');
        if (otherId == 0) continue;
        // أول رسالة هي الأحدث (لأن الترتيب -timestamp)
        if (!grouped.containsKey(otherId)) {
          grouped[otherId] = {
            'userId': otherId,
            'name': otherName,
            'lastMsg': msg['text']?.toString() ?? '',
            'timestamp': msg['timestamp']?.toString() ?? '',
            'logo':
                'https://ui-avatars.com/api/?name=${Uri.encodeComponent(otherName)}&background=B8860B&color=fff',
          };
        }
      }

      if (mounted) {
        setState(() {
          _conversations = grouped.values.toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('خطأ جلب المحادثات: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) return '';
    try {
      final dt = DateTime.parse(timestamp).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'الآن';
      if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
      if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
      if (diff.inDays < 7) return 'منذ ${diff.inDays} يوم';
      return '${dt.day}/${dt.month}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.deepNavy : AppColors.lightBackground;
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    final cardC = isDark ? const Color(0xFF072A38) : Colors.white;
    final borderC = isDark
        ? AppColors.goldenBronze.withOpacity(0.15)
        : Colors.grey.shade200;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          leading: IconButton(
              icon:
                  Icon(Icons.arrow_forward_ios_rounded, color: textC, size: 20),
              onPressed: () => Navigator.pop(context)),
          title: Text("صندوق الوارد",
              style: TextStyle(
                  color: textC, fontSize: 18, fontWeight: FontWeight.w900)),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.goldenBronze))
            : _conversations.isEmpty
                ? Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.inbox_rounded,
                        color: textC.withOpacity(0.2), size: 80),
                    const SizedBox(height: 16),
                    Text("لا توجد محادثات",
                        style: TextStyle(
                            color: textC.withOpacity(0.4), fontSize: 16)),
                    const SizedBox(height: 8),
                    Text("تواصل مع التجار لبدء محادثة",
                        style: TextStyle(
                            color: textC.withOpacity(0.3), fontSize: 13)),
                  ]))
                : RefreshIndicator(
                    color: AppColors.goldenBronze,
                    onRefresh: _fetchConversations,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      padding: const EdgeInsets.all(20),
                      itemCount: _conversations.length,
                      itemBuilder: (ctx, i) {
                        final c = _conversations[i];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                              ctx,
                              MaterialPageRoute(
                                builder: (_) => MerchantChatScreen(
                                    storeName: c['name'] ?? 'مستخدم',
                                    storeLogo: c['logo'] ?? '',
                                    offerTitle: 'محادثة سابقة',
                                    receiverId: c['userId'] as int?),
                              )),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: cardC,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: borderC),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(isDark ? 0.1 : 0.03),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(children: [
                              CircleAvatar(
                                  radius: 26,
                                  backgroundColor:
                                      AppColors.goldenBronze.withOpacity(0.1),
                                  backgroundImage:
                                      NetworkImage(c['logo'] ?? '')),
                              const SizedBox(width: 14),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Row(children: [
                                      Text(c['name'] ?? 'مستخدم',
                                          style: TextStyle(
                                              color: textC,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700)),
                                      const Spacer(),
                                      Text(
                                          _formatTime(
                                              c['timestamp']?.toString()),
                                          style: TextStyle(
                                              color: textC.withOpacity(0.4),
                                              fontSize: 11)),
                                    ]),
                                    const SizedBox(height: 4),
                                    Text(c['lastMsg'] ?? '',
                                        style: TextStyle(
                                            color: textC.withOpacity(0.5),
                                            fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ])),
                            ]),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
