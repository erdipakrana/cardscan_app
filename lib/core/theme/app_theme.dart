import 'package:flutter/material.dart';

class AppTheme {
  // Custom intelligence colors
  static const Color intelligenceTeal = Color(0xFF00B8D9);
  static const Color scannerGreen = Color(0xFF36B37E);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF003D9B),
        onPrimary: Colors.white,
        primaryContainer: Color(0xFF0052CC),
        onPrimaryContainer: Colors.white,
        secondary: Color(0xFF00687B),
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFF50DCFF),
        onSecondaryContainer: Color(0xFF005F71),
        background: Color(0xFFFAF9FF),
        onBackground: Color(0xFF051A3E),
        surface: Color(0xFFFAF9FF),
        onSurface: Color(0xFF051A3E),
        surfaceVariant: Color(0xFFD8E2FF),
        onSurfaceVariant: Color(0xFF434654),
        outline: Color(0xFF737685),
        outlineVariant: Color(0xFFC3C6D6),
        error: Color(0xFFBA1A1A),
        onError: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE1E4E8), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF1F3FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF737685), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFC3C6D6), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF0052CC), width: 2),
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF434654),
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF003D9B),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF0052CC),
        foregroundColor: Colors.white,
        elevation: 4,
        shape: StadiumBorder(),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFB2C5FF),
        onPrimary: Color(0xFF001848),
        primaryContainer: Color(0xFF0040A2),
        onPrimaryContainer: Color(0xFFDAE2FF),
        secondary: Color(0xFF48D7F9),
        onSecondary: Color(0xFF001F27),
        secondaryContainer: Color(0xFF004E5D),
        onSecondaryContainer: Color(0xFFBFE9FF),
        background: Color(0xFF161B22),
        onBackground: Color(0xFFEDF0FF),
        surface: Color(0xFF1D242C),
        onSurface: Color(0xFFEDF0FF),
        surfaceVariant: Color(0xFF434654),
        onSurfaceVariant: Color(0xFFC3C6D6),
        outline: Color(0xFF8D91A0),
        outlineVariant: Color(0xFF434654),
        error: Color(0xFFFFB4AB),
        onError: Color(0xFF690005),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1D242C),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF434654), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0F1419),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF8D91A0), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF434654), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFB2C5FF), width: 2),
        ),
        labelStyle: const TextStyle(
          color: Color(0xFFC3C6D6),
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0040A2),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF0040A2),
        foregroundColor: Colors.white,
        elevation: 4,
        shape: StadiumBorder(),
      ),
    );
  }
}
