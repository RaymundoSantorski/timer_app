import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timer/models/scheduled_notification.dart';
import 'package:timer/models/timer_session.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
// import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    // final TimezoneInfo timezoneName = await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.local);

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/reptimer_icon');

    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
          defaultPresentAlert: true,
          defaultPresentBadge: true,
          defaultPresentSound: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await notificationsPlugin.initialize(settings: settings);

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'timer_channel_v2',
          'Timer Notifications',
          channelDescription: 'Notifications for workout timer',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await notificationsPlugin.show(
      id: 0,
      title: title,
      body: body,
      payload: null,
      notificationDetails: details,
    );
  }

  static Future<void> scheduleNotification(
    ScheduledNotification notification,
  ) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'timer_channel_v2',
          'Timer Notifications',
          channelDescription: 'Notifications for workout timer',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    final tzDate = tz.TZDateTime.from(notification.scheduledTime, tz.local);

    await notificationsPlugin.zonedSchedule(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      scheduledDate: tzDate,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> test() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'timer_channel',
          'Timer Notifications',
          channelDescription: 'Notifications for workout timer',
          importance: Importance.max,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );
    final n1 = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
    final n2 = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 15));
    final n3 = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 20));

    await notificationsPlugin.zonedSchedule(
      id: 0,
      title: 'N1',
      body: '10 seconds',
      scheduledDate: n1,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    await notificationsPlugin.zonedSchedule(
      id: 1,
      title: 'N2',
      body: '15 seconds',
      scheduledDate: n2,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    await notificationsPlugin.zonedSchedule(
      id: 02,
      title: 'N3',
      body: '20 seconds',
      scheduledDate: n3,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> scheduleNotifications(
    List<ScheduledNotification> notifications,
  ) async {
    // CLAVE: Usar la hora de la zona horaria local configurada, no la del sistema operativo
    DateTime now = tz.TZDateTime.now(tz.local);

    for (ScheduledNotification notification in notifications) {
      if (notification.scheduledTime.isAfter(now)) {
        await scheduleNotification(notification);
      }
    }
  }

  static List<ScheduledNotification> buildNotifications(TimerSession session) {
    List<ScheduledNotification> notifications = [];
    // Aseguramos que la fecha base sea TZDateTime de la zona local
    DateTime currentTime = tz.TZDateTime.from(session.startTime, tz.local);
    int notificationId = 10000;

    for (int round = 1; round <= session.totalRounds; round++) {
      currentTime = currentTime.add(Duration(seconds: session.workSeconds));
      if (round == session.totalRounds) {
        notifications.add(
          ScheduledNotification(
            id: notificationId++,
            title: 'Workout complete!',
            body: 'All rounds finished',
            scheduledTime: currentTime,
          ),
        );
        break;
      }
      notifications.add(
        ScheduledNotification(
          id: notificationId++,
          title: 'Time to rest!',
          body: 'Round $round complete',
          scheduledTime: currentTime,
        ),
      );

      currentTime = currentTime.add(Duration(seconds: session.restSeconds));
      notifications.add(
        ScheduledNotification(
          id: notificationId++,
          title: 'Time to work!',
          body: 'Start round ${round + 1}',
          scheduledTime: currentTime,
        ),
      );
    }
    return notifications;
  }

  static Future<void> scheduleSession(TimerSession session) async {
    List<ScheduledNotification> notifications = buildNotifications(session);
    await scheduleNotifications(notifications);
  }

  static Future<void> cancelAll() async {
    await notificationsPlugin.cancelAll();
  }
}
