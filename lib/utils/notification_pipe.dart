import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medsi/models/notification_model.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> establishNotificationSettings() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/launch_background');

  const IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false);

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> pushMedsiNotification(MedsiNotification curNotification,
    MedsiNotificationChannel curNotificationChannel) async {
  await flutterLocalNotificationsPlugin.show(
    curNotification.id,
    curNotification.title,
    curNotification.subject,
    NotificationDetails(
        android: AndroidNotificationDetails(
            curNotificationChannel.id, curNotificationChannel.name,
            channelDescription: curNotificationChannel.name),
        iOS: const IOSNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true)),
  );
}
