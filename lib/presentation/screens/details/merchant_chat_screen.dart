import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/network/api_service.dart';
import '../../../core/network/api_constants.dart';

// ============================================================================
// شاشة الدردشة مع التاجر — مربوطة بـ /support/messages/
// ============================================================================
class MerchantChatScreen extends StatefulWidget {
  final String storeName;
  final String storeLogo;
  final String offerTitle;
  final int? receiverId; // user ID لصاحب المتجر

  const MerchantChatScreen({
    super.key,
    required this.storeName,
    required this.storeLogo,
    required this.offerTitle,
    this.receiverId,
  });

  @override
  State<MerchantChatScreen> createState() => _MerchantChatScreenState();
}

class _MerchantChatScreenState extends State<MerchantChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ApiService _api = ApiService();

  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    // تحديث الرسائل كل 5 ثوان
    _pollTimer = Timer.periodic(
        const Duration(seconds: 5), (_) => _fetchMessages(silent: true));
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchMessages({bool silent = false}) async {
    if (widget.receiverId == null) {
      if (mounted && !silent) setState(() => _isLoading = false);
      return;
    }
    try {
      final data = await _api.get(
        ApiConstants.directMessages,
        queryParams: {'ordering': 'timestamp', 'page_size': '100'},
      );
      final List raw =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);

      // فلترة الرسائل للمحادثة مع هذا المستلم فقط
      final filtered = raw
          .cast<Map<String, dynamic>>()
          .where((m) =>
              m['sender'] == widget.receiverId ||
              m['receiver'] == widget.receiverId)
          .toList();

      if (mounted) {
        final hadMessages = _messages.length;
        setState(() {
          _messages = filtered;
          _isLoading = false;
        });
        // تمرير تلقائي عند وصول رسائل جديدة
        if (filtered.length > hadMessages) {
          _scrollToBottom();
        }
      }
    } catch (e) {
      debugPrint('خطأ جلب الرسائل: $e');
      if (mounted && !silent) setState(() => _isLoading = false);
    }
  }

  Future<void> _sendMessage() async {
    final text = _msgController.text.trim();
    if (text.isEmpty || widget.receiverId == null || _isSending) return;

    setState(() => _isSending = true);
    _msgController.clear();

    try {
      final data = await _api.post(
        ApiConstants.directMessages,
        body: {
          'receiver': widget.receiverId,
          'text': text,
        },
      );

      if (data is Map && mounted) {
        setState(() {
          _messages.add(data.cast<String, dynamic>());
          _isSending = false;
        });
        _scrollToBottom();
        // تحديث الرسائل من السيرفر بعد ثانية لضمان الاستمرارية
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) _fetchMessages(silent: true);
        });
      }
    } catch (e) {
      debugPrint('خطأ إرسال الرسالة: $e');
      if (mounted) {
        setState(() => _isSending = false);
        AppToast.error(context, 'فشل إرسال الرسالة');
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final dt = DateTime.parse(timestamp).toLocal();
      return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.deepNavy : AppColors.lightBackground;
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: bg,
          body: SafeArea(
            child: Column(children: [
              _buildHeader(isDark, textC),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.goldenBronze))
                    : _messages.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chat_bubble_outline_rounded,
                                    size: 50,
                                    color: AppColors.goldenBronze
                                        .withOpacity(0.3)),
                                const SizedBox(height: 12),
                                Text(
                                    widget.receiverId != null
                                        ? "ابدأ محادثتك مع التاجر"
                                        : "الدردشة غير متاحة حالياً",
                                    style: TextStyle(
                                        color: AppColors.grey, fontSize: 14)),
                                if (widget.receiverId == null) ...[
                                  const SizedBox(height: 6),
                                  Text("لا يمكن تحديد صاحب المتجر",
                                      style: TextStyle(
                                          color:
                                              AppColors.grey.withOpacity(0.6),
                                          fontSize: 12)),
                                ],
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                            itemCount: _messages.length,
                            itemBuilder: (_, i) =>
                                _buildBubble(_messages[i], isDark),
                          ),
              ),
              if (widget.receiverId != null) _buildInputBar(isDark, textC),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, Color textC) {
    final headerBg = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: headerBg,
        border: Border(
            bottom: BorderSide(
                color: isDark
                    ? AppColors.goldenBronze.withOpacity(0.15)
                    : Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDark ? AppColors.deepNavy : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                    color: isDark
                        ? AppColors.goldenBronze.withOpacity(0.3)
                        : Colors.grey.shade300),
              ),
              child:
                  Icon(Icons.arrow_forward_ios_rounded, color: textC, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.goldenBronze, width: 2),
            ),
            child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.softCream,
                backgroundImage: NetworkImage(widget.storeLogo)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(widget.storeName,
                style: TextStyle(
                    color: textC, fontSize: 15, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(Map<String, dynamic> msg, bool isDark) {
    // الرسالة مني إذا أنا المرسل (sender != receiverId)
    final bool isMe = msg["sender"] != widget.receiverId;
    final bubbleColor = isMe
        ? AppColors.goldenBronze
        : (isDark ? const Color(0xFF072A38) : AppColors.pureWhite);
    final txtColor = isMe
        ? Colors.white
        : (isDark ? AppColors.pureWhite : AppColors.lightText);
    final timeColor = isMe ? Colors.white.withOpacity(0.7) : AppColors.grey;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
          border: isMe
              ? null
              : Border.all(
                  color: isDark
                      ? AppColors.goldenBronze.withOpacity(0.2)
                      : Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.15 : 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // اسم المرسل للرسائل الواردة
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(msg['sender_name']?.toString() ?? widget.storeName,
                    style: TextStyle(
                        color: AppColors.goldenBronze,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
            Text(msg["text"]?.toString() ?? '',
                style: TextStyle(color: txtColor, fontSize: 14, height: 1.5)),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(_formatTime(msg["timestamp"]?.toString()),
                  style: TextStyle(color: timeColor, fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(bool isDark, Color textC) {
    final barBg = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: barBg,
        border: Border(
            top: BorderSide(
                color: isDark
                    ? AppColors.goldenBronze.withOpacity(0.15)
                    : Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.deepNavy : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    color: isDark
                        ? AppColors.goldenBronze.withOpacity(0.2)
                        : Colors.grey.shade300),
              ),
              child: TextField(
                controller: _msgController,
                style: TextStyle(color: textC, fontSize: 14),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: "اكتب رسالتك...",
                  hintStyle: TextStyle(color: AppColors.grey, fontSize: 13),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _isSending ? null : _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _isSending
                    ? AppColors.goldenBronze.withOpacity(0.5)
                    : AppColors.goldenBronze,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.goldenBronze.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ],
              ),
              child: _isSending
                  ? const Center(
                      child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2)))
                  : const Icon(Icons.send_rounded,
                      color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
