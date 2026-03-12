import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/auth_provider.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  List<Map<String, dynamic>> _history = [];
  bool _loading = true;
  String? _referralCode;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final auth = context.read<AuthProvider>();

    // جلب رصيد النقاط
    await auth.fetchPointsBalance();

    // جلب سجل العمليات
    final history = await auth.fetchPointsHistory();
    if (mounted) {
      setState(() => _history = history);
    }

    // جلب رمز الإحالة
    await auth.fetchReferralCode();
    if (mounted) {
      setState(() {
        _referralCode = auth.referralCode;
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
    final auth = context.watch<AuthProvider>();

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
          title: Text("نقاطي ومكافآتي",
              style: TextStyle(
                  color: textC, fontSize: 18, fontWeight: FontWeight.w900)),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          color: AppColors.goldenBronze,
          onRefresh: _loadData,
          child: ListView(
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            children: [
              // Points wallet card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    AppColors.goldenBronze,
                    AppColors.goldenBronze.withOpacity(0.7)
                  ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.goldenBronze.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8))
                  ],
                ),
                child: Column(
                  children: [
                    const Text("رصيدك الحالي",
                        style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 8),
                    Text(auth.pointsBalance.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.w900)),
                    const Text("نقطة",
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 20),
                    // Referral
                    GestureDetector(
                      onTap: () {
                        final code = _referralCode ?? auth.referralCode ?? '';
                        if (code.isNotEmpty) {
                          Clipboard.setData(ClipboardData(text: code));
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(code.isNotEmpty
                                  ? "تم نسخ رمز الإحالة: $code ✓"
                                  : "تم نسخ رمز الإحالة ✓"),
                              backgroundColor: AppColors.goldenBronze,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.copy_rounded,
                                  color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                  _referralCode != null &&
                                          _referralCode!.isNotEmpty
                                      ? "رمز الإحالة: $_referralCode"
                                      : "انسخ رابط الإحالة",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold)),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // How to earn
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: cardC,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: borderC)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("كيف تكسب النقاط؟",
                          style: TextStyle(
                              color: textC,
                              fontSize: 15,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      _earnWay("إحالة صديق", "+50 نقطة",
                          Icons.person_add_rounded, textC),
                      _earnWay(
                          "مشاركة عرض", "+10 نقاط", Icons.share_rounded, textC),
                      _earnWay(
                          "تقييم متجر", "+15 نقطة", Icons.star_rounded, textC),
                      _earnWay("تسجيل دخول يومي", "+5 نقاط",
                          Icons.login_rounded, textC),
                    ]),
              ),
              const SizedBox(height: 24),
              Text("سجل العمليات",
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
              else if (_history.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Center(
                    child: Column(children: [
                      Icon(Icons.receipt_long_rounded,
                          color: textC.withOpacity(0.2), size: 48),
                      const SizedBox(height: 12),
                      Text("لا توجد عمليات بعد",
                          style: TextStyle(
                              color: textC.withOpacity(0.4), fontSize: 14)),
                    ]),
                  ),
                )
              else
                ..._history.map((h) {
                  final title =
                      h['title'] ?? h['description'] ?? h['type'] ?? 'عملية';
                  final pts = h['points'] ?? h['amount'] ?? 0;
                  final isPositive =
                      pts is int ? pts > 0 : pts.toString().startsWith('+');
                  final ptsStr = pts is int
                      ? (isPositive ? '+$pts' : '$pts')
                      : pts.toString();
                  final date = h['date'] ??
                      h['created_at']?.toString().substring(0, 10) ??
                      '';
                  final iconMap = {
                    'referral': Icons.person_add_rounded,
                    'share': Icons.share_rounded,
                    'login': Icons.login_rounded,
                    'rating': Icons.star_rounded,
                    'draw': Icons.redeem_rounded,
                    'redeem': Icons.redeem_rounded,
                  };
                  final type = (h['type'] ?? '').toString().toLowerCase();
                  final icon = iconMap.entries
                      .firstWhere((e) => type.contains(e.key),
                          orElse: () =>
                              MapEntry('default', Icons.swap_horiz_rounded))
                      .value;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: cardC,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderC)),
                    child: Row(children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: isPositive
                              ? AppColors.goldenBronze.withOpacity(0.1)
                              : AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon,
                            color: isPositive
                                ? AppColors.goldenBronze
                                : AppColors.error,
                            size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(title.toString(),
                                style: TextStyle(
                                    color: textC,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700)),
                            Text(date.toString(),
                                style: TextStyle(
                                    color: textC.withOpacity(0.4),
                                    fontSize: 11)),
                          ])),
                      Text(ptsStr,
                          style: TextStyle(
                            color: isPositive ? Colors.green : AppColors.error,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          )),
                    ]),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _earnWay(String title, String pts, IconData icon, Color textC) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Icon(icon, color: AppColors.goldenBronze, size: 18),
        const SizedBox(width: 10),
        Text(title,
            style: TextStyle(color: textC.withOpacity(0.7), fontSize: 13)),
        const Spacer(),
        Text(pts,
            style: const TextStyle(
                color: AppColors.goldenBronze,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
      ]),
    );
  }
}
