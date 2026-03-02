import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // --- الوضع الليلي (الأساسي حسب الهوية) [cite: 9, 99] ---
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.deepNavy,
      scaffoldBackgroundColor: AppColors.deepNavy, // الخلفية كحلي غامق [cite: 99]
      
      // إعدادات النصوص الافتراضية للوضع الليلي [cite: 42]
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.pureWhite, fontWeight: FontWeight.bold, fontSize: 32),
        headlineMedium: TextStyle(color: AppColors.pureWhite, fontWeight: FontWeight.bold, fontSize: 24),
        bodyLarge: TextStyle(color: AppColors.pureWhite, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.warmBeige, fontSize: 14), // التفاصيل بالبيج [cite: 42]
      ),
      
      // لون الأيقونات الافتراضي
      iconTheme: const IconThemeData(color: AppColors.goldenBronze),
    );
  }

  // --- الوضع النهاري ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.goldenBronze,
      scaffoldBackgroundColor: AppColors.lightBackground, // خلفية فاتحة
      
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.lightText, fontWeight: FontWeight.bold, fontSize: 32),
        headlineMedium: TextStyle(color: AppColors.lightText, fontWeight: FontWeight.bold, fontSize: 24),
        bodyLarge: TextStyle(color: AppColors.lightText, fontSize: 16),
        bodyMedium: TextStyle(color: Color(0xFF5D4037), fontSize: 14),
      ),
      
      iconTheme: const IconThemeData(color: AppColors.goldenBronze),
    );
  }
}