import 'package:flutter/material.dart';

class AppTheme {
  // Base colors (adjust these to match your Figma)
  static const Color _lightPrimary = Color(0xFF1D4E89);
  static const Color _lightAccent = Color(0xFF4EA8DE);
  static const Color _lightBackground = Color(0xFFF5F5F7);
  static const Color _lightSurface = Colors.white;
  static const Color _lightOnPrimary = Colors.white;
  static const Color _lightOnSurface = Color(0xFF1A1A1A);

  static const Color _darkPrimary = Color(0xFF0F1E2E);
  static const Color _darkAccent = Color(0xFF3A6C9D);
  static const Color _darkBackground = Color(0xFF131E28);
  static const Color _darkSurface = Color(0xFF1E2A38);
  static const Color _darkOnSurface = Colors.white70;

  // Light theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _lightPrimary,
    scaffoldBackgroundColor: _lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: _lightPrimary,
      foregroundColor: _lightOnPrimary,
      elevation: 1,
      iconTheme: IconThemeData(color: _lightOnPrimary),
      titleTextStyle: TextStyle(
        color: _lightOnPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _lightAccent,
      foregroundColor: _lightOnPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightPrimary,
        foregroundColor: _lightOnPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: _lightPrimary),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _lightPrimary,
        side: BorderSide(color: _lightPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    // Typical chat bubble colors
    colorScheme: ColorScheme.light(
      primary: _lightPrimary,
      secondary: _lightAccent,
      background: _lightBackground,
      surface: _lightSurface,
      onPrimary: _lightOnPrimary,
      onSecondary: _lightOnPrimary,
      onBackground: _lightOnSurface,
      onSurface: _lightOnSurface,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: _lightOnSurface,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: _lightOnSurface,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: _lightOnSurface, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.grey[800], fontSize: 14),
      bodySmall: TextStyle(color: Colors.grey[600], fontSize: 12),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.grey[500]),
    ),
    dividerColor: Colors.grey[300],
  );

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _darkPrimary,
    scaffoldBackgroundColor: _darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: _darkPrimary,
      foregroundColor: _darkOnSurface,
      elevation: 1,
      iconTheme: IconThemeData(color: _darkOnSurface),
      titleTextStyle: TextStyle(
        color: _darkOnSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _darkAccent,
      foregroundColor: _darkOnSurface,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkAccent,
        foregroundColor: _darkOnSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: _darkAccent),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _darkAccent,
        side: BorderSide(color: _darkAccent),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    colorScheme: ColorScheme.dark(
      primary: _darkPrimary,
      secondary: _darkAccent,
      background: _darkBackground,
      surface: _darkSurface,
      onPrimary: _darkOnSurface,
      onSecondary: _darkOnSurface,
      onBackground: _darkOnSurface,
      onSurface: _darkOnSurface,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: _darkOnSurface,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: _darkOnSurface,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: _darkOnSurface, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.grey[300], fontSize: 14),
      bodySmall: TextStyle(color: Colors.grey[400], fontSize: 12),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF2A303A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.grey[500]),
    ),
    dividerColor: Colors.grey[600],
  );
}
