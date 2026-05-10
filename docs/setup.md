# Setup — MesCalories

## Prérequis

| Outil | Version recommandée |
|-------|-------------------|
| Flutter | ≥ 3.27.x stable |
| Dart | ≥ 3.6.x |
| Xcode | ≥ 16 (pour iOS) |
| Android Studio | ≥ 2024.x |
| VS Code | Dernière version |

## Installation

### 1. Cloner le repository

```bash
git clone https://github.com/wicra/MesCalories.git
cd MesCalories
```

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Générer les fichiers Isar

Les modèles Isar nécessitent une génération de code :

```bash
dart run build_runner build --delete-conflicting-outputs
```

Pour regénérer automatiquement lors des modifications :

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### 4. Lancer l'application

```bash
# Simulateur iOS
flutter run -d ios

# Émulateur Android
flutter run -d android

# Tous les appareils connectés
flutter run
```

## Configuration des clés API

L'application ne nécessite **aucune clé API hardcodée**.

Au premier lancement, après l'onboarding, rendez-vous dans **Paramètres → Clés API** et renseignez votre clé pour le fournisseur IA de votre choix :

| Fournisseur | Où obtenir la clé |
|-------------|-------------------|
| OpenAI | https://platform.openai.com/api-keys |
| Google Gemini | https://aistudio.google.com/app/apikey |
| Anthropic | https://console.anthropic.com/ |

Les clés sont stockées de manière **chiffrée** sur votre appareil.

## Structure des variables d'environnement

Aucune `.env` n'est nécessaire. Toutes les clés sont gérées par l'utilisateur dans l'app.

## Tests

```bash
# Tests unitaires
flutter test

# Tests avec couverture
flutter test --coverage

# Analyse statique
flutter analyze
```

## Build de production

```bash
# iOS
flutter build ios --release

# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release
```

## Problèmes courants

### `isar_generator` introuvable

```bash
dart pub global activate build_runner
dart run build_runner build --delete-conflicting-outputs
```

### Erreur de permissions microphone (iOS)

Ajoutez dans `ios/Runner/Info.plist` :

```xml
<key>NSMicrophoneUsageDescription</key>
<string>MesCalories utilise le microphone pour la saisie vocale des repas.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>MesCalories utilise la reconnaissance vocale pour analyser vos repas.</string>
```

### Erreur de permissions caméra (iOS)

```xml
<key>NSCameraUsageDescription</key>
<string>MesCalories utilise la caméra pour photographier vos repas.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>MesCalories accède à vos photos pour analyser vos repas.</string>
```
