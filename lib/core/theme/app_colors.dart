import 'package:flutter/material.dart';

/// Palette de couleurs Design System — Premium, sobre, moderne.
/// Inspiré de Revolut, Apple, Linear, Notion.
abstract class AppColors {
  // ---------------------------------------------------------------------------
  // Accent principal — Indigo profond (moderne, rassurant, premium)
  // ---------------------------------------------------------------------------
  static const Color accent = Color(0xFF4F46E5);
  static const Color accentLight = Color(0xFF6366F1);
  static const Color accentGlow = Color(0x334F46E5);
  static const Color accentDim = Color(0x1A4F46E5);

  // ---------------------------------------------------------------------------
  // Mode clair — Apple-like
  // ---------------------------------------------------------------------------
  static const Color lightBg = Color(0xFFF5F5F7);         // fond principal
  static const Color lightSurface = Color(0xFFFFFFFF);    // cards, modals
  static const Color lightSurface2 = Color(0xFFF0F0F5);  // surfaces secondaires
  static const Color lightSurface3 = Color(0xFFE8E8ED);  // borders, dividers
  static const Color lightText = Color(0xFF111111);       // texte principal
  static const Color lightTextSecondary = Color(0xFF6E6E73); // texte secondaire
  static const Color lightTextTertiary = Color(0xFFAEAEB2); // texte tertiaire
  static const Color lightBorder = Color(0xFFE5E5EA);    // bordures

  // ---------------------------------------------------------------------------
  // Mode sombre — #0A0A0A deep, non saturé
  // ---------------------------------------------------------------------------
  static const Color darkBg = Color(0xFF0A0A0A);          // fond principal
  static const Color darkSurface = Color(0xFF161616);     // cards, modals
  static const Color darkSurface2 = Color(0xFF1E1E1E);   // surfaces secondaires
  static const Color darkSurface3 = Color(0xFF2A2A2A);   // surfaces tertiaires
  static const Color darkText = Color(0xFFF5F5F5);        // texte principal
  static const Color darkTextSecondary = Color(0xFF9A9AA1); // texte secondaire
  static const Color darkTextTertiary = Color(0xFF636369); // texte tertiaire
  static const Color darkBorder = Color(0xFF2A2A2A);     // bordures

  // ---------------------------------------------------------------------------
  // Compatibilité (anciens noms — conservés pour les widgets existants)
  // ---------------------------------------------------------------------------
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF0A0A0A);
  static const Color primaryLight = Color(0xFF111111);

  // Dark surfaces (alias)
  static const Color surfaceDark = darkSurface;
  static const Color surfaceSecondaryDark = darkSurface2;
  static const Color surfaceTertiaryDark = darkSurface3;

  // Light surfaces (alias)
  static const Color surfaceLight = lightSurface;
  static const Color surfaceSecondaryLight = lightSurface2;
  static const Color surfaceTertiaryLight = lightSurface3;

  // Textes (alias dark-first pour rétro-compatibilité)
  static const Color textPrimary = darkText;
  static const Color textSecondary = darkTextSecondary;
  static const Color textTertiary = darkTextTertiary;

  // Glass (pour éléments overlay uniquement)
  static const Color glassWhite = Color(0x0DFFFFFF);
  static const Color glassBorder = Color(0x18FFFFFF);
  static const Color glassLight = Color(0xCCFFFFFF);
  static const Color glassDark = Color(0x0DFFFFFF);

  // ---------------------------------------------------------------------------
  // Neutrals — grille grise universelle
  // ---------------------------------------------------------------------------
  static const Color grey100 = Color(0xFFF5F5F7);
  static const Color grey200 = Color(0xFFE5E5EA);
  static const Color grey300 = Color(0xFFD1D1D6);
  static const Color grey400 = Color(0xFFAEAEB2);
  static const Color grey500 = Color(0xFF8E8E93);
  static const Color grey600 = Color(0xFF636366);
  static const Color grey700 = Color(0xFF48484A);
  static const Color grey800 = Color(0xFF3A3A3C);
  static const Color grey900 = Color(0xFF1C1C1E);

  // ---------------------------------------------------------------------------
  // Macronutriments — couleurs fonctionnelles, sobres
  // ---------------------------------------------------------------------------
  static const Color calories = Color(0xFFEF4444);   // rouge doux
  static const Color proteins = Color(0xFF3B82F6);   // bleu
  static const Color carbs = Color(0xFFF59E0B);      // ambre
  static const Color fats = Color(0xFF10B981);       // vert émeraude

  // ---------------------------------------------------------------------------
  // États sémantiques
  // ---------------------------------------------------------------------------
  static const Color success = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFDC2626);
  static const Color errorBg = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoBg = Color(0xFFDBEAFE);
}
