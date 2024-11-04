import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'OpenSans',
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green,
      ).copyWith(
        primary: const Color(0xFF2BC155), 
        surface: Colors.white,
      ),
    );
  }
}
