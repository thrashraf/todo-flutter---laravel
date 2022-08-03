import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class Notifications {
  static final _notification = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@drawable/ic_launcher');

    const IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings settings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _notification.initialize(settings,
        onSelectNotification: onSelectedNotification);
  }

  Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          channelDescription: 'description',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          timeoutAfter: 5000,
          styleInformation: DefaultStyleInformation(true, true),
        ),
        iOS: IOSNotificationDetails());
  }

  Future scheduleNotification(
          {int id = 0,
          String? title,
          String? body,
          required DateTime dateTime}) async =>
      _notification.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(dateTime, tz.local),
        await _notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

  void onSelectedNotification(String? payload) {
    print('payload $payload');
  }
}
