import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Service de gestion des préférences et des clés API.
class PreferencesService {
  PreferencesService({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences prefs,
  })  : _secureStorage = secureStorage,
        _prefs = prefs;

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;

  // ---------------------------------------------------------------------------
  // Clés API (stockage sécurisé chiffré)
  // ---------------------------------------------------------------------------

  Future<void> saveApiKey(AiProvider provider, String key) async {
    final storageKey = _keyForProvider(provider);
    await _secureStorage.write(key: storageKey, value: key);
  }

  Future<String?> getApiKey(AiProvider provider) async {
    final storageKey = _keyForProvider(provider);
    return _secureStorage.read(key: storageKey);
  }

  Future<void> deleteApiKey(AiProvider provider) async {
    final storageKey = _keyForProvider(provider);
    await _secureStorage.delete(key: storageKey);
  }

  Future<bool> hasApiKey(AiProvider provider) async {
    final key = await getApiKey(provider);
    return key != null && key.isNotEmpty;
  }

  Future<void> setSelectedProvider(AiProvider provider) async {
    await _secureStorage.write(
      key: AppConstants.kSelectedProvider,
      value: provider.name,
    );
  }

  Future<AiProvider> getSelectedProvider() async {
    final value =
        await _secureStorage.read(key: AppConstants.kSelectedProvider);
    return AiProvider.values.firstWhere(
      (p) => p.name == value,
      orElse: () => AiProvider.groq,
    );
  }

  String _keyForProvider(AiProvider provider) => switch (provider) {
        AiProvider.openai => AppConstants.kOpenAiApiKey,
        AiProvider.gemini => AppConstants.kGeminiApiKey,
        AiProvider.anthropic => AppConstants.kAnthropicApiKey,
        AiProvider.groq => AppConstants.kGroqApiKey,
        AiProvider.mistral => AppConstants.kMistralApiKey,
        AiProvider.custom => AppConstants.kCustomApiKey,
      };

  // ---------------------------------------------------------------------------
  // URL de base et modèle (par provider, stockage sécurisé)
  // ---------------------------------------------------------------------------

  Future<void> saveBaseUrl(AiProvider provider, String url) async {
    await _secureStorage.write(key: _baseUrlKey(provider), value: url);
  }

  Future<String?> getBaseUrl(AiProvider provider) =>
      _secureStorage.read(key: _baseUrlKey(provider));

  Future<void> saveModelName(AiProvider provider, String model) async {
    await _secureStorage.write(key: _modelKey(provider), value: model);
  }

  Future<String?> getModelName(AiProvider provider) =>
      _secureStorage.read(key: _modelKey(provider));

  String _baseUrlKey(AiProvider p) => switch (p) {
        AiProvider.openai => AppConstants.kOpenAiBaseUrl,
        AiProvider.gemini => AppConstants.kGeminiBaseUrl,
        AiProvider.anthropic => AppConstants.kAnthropicBaseUrl,
        AiProvider.groq => AppConstants.kGroqBaseUrl,
        AiProvider.mistral => AppConstants.kMistralBaseUrl,
        AiProvider.custom => AppConstants.kCustomBaseUrl,
      };

  String _modelKey(AiProvider p) => switch (p) {
        AiProvider.openai => AppConstants.kOpenAiModel,
        AiProvider.gemini => AppConstants.kGeminiModel,
        AiProvider.anthropic => AppConstants.kAnthropicModel,
        AiProvider.groq => AppConstants.kGroqModel,
        AiProvider.mistral => AppConstants.kMistralModel,
        AiProvider.custom => AppConstants.kCustomModel,
      };

  // ---------------------------------------------------------------------------
  // Préférences générales (SharedPreferences)
  // ---------------------------------------------------------------------------

  bool get onboardingCompleted =>
      _prefs.getBool(AppConstants.kOnboardingCompleted) ?? false;

  Future<void> setOnboardingCompleted(bool value) async =>
      _prefs.setBool(AppConstants.kOnboardingCompleted, value);

  String get themeMode => _prefs.getString(AppConstants.kThemeMode) ?? 'system';

  Future<void> setThemeMode(String mode) async =>
      _prefs.setString(AppConstants.kThemeMode, mode);

  int get dailyCalorieGoal =>
      _prefs.getInt(AppConstants.kDailyCalorieGoal) ??
      AppConstants.defaultCalorieGoal;

  Future<void> setDailyCalorieGoal(int goal) async =>
      _prefs.setInt(AppConstants.kDailyCalorieGoal, goal);

  // ---------------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------------

  bool get notificationsEnabled =>
      _prefs.getBool(AppConstants.kNotificationsEnabled) ?? false;

  Future<void> setNotificationsEnabled(bool value) =>
      _prefs.setBool(AppConstants.kNotificationsEnabled, value);

  int get lunchHour =>
      _prefs.getInt(AppConstants.kNotificationLunchHour) ?? 12;
  int get lunchMinute =>
      _prefs.getInt(AppConstants.kNotificationLunchMinute) ?? 0;
  int get dinnerHour =>
      _prefs.getInt(AppConstants.kNotificationDinnerHour) ?? 19;
  int get dinnerMinute =>
      _prefs.getInt(AppConstants.kNotificationDinnerMinute) ?? 0;

  Future<void> setLunchTime(int hour, int minute) async {
    await _prefs.setInt(AppConstants.kNotificationLunchHour, hour);
    await _prefs.setInt(AppConstants.kNotificationLunchMinute, minute);
  }

  Future<void> setDinnerTime(int hour, int minute) async {
    await _prefs.setInt(AppConstants.kNotificationDinnerHour, hour);
    await _prefs.setInt(AppConstants.kNotificationDinnerMinute, minute);
  }

  // ---------------------------------------------------------------------------
  // Export / Suppression des données
  // ---------------------------------------------------------------------------

  Future<void> clearAllApiKeys() async {
    await _secureStorage.deleteAll();
  }
}
