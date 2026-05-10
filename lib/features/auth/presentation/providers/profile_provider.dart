import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/providers.dart';

// ---------------------------------------------------------------------------
// Profile providers
// ---------------------------------------------------------------------------

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  return ref.watch(userProfileRepositoryProvider).watchProfile();
});

// ---------------------------------------------------------------------------
// Setup State
// ---------------------------------------------------------------------------

class ProfileSetupState {
  const ProfileSetupState({
    this.firstName = '',
    this.age = 25,
    this.biologicalSex = BiologicalSex.male,
    this.weightKg = 70.0,
    this.heightCm = 175.0,
    this.activityLevel = ActivityLevel.moderate,
    this.goalType = GoalType.maintain,
    this.isLoading = false,
    this.error,
  });

  final String firstName;
  final int age;
  final BiologicalSex biologicalSex;
  final double weightKg;
  final double heightCm;
  final ActivityLevel activityLevel;
  final GoalType goalType;
  final bool isLoading;
  final String? error;

  ProfileSetupState copyWith({
    String? firstName,
    int? age,
    BiologicalSex? biologicalSex,
    double? weightKg,
    double? heightCm,
    ActivityLevel? activityLevel,
    GoalType? goalType,
    bool? isLoading,
    String? error,
  }) {
    return ProfileSetupState(
      firstName: firstName ?? this.firstName,
      age: age ?? this.age,
      biologicalSex: biologicalSex ?? this.biologicalSex,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      activityLevel: activityLevel ?? this.activityLevel,
      goalType: goalType ?? this.goalType,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProfileSetupNotifier extends Notifier<ProfileSetupState> {
  @override
  ProfileSetupState build() => const ProfileSetupState();

  void setFirstName(String v) => state = state.copyWith(firstName: v);
  void setAge(int v) => state = state.copyWith(age: v);
  void setSex(BiologicalSex v) => state = state.copyWith(biologicalSex: v);
  void setWeight(double v) => state = state.copyWith(weightKg: v);
  void setHeight(double v) => state = state.copyWith(heightCm: v);
  void setActivity(ActivityLevel v) => state = state.copyWith(activityLevel: v);
  void setGoal(GoalType v) => state = state.copyWith(goalType: v);

  Future<bool> saveProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(userProfileRepositoryProvider);
      final goals = repo.computeGoals(
        age: state.age,
        sex: state.biologicalSex,
        weightKg: state.weightKg,
        heightCm: state.heightCm,
        activity: state.activityLevel,
        goal: state.goalType,
      );
      final profile = UserProfile(
        id: 0,
        firstName: state.firstName.trim().isEmpty
            ? 'Utilisateur'
            : state.firstName.trim(),
        age: state.age,
        biologicalSex: state.biologicalSex,
        weightKg: state.weightKg,
        heightCm: state.heightCm,
        activityLevel: state.activityLevel,
        goalType: state.goalType,
        dailyCalorieGoal: goals.calorieGoal,
        proteinGoalG: goals.proteinGoalG,
        carbGoalG: goals.carbGoalG,
        fatGoalG: goals.fatGoalG,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await repo.saveProfile(profile);

      // Mettre à jour l'objectif dans SharedPreferences
      await ref
          .read(preferencesServiceProvider)
          .setDailyCalorieGoal(goals.calorieGoal);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final profileSetupNotifierProvider =
    NotifierProvider<ProfileSetupNotifier, ProfileSetupState>(
  ProfileSetupNotifier.new,
);
