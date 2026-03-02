import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap; // لجعلها قابلة للضغط
  final bool useLightGlass; // للتحكم بلون الزجاج

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.useLightGlass = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            width: width,
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              // معادلة اللون الزجاجي
              color: isDark
                  ? (useLightGlass 
                      ? Colors.white.withOpacity(0.05) 
                      : AppColors.deepNavy.withOpacity(0.6))
                  : Colors.white.withOpacity(0.65),
              
              borderRadius: BorderRadius.circular(borderRadius),
              // حدود خفيفة
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}