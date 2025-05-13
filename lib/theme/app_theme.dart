import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: const Color(0xFF8CEF74),
      scaffoldBackgroundColor: Colors.black,
      fontFamily: 'Laila',
      textTheme: const TextTheme(
        // Display
        displayLarge: TextStyle(fontFamily: 'Laila', fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF392515)),
        displayMedium: TextStyle(fontFamily: 'Laila', fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF392515)),
        displaySmall: TextStyle(fontFamily: 'Laila', fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF392515)),

        // Headline
        headlineLarge: TextStyle(fontFamily: 'Laila', fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF392515)),
        headlineMedium: TextStyle(fontFamily: 'Laila', fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF392515)),
        headlineSmall: TextStyle(fontFamily: 'Laila', fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF392515)),

        // Title
        titleLarge: TextStyle(fontFamily: 'Laila', fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF392515)),
        titleMedium: TextStyle(fontFamily: 'Laila', fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF392515)),
        titleSmall: TextStyle(fontFamily: 'Laila', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF392515)),

        // Body
        bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xFF4C2B12)),
        bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.normal, color: Color(0xFF4C2B12)),
        bodySmall: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.normal, color: Color(0xFF4C2B12)),

        // Label
        labelLarge: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF609254)),
        labelMedium: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF609254)),
        labelSmall: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w500, color: Color(0xFF609254)),
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF609254),
        secondary: Color(0xFFC3824D),
        background: Color(0xFFF4F5EC),
        surface: Color(0xFFEEF0E2),
        error: Color(0xFFB00020),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Color(0xFF392515),
        onSurface: Color(0xFF4C2B12),
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF609254),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF609254),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          textStyle: const TextStyle(
            fontFamily: 'Laila',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF609254),
          textStyle: const TextStyle(
            fontFamily: 'Laila',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF609254)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF609254)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF609254), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: Color(0xFF9F8571),
        ),
      ),
    );
  }
}