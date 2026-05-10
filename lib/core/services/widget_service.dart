import 'package:shared_preferences/shared_preferences.dart';

/// Service de mise à jour du widget home screen Android.
/// Utilise SharedPreferences pour persister les données lues par le widget natif.
class WidgetService {
  /// Met à jour le contenu du widget avec les calories du jour et l'objectif.
  /// Les valeurs sont écrites dans les SharedPreferences avec le namespace
  /// "HomeWidgetPreferences" compatible avec l'AppWidgetProvider Kotlin.
  static Future<void> update({
    required int caloriesToday,
    required int calorieGoal,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('calories_today', caloriesToday);
      await prefs.setInt('calorie_goal', calorieGoal);
    } catch (_) {
      // Erreur silencieuse — le widget est optionnel.
    }
  }
}
