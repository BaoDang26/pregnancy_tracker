import 'package:flutter/material.dart';

class ThemeConstants {
  // Primary Colors
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color primaryPink = Color(0xFFAD6E8C);
  
  // Gradient Colors - Green Theme
  static const List<Color> greenGradient = [
    Color(0xFFE8F5E9),
    Color(0xFFC8E6C9),
    Color(0xFFB2DFDB),
  ];

  // Gradient Colors - Pink Theme
  static const List<Color> pinkGradient = [
    Color(0xFFF8EEF6), // Light pastel pink
    Color(0xFFF5E1EB), // Pastel pink
    Color(0xFFEBD7E6), // Light pink with purple
    Color(0xFFE5D1E8), // Light lavender
    Color(0xFFDBC5DE), // Darker lavender
  ];

  // Button Colors
  static const Color cancelButtonColor = Color(0xFFF5E1EB);
  static const Color cancelTextColor = Color(0xFF8E6C88);
  static const Color createButtonColor = Color(0xFFAD6E8C);
  static const Color createTextColor = Colors.white;
} 