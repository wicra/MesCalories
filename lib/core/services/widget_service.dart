import 'package:flutter/services.dart';

/// Service de mise à jour du widget home screen Android.
/// Utilise un MethodChannel pour écrire dans le fichier SharedPreferences
/// "HomeWidgetPreferences" lu directement par MesCaloriesWidget.kt.
class WidgetService {
  static const _channel = MethodChannel('com.mescalories.app/widget');

  /// Met à jour le contenu du widget avec les calories du jour et l'objectif.
  static Future<void> update({
    required int caloriesToday,
    required int calorieGoal,
  }) async {
    try {
      await _channel.invokeMethod('updateWidget', {
        'calories_today': caloriesToday,
        'calorie_goal': calorieGoal,
      });
    } catch (_) {
      // Erreur silencieuse — le widget est optionnel.
    }
  }
}
