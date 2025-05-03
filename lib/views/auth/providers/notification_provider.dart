// lib/views/notifications/providers/notification_provider.dart
import 'package:flutter/material.dart';
import 'package:servipopapp/core/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:servipopapp/services/auth_service.dart';

class AppNotification {
  final int id;
  final int userId;
  final int? senderId;
  final String? senderName;
  final String? senderAvatar;
  final int? bookingId;
  final String? bookingCode;
  final String type;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;

  AppNotification({
    required this.id,
    required this.userId,
    this.senderId,
    this.senderName,
    this.senderAvatar,
    this.bookingId,
    this.bookingCode,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.readAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      userId: json['user_id'] ?? 0, // Asegurar un valor por defecto
      senderId: json['sender']?['id'],
      senderName: json['sender']?['name'],
      senderAvatar: json['sender']?['avatar'],
      bookingId: json['booking']?['id'],
      bookingCode: json['booking']?['code'],
      type: json['type'],
      title: json['title'],
      message: json['message'],
      isRead: json['is_read'] == 1 || json['is_read'] == true,
      createdAt: _parseDateTime(json['created_at']),
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
    );
  }

  static DateTime _parseDateTime(dynamic dateString) {
    if (dateString is String) {
      if (dateString.endsWith('ago')) {
        // Manejar formatos como "51 minutes ago" (esto es un placeholder)
        return DateTime.now().subtract(const Duration(minutes: 51));
      }
      return DateTime.parse(dateString);
    }
    return DateTime.now();
  }
}
class NotificationProvider with ChangeNotifier {
  List<AppNotification> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _error;

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  final AuthService _authService = AuthService();

   Future<void> fetchNotifications() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final token = await _authService.getToken();
      final response = await DioClient.dio.get(
        'notifications',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List<dynamic> notificationData = response.data['data']['notifications'];
      _notifications = notificationData
          .map<AppNotification>((item) => AppNotification.fromJson(item as Map<String, dynamic>))
          .toList();

      _unreadCount = response.data['meta']['unread_count'] ?? 0;
      _error = null;
    } on DioException catch (e) {
      _error = 'Error al cargar notificaciones: ${e.message}';
      _notifications = [];
      _unreadCount = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      final token = await _authService.getToken();
      await DioClient.dio.put(
        'notifications/$notificationId/read',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(
          isRead: true,
          readAt: DateTime.now(),
        );
        _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
        notifyListeners();
      }
    } on DioException catch (e) {
      throw Exception('Failed to mark notification as read: ${e.message}');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final token = await _authService.getToken();
      await DioClient.dio.put(
        'notifications/mark-all-read',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      _notifications = _notifications.map((n) {
        if (!n.isRead) {
          return n.copyWith(isRead: true, readAt: DateTime.now());
        }
        return n;
      }).toList();

      _unreadCount = 0;
      notifyListeners();
    } on DioException catch (e) {
      throw Exception('Failed to mark all notifications as read: ${e.message}');
    }
  }
}

extension NotificationCopyWith on AppNotification {
  AppNotification copyWith({
    bool? isRead,
    DateTime? readAt,
  }) {
    return AppNotification(
      id: id,
      userId: userId,
      senderId: senderId,
      bookingId: bookingId,
      type: type,
      title: title,
      message: message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      readAt: readAt ?? this.readAt,
    );
  }
}