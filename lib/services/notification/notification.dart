// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer' as dev;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationHandler {
  static final _notificationServerRef = FirebaseMessaging.instance;
  static Future<String?> notificatioToken = _notificationServerRef.getToken();
  NotificationHandler._();

  static final onNotifications = BehaviorSubject<String?>();

  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // define hight_importance notification channel
  static AndroidNotificationChannel channel = AndroidNotificationChannel(
    'default_channel', // id
    'Default Channel', // title
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('door_bell'),
  );

  // intialize all configuration for android
  static void initialize() async {
    final androiSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    final initializationSettings =
        InitializationSettings(android: androiSettings);

    await _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    // create notification channel
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static void onSelectNotification(payload) {
    dev.log('add payload to onNotification object');
    onNotifications.add(payload);
  }

  // function to display foreground notification
  static void display(RemoteMessage message) async {
    try {
      final notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "default_channel",
        "Default Channel",
        importance: Importance.max,
        // priority: Priority.high,
        // playSound: true,
        // sound: RawResourceAndroidNotificationSound('pristine'),
        // icon: "ic_launcher", //<-- Add this parameter
      ));
      var id = DateTime.now().millisecondsSinceEpoch % 2147483648;
      dev.log('${id}');
      await _notificationsPlugin.show(id, message.notification!.title,
          message.notification!.body, notificationDetails,
          payload: json.encode(message.data));
    } on Exception catch (e) {
      dev.log('cannot show heads up message in forground');
      print(e);
    }
  }
}
