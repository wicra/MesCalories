import 'dart:io';
import '../../domain/entities/meal_entry.dart';
import '../../domain/entities/nutrition_analysis.dart';

/// Contrat du repository de tracking alimentaire.
abstract class TrackingRepository {
  /// Analyse un texte et retourne une estimation nutritionnelle.
  Future<NutritionAnalysis> analyzeText(String text);

  /// Analyse une photo de repas et retourne une estimation.
  Future<NutritionAnalysis> analyzePhoto(String text, File imageFile);

  /// Sauvegarde une entrée repas dans la base locale.
  Future<MealEntry> saveMealEntry({
    required String userInput,
    required NutritionAnalysis analysis,
    required String inputMode,
    String? photoPath,
  });

  /// Récupère toutes les entrées d'une journée.
  Future<List<MealEntry>> getMealsForDate(DateTime date);

  /// Stream temps réel des entrées d'une journée.
  Stream<List<MealEntry>> watchMealsForDate(DateTime date);

  /// Récupère le résumé journalier avec agrégation des macros.
  Future<DailySummary> getDailySummary(DateTime date, int calorieGoal,
      int proteinGoal, int carbGoal, int fatGoal);

  /// Stream du résumé journalier.
  Stream<DailySummary> watchDailySummary(DateTime date, int calorieGoal,
      int proteinGoal, int carbGoal, int fatGoal);

  /// Récupère les journées ayant des données (pour l'historique).
  Future<List<DateTime>> getDaysWithData();

  /// Supprime une entrée.
  Future<void> deleteMealEntry(int id);

  /// Supprime toutes les données.
  Future<void> clearAllData();
}
