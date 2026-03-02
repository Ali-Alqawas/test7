import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class OfferActionButtons extends StatefulWidget {
  final bool isDarkMode;
  final String offerId;
  final bool initialIsLiked;
  final bool initialIsFavorited;

  const OfferActionButtons({
    super.key,
    required this.isDarkMode,
    required this.offerId,
    this.initialIsLiked = false,
    this.initialIsFavorited = false,
  });

  @override
  State<OfferActionButtons> createState() => _OfferActionButtonsState();
}

class _OfferActionButtonsState extends State<OfferActionButtons>
    with TickerProviderStateMixin {
  late bool isLiked;
  late bool isFavorited;

  late AnimationController _likeController;
  late AnimationController _favController;
  late Animation<double> _likeScale;
  late Animation<double> _favScale;

  @override
  void initState() {
    super.initState();
    isLiked = widget.initialIsLiked;
    isFavorited = widget.initialIsFavorited;

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

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    if (isLiked) {
      _likeController.forward(from: 0.0);
    }
  }

  void _toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });
    if (isFavorited) {
      _favController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
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
