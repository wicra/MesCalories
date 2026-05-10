/// Entité domaine représentant une analyse nutritionnelle retournée par l'IA.
class NutritionAnalysis {
  const NutritionAnalysis({
    required this.calories,
    required this.proteinsG,
    required this.carbsG,
    required this.fatsG,
    required this.fibersG,
    required this.detectedFoods,
    required this.summary,
    required this.rawJson,
  });

  final int calories;
  final double proteinsG;
  final double carbsG;
  final double fatsG;
  final double fibersG;
  final List<DetectedFood> detectedFoods;
  final String summary;
  final String rawJson;

  @override
  String toString() =>
      'NutritionAnalysis($calories kcal | P:${proteinsG}g | G:${carbsG}g | L:${fatsG}g)';
}

/// Un aliment détecté par l'IA.
class DetectedFood {
  const DetectedFood({
    required this.name,
    required this.portion,
    required this.calories,
    required this.proteinsG,
    required this.carbsG,
    required this.fatsG,
  });

  final String name;
  final String portion;
  final int calories;
  final double proteinsG;
  final double carbsG;
  final double fatsG;

  factory DetectedFood.fromJson(Map<String, dynamic> json) {
    return DetectedFood(
      name: json['name'] as String? ?? '',
      portion: json['portion'] as String? ?? '',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      proteinsG: (json['proteins_g'] as num?)?.toDouble() ?? 0.0,
      carbsG: (json['carbs_g'] as num?)?.toDouble() ?? 0.0,
      fatsG: (json['fats_g'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'portion': portion,
        'calories': calories,
        'proteins_g': proteinsG,
        'carbs_g': carbsG,
        'fats_g': fatsG,
      };
}
