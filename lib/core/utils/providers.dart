import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/ai_nutrition_service.dart';
import '../storage/isar_service.dart';
import '../storage/preferences_service.dart';
import '../../features/tracking/data/repositories/tracking_repository_impl.dart';
import '../../features/tracking/domain/repositories/tracking_repository.dart';
import '../../features/auth/data/repositories/user_profile_repository_impl.dart';
import '../../features/auth/domain/repositories/user_profile_repository.dart';

// ---------------------------------------------------------------------------
// Infrastructure
// ---------------------------------------------------------------------------

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialisé dans main.dart via ProviderScope');
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options = BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 60),
    contentType: 'application/json',
  );
  return dio;
});

// ---------------------------------------------------------------------------
// Services
// ---------------------------------------------------------------------------

final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  return PreferencesService(
    secureStorage: ref.watch(secureStorageProvider),
    prefs: ref.watch(sharedPreferencesProvider),
  );
});

final aiNutritionServiceProvider = Provider<AiNutritionService>((ref) {
  return AiNutritionService(
    secureStorage: ref.watch(secureStorageProvider),
    dio: ref.watch(dioProvider),
  );
});

final isarServiceProvider = Provider<IsarService>((ref) {
  return IsarService.instance;
});

// ---------------------------------------------------------------------------
// Repositories
// ---------------------------------------------------------------------------

final trackingRepositoryProvider = Provider<TrackingRepository>((ref) {
  return TrackingRepositoryImpl(
    isarService: ref.watch(isarServiceProvider),
    aiService: ref.watch(aiNutritionServiceProvider),
  );
});

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepositoryImpl(
    isarService: ref.watch(isarServiceProvider),
  );
});

// ---------------------------------------------------------------------------
// App State
// ---------------------------------------------------------------------------

/// Provider pour l'état d'onboarding.
final onboardingCompletedProvider = Provider<bool>((ref) {
  return ref.watch(preferencesServiceProvider).onboardingCompleted;
});

/// Provider pour le thème courant.
final themeModeProvider = StateProvider<String>((ref) {
  return ref.read(preferencesServiceProvider).themeMode;
});
