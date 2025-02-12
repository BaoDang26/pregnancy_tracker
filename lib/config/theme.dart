import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    primaryColor: const Color(0xff31493b),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'JosefinSans',
    // buttonColor: const Color(0xFF2f4252),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Color(0xff31493b),
      ),
      headlineMedium: TextStyle(
        color: Color(0xff31493b),
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: Color(0xff31493b),
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: Color(0xff219367),
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
