import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      textTheme: GoogleFonts.openSansTextTheme(),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green,
      ).copyWith(
        primary: const Color(0xFF2BC155), 
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
    );
  }
}
