import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/api_service.dart';
import '../../../core/helpers/auth_guard.dart';
import '../../../data/providers/auth_provider.dart';

class AllCommentsScreen extends StatefulWidget {
  final String productId;
  final String offerTitle;
  final bool isGroup;

  const AllCommentsScreen({
    super.key,
    required this.productId,
    required this.offerTitle,
    this.isGroup = false,
  });

  @override
  State<AllCommentsScreen> createState() => _AllCommentsScreenState();
}

class _AllCommentsScreenState extends State<AllCommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  List<Map<String, dynamic>> _comments = [];
  bool _isLoading = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────
  // جلب التعليقات
  // ──────────────────────────────────────────────
  Future<void> _fetchComments() async {
    try {
      final api = ApiService();
      final endpoint = widget.isGroup
          ? ApiConstants.groupComments(widget.productId)
          : ApiConstants.productComments(widget.productId);
      final data = await api.get(endpoint);
      final List raw =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);
      if (mounted) {
        setState(() {
          _comments = raw.cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(
          '\u062e\u0637\u0623 \u062c\u0644\u0628 \u0627\u0644\u062a\u0639\u0644\u064a\u0642\u0627\u062a: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ──────────────────────────────────────────────
  // إرسال تعليق جديد
  // ──────────────────────────────────────────────
  Future<void> _submitComment() async {
    if (!AuthGuard.requireAuth(context)) return;
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSending = true);
    try {
      final api = ApiService();
      final endpoint = widget.isGroup
          ? ApiConstants.groupComments(widget.productId)
          : ApiConstants.productComments(widget.productId);
      final result = await api.post(endpoint, body: {'text': text});

      if (mounted) {
        setState(() => _isSending = false);
        if (result != null) {
          _commentController.clear();
          _fetchComments();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "\u062a\u0645 \u0625\u0636\u0627\u0641\u0629 \u062a\u0639\u0644\u064a\u0642\u0643 \u2705",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              backgroundColor: Color(0xFF4CAF50),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "\u0641\u0634\u0644 \u0625\u0631\u0633\u0627\u0644 \u0627\u0644\u062a\u0639\u0644\u064a\u0642",
                style: TextStyle(fontWeight: FontWeight.w600)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  // ──────────────────────────────────────────────
  // حذف تعليق
  // ──────────────────────────────────────────────
  Future<void> _deleteComment(int commentId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text("حذف التعليق"),
          content: const Text("هل أنت متأكد من حذف هذا التعليق؟"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("إلغاء"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child:
                  const Text("حذف", style: TextStyle(color: AppColors.error)),
            ),
          ],
        ),
      ),
    );

    if (confirm != true) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.deleteComment(commentId);
    if (mounted) {
      if (success) {
        _fetchComments();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("تم حذف التعليق",
                style: TextStyle(fontWeight: FontWeight.w600)),
            backgroundColor: AppColors.goldenBronze,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("فشل حذف التعليق",
                style: TextStyle(fontWeight: FontWeight.w600)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  // ──────────────────────────────────────────────
  // تنسيق الوقت
  // ──────────────────────────────────────────────
  String _formatTimeAgo(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 1) return 'الآن';
      if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
      if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
      if (diff.inDays < 30) return 'منذ ${diff.inDays} يوم';
      return 'منذ ${(diff.inDays / 30).floor()} شهر';
    } catch (_) {
      return dateStr;
    }
  }

  // ──────────────────────────────────────────────
  // البناء
  // ──────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.deepNavy : AppColors.lightBackground;
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;

    // الحصول على user_id الحالي
    final auth = context.watch<AuthProvider>();
    final currentUserId =
        (auth.userProfile?['id'] ?? auth.userProfile?['user_id'] ?? '')
            .toString();

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: bg,
            body: SafeArea(
                child: Column(children: [
              _buildHeader(isDark, textC),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.goldenBronze, strokeWidth: 2))
                    : _comments.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chat_bubble_outline_rounded,
                                    color: textC.withOpacity(0.15), size: 56),
                                const SizedBox(height: 16),
                                Text("لا توجد تعليقات بعد",
                                    style: TextStyle(
                                        color: textC.withOpacity(0.5),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 8),
                                Text("كن أول من يعلّق!",
                                    style: TextStyle(
                                        color: textC.withOpacity(0.3),
                                        fontSize: 13)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 5, 16, 10),
                            itemCount: _comments.length,
                            itemBuilder: (_, i) => _buildComment(
                                _comments[i], isDark, textC, currentUserId),
                          ),
              ),
              _buildInputBar(isDark, textC),
            ]))));
  }

  Widget _buildHeader(bool isDark, Color textC) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
        child: Row(children: [
          GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF072A38)
                          : AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: isDark
                              ? AppColors.goldenBronze.withOpacity(0.3)
                              : Colors.grey.shade300)),
                  child: Icon(Icons.arrow_forward_ios_rounded,
                      color: textC, size: 18))),
          const SizedBox(width: 12),
          Expanded(
              child: Text("التعليقات 💬",
                  style: TextStyle(
                      color: textC,
                      fontSize: 22,
                      fontWeight: FontWeight.w900))),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: AppColors.goldenBronze.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.goldenBronze.withOpacity(0.3))),
              child: Text("${_comments.length}",
                  style: const TextStyle(
                      color: AppColors.goldenBronze,
                      fontSize: 12,
                      fontWeight: FontWeight.bold))),
          const SizedBox(width: 8),
          GestureDetector(
              onTap: toggleGlobalTheme,
              child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                      borderRadius: BorderRadius.circular(14)),
                  child: Icon(
                      isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                      color: AppColors.goldenBronze,
                      size: 20))),
        ]));
  }

  Widget _buildComment(
      Map<String, dynamic> c, bool isDark, Color textC, String currentUserId) {
    final commentId = c['id'] ?? c['comment_id'] ?? 0;
    final userName = (c['user_name'] ?? c['username'] ?? 'مستخدم').toString();
    final text = (c['text'] ?? '').toString();
    final createdAt = (c['created_at'] ?? '').toString();
    final commentUserId = (c['user'] ?? c['user_id'] ?? '').toString();
    final avatar = (c['user_avatar'] ?? c['avatar'] ?? '').toString();
    final avatarUrl = avatar.isNotEmpty
        ? ApiConstants.resolveImageUrl(avatar)
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(userName)}&background=B8860B&color=fff';
    final timeAgo = _formatTimeAgo(createdAt);
    final isOwnComment =
        commentUserId == currentUserId && currentUserId.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: isDark
              ? AppColors.deepNavy.withOpacity(0.5)
              : AppColors.lightBackground.withOpacity(0.7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isDark
                  ? AppColors.goldenBronze.withOpacity(0.1)
                  : Colors.grey.shade100)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // هيدر التعليق
        Row(children: [
          Container(
            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.goldenBronze.withOpacity(0.5), width: 1.5),
            ),
            child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.lightBackground,
                backgroundImage: NetworkImage(avatarUrl)),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(userName,
                    style: const TextStyle(
                        color: AppColors.goldenBronze,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Row(children: [
                  Icon(Icons.access_time_rounded,
                      color: AppColors.grey.withOpacity(0.6), size: 12),
                  const SizedBox(width: 4),
                  Text(timeAgo,
                      style: TextStyle(
                          color: AppColors.grey.withOpacity(0.7),
                          fontSize: 11)),
                ]),
              ])),
          // زر الحذف — يظهر فقط لصاحب التعليق
          if (isOwnComment)
            GestureDetector(
              onTap: () {
                final id = commentId is int
                    ? commentId
                    : int.tryParse(commentId.toString()) ?? 0;
                if (id > 0) _deleteComment(id);
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.delete_outline_rounded,
                    color: AppColors.error, size: 16),
              ),
            ),
        ]),
        const SizedBox(height: 10),
        // نص التعليق
        Text(text,
            style: TextStyle(
                color: textC.withOpacity(0.85), fontSize: 14, height: 1.5)),
      ]),
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
                      : Colors.grey.shade200))),
      child: Row(children: [
        Expanded(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.deepNavy : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                        color: isDark
                            ? AppColors.goldenBronze.withOpacity(0.2)
                            : Colors.grey.shade300)),
                child: TextField(
                    controller: _commentController,
                    style: TextStyle(color: textC, fontSize: 14),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _submitComment(),
                    decoration: InputDecoration(
                        hintText: "اكتب تعليقك...",
                        hintStyle:
                            TextStyle(color: AppColors.grey, fontSize: 13),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10))))),
        const SizedBox(width: 8),
        GestureDetector(
            onTap: _isSending ? null : _submitComment,
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
                    ]),
                child: _isSending
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.send_rounded,
                        color: Colors.white, size: 20))),
      ]),
    );
  }
}
