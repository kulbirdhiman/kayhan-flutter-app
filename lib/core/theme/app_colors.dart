import 'package:flutter/material.dart';

/// Brand palette. Screens read colours from `Theme.of(context).colorScheme`;
/// these constants feed the theme and cover semantic states.
class AppColors {
  AppColors._();

  // Brand colors from https://kayhanaudio.com.au/.
  static const primary = Color(0xFFD7261E); // Kayhan red
  static const primaryBright = Color(0xFFD7261E);
  static const primaryContainer = Color(0xFFF9DDD8);
  static const darkPrimaryContainer = Color(0xFF671C18);
  static const brandDeep = Color(0xFF781B16);
  static const ink = Color(0xFF111827);

  // Semantic
  static const sale = Color(0xFFBF1E14);
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFD97706);

  // Light neutrals
  static const lightBackground = Color(0xFFF5EFE7);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFE7DED2);
  static const lightMuted = Color(0xFF6B7280);

  // Dark neutrals
  static const darkBackground = Color(0xFF141414);
  static const darkSurface = Color(0xFF232323);
  static const darkBorder = Color(0xFF403B36);
  static const darkMuted = Color(0xFFBDB5AB);
}
