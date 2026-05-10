/// Constantes globales de l'application.
abstract class AppConstants {
  // --- App ---
  static const String appName = 'MesCalories';
  static const String appVersion = '1.0.0';
  static const String packageName = 'com.mescalories.app';

  // --- Stockage sécurisé : clés API ---
  static const String kOpenAiApiKey = 'openai_api_key';
  static const String kGeminiApiKey = 'gemini_api_key';
  static const String kAnthropicApiKey = 'anthropic_api_key';
  static const String kSelectedProvider = 'selected_ai_provider';

  // --- Stockage sécurisé : URL de base (saisies par l'utilisateur) ---
  static const String kOpenAiBaseUrl = 'openai_base_url';
  static const String kGeminiBaseUrl = 'gemini_base_url';
  static const String kAnthropicBaseUrl = 'anthropic_base_url';

  // --- Stockage sécurisé : modèles (saisis par l'utilisateur) ---
  static const String kOpenAiModel = 'openai_model';
  static const String kGeminiModel = 'gemini_model';
  static const String kAnthropicModel = 'anthropic_model';

  // --- SharedPreferences (clés) ---
  static const String kOnboardingCompleted = 'onboarding_completed';
  static const String kThemeMode = 'theme_mode';
  static const String kDailyCalorieGoal = 'daily_calorie_goal';

  // --- Hints IA : affichés dans les TextFields (non utilisés par défaut) ---
  static const String hintOpenAiBaseUrl = 'https://api.openai.com/v1';
  static const String hintGeminiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
  static const String hintAnthropicBaseUrl = 'https://api.anthropic.com/v1';
  static const String hintOpenAiModel = 'gpt-4o';
  static const String hintGeminiModel = 'gemini-2.0-flash';
  static const String hintAnthropicModel = 'claude-opus-4-5';

  // --- Objectifs caloriques par défaut ---
  static const int defaultCalorieGoal = 2000;
  static const int defaultProteinGoal = 150;
  static const int defaultCarbGoal = 250;
  static const int defaultFatGoal = 65;

  // --- UI ---
  static const double borderRadius = 16.0;
  static const double borderRadiusLarge = 24.0;
  static const double borderRadiusSmall = 10.0;
  static const double horizontalPadding = 20.0;
  static const double verticalPadding = 16.0;
  static const double cardPadding = 20.0;

  // --- Animation ---
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 350);
  static const Duration animationSlow = Duration(milliseconds: 600);
}

/// Fournisseurs d'IA supportés.
enum AiProvider {
  openai('OpenAI', 'GPT-4o'),
  gemini('Google', 'Gemini 2.0 Flash'),
  anthropic('Anthropic', 'Claude');

  const AiProvider(this.label, this.modelName);
  final String label;
  final String modelName;
}

/// Niveaux d'activité physique pour le calcul TDEE.
enum ActivityLevel {
  sedentary('Sédentaire', 1.2, 'Peu ou pas d\'exercice'),
  light('Légèrement actif', 1.375, '1-3 jours/semaine'),
  moderate('Modérément actif', 1.55, '3-5 jours/semaine'),
  active('Très actif', 1.725, '6-7 jours/semaine'),
  veryActive('Extrêmement actif', 1.9, 'Athlètes professionnels');

  const ActivityLevel(this.label, this.factor, this.description);
  final String label;
  final double factor;
  final String description;
}

/// Objectifs nutritionnels.
enum GoalType {
  lose('Perdre du poids', -500),
  maintain('Maintenir le poids', 0),
  gain('Prendre de la masse', 300);

  const GoalType(this.label, this.calorieAdjustment);
  final String label;
  final int calorieAdjustment;
}

/// Sexe biologique (utilisé pour le calcul BMR).
enum BiologicalSex {
  male('Homme'),
  female('Femme');

  const BiologicalSex(this.label);
  final String label;
}
