import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
      textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: Colors.grey.shade900,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade500),
        useMaterial3: true,
      );

  static ThemeData get lightTheme => ThemeData(
      textTheme: GoogleFonts.poppinsTextTheme(),

      colorScheme: ColorScheme.light(primary: Colors.red.shade500),
      useMaterial3: true);
}
