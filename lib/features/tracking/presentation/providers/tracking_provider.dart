import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/meal_entry.dart';
import '../../domain/entities/nutrition_analysis.dart';
import '../../../../core/utils/providers.dart';

// ---------------------------------------------------------------------------
// Tracking providers
// ---------------------------------------------------------------------------

/// Provider pour le résumé journalier en stream (mise à jour temps réel).
final dailySummaryProvider = StreamProvider.family<DailySummary, DateTime>(
  (ref, date) async* {
    final repo = ref.watch(trackingRepositoryProvider);
    final prefs = ref.watch(preferencesServiceProvider);
    yield* repo.watchDailySummary(
      date,
      prefs.dailyCalorieGoal,
      150,
      250,
      65,
    );
  },
);

/// Provider pour les repas d'une journée.
final mealsForDateProvider = StreamProvider.family<List<MealEntry>, DateTime>(
  (ref, date) {
    return ref.watch(trackingRepositoryProvider).watchMealsForDate(date);
  },
);

/// Provider pour les journées ayant des données (historique).
final daysWithDataProvider = FutureProvider<List<DateTime>>((ref) {
  return ref.watch(trackingRepositoryProvider).getDaysWithData();
});

// ---------------------------------------------------------------------------
// État de l'analyse IA
// ---------------------------------------------------------------------------

sealed class TrackingState {
  const TrackingState();
}

class TrackingIdle extends TrackingState {
  const TrackingIdle();
}

class TrackingLoading extends TrackingState {
  const TrackingLoading();
}

class TrackingSuccess extends TrackingState {
  const TrackingSuccess(this.analysis);
  final NutritionAnalysis analysis;
}

class TrackingError extends TrackingState {
  const TrackingError(this.message);
  final String message;
}

/// Notifier pour le workflow d'ajout d'un repas.
class TrackingNotifier extends AsyncNotifier<TrackingState> {
  @override
  Future<TrackingState> build() async => const TrackingIdle();

  Future<NutritionAnalysis?> analyzeText(String text) async {
    state = const AsyncData(TrackingLoading());
    try {
      final repo = ref.read(trackingRepositoryProvider);
      final analysis = await repo.analyzeText(text);
      state = AsyncData(TrackingSuccess(analysis));
      return analysis;
    } catch (e) {
      state = AsyncData(TrackingError(e.toString()));
      return null;
    }
  }

  Future<bool> saveEntry({
    required String userInput,
    required NutritionAnalysis analysis,
    required String inputMode,
    String? photoPath,
  }) async {
    try {
      final repo = ref.read(trackingRepositoryProvider);
      await repo.saveMealEntry(
        userInput: userInput,
        analysis: analysis,
        inputMode: inputMode,
        photoPath: photoPath,
      );
      state = const AsyncData(TrackingIdle());
      return true;
    } catch (e) {
      state = AsyncData(TrackingError(e.toString()));
      return false;
    }
  }

  void reset() {
    state = const AsyncData(TrackingIdle());
  }
}

final trackingNotifierProvider =
    AsyncNotifierProvider<TrackingNotifier, TrackingState>(
  TrackingNotifier.new,
);
