import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../details/merchant_chat_screen.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.deepNavy : AppColors.lightBackground;
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    final cardC = isDark ? const Color(0xFF072A38) : Colors.white;
    final borderC = isDark
        ? AppColors.goldenBronze.withOpacity(0.15)
        : Colors.grey.shade200;

    final conversations = [
      {
        "store": "اكسترا",
        "logo": "https://i.pravatar.cc/150?img=11",
        "lastMsg": "تم، الطلب جاهز للاستلام ✅",
        "time": "منذ 5 دقائق",
        "unread": 2
      },
      {
        "store": "ساكو",
        "logo": "https://i.pravatar.cc/150?img=12",
        "lastMsg": "نعتذر، المنتج غير متوفر حالياً",
        "time": "منذ ساعة",
        "unread": 0
      },
      {
        "store": "سنتربوينت",
        "logo": "https://i.pravatar.cc/150?img=13",
        "lastMsg": "يسعدنا خدمتك دائماً 😊",
        "time": "أمس",
        "unread": 0
      },
      {
        "store": "العربية للعود",
        "logo": "https://i.pravatar.cc/150?img=14",
        "lastMsg": "العرض ساري حتى نهاية الشهر",
        "time": "منذ 3 أيام",
        "unread": 1
      },
    ];

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
        body: conversations.isEmpty
            ? Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.inbox_rounded,
                    color: textC.withOpacity(0.2), size: 80),
                const SizedBox(height: 16),
                Text("لا توجد محادثات",
                    style:
                        TextStyle(color: textC.withOpacity(0.4), fontSize: 16)),
              ]))
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: conversations.length,
                itemBuilder: (ctx, i) {
                  final c = conversations[i];
                  final hasUnread = (c["unread"] as int) > 0;
                  return GestureDetector(
                    onTap: () => Navigator.push(
                        ctx,
                        MaterialPageRoute(
                          builder: (_) => MerchantChatScreen(
                              storeName: c["store"] as String,
                              storeLogo: c["logo"] as String,
                              offerTitle: "محادثة سابقة"),
                        )),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: hasUnread
                            ? AppColors.goldenBronze
                                .withOpacity(isDark ? 0.08 : 0.05)
                            : cardC,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: hasUnread
                                ? AppColors.goldenBronze.withOpacity(0.3)
                                : borderC),
                      ),
                      child: Row(children: [
                        Stack(children: [
                          CircleAvatar(
                              radius: 26,
                              backgroundImage:
                                  NetworkImage(c["logo"] as String)),
                          if (hasUnread)
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: AppColors.goldenBronze,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: isDark
                                            ? AppColors.deepNavy
                                            : Colors.white,
                                        width: 2)),
                                child: Center(
                                    child: Text("${c["unread"]}",
                                        style: const TextStyle(
                                            color: AppColors.deepNavy,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold))),
                              ),
                            ),
                        ]),
                        const SizedBox(width: 14),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Row(children: [
                                Text(c["store"] as String,
                                    style: TextStyle(
                                        color: textC,
                                        fontSize: 14,
                                        fontWeight: hasUnread
                                            ? FontWeight.w900
                                            : FontWeight.w700)),
                                const Spacer(),
                                Text(c["time"] as String,
                                    style: TextStyle(
                                        color: hasUnread
                                            ? AppColors.goldenBronze
                                            : textC.withOpacity(0.4),
                                        fontSize: 11)),
                              ]),
                              const SizedBox(height: 4),
                              Text(c["lastMsg"] as String,
                                  style: TextStyle(
                                      color: textC
                                          .withOpacity(hasUnread ? 0.8 : 0.5),
                                      fontSize: 12,
                                      fontWeight: hasUnread
                                          ? FontWeight.w600
                                          : FontWeight.normal),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ])),
                      ]),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
