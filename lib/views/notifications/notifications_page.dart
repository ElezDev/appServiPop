// lib/views/notifications/notifications_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:servipopapp/views/auth/providers/notification_provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final provider = context.read<NotificationProvider>();
    if (provider.notifications.isEmpty) {
      await provider.fetchNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<NotificationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          if (provider.unreadCount > 0)
            IconButton(
              icon: const Icon(Icons.mark_as_unread),
              onPressed: () async {
                try {
                  await provider.markAllAsRead();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Todas las notificaciones marcadas como leídas'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
        ],
      ),
      body: _buildBody(provider, theme),
    );
  }

  Widget _buildBody(NotificationProvider provider, ThemeData theme) {
    if (provider.isLoading && provider.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              provider.error!,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: provider.fetchNotifications,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (provider.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_off, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No hay notificaciones',
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.fetchNotifications,
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: provider.notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final notification = provider.notifications[index];
          return _buildNotificationItem(notification, theme, provider);
        },
      ),
    );
  }

  Widget _buildNotificationItem(
  AppNotification notification,
  ThemeData theme,
  NotificationProvider provider,
) {
  return Card(
    elevation: 2,
    color: notification.isRead
        ? theme.cardColor
        : theme.colorScheme.primary.withOpacity(0.05),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        if (!notification.isRead) {
          await provider.markAsRead(notification.id);
        }
        // Aquí puedes añadir navegación a la reserva/detalle
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar del remitente o icono de notificación
                if (notification.senderAvatar != null)
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(notification.senderAvatar!),
                  )
                else
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getNotificationColor(notification.type, theme),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getNotificationIcon(notification.type),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: notification.isRead
                                    ? theme.textTheme.titleMedium?.color
                                    : theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      if (notification.senderName != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            'De: ${notification.senderName}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              notification.message,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd MMM yyyy, hh:mm a')
                      .format(notification.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                if (notification.bookingCode != null)
                  Text(
                    'Código: ${notification.bookingCode}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'booking_created':
        return Icons.calendar_today;
      case 'booking_accepted':
        return Icons.check_circle;
      case 'booking_rejected':
        return Icons.cancel;
      case 'review_added':
        return Icons.message;
      case 'payment':
        return Icons.payment;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type, ThemeData theme) {
    switch (type) {
      case 'booking_created':
        return Colors.blue;
      case 'booking_accepted':
        return Colors.green;
      case 'booking_rejected':
        return Colors.red;
      case 'review_added':
        return Colors.purple;
      case 'payment':
        return Colors.orange;
      default:
        return theme.colorScheme.primary;
    }
  }
}