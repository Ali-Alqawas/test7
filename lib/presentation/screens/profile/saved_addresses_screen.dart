import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});
  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  final List<Map<String, dynamic>> _addresses = [
    {
      "title": "المنزل",
      "address": "صنعاء، حدة، شارع الستين",
      "icon": Icons.home_rounded,
      "isDefault": true
    },
    {
      "title": "العمل",
      "address": "صنعاء، شارع تعز، بجانب بنك اليمن",
      "icon": Icons.work_rounded,
      "isDefault": false
    },
  ];

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
          title: Text("العناوين المحفوظة",
              style: TextStyle(
                  color: textC, fontSize: 18, fontWeight: FontWeight.w900)),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.goldenBronze,
          icon: const Icon(Icons.add_location_alt_rounded,
              color: AppColors.deepNavy),
          label: const Text("إضافة عنوان",
              style: TextStyle(
                  color: AppColors.deepNavy, fontWeight: FontWeight.bold)),
          onPressed: () {},
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: _addresses.length,
          itemBuilder: (_, i) {
            final a = _addresses[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardC,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: a["isDefault"]
                        ? AppColors.goldenBronze.withOpacity(0.4)
                        : borderC,
                    width: a["isDefault"] ? 1.5 : 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                        color: AppColors.goldenBronze.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14)),
                    child: Icon(a["icon"],
                        color: AppColors.goldenBronze, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(a["title"],
                                style: TextStyle(
                                    color: textC,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800)),
                            if (a["isDefault"]) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                    color: AppColors.goldenBronze
                                        .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6)),
                                child: const Text("افتراضي",
                                    style: TextStyle(
                                        color: AppColors.goldenBronze,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ]),
                          const SizedBox(height: 4),
                          Text(a["address"],
                              style: TextStyle(
                                  color: textC.withOpacity(0.5), fontSize: 12)),
                        ]),
                  ),
                  PopupMenuButton(
                    icon: Icon(Icons.more_vert_rounded,
                        color: textC.withOpacity(0.4)),
                    color: cardC,
                    itemBuilder: (_) => [
                      PopupMenuItem(
                          child: Text("تعديل",
                              style: TextStyle(color: textC, fontSize: 13))),
                      PopupMenuItem(
                          child: Text("حذف",
                              style: TextStyle(
                                  color: AppColors.error, fontSize: 13))),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
