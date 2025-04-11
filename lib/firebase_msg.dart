import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:servipopapp/core/dio_client.dart'; // Importa tu DioClient
import 'package:dio/dio.dart';
import 'package:servipopapp/services/auth_service.dart';

class FirebaseMsg {
  final FirebaseMessaging msgService = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();
  final Dio _dio = DioClient.dio;
  final AuthService _authService = AuthService();

  Future<void> initFCM() async {
    await msgService.requestPermission(alert: true, badge: true, sound: true);

    await _setupLocalNotifications();

    _setupTokenHandling();

    FirebaseMessaging.onMessage.listen(_handleForegroundNotification);
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpened);
  }

  void _setupTokenHandling() async {
    msgService.onTokenRefresh.listen(_updateTokenOnServer);

    final token = await msgService.getToken();
    if (token != null) {
      print("Token FCM: $token");
      await _updateTokenOnServer(token);
    }
  }

  Future<void> _updateTokenOnServer(String token) async {
    final accesToken = await _authService.getToken();

    try {
      final response = await _dio.post(
        'update-device-token',
        data: {'device_token': token},
        options: Options(headers: {'Authorization': 'Bearer $accesToken'}),
      );

      print('Token actualizado en el servidor: ${response.data}');
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error del servidor al actualizar token: ${e.response?.data}');
      } else {
        print('Error de conexión al actualizar token: ${e.message}');
      }
    } catch (e) {
      print('Error inesperado al actualizar token: $e');
    }
  }



  Future<void> _setupLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

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
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> _handleForegroundNotification(RemoteMessage message) async {
    print('Notificación en primer plano: ${message.notification?.title}');
    await _showNotification(message);

    // Opcional: Manejar datos adicionales
    if (message.data.isNotEmpty) {
      print('Datos adicionales: ${message.data}');
    }
  }

  Future<void> _showNotification(RemoteMessage message) async {
    final bigTextStyle = BigTextStyleInformation(
      message.notification?.body ?? '',
      htmlFormatBigText: true,
      contentTitle: message.notification?.title,
      htmlFormatContentTitle: true,
    );

    final androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'Notificaciones importantes',
      channelDescription: 'Canal para mensajes prioritarios',
      importance: Importance.max,
      priority: Priority.max,
      styleInformation: bigTextStyle,
      color: Colors.green,
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );

    await localNotifications.show(
      0,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(android: androidDetails),
      payload: message.data.toString(), 
    );
  }
}

@pragma('vm:entry-point')
Future<void> _handleBackgroundNotification(RemoteMessage message) async {
  print('Notificación en segundo plano: ${message.notification?.title}');
  // Aquí podrías mostrar una notificación local también si lo deseas
}

Future<void> _handleNotificationOpened(RemoteMessage message) async {
  print('Notificación abierta: ${message.notification?.title}');
  // Aquí puedes navegar a una pantalla específica basada en los datos
  if (message.data.isNotEmpty) {
    print('Datos de la notificación: ${message.data}');
  }
}
