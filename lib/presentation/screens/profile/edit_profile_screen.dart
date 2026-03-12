import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _usernameCtrl;
  late TextEditingController _nameCtrl;
  String? _selectedImagePath;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _usernameCtrl =
        TextEditingController(text: auth.userProfile?['username'] ?? '');
    _nameCtrl = TextEditingController(
        text: auth.userProfile?['full_name'] ?? auth.userName);
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _selectedImagePath = picked.path);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final auth = context.read<AuthProvider>();

    final success = await auth.updateProfile(
      username: _usernameCtrl.text.trim().isNotEmpty
          ? _usernameCtrl.text.trim()
          : null,
      fullName: _nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : null,
      profileImagePath: _selectedImagePath,
    );

    if (!mounted) return;
    setState(() => _saving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("تم حفظ التعديلات بنجاح ✓"),
        backgroundColor: AppColors.goldenBronze,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      Navigator.pop(context);
    } else {
      final error = auth.errorMessage ?? 'حدث خطأ أثناء الحفظ';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
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
    final auth = context.watch<AuthProvider>();

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
            _saving
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.goldenBronze)),
                  )
                : TextButton(
                    onPressed: _save,
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
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.goldenBronze, width: 3),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.goldenBronze.withOpacity(0.3),
                                blurRadius: 15)
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _selectedImagePath != null
                              ? FileImage(File(_selectedImagePath!))
                                  as ImageProvider
                              : NetworkImage(auth.userImage),
                        ),
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
                                color:
                                    isDark ? AppColors.deepNavy : Colors.white,
                                width: 3),
                          ),
                          child: const Icon(Icons.camera_alt_rounded,
                              color: AppColors.deepNavy, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _field("اسم المستخدم", _usernameCtrl,
                  Icons.alternate_email_rounded, cardC, borderC, textC, isDark),
              _field("الاسم الكامل", _nameCtrl, Icons.person_outline_rounded,
                  cardC, borderC, textC, isDark),
              const SizedBox(height: 16),

              // Email (read-only)
              if (auth.userEmail.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                      color: cardC,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderC)),
                  child: Row(children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: AppColors.goldenBronze.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.email_outlined,
                          color: AppColors.goldenBronze, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("البريد الإلكتروني",
                                style: TextStyle(
                                    color: textC.withOpacity(0.4),
                                    fontSize: 11)),
                            const SizedBox(height: 4),
                            Text(auth.userEmail,
                                style: TextStyle(
                                    color: textC,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                          ]),
                    ),
                    Icon(Icons.lock_outline_rounded,
                        color: textC.withOpacity(0.3), size: 18),
                  ]),
                ),

              // Account Type (read-only)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                    color: cardC,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderC)),
                child: Row(children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: AppColors.goldenBronze.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.badge_outlined,
                        color: AppColors.goldenBronze, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("نوع الحساب",
                              style: TextStyle(
                                  color: textC.withOpacity(0.4), fontSize: 11)),
                          const SizedBox(height: 4),
                          Text(
                              auth.accountType == 'Personal'
                                  ? 'شخصي'
                                  : auth.accountType,
                              style: TextStyle(
                                  color: textC,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ]),
                  ),
                  Icon(Icons.lock_outline_rounded,
                      color: textC.withOpacity(0.3), size: 18),
                ]),
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
