import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notif {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidinitialize =
        new AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettings =
        new InitializationSettings(android: androidinitialize);
    WidgetsFlutterBinding.ensureInitialized();
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlaformChannelSpecifies =
        new AndroidNotificationDetails(
      'You-can name-it',
      'channel name',
      playSound: true,
      //sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );
    var not = NotificationDetails(android: androidPlaformChannelSpecifies);
    await fln.show(0, title, body, not);
  }
}
