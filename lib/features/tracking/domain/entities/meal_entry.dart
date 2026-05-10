/// Entité domaine représentant une entrée repas.
class MealEntry {
  const MealEntry({
    required this.id,
    required this.uuid,
    required this.date,
    required this.loggedAt,
    required this.userInput,
    required this.aiSummary,
    required this.calories,
    required this.proteinsG,
    required this.carbsG,
    required this.fatsG,
    required this.fibersG,
    required this.rawAiResponse,
    required this.aiProvider,
    required this.inputMode,
    required this.detectedFoodsJson,
    required this.createdAt,
    this.photoPath,
  });

  final int id;
  final String uuid;
  final DateTime date;
  final DateTime loggedAt;
  final String userInput;
  final String aiSummary;
  final int calories;
  final double proteinsG;
  final double carbsG;
  final double fatsG;
  final double fibersG;
  final String rawAiResponse;
  final String aiProvider;
  final String inputMode;
  final String detectedFoodsJson;
  final DateTime createdAt;
  final String? photoPath;

  MealEntry copyWith({
    int? id,
    String? uuid,
    DateTime? date,
    DateTime? loggedAt,
    String? userInput,
    String? aiSummary,
    int? calories,
    double? proteinsG,
    double? carbsG,
    double? fatsG,
    double? fibersG,
    String? rawAiResponse,
    String? aiProvider,
    String? inputMode,
    String? detectedFoodsJson,
    DateTime? createdAt,
    String? photoPath,
  }) {
    return MealEntry(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      date: date ?? this.date,
      loggedAt: loggedAt ?? this.loggedAt,
      userInput: userInput ?? this.userInput,
      aiSummary: aiSummary ?? this.aiSummary,
      calories: calories ?? this.calories,
      proteinsG: proteinsG ?? this.proteinsG,
      carbsG: carbsG ?? this.carbsG,
      fatsG: fatsG ?? this.fatsG,
      fibersG: fibersG ?? this.fibersG,
      rawAiResponse: rawAiResponse ?? this.rawAiResponse,
      aiProvider: aiProvider ?? this.aiProvider,
      inputMode: inputMode ?? this.inputMode,
      detectedFoodsJson: detectedFoodsJson ?? this.detectedFoodsJson,
      createdAt: createdAt ?? this.createdAt,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealEntry &&
          runtimeType == other.runtimeType &&
          uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;
}

/// Résumé journalier agrégé.
class DailySummary {
  const DailySummary({
    required this.date,
    required this.entries,
    required this.totalCalories,
    required this.totalProteinsG,
    required this.totalCarbsG,
    required this.totalFatsG,
    required this.calorieGoal,
    required this.proteinGoalG,
    required this.carbGoalG,
    required this.fatGoalG,
  });

  final DateTime date;
  final List<MealEntry> entries;
  final int totalCalories;
  final double totalProteinsG;
  final double totalCarbsG;
  final double totalFatsG;
  final int calorieGoal;
  final int proteinGoalG;
  final int carbGoalG;
  final int fatGoalG;

  int get remainingCalories => calorieGoal - totalCalories;
  double get calorieProgress => (totalCalories / calorieGoal).clamp(0.0, 1.0);
  double get proteinProgress =>
      (totalProteinsG / proteinGoalG).clamp(0.0, 1.0);
  double get carbProgress => (totalCarbsG / carbGoalG).clamp(0.0, 1.0);
  double get fatProgress => (totalFatsG / fatGoalG).clamp(0.0, 1.0);
}
