import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF005b96), // 经典的Jellycat蓝
        primary: const Color(0xFF005b96),
        secondary: const Color(0xFFe3e8ec),
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF005b96),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
    );
  }
}
