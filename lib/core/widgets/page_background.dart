import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PageBackground extends StatelessWidget {
  final Widget child;

  const PageBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      // لون الخلفية الأساسي
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          // 1. البقع اللونية (The Blobs) - تعطي حياة للتصميم
          Positioned(
            top: -100,
            right: -100,
            child: _buildBlob(AppColors.goldenBronze.withOpacity(isDark ? 0.15 : 0.1)),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: _buildBlob(AppColors.deepNavy.withOpacity(isDark ? 0.3 : 0.05)),
          ),
          
          // 2. المحتوى (الصفحة نفسها)
          Positioned.fill(child: child),
        ],
      ),
    );
  }

  Widget _buildBlob(Color color) {
    return Container(
      width: 350,
      height: 350,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        // تمويه قوي جداً لدمج الألوان
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 120, 
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}