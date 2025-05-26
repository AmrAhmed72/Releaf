import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF609254),
    scaffoldBackgroundColor: const Color(0xFFF4F5EC),
    cardColor: const Color(0xFFEEF0E2),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF392515)),
      bodyMedium: TextStyle(color: Color(0xFF4C2B12)),
      titleLarge: TextStyle(
        color: Color(0xFF392515),
        fontFamily: 'Laila',
        fontWeight: FontWeight.bold,
      ),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF22160d)),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(const Color(0xFF609254)),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: const BorderSide(color: Color(0xFF4C2B12)),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      hintStyle: TextStyle(
        color: Color(0xFF9F8571),
        fontSize: 14,
        fontFamily: 'Inter',
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF609254),
      secondary: const Color(0xFFC3824D),
      surface: const Color(0xFFEEF0E2),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF8BC34A),
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    cardColor: const Color(0xFF2A2A2A),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.grey),
      titleLarge: TextStyle(
        color: Colors.white,
        fontFamily: 'Laila',
        fontWeight: FontWeight.bold,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(const Color(0xFF8BC34A)),
      checkColor: WidgetStateProperty.all(Colors.black),
      side: const BorderSide(color: Colors.grey),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: 14,
        fontFamily: 'Inter',
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF8BC34A),
      secondary: const Color(0xFFE57373),
      surface: const Color(0xFF2A2A2A),
    ),
  );
}