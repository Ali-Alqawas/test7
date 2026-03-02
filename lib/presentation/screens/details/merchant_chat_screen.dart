import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class MerchantChatScreen extends StatefulWidget {
  final String storeName;
  final String storeLogo;
  final String offerTitle;

  const MerchantChatScreen({
    super.key,
    required this.storeName,
    required this.storeLogo,
    required this.offerTitle,
  });

  @override
  State<MerchantChatScreen> createState() => _MerchantChatScreenState();
}

class _MerchantChatScreenState extends State<MerchantChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [];

  // رسائل ترحيبية تلقائية من التاجر
  static const List<String> _autoReplies = [
    "أهلاً بك! كيف يمكنني مساعدتك؟ 😊",
    "شكراً لتواصلك معنا، سنرد عليك في أقرب وقت",
    "مرحباً! نسعد بخدمتك",
  ];

  @override
  void initState() {
    super.initState();
    // رسالة ترحيب تلقائية
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _messages.add({
            "text":
                "أهلاً بك في ${widget.storeName}! 👋\nكيف أقدر أساعدك بخصوص \"${widget.offerTitle}\"؟",
            "isMe": false,
            "time": _formatTime(),
          });
        });
      }
    });
  }

  String _formatTime() {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"text": text, "isMe": true, "time": _formatTime()});
    });
    _msgController.clear();
    _scrollToBottom();

    // رد تلقائي وهمي بعد لحظة
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.add({
            "text": _autoReplies[_messages.length % _autoReplies.length],
            "isMe": false,
            "time": _formatTime(),
          });
        });
        _scrollToBottom();
      }
    });
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

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.deepNavy : AppColors.lightBackground;
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: Column(
            children: [
              // الهيدر
              _buildHeader(isDark, textC),
              // الرسائل
              Expanded(
                child: _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline_rounded,
                                size: 50,
                                color: AppColors.goldenBronze.withOpacity(0.3)),
                            const SizedBox(height: 12),
                            Text("ابدأ محادثتك مع التاجر",
                                style: TextStyle(
                                    color: AppColors.grey, fontSize: 14)),
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
              // حقل الإرسال
              _buildInputBar(isDark, textC),
            ],
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.storeName,
                    style: TextStyle(
                        color: textC,
                        fontSize: 15,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Row(children: [
                  Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                          color: Color(0xFF4CAF50), shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  Text("متصل الآن",
                      style: TextStyle(color: AppColors.grey, fontSize: 11)),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(Map<String, dynamic> msg, bool isDark) {
    final bool isMe = msg["isMe"];
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
            Text(msg["text"],
                style: TextStyle(color: txtColor, fontSize: 14, height: 1.5)),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(msg["time"],
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
            onTap: _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.goldenBronze,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.goldenBronze.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ],
              ),
              child:
                  const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
