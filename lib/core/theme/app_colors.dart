import 'package:flutter/material.dart';

/// Brand palette. Screens read colours from `Theme.of(context).colorScheme`;
/// these constants feed the theme and cover semantic states.
class AppColors {
  AppColors._();

  // Brand
  static const primary = Color(0xFF0072BC); // Kayhan blue
  static const primaryBright = Color(0xFF00AEEF);
  static const ink = Color(0xFF0E1116);

  // Semantic
  static const sale = Color(0xFFE11D48);
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFD97706);

  // Light neutrals
  static const lightBackground = Color(0xFFF4F5F7);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFE4E7EC);
  static const lightMuted = Color(0xFF667085);

  // Dark neutrals
  static const darkBackground = Color(0xFF0B0D11);
  static const darkSurface = Color(0xFF151920);
  static const darkBorder = Color(0xFF262C36);
  static const darkMuted = Color(0xFF98A2B3);
}
