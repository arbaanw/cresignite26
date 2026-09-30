import 'package:flutter/material.dart';

/// CribeIt visual identity — warm, premium, craft-inspired.
class AppColors {
  static const burgundy = Color(0xFF5A1F2B);
  static const lavender = Color(0xFFB8A1C8);
  static const ivory = Color(0xFFF7F1E8);
  static const terracotta = Color(0xFFB96E58);
  static const charcoal = Color(0xFF242126);
  static const success = Color(0xFF3F6355);
  static const textMuted = Color(0xFF564F52);
}

class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.burgundy,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.burgundy,
      secondary: AppColors.terracotta,
      tertiary: AppColors.lavender,
      surface: AppColors.ivory,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.ivory,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.ivory,
        foregroundColor: AppColors.charcoal,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.charcoal,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w800),
        headlineMedium: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w700),
        headlineSmall: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w700),
        titleLarge: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: AppColors.charcoal),
        bodyMedium: TextStyle(color: AppColors.textMuted),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.charcoal.withOpacity(0.06)),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.burgundy,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.burgundy,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.burgundy, width: 1.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.burgundy,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.charcoal.withOpacity(0.12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.charcoal.withOpacity(0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.burgundy, width: 1.6),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.lavender.withOpacity(0.35),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.burgundy : AppColors.charcoal.withOpacity(0.6),
          );
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.ivory,
        selectedColor: AppColors.lavender.withOpacity(0.4),
        labelStyle: const TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w600),
        shape: StadiumBorder(side: BorderSide(color: AppColors.charcoal.withOpacity(0.1))),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      dividerTheme: DividerThemeData(color: AppColors.charcoal.withOpacity(0.08), thickness: 1),
    );
  }
}
