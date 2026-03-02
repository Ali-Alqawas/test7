import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../home/home_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(), // الشاشة الرئيسية النظيفة
    const Center(
        child: Text("التصنيفات",
            style: TextStyle(fontSize: 30, color: AppColors.deepNavy))),
    const Center(
        child: Text("المفضلة",
            style: TextStyle(fontSize: 30, color: AppColors.deepNavy))),
    const Center(
        child: Text("الإشعارات",
            style: TextStyle(fontSize: 30, color: AppColors.deepNavy))),
    const Center(
        child: Text("حسابي",
            style: TextStyle(fontSize: 30, color: AppColors.deepNavy))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
    );
  }
}
