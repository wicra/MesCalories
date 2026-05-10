# Contribuer à MesCalories

Merci de vouloir contribuer ! Ce guide explique comment participer au projet.

## Code de conduite

- Soyez respectueux et bienveillant
- Toute discrimination est interdite
- Revues de code constructives uniquement

## Prérequis

Voir [setup.md](setup.md) pour l'installation de l'environnement.

## Processus de contribution

### 1. Fork et clone

```bash
git clone https://github.com/VOTRE_USERNAME/MesCalories.git
cd MesCalories
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 2. Créer une branche

```bash
git checkout -b feat/ma-nouvelle-fonctionnalite
# ou
git checkout -b fix/correction-bug
```

Convention de nommage :
- `feat/` — nouvelle fonctionnalité
- `fix/` — correction de bug
- `refactor/` — refactoring sans changement de comportement
- `docs/` — documentation uniquement
- `test/` — ajout/modification de tests

### 3. Développer

Respectez l'architecture Clean Architecture et les conventions du projet.

```bash
# Vérifier l'analyse statique avant commit
flutter analyze

# Lancer les tests
flutter test

# Formater le code
dart format lib/
```

### 4. Commit

Utilisez la convention [Conventional Commits](https://www.conventionalcommits.org/) :

```
feat: ajouter l'analyse photo via Gemini Vision
fix: corriger le calcul du TDEE pour les femmes
docs: mettre à jour le setup.md
refactor: extraire le widget MacroCard dans shared/
```

### 5. Pull Request

1. Poussez votre branche : `git push origin feat/ma-fonctionnalite`
2. Ouvrez une PR vers `main`
3. Remplissez le template de PR
4. Attendez la revue de code

## Standards de code

### Architecture

- Toujours respecter les 3 couches : `data` / `domain` / `presentation`
- Pas de logique métier dans les widgets
- Pas d'appels directs à l'API IA depuis l'UI
- Les entités domain ne doivent pas importer de packages Flutter

### Dart/Flutter

- Types forts obligatoires (pas de `dynamic` sauf justification)
- Prefer `const` constructeurs
- Utiliser `sealed class` pour les états
- Riverpod : pas de `ref.read` dans `build()`, toujours `ref.watch`

### Tests

Chaque nouvelle feature doit inclure :
- Tests unitaires pour les usecases/repositories
- Tests widget pour les composants réutilisables
- Pas d'obligation pour les pages complètes (MVP)

```
test/
├── features/
│   ├── tracking/
│   │   ├── domain/
│   │   │   └── repositories/tracking_repository_test.dart
│   │   └── presentation/
│   │       └── providers/tracking_provider_test.dart
│   └── auth/
│       └── domain/
│           └── repositories/user_profile_repository_test.dart
└── core/
    └── network/
        └── ai_nutrition_service_test.dart
```

## Types de contributions bienvenus

- 🐛 Corrections de bugs
- ✨ Nouvelles fonctionnalités de la Roadmap
- 🌍 Traductions (autres langues)
- 🎨 Améliorations UI/UX
- 📚 Documentation
- ♻️ Refactoring et optimisations
- ✅ Tests unitaires

## Questions et discussions

Ouvrez une [GitHub Discussion](https://github.com/wicra/MesCalories/discussions) pour :
- Proposer de nouvelles idées
- Demander des clarifications
- Partager votre expérience utilisateur
