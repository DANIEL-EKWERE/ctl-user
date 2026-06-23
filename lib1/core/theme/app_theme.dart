import 'package:flutter/material.dart';

class AppColors {
  static const orange     = Color(0xFFF5A623);
  static const orangeDark = Color(0xFFD4881A);
  static const navy       = Color(0xFF1B3A6B);
  static const navyLight  = Color(0xFF2A5299);
  static const green      = Color(0xFF27AE60);
  static const red        = Color(0xFFE74C3C);
  static const bg         = Color(0xFFF4F6F9);
  static const border     = Color(0xFFE2E8F0);
  static const border2    = Color(0xFFCBD5E0);
  static const textPrimary   = Color(0xFF1A202C);
  static const textSecondary = Color(0xFF718096);
  static const textLight     = Color(0xFFA0AEC0);
  static const white      = Color(0xFFFFFFFF);
  static const inputBg    = Color(0xFFF7F9FC);
  static const chipBg     = Color(0xFFEDF2F7);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.orange,
      primary: AppColors.orange,
      secondary: AppColors.navy,
      surface: AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.navy,
      foregroundColor: AppColors.white,
      elevation: 0,
      titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.orange,
        foregroundColor: AppColors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        elevation: 4,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border, width: 1.5)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border, width: 1.5)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.orange, width: 1.5)),
      hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
      labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
    ),
  );
}