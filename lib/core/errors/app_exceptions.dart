/// Hiérarchie des erreurs domaine de l'application.
abstract class AppException implements Exception {
  const AppException(this.message, {this.code});
  final String message;
  final String? code;

  @override
  String toString() => 'AppException($code): $message';
}

/// Erreur réseau / appel API IA.
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

/// Erreur lors de l'appel à un provider IA.
class AiProviderException extends AppException {
  const AiProviderException(super.message, {super.code, this.provider});
  final String? provider;
}

/// Erreur base de données locale.
class StorageException extends AppException {
  const StorageException(super.message, {super.code});
}

/// Erreur de configuration (clé API manquante, etc.).
class ConfigurationException extends AppException {
  const ConfigurationException(super.message, {super.code});
}

/// Erreur de parsing (réponse IA mal formée).
class ParseException extends AppException {
  const ParseException(super.message, {super.code});
}

/// Erreur permission (microphone, caméra).
class PermissionException extends AppException {
  const PermissionException(super.message, {super.code});
}
