import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameCtrl;

  final _bioCtrl = TextEditingController(text: "عاشق للتسوق الذكي 🛒");
  String _selectedGender = "ذكر";

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _nameCtrl = TextEditingController(text: auth.userName);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
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
            icon: Icon(Icons.arrow_forward_ios_rounded, color: textC, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text("تعديل الملف الشخصي",
              style: TextStyle(
                  color: textC, fontSize: 18, fontWeight: FontWeight.w900)),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("حفظ",
                  style: TextStyle(
                      color: AppColors.goldenBronze,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Avatar
              Center(
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppColors.goldenBronze, width: 3),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.goldenBronze.withOpacity(0.3),
                              blurRadius: 15)
                        ],
                      ),
                      child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                              context.watch<AuthProvider>().userImage)),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.goldenBronze,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: isDark ? AppColors.deepNavy : Colors.white,
                              width: 3),
                        ),
                        child: const Icon(Icons.camera_alt_rounded,
                            color: AppColors.deepNavy, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _field("الاسم الكامل", _nameCtrl, Icons.person_outline_rounded,
                  cardC, borderC, textC, isDark),

              _field("النبذة", _bioCtrl, Icons.edit_note_rounded, cardC,
                  borderC, textC, isDark,
                  maxLines: 3),
              const SizedBox(height: 16),
              // Gender
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                    color: cardC,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderC)),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: AppColors.goldenBronze.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.wc_rounded,
                          color: AppColors.goldenBronze, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Text("الجنس",
                        style: TextStyle(
                            color: textC.withOpacity(0.6), fontSize: 13)),
                    const Spacer(),
                    DropdownButton<String>(
                      value: _selectedGender,
                      underline: const SizedBox(),
                      dropdownColor: cardC,
                      style: TextStyle(
                          color: textC,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      items: ["ذكر", "أنثى"]
                          .map(
                              (g) => DropdownMenuItem(value: g, child: Text(g)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedGender = v!),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, IconData icon,
      Color cardC, Color borderC, Color textC, bool isDark,
      {int maxLines = 1, bool isPhone = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
          color: cardC,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderC)),
      child: Row(
        crossAxisAlignment:
            maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: maxLines > 1 ? 14 : 0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: AppColors.goldenBronze.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: AppColors.goldenBronze, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: ctrl,
              maxLines: maxLines,
              keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
              style: TextStyle(
                  color: textC, fontSize: 14, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                labelText: label,
                labelStyle:
                    TextStyle(color: textC.withOpacity(0.4), fontSize: 13),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
