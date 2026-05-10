import 'package:flutter/material.dart';

/// Palette de couleurs premium — Noir pur, Liquid Glass, minimaliste.
abstract class AppColors {
  // --- Fond principal (ultra dark) ---
  static const Color black = Color(0xFF000000);
  static const Color deepBlack = Color(0xFF050508);
  static const Color primary = Color(0xFF000000);
  static const Color primaryLight = Color(0xFF0A0A12);

  // --- Surfaces dark ---
  static const Color surfaceDark = Color(0xFF0C0C14);
  static const Color surfaceSecondaryDark = Color(0xFF13131E);
  static const Color surfaceTertiaryDark = Color(0xFF1C1C2A);

  // --- Surfaces light (fallback) ---
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceSecondaryLight = Color(0xFFF2F2F7);
  static const Color surfaceTertiaryLight = Color(0xFFE8E8F0);

  // --- Accent — electric teal ---
  static const Color accent = Color(0xFF00D4C2);
  static const Color accentLight = Color(0xFF00EDD8);
  static const Color accentGlow = Color(0x3300D4C2);
  static const Color accentDim = Color(0x1A00D4C2);

  // --- Glass (liquid glass effect) ---
  static const Color glassWhite = Color(0x0DFFFFFF); // 5% blanc
  static const Color glassBorder = Color(0x1AFFFFFF); // 10% blanc
  static const Color glassLight = Color(0xCCFFFFFF);
  static const Color glassDark = Color(0x0DFFFFFF);

  // --- Textes ---
  static const Color white = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9898A8);
  static const Color textTertiary = Color(0xFF52525E);

  // --- Neutres (compatibilité) ---
  static const Color grey100 = Color(0xFFF5F5F7);
  static const Color grey200 = Color(0xFFE8E8ED);
  static const Color grey300 = Color(0xFFD1D1D6);
  static const Color grey400 = Color(0xFF8E8E9A);
  static const Color grey500 = Color(0xFF636370);
  static const Color grey600 = Color(0xFF48484E);
  static const Color grey700 = Color(0xFF3A3A42);
  static const Color grey800 = Color(0xFF2C2C36);
  static const Color grey900 = Color(0xFF1C1C24);

  // --- Macronutriments (electric, premium) ---
  static const Color calories = Color(0xFFFF5F57);
  static const Color proteins = Color(0xFF5CE0D9);
  static const Color carbs = Color(0xFFFFCC00);
  static const Color fats = Color(0xFFFF7F50);

  // --- États ---
  static const Color success = Color(0xFF30D158);
  static const Color warning = Color(0xFFFF9F0A);
  static const Color error = Color(0xFFFF453A);
  static const Color info = Color(0xFF0A84FF);
}
