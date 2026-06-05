import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timer/models/scheduled_notification.dart';
import 'package:timer/models/timer_session.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
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
  }

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
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

    await notificationsPlugin.zonedSchedule(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      scheduledDate: tz.TZDateTime.from(notification.scheduledTime, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> scheduleNotifications(
    List<ScheduledNotification> notifications,
  ) async {
    DateTime now = DateTime.now();
    for (ScheduledNotification notification in notifications) {
      if (notification.scheduledTime.isAfter(now)) {
        await scheduleNotification(notification);
      } else {
        continue;
      }
    }
  }

  static List<ScheduledNotification> buildNotifications(TimerSession session) {
    List<ScheduledNotification> notifications = [];
    DateTime currentTime = session.startTime;
    int notificationId = 10000;
    for (int round = 1; round <= session.totalRounds; round++) {
      currentTime = currentTime.add(Duration(seconds: session.workSeconds));
      if (round == session.totalRounds) {
        // If it's the last round, we only need the work notification
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
      // Rest notification
      notifications.add(
        ScheduledNotification(
          id: notificationId++,
          title: 'Time to rest!',
          body: 'Round $round complete',
          scheduledTime: currentTime,
        ),
      );
      // Work notification
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
