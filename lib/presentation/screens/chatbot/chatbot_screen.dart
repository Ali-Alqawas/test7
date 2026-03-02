import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';

// نموذج رسالة
class ChatMessage {
  final String text;
  final bool isUser;
  final String? imagePath; // مسار صورة (اختياري)
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.imagePath,
    DateTime? time,
  }) : time = time ?? DateTime.now();
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  bool _isTyping = false; // محاكاة كتابة البوت

  // رسائل تجريبية
  final List<ChatMessage> _messages = [];

  // أمثلة توضيحية
  final List<Map<String, dynamic>> _examplePrompts = [
    {
      'icon': Icons.local_offer_rounded,
      'title': 'أفضل العروض',
      'prompt': 'ما هي أفضل العروض المتاحة اليوم؟',
    },
    {
      'icon': Icons.search_rounded,
      'title': 'ابحث عن منتج',
      'prompt': 'أبحث عن ساعة رجالية فاخرة بسعر مناسب',
    },
    {
      'icon': Icons.compare_arrows_rounded,
      'title': 'قارن منتجات',
      'prompt': 'قارن بين أحدث هواتف آيفون وسامسونج',
    },
    {
      'icon': Icons.recommend_rounded,
      'title': 'توصيات مخصصة',
      'prompt': 'اقترح لي هدية مناسبة بمناسبة عيد ميلاد',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _msgController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text.trim(), isUser: true));
      _msgController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // محاكاة رد البوت
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: _getBotResponse(text),
          isUser: false,
        ));
      });
      _scrollToBottom();
    });
  }

  String _getBotResponse(String userMsg) {
    if (userMsg.contains('عرض') || userMsg.contains('عروض')) {
      return "🎉 لدينا عروض رائعة اليوم!\n\n• خصم 30% على الإلكترونيات\n• خصم 50% على الأزياء\n• شحن مجاني للطلبات فوق 200 ريال\n\nهل تريد تفاصيل أكثر عن فئة معينة؟";
    } else if (userMsg.contains('ساعة') || userMsg.contains('ساعات')) {
      return "⌚ إليك أفضل الساعات المتاحة:\n\n1. Rolex Submariner - 45,000 ر.س\n2. Omega Seamaster - 22,000 ر.س\n3. TAG Heuer Monaco - 15,000 ر.س\n\nيمكنني مساعدتك في المقارنة بينها!";
    } else if (userMsg.contains('هدية') || userMsg.contains('هدايا')) {
      return "🎁 إليك بعض أفكار الهدايا:\n\n• عطر فاخر من ديور\n• محفظة جلدية من مونت بلانك\n• سماعة AirPods Pro\n• طقم عناية شخصية\n\nما الميزانية التي تفضلها؟";
    } else if (userMsg.contains('قارن') || userMsg.contains('مقارنة')) {
      return "📊 بكل سرور! أرسل لي اسم المنتجين اللذين تريد المقارنة بينهما وسأقدم لك مقارنة تفصيلية تشمل السعر والمواصفات وتقييمات المستخدمين.";
    }
    return "مرحباً! 👋\n\nأنا مساعدك الذكي في SIDE. يمكنني مساعدتك في:\n\n• البحث عن المنتجات والعروض\n• مقارنة الأسعار\n• تقديم توصيات مخصصة\n• الإجابة عن استفساراتك\n\nكيف يمكنني مساعدتك اليوم؟";
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _pickImage() {
    // محاكاة إرسال صورة
    setState(() {
      _messages.add(ChatMessage(
        text: "📷 تم إرسال صورة",
        isUser: true,
        imagePath: "image_placeholder",
      ));
      _isTyping = true;
    });
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text:
              "📸 استلمت الصورة! هل تريدني أن أبحث عن منتجات مشابهة لما في الصورة؟",
          isUser: false,
        ));
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.deepNavy : AppColors.lightBackground,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              // --- الهيدر ---
              _buildAppBar(isDark),

              // --- محتوى الدردشة ---
              Expanded(
                child: _messages.isEmpty
                    ? _buildWelcomeView(isDark)
                    : _buildChatList(isDark),
              ),

              // --- مؤشر الكتابة ---
              if (_isTyping) _buildTypingIndicator(isDark),

              // --- حقل الإدخال ---
              _buildInputBar(isDark),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  //  الهيدر
  // ═══════════════════════════════════════
  Widget _buildAppBar(bool isDark) {
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepNavy : AppColors.lightBackground,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF072A38) : AppColors.pureWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? AppColors.goldenBronze.withOpacity(0.3)
                      : Colors.grey.shade300,
                ),
              ),
              child:
                  Icon(Icons.arrow_forward_ios_rounded, size: 18, color: textC),
            ),
          ),
          const SizedBox(width: 12),
          Text("SIDE AI \u2728",
              style: TextStyle(
                  color: textC, fontSize: 22, fontWeight: FontWeight.w900)),
          const Spacer(),
          GestureDetector(
            onTap: () => toggleGlobalTheme(),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? Colors.black : AppColors.deepNavy)
                        .withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                size: 20,
                color: AppColors.goldenBronze,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  //  شاشة الترحيب (بدون رسائل)
  // ═══════════════════════════════════════
  Widget _buildWelcomeView(bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Column(
        children: [
          // أيقونة الذكاء الاصطناعي
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.goldenBronze.withOpacity(0.15),
                  AppColors.goldenBronze.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.goldenBronze.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 36,
              color: AppColors.goldenBronze,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            "مرحباً بك في SIDE AI",
            style: TextStyle(
              color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "أنا هنا لمساعدتك في إيجاد أفضل العروض\nوالمنتجات المناسبة لك",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey.shade600,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 35),

          // أمثلة توضيحية
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "جرّب أن تسأل:",
              style: TextStyle(
                color: isDark ? AppColors.warmBeige : AppColors.deepNavy,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 14),

          ...List.generate(_examplePrompts.length, (index) {
            final example = _examplePrompts[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => _sendMessage(example['prompt']),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        isDark ? Colors.white.withOpacity(0.04) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.goldenBronze.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          example['icon'],
                          size: 20,
                          color: AppColors.goldenBronze,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              example['title'],
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.pureWhite
                                    : AppColors.deepNavy,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              example['prompt'],
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white38
                                    : Colors.grey.shade500,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: isDark ? Colors.white24 : Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  //  قائمة الرسائل
  // ═══════════════════════════════════════
  Widget _buildChatList(bool isDark) {
    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        return _buildMessageBubble(msg, isDark);
      },
    );
  }

  // ═══════════════════════════════════════
  //  فقاعة الرسالة
  // ═══════════════════════════════════════
  Widget _buildMessageBubble(ChatMessage msg, bool isDark) {
    final isUser = msg.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // أيقونة البوت
          if (!isUser) ...[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.goldenBronze,
                    AppColors.goldenBronze.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],

          // فقاعة الرسالة
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.goldenBronze
                    : (isDark ? Colors.white.withOpacity(0.06) : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                border: isUser
                    ? null
                    : Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.08)
                            : Colors.grey.shade200,
                      ),
                boxShadow: [
                  BoxShadow(
                    color: isUser
                        ? AppColors.goldenBronze.withOpacity(0.2)
                        : (isDark
                            ? Colors.black.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.08)),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // صورة (إن وُجدت)
                  if (msg.imagePath != null) ...[
                    Container(
                      width: 180,
                      height: 140,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.image_rounded,
                        size: 50,
                        color: isDark ? Colors.white24 : Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    msg.text,
                    style: TextStyle(
                      color: isUser
                          ? Colors.white
                          : (isDark ? AppColors.pureWhite : AppColors.deepNavy),
                      fontSize: 14.5,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${msg.time.hour.toString().padLeft(2, '0')}:${msg.time.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      color: isUser
                          ? Colors.white60
                          : (isDark ? Colors.white24 : Colors.grey.shade400),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  //  مؤشر الكتابة
  // ═══════════════════════════════════════
  Widget _buildTypingIndicator(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.goldenBronze,
                  AppColors.goldenBronze.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.grey.shade200,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 400 + (i * 200)),
                  builder: (context, value, child) {
                    return Container(
                      margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.goldenBronze
                            .withOpacity(0.3 + (value * 0.4)),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  //  حقل الإدخال
  // ═══════════════════════════════════════
  Widget _buildInputBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepNavy : AppColors.lightBackground,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // زر الصورة
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.shade300,
                ),
              ),
              child: Icon(
                Icons.image_rounded,
                size: 22,
                color: isDark ? Colors.white54 : Colors.grey.shade500,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // حقل النص
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.shade300,
                ),
              ),
              child: TextField(
                controller: _msgController,
                focusNode: _focusNode,
                style: TextStyle(
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  fontSize: 14.5,
                ),
                decoration: InputDecoration(
                  hintText: "اكتب رسالتك...",
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white30 : Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: _sendMessage,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // زر الإرسال
          GestureDetector(
            onTap: () => _sendMessage(_msgController.text),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.goldenBronze, Color(0xFFC9A574)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.goldenBronze.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
