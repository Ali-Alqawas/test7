import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/auth_provider.dart';

class SupportCenterScreen extends StatefulWidget {
  const SupportCenterScreen({super.key});

  @override
  State<SupportCenterScreen> createState() => _SupportCenterScreenState();
}

class _SupportCenterScreenState extends State<SupportCenterScreen> {
  List<Map<String, dynamic>> _tickets = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    setState(() => _loading = true);
    final auth = context.read<AuthProvider>();
    final tickets = await auth.fetchTickets();
    if (mounted) {
      setState(() {
        _tickets = tickets;
        _loading = false;
      });
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
          title: Text("مركز الدعم",
              style: TextStyle(
                  color: textC, fontSize: 18, fontWeight: FontWeight.w900)),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.goldenBronze,
          icon: const Icon(Icons.add_rounded, color: AppColors.deepNavy),
          label: const Text("تذكرة جديدة",
              style: TextStyle(
                  color: AppColors.deepNavy, fontWeight: FontWeight.bold)),
          onPressed: () =>
              _showCreateTicket(context, isDark, textC, cardC, borderC),
        ),
        body: RefreshIndicator(
          color: AppColors.goldenBronze,
          onRefresh: _loadTickets,
          child: ListView(
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            children: [
              // FAQ quick links
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: cardC,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: borderC)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("الأسئلة الشائعة",
                          style: TextStyle(
                              color: textC,
                              fontSize: 15,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      _faqItem("كيف أكسب النقاط؟", textC, isDark),
                      _faqItem("كيف أتواصل مع التاجر؟", textC, isDark),
                      _faqItem("هل يمكنني إلغاء المتابعة؟", textC, isDark),
                      _faqItem("كيف أبلّغ عن متجر؟", textC, isDark),
                    ]),
              ),
              const SizedBox(height: 24),
              Text("تذاكر الدعم",
                  style: TextStyle(
                      color: textC, fontSize: 16, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),

              if (_loading)
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                      child: CircularProgressIndicator(
                          color: AppColors.goldenBronze, strokeWidth: 2)),
                )
              else if (_tickets.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Center(
                    child: Column(children: [
                      Icon(Icons.confirmation_number_outlined,
                          color: textC.withOpacity(0.2), size: 48),
                      const SizedBox(height: 12),
                      Text("لا توجد تذاكر بعد",
                          style: TextStyle(
                              color: textC.withOpacity(0.4), fontSize: 14)),
                      const SizedBox(height: 4),
                      Text("أنشئ تذكرة جديدة إذا واجهت مشكلة",
                          style: TextStyle(
                              color: textC.withOpacity(0.3), fontSize: 12)),
                    ]),
                  ),
                )
              else
                ..._tickets.map(
                    (t) => _buildTicketCard(t, textC, cardC, borderC, isDark)),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> t, Color textC, Color cardC,
      Color borderC, bool isDark) {
    final id = t['id'] ?? t['ticket_id'] ?? '';
    final title = t['title'] ?? t['subject'] ?? t['issue_type'] ?? 'تذكرة';
    final status = (t['status'] ?? 'open').toString().toLowerCase();
    final date =
        t['created_at']?.toString().substring(0, 10) ?? t['date'] ?? '';
    final desc = t['description'] ?? '';

    Color statusColor;
    String statusText;
    switch (status) {
      case 'open':
      case 'مفتوحة':
        statusColor = Colors.orange;
        statusText = 'مفتوحة';
        break;
      case 'in_progress':
      case 'pending':
      case 'قيد المعالجة':
        statusColor = AppColors.goldenBronze;
        statusText = 'قيد المعالجة';
        break;
      case 'closed':
      case 'resolved':
      case 'مغلقة':
        statusColor = Colors.green;
        statusText = 'مغلقة';
        break;
      default:
        statusColor = AppColors.grey;
        statusText = status;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: cardC,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderC)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('#$id',
              style: const TextStyle(
                  color: AppColors.goldenBronze,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8)),
            child: Text(statusText,
                style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold)),
          ),
        ]),
        const SizedBox(height: 8),
        Text(title.toString(),
            style: TextStyle(
                color: textC, fontSize: 14, fontWeight: FontWeight.w700)),
        if (desc.toString().isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(desc.toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: textC.withOpacity(0.5), fontSize: 12)),
        ],
        const SizedBox(height: 6),
        Text(date.toString(),
            style: TextStyle(color: textC.withOpacity(0.4), fontSize: 11)),
      ]),
    );
  }

  Widget _faqItem(String q, Color textC, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Icon(Icons.help_outline_rounded,
            color: AppColors.goldenBronze, size: 18),
        const SizedBox(width: 10),
        Expanded(
            child: Text(q,
                style: TextStyle(color: textC.withOpacity(0.7), fontSize: 13))),
        Icon(Icons.arrow_back_ios_new_rounded,
            color: AppColors.grey.withOpacity(0.4), size: 12),
      ]),
    );
  }

  void _showCreateTicket(
      BuildContext ctx, bool isDark, Color textC, Color cardC, Color borderC) {
    final descCtrl = TextEditingController();
    bool sending = false;
    String selectedIssueType = 'GENERAL';
    String? selectedImagePath;

    final issueTypes = {
      'GENERAL': 'استفسار عام',
      'TECHNICAL': 'مشكلة تقنية',
      'BILLING': 'مشكلة في الفوترة',
      'STORE_SETUP': 'إعداد المتجر',
      'ORDER_PROBLEM': 'مشكلة في الطلب',
      'OTHER': 'أخرى',
    };

    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(builder: (context, setInnerState) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.deepNavy : Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10))),
                  const SizedBox(height: 20),
                  Text("إنشاء تذكرة جديدة",
                      style: TextStyle(
                          color: textC,
                          fontSize: 18,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 20),
                  // نوع المشكلة
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: cardC,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderC),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedIssueType,
                        dropdownColor:
                            isDark ? AppColors.deepNavy : Colors.white,
                        icon: Icon(Icons.keyboard_arrow_down_rounded,
                            color: textC.withOpacity(0.5)),
                        style: TextStyle(color: textC, fontSize: 14),
                        items: issueTypes.entries
                            .map((e) => DropdownMenuItem(
                                value: e.key,
                                child: Text(e.value,
                                    style: TextStyle(
                                        color: textC,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600))))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setInnerState(() => selectedIssueType = val);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // وصف المشكلة
                  TextField(
                    controller: descCtrl,
                    maxLines: 4,
                    style: TextStyle(color: textC, fontSize: 14),
                    decoration: InputDecoration(
                      labelText: "وصف المشكلة",
                      labelStyle: TextStyle(color: textC.withOpacity(0.4)),
                      filled: true,
                      fillColor: cardC,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: borderC)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: borderC)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              const BorderSide(color: AppColors.goldenBronze)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // إرفاق صورة (اختياري)
                  if (selectedImagePath != null)
                    Stack(
                      children: [
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderC),
                            image: DecorationImage(
                              image: FileImage(File(selectedImagePath!)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 6,
                          left: 6,
                          child: GestureDetector(
                            onTap: () =>
                                setInnerState(() => selectedImagePath = null),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 4)
                                ],
                              ),
                              child: const Icon(Icons.close_rounded,
                                  color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final picked = await picker.pickImage(
                          source: ImageSource.gallery,
                          maxWidth: 1200,
                          maxHeight: 1200,
                          imageQuality: 80,
                        );
                        if (picked != null) {
                          setInnerState(() => selectedImagePath = picked.path);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: cardC,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderC),
                        ),
                        child: Column(children: [
                          Icon(Icons.add_photo_alternate_outlined,
                              color: textC.withOpacity(0.3), size: 32),
                          const SizedBox(height: 6),
                          Text("إرفاق صورة (اختياري)",
                              style: TextStyle(
                                  color: textC.withOpacity(0.4),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ]),
                      ),
                    ),
                  const SizedBox(height: 20),
                  // زر الإرسال
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: sending
                          ? null
                          : () async {
                              if (descCtrl.text.trim().isEmpty) {
                                ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                                  content: const Text("يرجى كتابة وصف المشكلة"),
                                  backgroundColor: AppColors.error,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ));
                                return;
                              }

                              setInnerState(() => sending = true);
                              final auth = ctx.read<AuthProvider>();
                              final success = await auth.createTicket(
                                description: descCtrl.text.trim(),
                                issueType: selectedIssueType,
                                imagePath: selectedImagePath,
                              );
                              setInnerState(() => sending = false);

                              if (success) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                                  content:
                                      const Text("تم إرسال التذكرة بنجاح ✓"),
                                  backgroundColor: AppColors.goldenBronze,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ));
                                _loadTickets();
                              } else {
                                ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                                  content: Text(
                                      auth.errorMessage ?? 'فشل إرسال التذكرة'),
                                  backgroundColor: AppColors.error,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ));
                              }
                            },
                      icon: sending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: AppColors.deepNavy))
                          : const Icon(Icons.send_rounded,
                              color: AppColors.deepNavy),
                      label: Text(sending ? "جاري الإرسال..." : "إرسال التذكرة",
                          style: const TextStyle(
                              color: AppColors.deepNavy,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.goldenBronze,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14))),
                    ),
                  ),
                  const SizedBox(height: 10),
                ]),
              ),
            ),
          ),
        );
      }),
    );
  }
}
