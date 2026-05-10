import 'package:isar/isar.dart';
import '../../../../core/constants/app_constants.dart';

part 'user_profile_model.g.dart';

/// Modèle Isar pour le profil utilisateur.
/// Stocke les données personnelles pour le calcul des objectifs caloriques.
@Collection()
class UserProfileModel {
  Id id = Isar.autoIncrement;

  late String firstName;
  late int age;

  @enumerated
  late BiologicalSex biologicalSex;

  /// Poids en kilogrammes.
  late double weightKg;

  /// Taille en centimètres.
  late double heightCm;

  @enumerated
  late ActivityLevel activityLevel;

  @enumerated
  late GoalType goalType;

  /// Objectif calorique journalier calculé (kcal).
  late int dailyCalorieGoal;

  /// Objectif protéines (g).
  late int proteinGoalG;

  /// Objectif glucides (g).
  late int carbGoalG;

  /// Objectif lipides (g).
  late int fatGoalG;

  late DateTime createdAt;
  late DateTime updatedAt;

  /// Calcule le BMR (formule Mifflin-St Jeor).
  double get bmr {
    if (biologicalSex == BiologicalSex.male) {
      return 10 * weightKg + 6.25 * heightCm - 5 * age + 5;
    } else {
      return 10 * weightKg + 6.25 * heightCm - 5 * age - 161;
    }
  }

  /// Calcule le TDEE (BMR × facteur d'activité).
  double get tdee => bmr * activityLevel.factor;

  /// Calcule l'objectif calorique ajusté selon le goal.
  int get computedCalorieGoal =>
      (tdee + goalType.calorieAdjustment).round().clamp(1200, 4000);
}
