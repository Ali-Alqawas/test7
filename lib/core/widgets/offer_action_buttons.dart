import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/social_provider.dart';
import '../theme/app_colors.dart';

// ============================================================================
// أزرار اللايك والمفضلة — مربوطة بـ SocialProvider المركزي
// تدعم المنتجات الفردية والمجموعات (الباقات/البروشورات)
// ============================================================================
class OfferActionButtons extends StatefulWidget {
  final bool isDarkMode;
  final String offerId;

  /// إذا كان true → يستخدم endpoints المجموعات (group-likes/group-favorites)
  final bool isGroup;

  const OfferActionButtons({
    super.key,
    required this.isDarkMode,
    required this.offerId,
    this.isGroup = false,
  });

  @override
  State<OfferActionButtons> createState() => _OfferActionButtonsState();
}

class _OfferActionButtonsState extends State<OfferActionButtons>
    with TickerProviderStateMixin {
  late AnimationController _likeController;
  late AnimationController _favController;
  late Animation<double> _likeScale;
  late Animation<double> _favScale;

  @override
  void initState() {
    super.initState();

    _likeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _likeScale = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 1.4)
              .chain(CurveTween(curve: Curves.easeOutCubic)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.4, end: 1.0)
              .chain(CurveTween(curve: Curves.easeInCubic)),
          weight: 50),
    ]).animate(_likeController);

    _favController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _favScale = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 1.4)
              .chain(CurveTween(curve: Curves.easeOutCubic)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.4, end: 1.0)
              .chain(CurveTween(curve: Curves.easeInCubic)),
          weight: 50),
    ]).animate(_favController);
  }

  @override
  void dispose() {
    _likeController.dispose();
    _favController.dispose();
    super.dispose();
  }

  /// هل الـ ID صالح للإرسال للـ API؟
  bool get _isValidId {
    final id = widget.offerId;
    return id.isNotEmpty && int.tryParse(id) != null;
  }

  void _toggleLike() async {
    if (!_isValidId) {
      debugPrint('⚠️ offerId غير رقمي: "${widget.offerId}"');
      return;
    }

    _likeController.forward(from: 0.0);
    final social = context.read<SocialProvider>();

    final success = widget.isGroup
        ? await social.toggleGroupLike(widget.offerId)
        : await social.toggleLike(widget.offerId);

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('حدث خطأ في الإعجاب، يرجى المحاولة لاحقاً')),
      );
    }
  }

  void _toggleFavorite() async {
    if (!_isValidId) {
      debugPrint('⚠️ offerId غير رقمي: "${widget.offerId}"');
      return;
    }

    _favController.forward(from: 0.0);
    final social = context.read<SocialProvider>();

    final success = widget.isGroup
        ? await social.toggleGroupFavorite(widget.offerId)
        : await social.toggleFavorite(widget.offerId);

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('حدث خطأ في المفضلة، يرجى المحاولة لاحقاً')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final social = context.watch<SocialProvider>();

    // اختيار الحالة حسب النوع (منتج فردي أو مجموعة)
    final bool isLiked = _isValidId
        ? (widget.isGroup
            ? social.isGroupLiked(widget.offerId)
            : social.isLiked(widget.offerId))
        : false;
    final bool isFavorited = _isValidId
        ? (widget.isGroup
            ? social.isGroupFavorited(widget.offerId)
            : social.isFavorited(widget.offerId))
        : false;

    final Color boxBgColor = widget.isDarkMode
        ? Colors.white.withOpacity(0.05)
        : Colors.grey.shade100;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _toggleLike,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isLiked
                  ? AppColors.goldenBronze.withOpacity(0.15)
                  : boxBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ScaleTransition(
              scale: _likeScale,
              child: Icon(
                isLiked
                    ? Icons.thumb_up_alt_rounded
                    : Icons.thumb_up_alt_outlined,
                color: isLiked ? AppColors.goldenBronze : AppColors.grey,
                size: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _toggleFavorite,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color:
                  isFavorited ? AppColors.error.withOpacity(0.15) : boxBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ScaleTransition(
              scale: _favScale,
              child: Icon(
                isFavorited
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: isFavorited ? AppColors.error : AppColors.grey,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
