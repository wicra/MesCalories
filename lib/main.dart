import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/utils/providers.dart';
import 'core/services/notification_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Localisation dates en français.
  await initializeDateFormatting('fr_FR', null);

  // SharedPreferences initialisé avant le démarrage de l'app.
  final sharedPreferences = await SharedPreferences.getInstance();

  // Notifications locales.
  await NotificationService.initialize();

  // Reprogrammer les rappels s'ils étaient activés.
  final notifEnabled =
      sharedPreferences.getBool('notifications_enabled') ?? false;
  if (notifEnabled) {
    final lunchHour =
        sharedPreferences.getInt('notification_lunch_hour') ?? 12;
    final lunchMinute =
        sharedPreferences.getInt('notification_lunch_minute') ?? 0;
    final dinnerHour =
        sharedPreferences.getInt('notification_dinner_hour') ?? 19;
    final dinnerMinute =
        sharedPreferences.getInt('notification_dinner_minute') ?? 0;
    await NotificationService.scheduleMealReminders(
      lunchHour: lunchHour,
      lunchMinute: lunchMinute,
      dinnerHour: dinnerHour,
      dinnerMinute: dinnerMinute,
    );
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MesCaloriesApp(),
    ),
  );
}
