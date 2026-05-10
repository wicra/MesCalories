import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';
import '../errors/app_exceptions.dart';
import '../../features/tracking/domain/entities/nutrition_analysis.dart';

/// Service d'analyse nutritionnelle par IA.
/// Supporte OpenAI, Gemini, Anthropic, Groq (gratuit) et Mistral (gratuit).
class AiNutritionService {
  AiNutritionService({
    required FlutterSecureStorage secureStorage,
    required Dio dio,
  })  : _secureStorage = secureStorage,
        _dio = dio;

  final FlutterSecureStorage _secureStorage;
  final Dio _dio;

  // ---------------------------------------------------------------------------
  // Points d'entrée publics
  // ---------------------------------------------------------------------------

  Future<NutritionAnalysis> analyzeText(String userText) async {
    final provider = await _getProvider();
    final apiKey = await _getApiKey(provider);
    final baseUrl = await _getBaseUrl(provider);
    final model = await _getModel(provider);

    return switch (provider) {
      AiProvider.openai =>
        _analyzeWithOpenAi(userText, apiKey, null, baseUrl, model),
      AiProvider.groq => _analyzeWithOpenAiCompat(
          userText, apiKey, null, baseUrl, model, 'groq'),
      AiProvider.mistral =>
        _analyzeWithMistral(userText, apiKey, baseUrl, model),
      AiProvider.gemini =>
        _analyzeWithGemini(userText, apiKey, null, baseUrl, model),
      AiProvider.anthropic =>
        _analyzeWithAnthropic(userText, apiKey, baseUrl, model),
      AiProvider.custom => _analyzeWithOpenAiCompat(
          userText, apiKey, null, baseUrl, model, 'custom'),
    };
  }

  Future<NutritionAnalysis> analyzePhoto(
    String userText,
    File imageFile,
  ) async {
    final provider = await _getProvider();
    final apiKey = await _getApiKey(provider);
    final baseUrl = await _getBaseUrl(provider);
    final model = await _getModel(provider);

    final imageBytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(imageBytes);

    return switch (provider) {
      AiProvider.openai =>
        _analyzeWithOpenAi(userText, apiKey, base64Image, baseUrl, model),
      AiProvider.groq =>
        // Groq Llama 3.2 vision ou fallback texte
        _analyzeWithOpenAiCompat(
            userText, apiKey, base64Image, baseUrl, model, 'groq'),
      AiProvider.mistral => _analyzeWithMistral(
          '$userText\n[Photo du repas attachée — estime les portions visuellement]',
          apiKey,
          baseUrl,
          model,
        ),
      AiProvider.gemini =>
        _analyzeWithGemini(userText, apiKey, base64Image, baseUrl, model),
      AiProvider.anthropic => _analyzeWithAnthropic(
          '$userText\n[Photo jointe : analyse visuelle requise]',
          apiKey,
          baseUrl,
          model,
        ),
      AiProvider.custom => _analyzeWithOpenAiCompat(
          userText, apiKey, base64Image, baseUrl, model, 'custom'),
    };
  }

  // ---------------------------------------------------------------------------
  // OpenAI (format officiel)
  // ---------------------------------------------------------------------------

  Future<NutritionAnalysis> _analyzeWithOpenAi(
    String text,
    String apiKey,
    String? base64Image,
    String baseUrl,
    String model,
  ) async {
    final content = _buildOpenAiContent(text, base64Image);
    try {
      final response = await _dio.post(
        '$baseUrl/chat/completions',
        options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
        data: {
          'model': model,
          'messages': [
            {'role': 'system', 'content': _systemPrompt},
            {'role': 'user', 'content': content},
          ],
          'response_format': {'type': 'json_object'},
          'max_tokens': 1024,
          'temperature': 0.2,
        },
      );
      final rawJson =
          response.data['choices'][0]['message']['content'] as String;
      return _parseAiResponse(rawJson);
    } on DioException catch (e) {
      throw AiProviderException(
        'Erreur OpenAI : ${e.response?.data ?? e.message}',
        provider: 'openai',
        code: e.response?.statusCode?.toString(),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Compatible OpenAI (Groq — sans response_format pour les modèles Llama)
  // ---------------------------------------------------------------------------

  Future<NutritionAnalysis> _analyzeWithOpenAiCompat(
    String text,
    String apiKey,
    String? base64Image,
    String baseUrl,
    String model,
    String providerName,
  ) async {
    final content = _buildOpenAiContent(text, base64Image);
    try {
      final response = await _dio.post(
        '$baseUrl/chat/completions',
        options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
        data: {
          'model': model,
          'messages': [
            {'role': 'system', 'content': _systemPrompt},
            {'role': 'user', 'content': content},
          ],
          'max_tokens': 1024,
          'temperature': 0.2,
        },
      );
      final rawJson =
          response.data['choices'][0]['message']['content'] as String;
      // Extraire le JSON du texte brut (Groq ne force pas json_object)
      final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(rawJson);
      final jsonStr = jsonMatch?.group(0) ?? rawJson;
      return _parseAiResponse(jsonStr);
    } on DioException catch (e) {
      throw AiProviderException(
        'Erreur $providerName : ${e.response?.data ?? e.message}',
        provider: providerName,
        code: e.response?.statusCode?.toString(),
      );
    }
  }

  dynamic _buildOpenAiContent(String text, String? base64Image) {
    if (base64Image == null) return text;
    return [
      {'type': 'text', 'text': text},
      {
        'type': 'image_url',
        'image_url': {'url': 'data:image/jpeg;base64,$base64Image'},
      },
    ];
  }

  // ---------------------------------------------------------------------------
  // Mistral AI
  // ---------------------------------------------------------------------------

  Future<NutritionAnalysis> _analyzeWithMistral(
    String text,
    String apiKey,
    String baseUrl,
    String model,
  ) async {
    try {
      final response = await _dio.post(
        '$baseUrl/chat/completions',
        options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
        data: {
          'model': model,
          'messages': [
            {'role': 'system', 'content': _systemPrompt},
            {'role': 'user', 'content': text},
          ],
          'response_format': {'type': 'json_object'},
          'max_tokens': 1024,
          'temperature': 0.2,
        },
      );
      final rawJson =
          response.data['choices'][0]['message']['content'] as String;
      return _parseAiResponse(rawJson);
    } on DioException catch (e) {
      throw AiProviderException(
        'Erreur Mistral : ${e.response?.data ?? e.message}',
        provider: 'mistral',
        code: e.response?.statusCode?.toString(),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Gemini
  // ---------------------------------------------------------------------------

  Future<NutritionAnalysis> _analyzeWithGemini(
    String text,
    String apiKey,
    String? base64Image,
    String baseUrl,
    String model,
  ) async {
    final parts = <Map<String, dynamic>>[
      {'text': '$_systemPrompt\n\n$text'},
    ];
    if (base64Image != null) {
      parts.add({
        'inlineData': {'mimeType': 'image/jpeg', 'data': base64Image},
      });
    }
    try {
      final response = await _dio.post(
        '$baseUrl/models/$model:generateContent',
        queryParameters: {'key': apiKey},
        data: {
          'contents': [
            {'parts': parts},
          ],
          'generationConfig': {
            'responseMimeType': 'application/json',
            'temperature': 0.2,
            'maxOutputTokens': 1024,
          },
        },
      );
      final rawJson = response.data['candidates'][0]['content']['parts'][0]
          ['text'] as String;
      return _parseAiResponse(rawJson);
    } on DioException catch (e) {
      throw AiProviderException(
        'Erreur Gemini : ${e.response?.data ?? e.message}',
        provider: 'gemini',
        code: e.response?.statusCode?.toString(),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Anthropic
  // ---------------------------------------------------------------------------

  Future<NutritionAnalysis> _analyzeWithAnthropic(
    String text,
    String apiKey,
    String baseUrl,
    String model,
  ) async {
    try {
      final response = await _dio.post(
        '$baseUrl/messages',
        options: Options(
          headers: {
            'x-api-key': apiKey,
            'anthropic-version': '2023-06-01',
          },
        ),
        data: {
          'model': model,
          'max_tokens': 1024,
          'system': _systemPrompt,
          'messages': [
            {'role': 'user', 'content': text},
          ],
        },
      );
      final rawJson = response.data['content'][0]['text'] as String;
      final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(rawJson);
      final jsonStr = jsonMatch?.group(0) ?? rawJson;
      return _parseAiResponse(jsonStr);
    } on DioException catch (e) {
      throw AiProviderException(
        'Erreur Anthropic : ${e.response?.data ?? e.message}',
        provider: 'anthropic',
        code: e.response?.statusCode?.toString(),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Parsing
  // ---------------------------------------------------------------------------

  NutritionAnalysis _parseAiResponse(String rawJson) {
    try {
      final data = jsonDecode(rawJson) as Map<String, dynamic>;
      final foods = (data['foods'] as List<dynamic>? ?? [])
          .map((f) => DetectedFood.fromJson(f as Map<String, dynamic>))
          .toList();
      return NutritionAnalysis(
        calories: (data['total_calories'] as num?)?.toInt() ?? 0,
        proteinsG: (data['total_proteins_g'] as num?)?.toDouble() ?? 0.0,
        carbsG: (data['total_carbs_g'] as num?)?.toDouble() ?? 0.0,
        fatsG: (data['total_fats_g'] as num?)?.toDouble() ?? 0.0,
        fibersG: (data['total_fibers_g'] as num?)?.toDouble() ?? 0.0,
        detectedFoods: foods,
        summary: data['summary'] as String? ?? '',
        rawJson: rawJson,
      );
    } catch (e) {
      throw ParseException(
        'Impossible de parser la réponse IA : $e\nRaw: $rawJson',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers lecture stockage sécurisé
  // ---------------------------------------------------------------------------

  Future<AiProvider> _getProvider() async {
    final value =
        await _secureStorage.read(key: AppConstants.kSelectedProvider);
    return AiProvider.values.firstWhere(
      (p) => p.name == value,
      orElse: () => AiProvider.groq,
    );
  }

  Future<String> _getApiKey(AiProvider provider) async {
    final storageKey = switch (provider) {
      AiProvider.openai => AppConstants.kOpenAiApiKey,
      AiProvider.gemini => AppConstants.kGeminiApiKey,
      AiProvider.anthropic => AppConstants.kAnthropicApiKey,
      AiProvider.groq => AppConstants.kGroqApiKey,
      AiProvider.mistral => AppConstants.kMistralApiKey,
      AiProvider.custom => AppConstants.kCustomApiKey,
    };
    final apiKey = await _secureStorage.read(key: storageKey);
    // Pour le provider custom, la clé est optionnelle (ex: Ollama sans auth)
    if (provider != AiProvider.custom && (apiKey == null || apiKey.isEmpty)) {
      throw ConfigurationException(
        'Clé API ${provider.label} non configurée. Rendez-vous dans Paramètres.',
      );
    }
    return apiKey ?? '';
  }

  Future<String> _getBaseUrl(AiProvider provider) async {
    final storageKey = switch (provider) {
      AiProvider.openai => AppConstants.kOpenAiBaseUrl,
      AiProvider.gemini => AppConstants.kGeminiBaseUrl,
      AiProvider.anthropic => AppConstants.kAnthropicBaseUrl,
      AiProvider.groq => AppConstants.kGroqBaseUrl,
      AiProvider.mistral => AppConstants.kMistralBaseUrl,
      AiProvider.custom => AppConstants.kCustomBaseUrl,
    };
    final url = await _secureStorage.read(key: storageKey);
    if (url == null || url.isEmpty) {
      // URL par défaut pour les providers gratuits
      return switch (provider) {
        AiProvider.groq => AppConstants.hintGroqBaseUrl,
        AiProvider.mistral => AppConstants.hintMistralBaseUrl,
        AiProvider.gemini => AppConstants.hintGeminiBaseUrl,
        _ => throw ConfigurationException(
            'URL API ${provider.label} non configurée. Rendez-vous dans Paramètres.',
          ),
      };
    }
    return url;
  }

  Future<String> _getModel(AiProvider provider) async {
    final storageKey = switch (provider) {
      AiProvider.openai => AppConstants.kOpenAiModel,
      AiProvider.gemini => AppConstants.kGeminiModel,
      AiProvider.anthropic => AppConstants.kAnthropicModel,
      AiProvider.groq => AppConstants.kGroqModel,
      AiProvider.mistral => AppConstants.kMistralModel,
      AiProvider.custom => AppConstants.kCustomModel,
    };
    final model = await _secureStorage.read(key: storageKey);
    if (model == null || model.isEmpty) {
      // Modèle par défaut pour les providers connus
      return switch (provider) {
        AiProvider.groq => AppConstants.hintGroqModel,
        AiProvider.mistral => AppConstants.hintMistralModel,
        AiProvider.gemini => AppConstants.hintGeminiModel,
        _ => throw ConfigurationException(
            'Modèle ${provider.label} non configuré. Rendez-vous dans Paramètres.',
          ),
      };
    }
    return model;
  }

  // ---------------------------------------------------------------------------
  // Prompt système
  // ---------------------------------------------------------------------------

  static const String _systemPrompt = '''
Tu es un expert nutritionniste. Analyse la description alimentaire fournie et retourne UNIQUEMENT un objet JSON valide avec exactement cette structure :

{
  "foods": [
    {
      "name": "nom de l'aliment",
      "portion": "quantité estimée (ex: 2 œufs moyens)",
      "calories": 156,
      "proteins_g": 12.6,
      "carbs_g": 1.1,
      "fats_g": 10.8
    }
  ],
  "total_calories": 450,
  "total_proteins_g": 25.0,
  "total_carbs_g": 45.0,
  "total_fats_g": 15.0,
  "total_fibers_g": 4.0,
  "summary": "Résumé court et bienveillant du repas en français"
}

Règles :
- Valeurs nutritionnelles moyennes françaises.
- Si la portion n'est pas précisée, estime une portion standard.
- Le champ summary en français, encourageant et informatif.
- Ne retourne AUCUN texte en dehors du JSON.
''';
}
