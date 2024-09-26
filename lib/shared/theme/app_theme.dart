import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey.shade900,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red.shade500,
          brightness: Brightness.dark,
        ),
        textTheme: _buildTextTheme(Brightness.dark),
        useMaterial3: true,
      );

  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red.shade500,
          brightness: Brightness.light,
        ),
        textTheme: _buildTextTheme(Brightness.light),
        useMaterial3: true,
      );

  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;

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
}
