import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

/// Service de notifications locales — rappels repas quotidiens.
class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  // Identifiants de canaux
  static const _channelId = 'meal_reminders';
  static const _channelName = 'Rappels de repas';
  static const _channelDesc = 'Rappels quotidiens pour logger vos repas';

  // Identifiants de notifications
  static const _lunchId = 1001;
  static const _dinnerId = 1002;

  // ---------------------------------------------------------------------------
  // Initialisation
  // ---------------------------------------------------------------------------

  static Future<void> initialize() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    _initialized = true;
  }

  // ---------------------------------------------------------------------------
  // Permissions
  // ---------------------------------------------------------------------------

  static Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestNotificationsPermission() ?? false;
  }

  // ---------------------------------------------------------------------------
  // Planification
  // ---------------------------------------------------------------------------

  /// Programme les deux rappels quotidiens (déjeuner + dîner).
  static Future<void> scheduleMealReminders({
    int lunchHour = 12,
    int lunchMinute = 0,
    int dinnerHour = 19,
    int dinnerMinute = 0,
  }) async {
    await cancelMealReminders();

    await _scheduleDailyAt(
      id: _lunchId,
      hour: lunchHour,
      minute: lunchMinute,
      title: 'Heure du déjeuner 🥗',
      body: 'Pensez à logger votre repas dans MesCalories !',
    );

    await _scheduleDailyAt(
      id: _dinnerId,
      hour: dinnerHour,
      minute: dinnerMinute,
      title: 'Heure du dîner 🍽',
      body: 'Avez-vous noté votre repas du soir ?',
    );
  }

  static Future<void> cancelMealReminders() async {
    await _plugin.cancel(_lunchId);
    await _plugin.cancel(_dinnerId);
  }

  // ---------------------------------------------------------------------------
  // Interne
  // ---------------------------------------------------------------------------

  static Future<void> _scheduleDailyAt({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
