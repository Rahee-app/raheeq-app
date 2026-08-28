import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors (From Visual Identity)
  static const Color primaryGreen = Color(0xFF16652B);
  static const Color primaryGreenLight = Color(0xFF1D8337);
  static const Color primaryGreenDark = Color(0xFF0E461B);

  // Accent Brand Colors
  static const Color accentLime = Color(0xFFDCF755);
  static const Color accentLimeLight = Color(0xFFE8FB7E);
  static const Color accentLimeDark = Color(0xFFB5CE2F);

  // Gender Symbolic Colors
  static const Color maleAvatar = Color(0xFF3B82F6);      // Gentle Sky Blue
  static const Color femaleAvatar = Color(0xFFEC4899);    // Gentle Rose Pink

  // Light Mode Colors
  static const Color lightBackground = Color(0xFFF7F8F9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardBorder = Color(0xFFE8ECEF);
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color lightTextMuted = Color(0xFFA0A0A0);
  static const Color lightDivider = Color(0xFFEBEBEB);

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF252525);
  static const Color darkCardBorder = Color(0xFF2E2E2E);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFAAAAAA);
  static const Color darkTextMuted = Color(0xFF6B6B6B);
  static const Color darkDivider = Color(0xFF2C2C2C);

  // Status & Utility Colors
  static const Color success = Color(0xFF16652B);
  static const Color completedGreen = Color(0xFF2E7D32);
  static const Color completedGreenLight = Color(0xFFE8F5E9);
  static const Color completedGreenDark = Color(0xFF1B381E);
}
