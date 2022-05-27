import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHandler {
  static final _notificationServerRef = FirebaseMessaging.instance;

  static Future<String?> notificatioToken = _notificationServerRef.getToken();

  NotificationHandler._();
}
