import '../../domain/entities/user_profile.dart';
import '../../../../core/constants/app_constants.dart';

/// Contrat du repository profil utilisateur.
abstract class UserProfileRepository {
  Future<UserProfile?> getProfile();
  Future<void> saveProfile(UserProfile profile);
  Future<void> deleteProfile();
  Stream<UserProfile?> watchProfile();

  /// Calcule les objectifs calorique et macros selon les données utilisateur.
  NutritionalGoals computeGoals({
    required int age,
    required BiologicalSex sex,
    required double weightKg,
    required double heightCm,
    required ActivityLevel activity,
    required GoalType goal,
  });
}

/// Objectifs nutritionnels calculés.
class NutritionalGoals {
  const NutritionalGoals({
    required this.calorieGoal,
    required this.proteinGoalG,
    required this.carbGoalG,
    required this.fatGoalG,
    required this.bmr,
    required this.tdee,
  });

  final int calorieGoal;
  final int proteinGoalG;
  final int carbGoalG;
  final int fatGoalG;
  final double bmr;
  final double tdee;
}
