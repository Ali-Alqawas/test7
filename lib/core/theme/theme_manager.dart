import 'package:flutter/material.dart';

// متغير عام للتحكم في الثيم من أي مكان في التطبيق
final ValueNotifier<ThemeMode> appThemeNotifier = ValueNotifier(ThemeMode.dark);

void toggleGlobalTheme() {
  appThemeNotifier.value = appThemeNotifier.value == ThemeMode.dark 
      ? ThemeMode.light 
      : ThemeMode.dark;
}