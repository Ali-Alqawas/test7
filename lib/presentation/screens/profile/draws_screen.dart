import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../data/providers/auth_provider.dart';

class DrawsScreen extends StatefulWidget {
  final String? initialDrawId;
  const DrawsScreen({super.key, this.initialDrawId});

  @override
  State<DrawsScreen> createState() => _DrawsScreenState();
}

class _DrawsScreenState extends State<DrawsScreen> {
  List<Map<String, dynamic>> _draws = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDraws();
  }

  Future<void> _loadDraws() async {
    setState(() => _loading = true);
    final auth = context.read<AuthProvider>();
    final draws = await auth.fetchDraws();
    if (mounted) {
      setState(() {
        _draws = draws;
        _loading = false;
      });
      // إذا جاء من صفحة الحساب بسحب محدد → نعرض تفاصيله تلقائياً
      if (widget.initialDrawId != null && widget.initialDrawId!.isNotEmpty) {
        _autoShowDraw(widget.initialDrawId!);
      }
    }
  }

  void _autoShowDraw(String drawId) {
    final match = _draws
        .where((d) => (d['draw_id'] ?? d['id'] ?? '').toString() == drawId);
    if (match.isNotEmpty) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
      final cardC = isDark ? const Color(0xFF072A38) : AppColors.pureWhite;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showDrawDetails(match.first, isDark, textC, cardC);
      });
    }
  }

  Future<void> _enterDraw(Map<String, dynamic> draw) async {
    final id = (draw['draw_id'] ?? draw['id'] ?? '').toString();
    if (id.isEmpty) return;

    final pts = draw['points_required'] ?? 0;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: isDark ? AppColors.deepNavy : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text("تأكيد الدخول",
                style: TextStyle(
                    color: textC, fontWeight: FontWeight.w900, fontSize: 18)),
            content: Text(
                "هل أنت متأكد من دخول السحب؟\n\nسيتم خصم $pts نقطة من رصيدك.",
                style: TextStyle(color: textC.withOpacity(0.7), fontSize: 14)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text("إلغاء",
                      style: TextStyle(color: textC.withOpacity(0.5)))),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldenBronze,
                    foregroundColor: AppColors.deepNavy,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text("دخول السحب",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );

    if (confirmed != true || !mounted) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.enterDraw(id);

    if (!mounted) return;

    if (success) {
      // تحديث محلي فوري + إعادة تحميل من API
      setState(() {
        final idx = _draws.indexWhere(
            (d) => (d['draw_id'] ?? d['id'] ?? '').toString() == id);
        if (idx >= 0) _draws[idx]['is_entered'] = true;
      });
      AppToast.success(context, 'تم تسجيلك في السحب بنجاح 🎉');
      _loadDraws();
    } else {
      AppToast.error(context, auth.errorMessage ?? 'فشل الدخول في السحب');
    }
  }

  // ────────────────────────────────────────────
  // حساب الوقت المتبقي
  // ────────────────────────────────────────────
  String _timeRemaining(String? endDateStr) {
    if (endDateStr == null || endDateStr.isEmpty) return '';
    try {
      final endDate = DateTime.parse(endDateStr);
      final now = DateTime.now();
      final diff = endDate.difference(now);
      if (diff.isNegative) return 'منتهي';
      if (diff.inDays > 0) return 'متبقي ${diff.inDays} يوم';
      if (diff.inHours > 0) return 'متبقي ${diff.inHours} ساعة';
      return 'متبقي ${diff.inMinutes} دقيقة';
    } catch (_) {
      return endDateStr;
    }
  }

  // ────────────────────────────────────────────
  // تحويل حالة السحب للعربية
  // ────────────────────────────────────────────
  Map<String, dynamic> _statusInfo(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return {'text': 'جاري', 'color': Colors.green, 'canEnter': true};
      case 'UPCOMING':
        return {'text': 'قريباً', 'color': Colors.blue, 'canEnter': false};
      case 'ENDED':
        return {'text': 'منتهي', 'color': Colors.grey, 'canEnter': false};
      case 'CANCELLED':
        return {'text': 'ملغي', 'color': AppColors.error, 'canEnter': false};
      default:
        return {'text': status, 'color': AppColors.grey, 'canEnter': false};
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
          title: Text("السحوبات والجوائز",
              style: TextStyle(
                  color: textC, fontSize: 18, fontWeight: FontWeight.w900)),
          centerTitle: true,
        ),
        body: _loading
            ? const Center(
                child: CircularProgressIndicator(
                    color: AppColors.goldenBronze, strokeWidth: 2))
            : _draws.isEmpty
                ? Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Icon(Icons.card_giftcard_rounded,
                            color: textC.withOpacity(0.2), size: 64),
                        const SizedBox(height: 16),
                        Text("لا توجد سحوبات حالياً",
                            style: TextStyle(
                                color: textC.withOpacity(0.4),
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Text("عد لاحقاً لمشاهدة السحوبات الجديدة",
                            style: TextStyle(
                                color: textC.withOpacity(0.3), fontSize: 13)),
                      ]))
                : RefreshIndicator(
                    color: AppColors.goldenBronze,
                    onRefresh: _loadDraws,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: _draws.length,
                      itemBuilder: (ctx, i) {
                        final d = _draws[i];
                        return _buildDrawCard(d, isDark, textC, cardC, borderC);
                      },
                    ),
                  ),
      ),
    );
  }

  Widget _buildDrawCard(Map<String, dynamic> d, bool isDark, Color textC,
      Color cardC, Color borderC) {
    final name = d['name'] ?? 'سحب';
    final description = d['description'] ?? '';
    final conditions = d['conditions'] ?? '';
    final pointsRequired = d['points_required'] ?? 0;
    final endDate = d['end_date'] ?? '';
    final startDate = d['start_date'] ?? '';
    final entriesCount = d['entries_count'] ?? 0;
    final status = (d['status'] ?? 'ACTIVE').toString();
    final sInfo = _statusInfo(status);
    final bool isEntered = d['is_entered'] == true || d['user_entered'] == true;
    final bool canEnter = sInfo['canEnter'] == true && !isEntered;
    final remaining = _timeRemaining(endDate.toString());

    return GestureDetector(
      onTap: () => _showDrawDetails(d, isDark, textC, cardC),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: cardC,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderC),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header with gradient
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                AppColors.goldenBronze.withOpacity(0.15),
                AppColors.goldenBronze.withOpacity(0.05),
              ], begin: Alignment.topRight, end: Alignment.bottomLeft),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(19)),
            ),
            child: Row(children: [
              // صورة السحب أو الأيقونة
              _buildDrawImage(d, 50, 14),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name.toString(),
                          style: TextStyle(
                              color: textC,
                              fontSize: 16,
                              fontWeight: FontWeight.w800)),
                      if (description.toString().isNotEmpty)
                        Text(description.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: textC.withOpacity(0.5), fontSize: 12)),
                    ]),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: (sInfo['color'] as Color).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(sInfo['text'] as String,
                    style: TextStyle(
                        color: sInfo['color'] as Color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
            ]),
          ),
          // Details
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                _info(Icons.stars_rounded, "$pointsRequired نقطة للدخول",
                    AppColors.goldenBronze),
                const SizedBox(width: 16),
                _info(Icons.people_rounded, "$entriesCount مشارك",
                    textC.withOpacity(0.5)),
              ]),
              if (remaining.isNotEmpty) ...[
                const SizedBox(height: 8),
                _info(Icons.timer_rounded, remaining, textC.withOpacity(0.5)),
              ],
              if (canEnter || isEntered) ...[
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: canEnter ? () => _enterDraw(d) : null,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isEntered
                          ? Colors.transparent
                          : AppColors.goldenBronze,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: AppColors.goldenBronze, width: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            isEntered
                                ? Icons.check_circle_rounded
                                : Icons.confirmation_number_rounded,
                            color: isEntered
                                ? AppColors.goldenBronze
                                : AppColors.deepNavy,
                            size: 18),
                        const SizedBox(width: 8),
                        Text(
                          isEntered ? "تم التسجيل ✓" : "دخول السحب 🎉",
                          style: TextStyle(
                              color: isEntered
                                  ? AppColors.goldenBronze
                                  : AppColors.deepNavy,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _info(IconData icon, String text, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: color, size: 15),
      const SizedBox(width: 4),
      Text(text,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    ]);
  }

  /// صورة السحب — إذا وجدت نعرضها وإلا أيقونة
  Widget _buildDrawImage(Map<String, dynamic> d, double size, double radius) {
    final imageUrl = (d['image_url'] ?? d['image'])?.toString();
    if (imageUrl != null && imageUrl.isNotEmpty) {
      final resolved = ApiConstants.resolveImageUrl(imageUrl);
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.network(
          resolved,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.goldenBronze.withOpacity(0.15),
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Icon(Icons.card_giftcard_rounded,
                color: AppColors.goldenBronze, size: size * 0.5),
          ),
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.goldenBronze.withOpacity(0.15),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(Icons.card_giftcard_rounded,
          color: AppColors.goldenBronze, size: size * 0.5),
    );
  }

  void _showDrawDetails(
      Map<String, dynamic> d, bool isDark, Color textC, Color cardC) {
    final name = d['name'] ?? 'سحب';
    final description = d['description'] ?? '';
    final conditions = d['conditions'] ?? '';
    final pointsRequired = d['points_required'] ?? 0;
    final endDate = d['end_date'] ?? '';
    final startDate = d['start_date'] ?? '';
    final entriesCount = d['entries_count'] ?? 0;
    final status = (d['status'] ?? 'ACTIVE').toString();
    final sInfo = _statusInfo(status);
    final bool canEnter = sInfo['canEnter'] == true;
    final bool isEntered = d['is_entered'] == true || d['user_entered'] == true;
    final remaining = _timeRemaining(endDate.toString());

    // تنسيق التاريخ
    String formatDate(String dateStr) {
      try {
        final dt = DateTime.parse(dateStr);
        return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
      } catch (_) {
        return dateStr;
      }
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.deepNavy : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 20),
            // العنوان والحالة
            Row(children: [
              // صورة السحب
              _buildDrawImage(d, 56, 16),
              const SizedBox(width: 14),
              Expanded(
                child: Text(name.toString(),
                    style: TextStyle(
                        color: textC,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: (sInfo['color'] as Color).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(sInfo['text'] as String,
                    style: TextStyle(
                        color: sInfo['color'] as Color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
            ]),
            const SizedBox(height: 20),
            // التفاصيل
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: cardC,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: isDark ? Colors.white10 : Colors.grey.shade200)),
              child: Column(children: [
                _detailRow("النقاط المطلوبة", "$pointsRequired نقطة", textC),
                Divider(
                    color: isDark ? Colors.white10 : Colors.grey.shade200,
                    height: 20),
                _detailRow("عدد المشاركين", "$entriesCount", textC),
                Divider(
                    color: isDark ? Colors.white10 : Colors.grey.shade200,
                    height: 20),
                _detailRow(
                    "تاريخ البداية", formatDate(startDate.toString()), textC),
                Divider(
                    color: isDark ? Colors.white10 : Colors.grey.shade200,
                    height: 20),
                _detailRow(
                    "تاريخ الانتهاء", formatDate(endDate.toString()), textC),
                if (remaining.isNotEmpty) ...[
                  Divider(
                      color: isDark ? Colors.white10 : Colors.grey.shade200,
                      height: 20),
                  _detailRow("الوقت المتبقي", remaining, textC),
                ],
              ]),
            ),
            // الوصف
            if (description.toString().isNotEmpty) ...[
              const SizedBox(height: 16),
              Text("الوصف",
                  style: TextStyle(
                      color: textC, fontSize: 14, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(description.toString(),
                  style: TextStyle(
                      color: textC.withOpacity(0.6),
                      fontSize: 13,
                      height: 1.7)),
            ],
            // الشروط
            if (conditions.toString().isNotEmpty) ...[
              const SizedBox(height: 16),
              Text("الشروط",
                  style: TextStyle(
                      color: textC, fontSize: 14, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(conditions.toString(),
                  style: TextStyle(
                      color: textC.withOpacity(0.6),
                      fontSize: 13,
                      height: 1.7)),
            ],
            const Spacer(),
            if (canEnter || isEntered)
              GestureDetector(
                onTap: canEnter
                    ? () {
                        Navigator.pop(context);
                        _enterDraw(d);
                      }
                    : null,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color:
                        isEntered ? Colors.transparent : AppColors.goldenBronze,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.goldenBronze, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          isEntered
                              ? Icons.check_circle_rounded
                              : Icons.confirmation_number_rounded,
                          color: isEntered
                              ? AppColors.goldenBronze
                              : AppColors.deepNavy,
                          size: 20),
                      const SizedBox(width: 8),
                      Text(
                        isEntered ? "تم التسجيل في السحب ✓" : "دخول السحب 🎉",
                        style: TextStyle(
                            color: isEntered
                                ? AppColors.goldenBronze
                                : AppColors.deepNavy,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: (sInfo['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      status.toUpperCase() == 'UPCOMING'
                          ? "السحب لم يبدأ بعد"
                          : "السحب منتهي",
                      style: TextStyle(
                          color: sInfo['color'] as Color,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, Color textC) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label,
          style: TextStyle(color: textC.withOpacity(0.5), fontSize: 13)),
      Text(value,
          style: const TextStyle(
              color: AppColors.goldenBronze,
              fontSize: 14,
              fontWeight: FontWeight.bold)),
    ]);
  }
}
