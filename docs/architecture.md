# Architecture — MesCalories

## Vue d'ensemble

MesCalories suit la **Clean Architecture** combinée avec une **Feature-First Architecture**. Cette approche garantit une séparation stricte des responsabilités et une testabilité maximale.

```
lib/
├── app.dart                    # Widget racine
├── main.dart                   # Point d'entrée + initialisation
│
├── core/                       # Code partagé entre toutes les features
│   ├── constants/              # Constantes globales, enums
│   ├── errors/                 # Hiérarchie d'exceptions
│   ├── navigation/             # GoRouter (routes + shell)
│   ├── network/                # Service IA (OpenAI, Gemini, Anthropic)
│   ├── storage/                # Isar service, Preferences service
│   ├── theme/                  # Design system (couleurs, typo, thème)
│   ├── utils/                  # Providers Riverpod globaux
│   └── widgets/                # Widgets réutilisables globaux
│
├── features/                   # Une feature = un domaine métier isolé
│   ├── auth/                   # Profil utilisateur
│   ├── onboarding/             # Slides d'introduction
│   ├── tracking/               # Saisie et analyse des repas
│   ├── dashboard/              # Vue journalière
│   ├── history/                # Historique des journées
│   └── settings/               # Paramètres + clés API
│
└── shared/                     # Widgets/utils partagés inter-features
```

## Couches par feature

```
feature/
├── data/
│   ├── datasources/            # Sources de données brutes (API, BDD)
│   ├── models/                 # Modèles Isar (@Collection)
│   └── repositories/           # Implémentations des repositories
│
├── domain/
│   ├── entities/               # Entités pures (pas de dépendances)
│   ├── repositories/           # Contrats abstraits
│   └── usecases/               # Cas d'usage (logique métier)
│
└── presentation/
    ├── pages/                  # Screens Flutter
    ├── widgets/                # Widgets spécifiques à la feature
    └── providers/              # Providers Riverpod de la feature
```

## Flux de données

```
UI (Page) 
  → watch(Provider) 
    → Repository (abstraction)
      → DataSource (Isar / API IA)
        → Entité domain
```

## Gestion d'état

**Riverpod 2.x** est utilisé avec les patterns suivants :

| Pattern | Usage |
|---------|-------|
| `Provider` | Services, repositories (injectés) |
| `StreamProvider` | Données temps réel Isar (watch) |
| `AsyncNotifierProvider` | Actions asynchrones avec état |
| `NotifierProvider` | État formulaire synchrone |
| `FutureProvider` | Données chargées une fois |

## Base de données

**Isar 3.x** avec les collections :

- `UserProfileModel` — profil utilisateur (1 entrée max)
- `MealEntryModel` — entrées repas, indexées par date

## Sécurité

- Clés API : chiffrées via `flutter_secure_storage` (Keychain iOS / Keystore Android)
- Aucune donnée transmise à des serveurs tiers hors appels IA explicites
- Architecture "local-first" : tout est stocké sur l'appareil

## State management — règles

1. Les Providers `core/utils/providers.dart` déclarent les dépendances d'infrastructure
2. Chaque feature a ses propres providers dans `presentation/providers/`
3. Les providers de features consomment les providers core via `ref.watch/read`
4. Pas de `BuildContext` dans les providers
