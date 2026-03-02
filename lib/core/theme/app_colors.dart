import 'package:flutter/material.dart';

class AppColors {
  // --- الألوان الأساسية (Primary) ---
  // الخلفية الأساسية للوضع الداكن [cite: 9]
  static const Color deepNavy = Color(0xFF001E28); 
  // اللون الثانوي (للأزرار، الأيقونات، النصوص المميزة) [cite: 5]
  static const Color goldenBronze = Color(0xFFB48C69); 

  // --- ألوان التمييز (Accents) ---
  // للنصوص الثانوية والتفاصيل في الوضع الداكن [cite: 18]
  static const Color warmBeige = Color(0xFFDCB98C); 
  // للبطاقات الفاتحة وخلفيات الوضع النهاري [cite: 17]
  static const Color softCream = Color(0xFFE5CDAF); 
  
  // --- الألوان المحايدة (Neutrals) ---
  // للعناوين الرئيسية فقط في الوضع الداكن [cite: 31, 42]
  static const Color pureWhite = Color(0xFFFFFFFF); 
  static const Color grey = Color(0xFF9E9E9E);
  static const Color error = Color(0xFFD32F2F);

  // --- مشتقات للأوضاع (Derived) ---
  // خلفية الوضع النهاري (مشتقة من الكريمي لتكون مريحة للعين)
  static const Color lightBackground = Color(0xFFF9F5F0);
  // لون النصوص في الوضع النهاري (كحلي غامق)
  static const Color lightText = Color(0xFF001E28);
}