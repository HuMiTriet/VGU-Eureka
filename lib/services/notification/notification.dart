// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'package:etoet/main.dart';
import 'package:etoet/constants/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rxdart/rxdart.dart';

class NotificationHandler {
  static final _notificationServerRef = FirebaseMessaging.instance;
  static Future<String?> notificatioToken = _notificationServerRef.getToken();
  NotificationHandler._();

  static final onNotifications = BehaviorSubject<String?>();

  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // define hight_importance notification channel
  static AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('pristine'),
  );

  // intialize all configuration for android
  static void initialize() async {
    final androiSettings = AndroidInitializationSettings('ic_launcher');

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
    log('add payload to onNotification object');
    onNotifications.add(payload);
  }

  // function to display foreground notification
  static void display(RemoteMessage message) async {
    try {
      final notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "hight_important",
        "high important channel",
        importance: Importance.max,
        // priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('pristine'),
        icon: "ic_launcher", //<-- Add this parameter
      ));

      await _notificationsPlugin.show(0, message.notification!.title,
          message.notification!.body, notificationDetails,
          payload: 'friend');
    } on Exception catch (e) {
      log('cannot show heads up message in forground');
      print(e);
    }
  }
}
