import 'dart:convert';
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/meal_entry.dart';
import '../../domain/entities/nutrition_analysis.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../../data/models/meal_entry_model.dart';
import '../../../../core/network/ai_nutrition_service.dart';
import '../../../../core/storage/isar_service.dart';
import '../../../../core/errors/app_exceptions.dart';

/// Implémentation du repository de tracking (Isar + IA).
class TrackingRepositoryImpl implements TrackingRepository {
  TrackingRepositoryImpl({
    required IsarService isarService,
    required AiNutritionService aiService,
  })  : _isarService = isarService,
        _aiService = aiService;

  final IsarService _isarService;
  final AiNutritionService _aiService;
  final _uuid = const Uuid();

  @override
  Future<NutritionAnalysis> analyzeText(String text) =>
      _aiService.analyzeText(text);

  @override
  Future<NutritionAnalysis> analyzePhoto(String text, File imageFile) =>
      _aiService.analyzePhoto(text, imageFile);

  @override
  Future<MealEntry> saveMealEntry({
    required String userInput,
    required NutritionAnalysis analysis,
    required String inputMode,
    String? photoPath,
  }) async {
    final db = await _isarService.db;
    final now = DateTime.now();
    final model = MealEntryModel()
      ..uuid = _uuid.v4()
      ..date = MealEntryModel.normalizeDate(now)
      ..loggedAt = now
      ..userInput = userInput
      ..aiSummary = analysis.summary
      ..calories = analysis.calories
      ..proteinsG = analysis.proteinsG
      ..carbsG = analysis.carbsG
      ..fatsG = analysis.fatsG
      ..fibersG = analysis.fibersG
      ..rawAiResponse = analysis.rawJson
      ..aiProvider = 'unknown'
      ..inputMode = inputMode
      ..photoPath = photoPath
      ..detectedFoodsJson =
          jsonEncode(analysis.detectedFoods.map((f) => f.toJson()).toList())
      ..createdAt = now;

    await db.writeTxn(() async {
      await db.mealEntryModels.put(model);
    });

    return _toEntity(model);
  }

  @override
  Future<List<MealEntry>> getMealsForDate(DateTime date) async {
    final db = await _isarService.db;
    final normalized = MealEntryModel.normalizeDate(date);
    final models = await db.mealEntryModels
        .where()
        .dateBetween(
          normalized,
          normalized.add(const Duration(hours: 23, minutes: 59, seconds: 59)),
        )
        .sortByLoggedAtDesc()
        .findAll();
    return models.map(_toEntity).toList();
  }

  @override
  Stream<List<MealEntry>> watchMealsForDate(DateTime date) async* {
    final db = await _isarService.db;
    final normalized = MealEntryModel.normalizeDate(date);
    yield* db.mealEntryModels
        .where()
        .dateBetween(
          normalized,
          normalized.add(const Duration(hours: 23, minutes: 59, seconds: 59)),
        )
        .watch(fireImmediately: true)
        .map((list) {
      final sorted = [...list]
        ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
      return sorted.map(_toEntity).toList();
    });
  }

  @override
  Future<DailySummary> getDailySummary(
    DateTime date,
    int calorieGoal,
    int proteinGoal,
    int carbGoal,
    int fatGoal,
  ) async {
    final entries = await getMealsForDate(date);
    return _buildSummary(date, entries, calorieGoal, proteinGoal, carbGoal, fatGoal);
  }

  @override
  Stream<DailySummary> watchDailySummary(
    DateTime date,
    int calorieGoal,
    int proteinGoal,
    int carbGoal,
    int fatGoal,
  ) {
    return watchMealsForDate(date).map(
      (entries) =>
          _buildSummary(date, entries, calorieGoal, proteinGoal, carbGoal, fatGoal),
    );
  }

  @override
  Future<List<DateTime>> getDaysWithData() async {
    final db = await _isarService.db;
    final models =
        await db.mealEntryModels.where().sortByDateDesc().findAll();
    final seen = <String>{};
    final days = <DateTime>[];
    for (final m in models) {
      final key =
          '${m.date.year}-${m.date.month}-${m.date.day}';
      if (seen.add(key)) {
        days.add(m.date);
      }
    }
    return days;
  }

  @override
  Future<void> deleteMealEntry(int id) async {
    final db = await _isarService.db;
    await db.writeTxn(() async {
      final deleted = await db.mealEntryModels.delete(id);
      if (!deleted) throw StorageException('Entrée introuvable (id=$id)');
    });
  }

  @override
  Future<void> clearAllData() async {
    final db = await _isarService.db;
    await db.writeTxn(() async {
      await db.mealEntryModels.clear();
    });
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  DailySummary _buildSummary(
    DateTime date,
    List<MealEntry> entries,
    int calorieGoal,
    int proteinGoal,
    int carbGoal,
    int fatGoal,
  ) {
    int totalCal = 0;
    double totalP = 0, totalC = 0, totalF = 0;
    for (final e in entries) {
      totalCal += e.calories;
      totalP += e.proteinsG;
      totalC += e.carbsG;
      totalF += e.fatsG;
    }
    return DailySummary(
      date: date,
      entries: entries,
      totalCalories: totalCal,
      totalProteinsG: totalP,
      totalCarbsG: totalC,
      totalFatsG: totalF,
      calorieGoal: calorieGoal,
      proteinGoalG: proteinGoal,
      carbGoalG: carbGoal,
      fatGoalG: fatGoal,
    );
  }

  MealEntry _toEntity(MealEntryModel m) => MealEntry(
        id: m.id,
        uuid: m.uuid,
        date: m.date,
        loggedAt: m.loggedAt,
        userInput: m.userInput,
        aiSummary: m.aiSummary,
        calories: m.calories,
        proteinsG: m.proteinsG,
        carbsG: m.carbsG,
        fatsG: m.fatsG,
        fibersG: m.fibersG,
        rawAiResponse: m.rawAiResponse,
        aiProvider: m.aiProvider,
        inputMode: m.inputMode,
        detectedFoodsJson: m.detectedFoodsJson,
        createdAt: m.createdAt,
        photoPath: m.photoPath,
      );
}
