// ignore_for_file: prefer_const_constructors

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  static final _notificationServerRef = FirebaseMessaging.instance;

  static Future<String?> notificatioToken = _notificationServerRef.getToken();

  NotificationHandler._();

  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // define hight_importance notification channel
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
  );

  static void initialize() async {
    // create notification channel
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // function to display foreground notification
  static void display(RemoteMessage message) async {
    try {
      final notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "hight_important",
        "high important channel",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        fullScreenIntent: true,
      ));

      await _notificationsPlugin.show(
        1,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
