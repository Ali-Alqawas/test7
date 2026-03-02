import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';

class AllCommentsScreen extends StatefulWidget {
  final String offerTitle;
  const AllCommentsScreen({super.key, required this.offerTitle});
  @override
  State<AllCommentsScreen> createState() => _AllCommentsScreenState();
}

class _AllCommentsScreenState extends State<AllCommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  String _selectedFilter = "الأحدث";
  // مفتاح الرد: إن كان != null نحن في وضع الرد على تعليق
  int? _replyingTo;

  final List<Map<String, dynamic>> _comments = [
    {
      "user": "أحمد محمد",
      "avatar": "https://i.pravatar.cc/150?img=1",
      "text": "عرض ممتاز جداً! استفدت منه كثير 👏",
      "time": "منذ ساعتين",
      "likes": 24,
      "liked": false,
      "mood": "😍",
      "replies": [
        {
          "user": "سارة علي",
          "avatar": "https://i.pravatar.cc/150?img=5",
          "text": "أنا بعد! أنصح الكل يستفيد منه",
          "time": "منذ ساعة",
          "likes": 8,
          "liked": false
        },
        {
          "user": "خالد حسن",
          "avatar": "https://i.pravatar.cc/150?img=8",
          "text": "موافق 100%",
          "time": "منذ 45 دقيقة",
          "likes": 3,
          "liked": false
        },
      ],
    },
    {
      "user": "فاطمة يوسف",
      "avatar": "https://i.pravatar.cc/150?img=9",
      "text": "السعر مناسب مقارنة بالمحلات الثانية",
      "time": "منذ 5 ساعات",
      "likes": 15,
      "liked": false,
      "mood": "😊",
      "replies": [
        {
          "user": "نورة",
          "avatar": "https://i.pravatar.cc/150?img=10",
          "text": "وين المحل بالضبط؟",
          "time": "منذ 4 ساعات",
          "likes": 2,
          "liked": false
        },
      ],
    },
    {
      "user": "عمر العبدلي",
      "avatar": "https://i.pravatar.cc/150?img=3",
      "text": "جربته وكان عادي صراحة، متوقع أكثر",
      "time": "منذ يوم",
      "likes": 7,
      "liked": false,
      "mood": "😐",
      "replies": [],
    },
    {
      "user": "ريم الشهري",
      "avatar": "https://i.pravatar.cc/150?img=20",
      "text": "أفضل عرض شفته هالشهر 🔥🔥",
      "time": "منذ يومين",
      "likes": 31,
      "liked": false,
      "mood": "😍",
      "replies": [
        {
          "user": "ليلى",
          "avatar": "https://i.pravatar.cc/150?img=21",
          "text": "وش اللون اللي اخذتيه؟",
          "time": "منذ يومين",
          "likes": 1,
          "liked": false
        },
        {
          "user": "ريم الشهري",
          "avatar": "https://i.pravatar.cc/150?img=20",
          "text": "الأسود، ينفع لكل شيء",
          "time": "منذ يومين",
          "likes": 5,
          "liked": false
        },
        {
          "user": "هند",
          "avatar": "https://i.pravatar.cc/150?img=22",
          "text": "ابي اطلبه بعد!",
          "time": "منذ يوم",
          "likes": 0,
          "liked": false
        },
      ],
    },
    {
      "user": "ماجد السعدي",
      "avatar": "https://i.pravatar.cc/150?img=6",
      "text": "التوصيل كان بطيء بس المنتج حلو",
      "time": "منذ 3 أيام",
      "likes": 9,
      "liked": false,
      "mood": "😊",
      "replies": [],
    },
    {
      "user": "نوف الحربي",
      "avatar": "https://i.pravatar.cc/150?img=25",
      "text": "ما يستاهل الضجة اللي حوله 😕",
      "time": "منذ 4 أيام",
      "likes": 4,
      "liked": false,
      "mood": "😤",
      "replies": [
        {
          "user": "محمد",
          "avatar": "https://i.pravatar.cc/150?img=7",
          "text": "ليش؟ وش المشكلة اللي واجهتك؟",
          "time": "منذ 4 أيام",
          "likes": 2,
          "liked": false
        },
      ],
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
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
                child: Column(children: [
              _buildHeader(isDark, textC),
              _buildFilterBar(isDark, textC),
              Expanded(
                  child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 10),
                itemCount: _comments.length,
                itemBuilder: (_, i) => _buildComment(i, isDark, textC),
              )),
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

  Widget _buildFilterBar(bool isDark, Color textC) {
    final filters = ["الأحدث", "الأكثر تفاعلاً", "الإيجابية", "السلبية"];
    return SizedBox(
        height: 42,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filters.length,
          itemBuilder: (_, i) {
            final f = filters[i];
            final sel = f == _selectedFilter;
            return GestureDetector(
                onTap: () => setState(() => _selectedFilter = f),
                child: Container(
                    margin: const EdgeInsets.only(left: 8, bottom: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                        color: sel
                            ? AppColors.goldenBronze
                            : (isDark
                                ? const Color(0xFF072A38)
                                : AppColors.pureWhite),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: sel
                                ? AppColors.goldenBronze
                                : AppColors.goldenBronze.withOpacity(0.3))),
                    child: Text(f,
                        style: TextStyle(
                            color: sel ? Colors.white : textC,
                            fontSize: 12,
                            fontWeight: FontWeight.w700))));
          },
        ));
  }

  Widget _buildComment(int index, bool isDark, Color textC) {
    final c = _comments[index];
    final cardBg = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
    final List replies = c["replies"] ?? [];
    final bool expanded = c["showReplies"] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isDark
                  ? AppColors.goldenBronze.withOpacity(0.15)
                  : Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.15 : 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // هيدر التعليق
        Row(children: [
          CircleAvatar(radius: 18, backgroundImage: NetworkImage(c["avatar"])),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(children: [
                  Text(c["user"],
                      style: TextStyle(
                          color: textC,
                          fontSize: 13,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(width: 6),
                  Text(c["mood"] ?? "", style: const TextStyle(fontSize: 14)),
                ]),
                Text(c["time"],
                    style: TextStyle(color: AppColors.grey, fontSize: 11)),
              ])),
        ]),
        const SizedBox(height: 10),
        // نص التعليق
        Text(c["text"],
            style: TextStyle(color: textC, fontSize: 14, height: 1.5)),
        const SizedBox(height: 10),
        // أزرار التفاعل
        Row(children: [
          GestureDetector(
            onTap: () => setState(() {
              c["liked"] = !(c["liked"] ?? false);
              c["likes"] += c["liked"] ? 1 : -1;
            }),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(
                  c["liked"]
                      ? Icons.thumb_up_alt_rounded
                      : Icons.thumb_up_alt_outlined,
                  color: c["liked"] ? AppColors.goldenBronze : AppColors.grey,
                  size: 16),
              const SizedBox(width: 4),
              Text("${c["likes"]}",
                  style: TextStyle(color: AppColors.grey, fontSize: 12)),
            ]),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () => setState(() {
              _replyingTo = index;
            }),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.reply_rounded, color: AppColors.grey, size: 16),
              const SizedBox(width: 4),
              Text("رد", style: TextStyle(color: AppColors.grey, fontSize: 12)),
            ]),
          ),
        ]),
        // الردود
        if (replies.isNotEmpty) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => c["showReplies"] = !expanded),
            child: Text(
                expanded ? "إخفاء الردود ▲" : "عرض ${replies.length} رد ▼",
                style: const TextStyle(
                    color: AppColors.goldenBronze,
                    fontSize: 12,
                    fontWeight: FontWeight.w700)),
          ),
          if (expanded) ...[
            const SizedBox(height: 8),
            ...replies.map<Widget>((r) => _buildReply(r, isDark, textC)),
          ],
        ],
      ]),
    );
  }

  Widget _buildReply(Map<String, dynamic> r, bool isDark, Color textC) {
    return Container(
      margin: const EdgeInsets.only(top: 8, right: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: isDark ? AppColors.deepNavy : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isDark
                  ? AppColors.goldenBronze.withOpacity(0.1)
                  : Colors.grey.shade100)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(radius: 12, backgroundImage: NetworkImage(r["avatar"])),
          const SizedBox(width: 8),
          Text(r["user"],
              style: TextStyle(
                  color: textC, fontSize: 12, fontWeight: FontWeight.w700)),
          const Spacer(),
          Text(r["time"],
              style: TextStyle(color: AppColors.grey, fontSize: 10)),
        ]),
        const SizedBox(height: 6),
        Text(r["text"],
            style: TextStyle(color: textC, fontSize: 13, height: 1.4)),
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
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        if (_replyingTo != null)
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: AppColors.goldenBronze.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              const Icon(Icons.reply_rounded,
                  color: AppColors.goldenBronze, size: 14),
              const SizedBox(width: 6),
              Expanded(
                  child: Text("الرد على ${_comments[_replyingTo!]["user"]}",
                      style: const TextStyle(
                          color: AppColors.goldenBronze,
                          fontSize: 12,
                          fontWeight: FontWeight.w600))),
              GestureDetector(
                  onTap: () => setState(() => _replyingTo = null),
                  child: const Icon(Icons.close_rounded,
                      color: AppColors.grey, size: 16)),
            ]),
          ),
        Row(children: [
          Expanded(
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.deepNavy
                          : AppColors.lightBackground,
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
                          hintText: _replyingTo != null
                              ? "اكتب ردك..."
                              : "اكتب تعليقك...",
                          hintStyle:
                              TextStyle(color: AppColors.grey, fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10))))),
          const SizedBox(width: 8),
          GestureDetector(
              onTap: _submitComment,
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
                      ]),
                  child: const Icon(Icons.send_rounded,
                      color: Colors.white, size: 20))),
        ]),
      ]),
    );
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      if (_replyingTo != null) {
        (_comments[_replyingTo!]["replies"] as List).add({
          "user": "أنت",
          "avatar": "https://i.pravatar.cc/150?img=11",
          "text": text,
          "time": "الآن",
          "likes": 0,
          "liked": false,
        });
        _comments[_replyingTo!]["showReplies"] = true;
        _replyingTo = null;
      } else {
        _comments.insert(0, {
          "user": "أنت",
          "avatar": "https://i.pravatar.cc/150?img=11",
          "text": text,
          "time": "الآن",
          "likes": 0,
          "liked": false,
          "mood": "😊",
          "replies": [],
        });
      }
    });
    _commentController.clear();
  }
}
