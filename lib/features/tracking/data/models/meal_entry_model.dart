import 'package:isar/isar.dart';

part 'meal_entry_model.g.dart';

/// Modèle Isar représentant une entrée repas.
@Collection()
class MealEntryModel {
  Id id = Isar.autoIncrement;

  /// Identifiant unique pour la synchronisation future.
  @Index(unique: true)
  late String uuid;

  /// Date du journal (sans heure pour le regroupement journalier).
  @Index()
  late DateTime date;

  /// Heure de l'entrée (DateTime complet).
  late DateTime loggedAt;

  /// Description textuelle saisie par l'utilisateur.
  late String userInput;

  /// Résumé généré par l'IA.
  late String aiSummary;

  /// Données nutritionnelles estimées.
  late int calories;
  late double proteinsG;
  late double carbsG;
  late double fatsG;
  late double fibersG;

  /// JSON brut retourné par l'IA (pour audit/debug).
  late String rawAiResponse;

  /// Nom du fournisseur IA utilisé.
  late String aiProvider;

  /// Mode de saisie : 'text', 'voice', 'photo'.
  late String inputMode;

  /// Chemin de la photo si inputMode == 'photo'.
  String? photoPath;

  /// Aliments détectés (liste JSON sérialisée).
  late String detectedFoodsJson;

  late DateTime createdAt;

  /// Calcule la date normalisée (minuit) pour le groupement journalier.
  static DateTime normalizeDate(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);
}
