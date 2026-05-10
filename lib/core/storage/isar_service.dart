import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../../features/auth/data/models/user_profile_model.dart';
import '../../../features/tracking/data/models/meal_entry_model.dart';

/// Service singleton pour la base de données Isar.
/// Gère l'ouverture, la fermeture et l'accès aux collections.
class IsarService {
  IsarService._();
  static final IsarService instance = IsarService._();

  Isar? _isar;

  /// Retourne l'instance Isar ouverte (lazy init).
  Future<Isar> get db async {
    _isar ??= await _open();
    return _isar!;
  }

  Future<Isar> _open() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      [UserProfileModelSchema, MealEntryModelSchema],
      directory: dir.path,
      name: 'mes_calories_db',
    );
  }

  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
