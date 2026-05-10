import 'package:isar/isar.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../data/models/user_profile_model.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/isar_service.dart';

/// Implémentation concrète du repository profil utilisateur (Isar).
class UserProfileRepositoryImpl implements UserProfileRepository {
  UserProfileRepositoryImpl({required IsarService isarService})
      : _isarService = isarService;

  final IsarService _isarService;

  @override
  Future<UserProfile?> getProfile() async {
    final db = await _isarService.db;
    final model =
        await db.userProfileModels.where().sortByCreatedAtDesc().findFirst();
    return model == null ? null : _toEntity(model);
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    final db = await _isarService.db;
    final model = _toModel(profile);
    await db.writeTxn(() async {
      await db.userProfileModels.put(model);
    });
  }

  @override
  Future<void> deleteProfile() async {
    final db = await _isarService.db;
    await db.writeTxn(() async {
      await db.userProfileModels.clear();
    });
  }

  @override
  Stream<UserProfile?> watchProfile() async* {
    final db = await _isarService.db;
    yield* db.userProfileModels
        .where()
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : _toEntity(list.last));
  }

  @override
  NutritionalGoals computeGoals({
    required int age,
    required BiologicalSex sex,
    required double weightKg,
    required double heightCm,
    required ActivityLevel activity,
    required GoalType goal,
  }) {
    // Formule Mifflin-St Jeor
    final bmr = sex == BiologicalSex.male
        ? 10 * weightKg + 6.25 * heightCm - 5 * age + 5
        : 10 * weightKg + 6.25 * heightCm - 5 * age - 161;

    final tdee = bmr * activity.factor;
    final calorieGoal =
        (tdee + goal.calorieAdjustment).round().clamp(1200, 4000);

    // Distribution macros : 30% P, 40% G, 30% L
    final proteinGoal = ((calorieGoal * 0.30) / 4).round();
    final carbGoal = ((calorieGoal * 0.40) / 4).round();
    final fatGoal = ((calorieGoal * 0.30) / 9).round();

    return NutritionalGoals(
      calorieGoal: calorieGoal,
      proteinGoalG: proteinGoal,
      carbGoalG: carbGoal,
      fatGoalG: fatGoal,
      bmr: bmr,
      tdee: tdee,
    );
  }

  // ---------------------------------------------------------------------------
  // Mappers
  // ---------------------------------------------------------------------------

  UserProfile _toEntity(UserProfileModel m) => UserProfile(
        id: m.id,
        firstName: m.firstName,
        age: m.age,
        biologicalSex: m.biologicalSex,
        weightKg: m.weightKg,
        heightCm: m.heightCm,
        activityLevel: m.activityLevel,
        goalType: m.goalType,
        dailyCalorieGoal: m.dailyCalorieGoal,
        proteinGoalG: m.proteinGoalG,
        carbGoalG: m.carbGoalG,
        fatGoalG: m.fatGoalG,
        createdAt: m.createdAt,
        updatedAt: m.updatedAt,
      );

  UserProfileModel _toModel(UserProfile e) {
    final model = UserProfileModel()
      ..id = e.id == 0 ? Isar.autoIncrement : e.id
      ..firstName = e.firstName
      ..age = e.age
      ..biologicalSex = e.biologicalSex
      ..weightKg = e.weightKg
      ..heightCm = e.heightCm
      ..activityLevel = e.activityLevel
      ..goalType = e.goalType
      ..dailyCalorieGoal = e.dailyCalorieGoal
      ..proteinGoalG = e.proteinGoalG
      ..carbGoalG = e.carbGoalG
      ..fatGoalG = e.fatGoalG
      ..createdAt = e.createdAt
      ..updatedAt = e.updatedAt;
    return model;
  }
}
