import 'package:flutter/material.dart';

/// Ombres — subtiles, premium, jamais agressives.
abstract class AppShadows {
  /// Ombre douce pour les cards (mode clair)
  static List<BoxShadow> card = [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.06),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  /// Ombre légère
  static List<BoxShadow> soft = [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  /// Ombre pour boutons avec accent
  static List<BoxShadow> accentButton = [
    BoxShadow(
      color: const Color(0xFF4F46E5).withValues(alpha: 0.30),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  /// Pas d'ombre (réinitialisation)
  static const List<BoxShadow> none = [];
}
