<div align="center">
  <h1>🥗 MesCalories</h1>
  <p><strong>Suivi calorique par IA — Local-First · Privacy-First · Open Source</strong></p>

  <p>
    <img src="https://img.shields.io/badge/Flutter-3.27+-02569B?logo=flutter" />
    <img src="https://img.shields.io/badge/Dart-3.6+-0175C2?logo=dart" />
    <img src="https://img.shields.io/badge/License-MIT-green" />
    <img src="https://img.shields.io/badge/Platform-iOS%20%7C%20Android-lightgrey" />
  </p>

  <p>
    <img src="https://img.shields.io/badge/IA-OpenAI%20%7C%20Gemini%20%7C%20Anthropic-blueviolet" />
    <img src="https://img.shields.io/badge/Stockage-Isar%20Local-orange" />
    <img src="https://img.shields.io/badge/State-Riverpod%202.x-blue" />
  </p>
</div>

---

## 🎯 C'est quoi ?

**MesCalories** est une application mobile Flutter open source qui simplifie radicalement le suivi calorique grâce à l'intelligence artificielle.

Décrivez votre repas en une phrase ou avec votre voix → l'IA analyse, calcule les calories et les macros en quelques secondes.

**Vos données vous appartiennent.** Tout est stocké localement sur votre téléphone. Vous utilisez votre propre clé API.

---

## ✨ Fonctionnalités

### Tracking alimentaire
- 💬 **Saisie texte libre** — "J'ai mangé une omelette 3 œufs et une tartine"
- 🎙️ **Saisie vocale** — Parlez à votre téléphone, l'IA comprend
- 📸 **Photo de repas** *(MVP+)* — Vision IA pour détecter les aliments
- 🤖 **Analyse nutritionnelle complète** — Calories, protéines, glucides, lipides, fibres

### Profil & Objectifs
- 👤 **Profil personnalisé** — Âge, sexe, poids, taille
- 🧮 **Calcul BMR/TDEE automatique** — Formule Mifflin-St Jeor
- 🎯 **Objectif personnalisé** — Perte, maintien, prise de masse
- 📊 **Macros calculées automatiquement** — Distribution 30/40/30

### Dashboard
- 🔄 **Temps réel** — Mise à jour instantanée
- 📈 **Anneau de progression calories**
- 🟢 **Barres de macros** (P/G/L)
- 📋 **Liste des repas de la journée**

### Historique
- 📅 **Journées avec données**
- 🔍 **Détail de chaque journée**
- 📉 **Progression vers l'objectif**

### Paramètres & Confidentialité
- 🔑 **Vos clés API** — OpenAI, Gemini Pro, Anthropic Claude
- 🌓 **Thème clair/sombre/système**
- 🗑️ **Suppression complète des données**

---

## 🏗️ Architecture

```
Clean Architecture + Feature-First + Riverpod 2.x

lib/
├── core/           # Thème, navigation, réseau, stockage
├── features/
│   ├── auth/       # Profil utilisateur + calcul objectifs
│   ├── onboarding/ # Slides introduction
│   ├── tracking/   # Saisie + analyse IA
│   ├── dashboard/  # Vue journalière
│   ├── history/    # Historique
│   └── settings/   # Paramètres + clés API
└── shared/         # Widgets réutilisables
```

→ Voir [docs/architecture.md](docs/architecture.md) pour les détails.

---

## 🚀 Installation rapide

```bash
git clone https://github.com/wicra/MesCalories.git
cd MesCalories
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

→ Voir [docs/setup.md](docs/setup.md) pour le guide complet.

---

## 🔐 Confidentialité

- **Aucun serveur** — tout reste sur votre téléphone
- **Aucune collecte** — zéro analytics, zéro tracking
- **Clés API chiffrées** — Keychain iOS / Keystore Android
- **Open source** — auditez le code vous-même

→ Voir [docs/privacy.md](docs/privacy.md)

---

## 🧰 Stack technique

| Catégorie | Technologie |
|-----------|-------------|
| Framework | Flutter 3.27+ |
| Language | Dart 3.6+ |
| State | Riverpod 2.x |
| Navigation | GoRouter |
| Base de données | Isar 3.x |
| Sécurité | flutter_secure_storage |
| Réseau | Dio |
| Voix | speech_to_text |
| Photo | image_picker |
| Animations | flutter_animate |

---

## 🤝 Contribuer

Les contributions sont les bienvenues !

1. Fork → Branche → Développez → PR
2. Respectez la Clean Architecture
3. `flutter analyze` et `flutter test` avant le PR

→ Voir [docs/contributing.md](docs/contributing.md)

---

## 📋 Roadmap

→ Voir [docs/roadmap.md](docs/roadmap.md)

---

## 📄 Licence

MIT — libre d'utilisation, modification et distribution.

---

<div align="center">
  <p>Fait avec ❤️ pour la communauté open source française</p>
  <p><strong>Mangez bien, codez mieux.</strong></p>
</div>
