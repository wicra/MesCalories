import 'package:flutter/material.dart';

/// Palette de couleurs de l'application.
/// Inspirée de Revolut & Apple — minimaliste, premium, lisible.
abstract class AppColors {
  // --- Couleurs primaires ---
  static const Color primary = Color(0xFF1A1A2E);
  static const Color primaryLight = Color(0xFF16213E);
  static const Color accent = Color(0xFF4CAF82);
  static const Color accentLight = Color(0xFF6FCBA0);

  // --- Neutres ---
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF0A0A0A);
  static const Color grey100 = Color(0xFFF5F5F7);
  static const Color grey200 = Color(0xFFE8E8ED);
  static const Color grey300 = Color(0xFFD1D1D6);
  static const Color grey400 = Color(0xFFAEAEB2);
  static const Color grey500 = Color(0xFF8E8E93);
  static const Color grey600 = Color(0xFF636366);
  static const Color grey700 = Color(0xFF48484A);
  static const Color grey800 = Color(0xFF3A3A3C);
  static const Color grey900 = Color(0xFF1C1C1E);

  // --- Surfaces (Light mode) ---
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceSecondaryLight = Color(0xFFF5F5F7);
  static const Color surfaceTertiaryLight = Color(0xFFEFEFF4);

  // --- Surfaces (Dark mode) ---
  static const Color surfaceDark = Color(0xFF1C1C1E);
  static const Color surfaceSecondaryDark = Color(0xFF2C2C2E);
  static const Color surfaceTertiaryDark = Color(0xFF3A3A3C);

  // --- Macronutriments ---
  static const Color calories = Color(0xFFFF6B6B);
  static const Color proteins = Color(0xFF4ECDC4);
  static const Color carbs = Color(0xFFFFE66D);
  static const Color fats = Color(0xFFFF8B94);

  // --- États ---
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9500);
  static const Color error = Color(0xFFFF3B30);
  static const Color info = Color(0xFF007AFF);

  // --- Glassmorphism ---
  static const Color glassLight = Color(0x99FFFFFF);
  static const Color glassDark = Color(0x661C1C1E);
}
