import '../../../../core/constants/app_constants.dart';

/// Entité domaine représentant le profil utilisateur.
/// Indépendante du framework et de la base de données.
class UserProfile {
  const UserProfile({
    required this.id,
    required this.firstName,
    required this.age,
    required this.biologicalSex,
    required this.weightKg,
    required this.heightCm,
    required this.activityLevel,
    required this.goalType,
    required this.dailyCalorieGoal,
    required this.proteinGoalG,
    required this.carbGoalG,
    required this.fatGoalG,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String firstName;
  final int age;
  final BiologicalSex biologicalSex;
  final double weightKg;
  final double heightCm;
  final ActivityLevel activityLevel;
  final GoalType goalType;
  final int dailyCalorieGoal;
  final int proteinGoalG;
  final int carbGoalG;
  final int fatGoalG;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile copyWith({
    int? id,
    String? firstName,
    int? age,
    BiologicalSex? biologicalSex,
    double? weightKg,
    double? heightCm,
    ActivityLevel? activityLevel,
    GoalType? goalType,
    int? dailyCalorieGoal,
    int? proteinGoalG,
    int? carbGoalG,
    int? fatGoalG,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      age: age ?? this.age,
      biologicalSex: biologicalSex ?? this.biologicalSex,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      activityLevel: activityLevel ?? this.activityLevel,
      goalType: goalType ?? this.goalType,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      proteinGoalG: proteinGoalG ?? this.proteinGoalG,
      carbGoalG: carbGoalG ?? this.carbGoalG,
      fatGoalG: fatGoalG ?? this.fatGoalG,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
