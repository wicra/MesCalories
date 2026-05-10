# Politique de Confidentialité — MesCalories

## Principes fondamentaux

MesCalories est conçu selon les principes **Privacy by Design** :

1. **Local-First** — Vos données sont stockées sur votre appareil, pas sur nos serveurs.
2. **Aucune collecte** — Nous ne collectons aucune donnée personnelle.
3. **Transparence totale** — Le code est open source et auditable.
4. **Contrôle utilisateur** — Vous pouvez supprimer toutes vos données à tout moment.

---

## Données stockées sur votre appareil

| Donnée | Stockage | Chiffrement |
|--------|----------|-------------|
| Profil (âge, poids, taille, sexe) | Isar local | Non (lecture seule locale) |
| Historique des repas | Isar local | Non (lecture seule locale) |
| Clés API | Keychain/Keystore | **Oui (AES)** |
| Préférences (thème, objectif) | SharedPreferences | Non |

---

## Données transmises à des tiers

**La seule transmission de données externe** est l'envoi de votre description de repas au fournisseur IA que vous avez choisi et configuré vous-même.

| Cas | Donnée envoyée | Destinataire |
|-----|---------------|-------------|
| Analyse texte | Description textuelle du repas | OpenAI / Gemini / Anthropic |
| Analyse photo | Image JPEG encodée + description | OpenAI / Gemini |

**Ces données sont soumises à la politique de confidentialité du fournisseur IA choisi.**

---

## Ce que nous ne faisons PAS

- ❌ Pas de serveurs MesCalories
- ❌ Pas d'analytics
- ❌ Pas de tracking
- ❌ Pas de publicités
- ❌ Pas de monétisation des données
- ❌ Pas de clés API stockées hors de votre appareil
- ❌ Pas d'accès à vos contacts, localisation, ou autres capteurs non nécessaires

---

## Suppression des données

Pour supprimer toutes vos données :

1. **Dans l'app** : Paramètres → Données → Effacer toutes les données
2. **Clés API** : Paramètres → Clés API → Supprimer toutes les clés
3. **Complète** : Désinstallez l'application

La désinstallation supprime toutes les données Isar et SharedPreferences. Les clés du Keychain peuvent persister selon votre OS — supprimez-les manuellement via "Trousseaux" (iOS) si nécessaire.

---

## Permissions requises

| Permission | Raison | Requis |
|-----------|--------|---------|
| Microphone | Saisie vocale des repas | Optionnel |
| Caméra | Photo de repas | Optionnel |
| Photothèque | Sélection photo | Optionnel |
| Internet | Appels API IA | Requis pour l'analyse |

---

## Open Source & Audit

Le code source est disponible sur GitHub. Vous pouvez vérifier exactement ce que fait l'application :

```
https://github.com/wicra/MesCalories
```

---

*Dernière mise à jour : Mai 2026*
