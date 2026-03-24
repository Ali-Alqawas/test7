import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/network/api_service.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/helpers/auth_guard.dart';
import '../../../core/widgets/premium_standard_offer_card.dart';
import '../../../core/widgets/premium_featured_offers.dart';
import '../../../core/widgets/premium_bundled_offers.dart';
import '../../../core/widgets/premium_brochures_section.dart';
import '../../../data/providers/social_provider.dart';
import '../../screens/details/merchant_chat_screen.dart';

// ============================================================================
// شاشة ملف المتجر — التصميم الجديد مع بيانات حقيقية
// ============================================================================
class MerchantProfileScreen extends StatefulWidget {
  final String storeId;
  final String storeName;
  final String storeLogo;

  const MerchantProfileScreen({
    super.key,
    required this.storeId,
    required this.storeName,
    required this.storeLogo,
  });

  @override
  State<MerchantProfileScreen> createState() => _MerchantProfileScreenState();
}

class _MerchantProfileScreenState extends State<MerchantProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final ApiService _api = ApiService();

  // ── بيانات المتجر ──
  String _description = '';
  String _location = '';
  String _activityType = '';
  String _workingHours = '';
  String _coverUrl = '';
  String _logoUrl = ''; // اللوجو الحقيقي من API
  String _phone = '';
  String _email = '';
  double _rating = 0;
  int _ratingCount = 0;
  int _followersCount = 0;
  int _offersCount = 0;
  bool _isVerified = false;
  int? _storeOwnerId;

  // ── التقييمات ──
  List<Map<String, dynamic>> _ratings = [];
  bool _loadingRatings = true;
  bool _hasRated = false;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 5, vsync: this, initialIndex: 0);
    _logoUrl = widget.storeLogo; // قيمة مبدئية من الصفحة السابقة
    _fetchStoreDetails();
    _fetchRatings();
    try {
      final social = context.read<SocialProvider>();
      social.loadFollows();
    } catch (_) {}
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchStoreDetails() async {
    try {
      final data = await _api.get(
        ApiConstants.storeDetails(widget.storeId),
        requiresAuth: false,
      );
      if (data is Map && mounted) {
        setState(() {
          _description = data['description']?.toString() ?? '';
          _location = data['location']?.toString() ?? '';
          _activityType = data['activity_type']?.toString() ?? '';
          _workingHours = data['working_hours']?.toString() ?? '';
          _phone = data['phone']?.toString() ?? '';
          _email = data['email']?.toString() ?? '';
          _coverUrl = data['cover_image']?.toString() ?? '';
          if (_coverUrl.isNotEmpty) {
            _coverUrl = ApiConstants.resolveImageUrl(_coverUrl);
          }
          // جلب اللوجو الحقيقي من بيانات المتجر
          final apiLogo =
              (data['logo'] ?? data['store_logo'])?.toString() ?? '';
          if (apiLogo.isNotEmpty) {
            _logoUrl = ApiConstants.resolveImageUrl(apiLogo);
          }
          _rating =
              double.tryParse(data['average_rating']?.toString() ?? '0') ?? 0;
          _ratingCount = data['rating_count'] as int? ?? 0;
          _followersCount = data['followers_count'] as int? ?? 0;
          _offersCount = data['offers_count'] as int? ?? 0;
          _isVerified = data['verification_status'] == 'VERIFIED';
          // owner user ID for chat
          _storeOwnerId = data['user'] as int? ?? data['owner'] as int?;
        });
      }
    } catch (e) {
      debugPrint('خطأ جلب بيانات المتجر: $e');
      if (mounted) setState(() {});
    }
  }

  Future<void> _fetchRatings() async {
    try {
      final data = await _api.get(
        ApiConstants.ratings,
        queryParams: {'store': widget.storeId, 'page_size': '20'},
        requiresAuth: false,
      );
      final List raw =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);
      if (mounted) {
        setState(() {
          _ratings = raw.cast<Map<String, dynamic>>();
          _loadingRatings = false;
          // تحقق هل المستخدم قيّم مسبقاً
          _hasRated = _ratings
              .any((r) => r['is_owner'] == true || r['is_mine'] == true);
        });
      }
    } catch (e) {
      debugPrint('خطأ جلب التقييمات: $e');
      if (mounted) setState(() => _loadingRatings = false);
    }
  }

  // ====================================================================
  // BUILD الرئيسي
  // ====================================================================
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.deepNavy : AppColors.lightBackground;
    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    final cardC = isDark ? const Color(0xFF072A38) : Colors.white;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: bg,
          body: NestedScrollView(
            headerSliverBuilder: (ctx, _) => [
              SliverToBoxAdapter(
                  child: _buildHeroHeader(ctx, isDark, textC, cardC)),
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabDelegate(
                  _buildPillTabBar(isDark),
                  isDark,
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabCtrl,
              children: [
                // حول — أول تبويب
                _buildAboutTab(isDark, textC, cardC),
                // عروض
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 8),
                  child: PremiumStandardOffersSection(
                      isDarkMode: isDark, storeId: widget.storeId),
                ),
                // مميزة
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 8),
                  child: PremiumFeaturedOffersSection(
                      isDarkMode: isDark, storeId: widget.storeId),
                ),
                // باقات
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 8),
                  child: PremiumBundledOffersSection(
                      isDarkMode: isDark, storeId: widget.storeId),
                ),
                // كتيبات
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 8),
                  child: FocusedBrochuresSection(
                      isDarkMode: isDark, storeId: widget.storeId),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ====================================================================
  // Pill-Shaped Tab Bar — مع حدود أنيقة
  // ====================================================================
  Widget _buildPillTabBar(bool isDark) {
    final bgColor = isDark ? AppColors.deepNavy : AppColors.lightBackground;
    final borderC =
        isDark ? AppColors.goldenBronze.withOpacity(0.2) : Colors.grey.shade300;
    final unselectedBg =
        isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade100;

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: unselectedBg,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: borderC.withOpacity(0.5)),
        ),
        child: TabBar(
          controller: _tabCtrl,
          isScrollable: false,
          labelPadding: EdgeInsets.zero,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.symmetric(vertical: 2),
          indicator: BoxDecoration(
            color: AppColors.goldenBronze,
            borderRadius: BorderRadius.circular(20),
          ),
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: isDark ? AppColors.grey : AppColors.lightText,
          labelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          unselectedLabelStyle:
              const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: "حول"),
            Tab(text: "عروض"),
            Tab(text: "مميزة"),
            Tab(text: "باقات"),
            Tab(text: "كتيبات"),
          ],
        ),
      ),
    );
  }

  // ====================================================================
  // HERO HEADER
  // ====================================================================
  Widget _buildHeroHeader(
      BuildContext ctx, bool isDark, Color textC, Color cardC) {
    final top = MediaQuery.of(ctx).padding.top;
    const double coverH = 200;
    const double logoR = 50;

    return Column(
      children: [
        // Cover + overlay + logo
        SizedBox(
          height: coverH + logoR,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                bottom: logoR,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _coverUrl.isNotEmpty
                        ? Image.network(_coverUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                                color: AppColors.goldenBronze.withOpacity(0.2),
                                child: const Center(
                                    child: Icon(Icons.store_rounded,
                                        color: AppColors.goldenBronze,
                                        size: 60))))
                        : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.deepNavy,
                                  AppColors.goldenBronze.withOpacity(0.4)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Center(
                                child: Icon(Icons.store_rounded,
                                    color: Colors.white38, size: 80)),
                          ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.transparent,
                            Colors.black.withOpacity(0.3)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0, 0.4, 1],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Top buttons
              Positioned(
                top: top + 8,
                right: 16,
                left: 16,
                child: Row(
                  children: [
                    _headerBtn(Icons.arrow_forward_ios_rounded,
                        () => Navigator.pop(ctx)),
                    const Spacer(),
                    _headerBtn(Icons.flag_rounded,
                        () => _showReportSheet(ctx, isDark)),
                  ],
                ),
              ),
              // Logo
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.deepNavy
                          : AppColors.lightBackground,
                      border:
                          Border.all(color: AppColors.goldenBronze, width: 3),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.goldenBronze.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: logoR - 4,
                      backgroundColor:
                          isDark ? AppColors.deepNavy : Colors.white,
                      backgroundImage: NetworkImage(_logoUrl),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Name + badge
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(widget.storeName,
                  style: TextStyle(
                      color: textC, fontSize: 22, fontWeight: FontWeight.w900),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 6),
            if (_isVerified)
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                    color: Color(0xFF1DA1F2), shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 13),
              ),
          ],
        ),
        const SizedBox(height: 4),
        if (_activityType.isNotEmpty)
          Text(_activityLabel(_activityType),
              style: TextStyle(
                  color: textC.withOpacity(0.55),
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),

        // Rating + Location
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _tabCtrl.animateTo(0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        AppColors.goldenBronze.withOpacity(isDark ? 0.18 : 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded,
                          color: AppColors.goldenBronze, size: 16),
                      const SizedBox(width: 4),
                      Text(_rating > 0 ? _rating.toStringAsFixed(1) : "—",
                          style: const TextStyle(
                              color: AppColors.goldenBronze,
                              fontSize: 14,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(width: 3),
                      Text("($_ratingCount)",
                          style: TextStyle(
                              color: textC.withOpacity(0.4), fontSize: 11)),
                    ],
                  ),
                ),
              ),
              if (_location.isNotEmpty) ...[
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_rounded,
                          color: AppColors.goldenBronze, size: 15),
                      const SizedBox(width: 4),
                      Text(_location,
                          style: TextStyle(
                              color: textC.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Quick Stats
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _statItem("$_followersCount", "متابع", textC, isDark),
              _divider(textC),
              _statItem("$_offersCount", "عرض", textC, isDark),
              _divider(textC),
              _statItem(_rating > 0 ? _rating.toStringAsFixed(1) : "—", "تقييم",
                  textC, isDark),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Action Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Consumer<SocialProvider>(
            builder: (_, social, __) {
              final isFollowing = social.isFollowing(widget.storeId);
              return Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (!AuthGuard.requireAuth(context)) return;
                        await social.toggleFollow(widget.storeId);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isFollowing
                              ? Colors.transparent
                              : AppColors.goldenBronze,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppColors.goldenBronze, width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                                isFollowing
                                    ? Icons.notifications_active_rounded
                                    : Icons.person_add_rounded,
                                color: isFollowing
                                    ? AppColors.goldenBronze
                                    : AppColors.deepNavy,
                                size: 18),
                            const SizedBox(width: 8),
                            Text(
                              isFollowing ? "متابَع ✓" : "متابعة",
                              style: TextStyle(
                                  color: isFollowing
                                      ? AppColors.goldenBronze
                                      : AppColors.deepNavy,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      if (!AuthGuard.requireAuth(context)) return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MerchantChatScreen(
                                storeName: widget.storeName,
                                storeLogo: _logoUrl,
                                offerTitle: "استفسار عن المتجر",
                                receiverId: _storeOwnerId),
                          ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: cardC,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.goldenBronze),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded,
                              color: AppColors.goldenBronze, size: 18),
                          SizedBox(width: 6),
                          Text("دردشة",
                              style: TextStyle(
                                  color: AppColors.goldenBronze,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () =>
                        Share.share('تصفح متجر ${widget.storeName} على SIDE'),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: cardC,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color:
                                isDark ? Colors.white12 : Colors.grey.shade300),
                      ),
                      child: Icon(Icons.share_rounded,
                          color: textC.withOpacity(0.6), size: 20),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 12),
      ],
    );
  }

  // ====================================================================
  // Quick Stats helpers
  // ====================================================================
  Widget _statItem(String value, String label, Color textC, bool isDark) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: textC, fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(
                color: textC.withOpacity(0.45),
                fontSize: 11,
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _divider(Color textC) {
    return Container(
      width: 1,
      height: 28,
      color: textC.withOpacity(0.12),
    );
  }

  // ====================================================================
  // أزرار الهيدر الشفافة
  // ====================================================================
  Widget _headerBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 19),
          ),
        ),
      ),
    );
  }

  // ====================================================================
  // تبويب "حول المتجر" — تصميم Premium
  // ====================================================================
  Widget _buildAboutTab(bool isDark, Color textC, Color cardC) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ▸ الوصف
          if (_description.isNotEmpty) ...[
            _aboutCard(
              isDark: isDark,
              textC: textC,
              cardC: cardC,
              icon: Icons.info_outline_rounded,
              title: "عن المتجر",
              child: Text(_description,
                  style: TextStyle(
                      color: textC.withOpacity(0.8),
                      fontSize: 14,
                      height: 1.7)),
            ),
            const SizedBox(height: 14),
          ],

          // ▸ التواصل
          _aboutCard(
            isDark: isDark,
            textC: textC,
            cardC: cardC,
            icon: Icons.contact_phone_rounded,
            title: "بيانات التواصل",
            child: Column(
              children: [
                if (_phone.isNotEmpty)
                  _contactRow(Icons.phone_rounded, _phone, textC, isDark),
                if (_email.isNotEmpty)
                  _contactRow(Icons.email_rounded, _email, textC, isDark),
                if (_location.isNotEmpty)
                  _contactRow(
                      Icons.location_on_rounded, _location, textC, isDark),
                if (_phone.isEmpty && _email.isEmpty && _location.isEmpty)
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: textC.withOpacity(0.3), size: 16),
                      const SizedBox(width: 8),
                      Text("لا توجد بيانات تواصل متاحة",
                          style: TextStyle(
                              color: textC.withOpacity(0.4), fontSize: 13)),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ▸ ساعات العمل
          if (_workingHours.isNotEmpty) ...[
            _aboutCard(
              isDark: isDark,
              textC: textC,
              cardC: cardC,
              icon: Icons.schedule_rounded,
              title: "ساعات العمل",
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, color: Color(0xFF4CAF50), size: 8),
                        SizedBox(width: 6),
                        Text("مفتوح",
                            style: TextStyle(
                                color: Color(0xFF4CAF50),
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(_workingHours,
                        style: TextStyle(
                            color: textC.withOpacity(0.7),
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          // ▸ التقييمات والمراجعات
          _buildRatingsSection(isDark, textC, cardC),
        ],
      ),
    );
  }

  // ────── بطاقة About مخصصة ──────
  Widget _aboutCard({
    required bool isDark,
    required Color textC,
    required Color cardC,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardC,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? AppColors.goldenBronze.withOpacity(0.12)
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.15 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان مع أيقونة
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.goldenBronze.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.goldenBronze, size: 17),
              ),
              const SizedBox(width: 10),
              Text(title,
                  style: TextStyle(
                      color: textC, fontSize: 15, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _contactRow(IconData icon, String text, Color textC, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.goldenBronze.withOpacity(0.1)
                  : AppColors.goldenBronze.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.goldenBronze, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    color: textC.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  // ====================================================================
  // قسم التقييمات — Premium Design
  // ====================================================================
  Widget _buildRatingsSection(bool isDark, Color textC, Color cardC) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // هيدر التقييمات
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.goldenBronze.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.star_rounded,
                      color: AppColors.goldenBronze, size: 17),
                ),
                const SizedBox(width: 10),
                Text("التقييمات",
                    style: TextStyle(
                        color: textC,
                        fontSize: 15,
                        fontWeight: FontWeight.w800)),
              ],
            ),
            GestureDetector(
              onTap: _hasRated
                  ? null
                  : () => _showRatingSheet(context, isDark, textC, cardC),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: _hasRated
                      ? (isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.grey.shade200)
                      : AppColors.goldenBronze,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                        _hasRated
                            ? Icons.check_circle_rounded
                            : Icons.edit_rounded,
                        color:
                            _hasRated ? AppColors.goldenBronze : Colors.white,
                        size: 14),
                    const SizedBox(width: 5),
                    Text(_hasRated ? "تم التقييم ✓" : "أضف تقييمك",
                        style: TextStyle(
                            color: _hasRated
                                ? AppColors.goldenBronze
                                : Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // ملخص التقييم الكبير
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardC,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: isDark
                    ? AppColors.goldenBronze.withOpacity(0.15)
                    : Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.12 : 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // الرقم الكبير
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.goldenBronze.withOpacity(0.15),
                      AppColors.goldenBronze.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    _rating > 0 ? _rating.toStringAsFixed(1) : "—",
                    style: TextStyle(
                        color: textC,
                        fontSize: 28,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(
                          5,
                          (i) => Icon(Icons.star_rounded,
                              color: i < _rating.round()
                                  ? AppColors.goldenBronze
                                  : (isDark
                                      ? Colors.white24
                                      : Colors.grey.shade300),
                              size: 20)),
                    ),
                    const SizedBox(height: 6),
                    Text("$_ratingCount تقييم",
                        style: TextStyle(
                            color: textC.withOpacity(0.5),
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // قائمة التقييمات
        if (_loadingRatings)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
                child:
                    CircularProgressIndicator(color: AppColors.goldenBronze)),
          )
        else if (_ratings.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: cardC,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                  color: isDark ? Colors.white10 : Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Icon(Icons.rate_review_outlined,
                    color: textC.withOpacity(0.2), size: 40),
                const SizedBox(height: 10),
                Text("لا توجد تقييمات بعد",
                    style:
                        TextStyle(color: textC.withOpacity(0.4), fontSize: 14)),
                const SizedBox(height: 4),
                Text("كن أول من يقيّم هذا المتجر!",
                    style: TextStyle(
                        color: AppColors.goldenBronze.withOpacity(0.7),
                        fontSize: 12)),
              ],
            ),
          )
        else
          ...List.generate(_ratings.length, (i) {
            final r = _ratings[i];
            final stars = (r['rating'] is int)
                ? r['rating'] as int
                : (double.tryParse(r['rating']?.toString() ?? '0')?.round() ??
                    0);
            final userName = r['user_name']?.toString() ??
                r['reporter_name']?.toString() ??
                'مستخدم';
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardC,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: isDark
                        ? AppColors.goldenBronze.withOpacity(0.1)
                        : Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.08 : 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            AppColors.goldenBronze.withOpacity(0.1),
                        child: Text(userName[0].toUpperCase(),
                            style: const TextStyle(
                                color: AppColors.goldenBronze,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userName,
                                style: TextStyle(
                                    color: textC,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Row(
                              children: List.generate(
                                  5,
                                  (j) => Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: Icon(Icons.star_rounded,
                                            color: j < stars
                                                ? AppColors.goldenBronze
                                                : (isDark
                                                    ? Colors.white24
                                                    : Colors.grey.shade300),
                                            size: 15),
                                      )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if ((r['comment']?.toString() ?? '').isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.03)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(r['comment'].toString(),
                          style: TextStyle(
                              color: textC.withOpacity(0.7),
                              fontSize: 13,
                              height: 1.5)),
                    ),
                  ],
                ],
              ),
            );
          }),
      ],
    );
  }

  // ====================================================================
  // نموذج التقييم (BottomSheet)
  // ====================================================================
  void _showRatingSheet(
      BuildContext ctx, bool isDark, Color textC, Color cardC) {
    if (!AuthGuard.requireAuth(ctx)) return;

    int selectedStars = 0;
    final commentCtrl = TextEditingController();
    bool isSending = false;

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setSheetState) => Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20,
                right: 20,
                left: 20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF072A38) : Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text("قيّم المتجر",
                    style: TextStyle(
                        color: textC,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text("شاركنا تجربتك مع هذا المتجر",
                    style:
                        TextStyle(color: textC.withOpacity(0.4), fontSize: 13)),
                const SizedBox(height: 16),
                // Stars
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    return GestureDetector(
                      onTap: () => setSheetState(() => selectedStars = i + 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: AnimatedScale(
                          scale: i < selectedStars ? 1.2 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            i < selectedStars
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: i < selectedStars
                                ? AppColors.goldenBronze
                                : AppColors.grey,
                            size: 42,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                // Stars label
                if (selectedStars > 0)
                  Text(
                    [
                      "",
                      "ضعيف 😔",
                      "مقبول 😐",
                      "جيد 🙂",
                      "ممتاز 😃",
                      "رائع 🤩"
                    ][selectedStars],
                    style: TextStyle(
                        color: AppColors.goldenBronze,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                const SizedBox(height: 14),
                // Comment field
                TextField(
                  controller: commentCtrl,
                  maxLines: 3,
                  style: TextStyle(color: textC, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "اكتب مراجعتك (اختياري)...",
                    hintStyle:
                        TextStyle(color: textC.withOpacity(0.3), fontSize: 13),
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color:
                              isDark ? Colors.white10 : Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color:
                              isDark ? Colors.white10 : Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          const BorderSide(color: AppColors.goldenBronze),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedStars > 0
                          ? AppColors.goldenBronze
                          : AppColors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: selectedStars > 0 ? 4 : 0,
                      shadowColor: AppColors.goldenBronze.withOpacity(0.3),
                    ),
                    onPressed: selectedStars == 0 || isSending
                        ? null
                        : () async {
                            setSheetState(() => isSending = true);
                            try {
                              await _api.post(ApiConstants.ratings, body: {
                                'rating': selectedStars,
                                'comment': commentCtrl.text.trim(),
                                'store': int.parse(widget.storeId),
                              });
                              if (mounted) {
                                Navigator.pop(context);
                                _fetchRatings();
                                _fetchStoreDetails();
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  const SnackBar(
                                    content: Text("شكراً لتقييمك! ✨"),
                                    backgroundColor: AppColors.goldenBronze,
                                  ),
                                );
                              }
                            } catch (e) {
                              setSheetState(() => isSending = false);
                              if (mounted) {
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  const SnackBar(
                                    content: Text("فشل إرسال التقييم"),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            }
                          },
                    child: isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text("إرسال التقييم",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ====================================================================
  // بلاغ — مربوط بـ POST /social/reports/
  // ====================================================================
  void _showReportSheet(BuildContext ctx, bool isDark) {
    if (!AuthGuard.requireAuth(ctx)) return;

    final textC = isDark ? AppColors.pureWhite : AppColors.lightText;
    String? selectedReason;
    final descCtrl = TextEditingController();
    bool isSending = false;

    const reasons = {
      "MISLEADING": "محتوى مضلل",
      "SPAM": "إزعاج أو سبام",
      "OFFENSIVE": "محتوى غير لائق",
      "FRAUD": "احتيال أو نصب",
      "INAPPROPRIATE": "سلوك غير مناسب",
      "OTHER": "سبب آخر",
    };

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setSheetState) => Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20,
                right: 20,
                left: 20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF072A38) : Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Icon(Icons.flag_rounded,
                    color: AppColors.error, size: 32),
                const SizedBox(height: 8),
                Text("الإبلاغ عن المتجر",
                    style: TextStyle(
                        color: textC,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text("اختر سبب الإبلاغ",
                    style:
                        TextStyle(color: textC.withOpacity(0.4), fontSize: 13)),
                const SizedBox(height: 16),
                // Reason chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: reasons.entries.map((e) {
                    final isActive = selectedReason == e.key;
                    return GestureDetector(
                      onTap: () => setSheetState(() => selectedReason = e.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.error.withOpacity(0.12)
                              : (isDark
                                  ? Colors.white.withOpacity(0.05)
                                  : Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: isActive
                                  ? AppColors.error
                                  : Colors.transparent,
                              width: 1.5),
                        ),
                        child: Text(e.value,
                            style: TextStyle(
                                color: isActive
                                    ? AppColors.error
                                    : textC.withOpacity(0.7),
                                fontSize: 13,
                                fontWeight: isActive
                                    ? FontWeight.w700
                                    : FontWeight.w500)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                // Description
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  style: TextStyle(color: textC, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "تفاصيل إضافية (اختياري)...",
                    hintStyle:
                        TextStyle(color: textC.withOpacity(0.3), fontSize: 13),
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color:
                              isDark ? Colors.white10 : Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color:
                              isDark ? Colors.white10 : Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.error),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedReason != null
                          ? AppColors.error
                          : AppColors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: selectedReason == null || isSending
                        ? null
                        : () async {
                            setSheetState(() => isSending = true);
                            try {
                              await _api.post(ApiConstants.reports, body: {
                                'report_type': 'STORE',
                                'reason': selectedReason,
                                'description': descCtrl.text.trim(),
                                'store_id': int.parse(widget.storeId),
                              });
                              if (mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("تم إرسال البلاغ، شكراً لك 🙏"),
                                    backgroundColor: AppColors.goldenBronze,
                                  ),
                                );
                              }
                            } catch (e) {
                              setSheetState(() => isSending = false);
                              if (mounted) {
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  const SnackBar(
                                    content: Text("فشل إرسال البلاغ"),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            }
                          },
                    child: isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text("إرسال البلاغ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _activityLabel(String? type) {
    switch (type) {
      case 'RETAIL':
        return 'تجزئة';
      case 'SERVICE':
        return 'خدمات';
      case 'FOOD':
        return 'مطاعم ومشروبات';
      case 'OTHER':
        return 'أخرى';
      default:
        return '';
    }
  }
}

// ============================================================================
// Sticky Tab Delegate
// ============================================================================
class _StickyTabDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final bool isDark;
  static const double _height = 60;

  _StickyTabDelegate(this.child, this.isDark);

  @override
  double get minExtent => _height;
  @override
  double get maxExtent => _height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickyTabDelegate old) => true;
}
