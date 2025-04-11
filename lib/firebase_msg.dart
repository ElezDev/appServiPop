import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMsg {
  final FirebaseMessaging msgService = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin localNotifications = 
      FlutterLocalNotificationsPlugin();

  Future<void> initFCM() async {
    // Solicitar permisos (iOS)
    await msgService.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await _setupLocalNotifications();

    var token = await msgService.getToken();
    print("Token FCM: $token");

    FirebaseMessaging.onMessage.listen(_handleForegroundNotification);
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpened);
  }

  Future<void> _setupLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await localNotifications.initialize(initializationSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', 
      'Notificaciones importantes', 
      description: 'Canal para notificaciones importantes',
      importance: Importance.high,
      playSound: true,
    );

    await localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _handleForegroundNotification(RemoteMessage message) async {
    print('Notificación en primer plano: ${message.notification?.title}');
    await _showNotification(message);
  }

  Future<void> _showNotification(RemoteMessage message) async {
    if (message.notification == null) return;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel', 
      'Notificaciones importantes',
      channelDescription: 'Canal para notificaciones importantes',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await localNotifications.show(
      0, 
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }
}

@pragma('vm:entry-point')
Future<void> _handleBackgroundNotification(RemoteMessage message) async {
  print('Notificación en segundo plano: ${message.notification?.title}');
}

Future<void> _handleNotificationOpened(RemoteMessage message) async {
  print('Notificación abierta: ${message.notification?.title}');
}