import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _darkColorScheme.background,
        colorScheme: _darkColorScheme,
        textTheme: _buildTextTheme(Brightness.dark),
        useMaterial3: true,
      );

  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: _lightColorScheme.background,
        colorScheme: _lightColorScheme,
        textTheme: _buildTextTheme(Brightness.light),
        useMaterial3: true,
      );

  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();
    final textColor =
        brightness == Brightness.dark ? Colors.white : Colors.black;

    return baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        fontSize: 96,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        fontSize: 60,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontSize: 16,
        color: textColor,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize: 14,
        color: textColor,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontSize: 12,
        color: textColor,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        fontSize: 10,
        color: textColor,
      ),
    );
  }

  static final ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Colors.red.shade600,
    onPrimary: Colors.white,
    secondary: Colors.blue.shade600,
    onSecondary: Colors.white,
    tertiary: Colors.orange.shade600,
    onTertiary: Colors.white,
    error: Colors.red.shade700,
    onError: Colors.white,
    background: Colors.grey.shade50,
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
    surfaceVariant: Colors.green.shade600,
    onSurfaceVariant: Colors.white,
    outline: Colors.grey.shade500,
    shadow: Colors.black45,
    inverseSurface: Colors.grey.shade200,
    onInverseSurface: Colors.black,
    inversePrimary: Colors.red.shade700,
  );

  static final ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.red.shade300,
    onPrimary: Colors.black,
    secondary: Colors.blue.shade300,
    onSecondary: Colors.black,
    tertiary: Colors.orange.shade300,
    onTertiary: Colors.black,
    error: Colors.red.shade200,
    onError: Colors.black,
    background: Colors.grey.shade900,
    onBackground: Colors.white,
    surface: Colors.grey.shade800,
    onSurface: Colors.white,
    surfaceVariant: Colors.green.shade300,
    onSurfaceVariant: Colors.black,
    outline: Colors.grey.shade600,
    shadow: Colors.black,
    inverseSurface: Colors.grey.shade800,
    onInverseSurface: Colors.white,
    inversePrimary: Colors.red.shade100,
  );
}
