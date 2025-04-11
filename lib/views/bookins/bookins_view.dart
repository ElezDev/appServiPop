// lib/features/bookings/views/bookings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:servipopapp/views/auth/providers/bookings_provider.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookingsProvider()..fetchBookings(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Bookings'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () {
                context.read<BookingsProvider>().refreshBookings();
              },
            ),
          ],
        ),
        body: const _BookingsContent(),
      ),
    );
  }
}

class _BookingsContent extends StatelessWidget {
  const _BookingsContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingsProvider>();

    if (provider.isLoading && provider.bookings.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.errorMessage),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: provider.fetchBookings,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (provider.bookings.isEmpty) {
      return const _EmptyBookingsState();
    }

    return RefreshIndicator(
      onRefresh: provider.refreshBookings,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: provider.bookings.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final booking = provider.bookings[index];
          return BookingCard(booking: booking);
        },
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final dynamic booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheduledAt = DateTime.parse(booking['scheduled_at']);
    final formattedDate = DateFormat('MMM d, y').format(scheduledAt);
    final formattedTime = DateFormat('h:mm a').format(scheduledAt);
    final duration = Duration(minutes: booking['duration']);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                StatusIndicator(status: booking['status']),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    booking['service']['title'],
                    style: theme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.surfaceVariant,
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: booking['user']['avatar'],
                      placeholder:
                          (context, url) => Icon(
                            Icons.person_rounded,
                            color: theme.colorScheme.primary,
                          ),
                      errorWidget:
                          (context, url, error) => Icon(
                            Icons.person_rounded,
                            color: theme.colorScheme.primary,
                          ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${booking['user']['name']} ${booking['user']['lastname']}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        booking['service_provider']['service_type'],
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_month_rounded, size: 20),
                const SizedBox(width: 8),
                Text(formattedDate),
                const SizedBox(width: 16),
                Icon(Icons.access_time_rounded, size: 20),
                const SizedBox(width: 8),
                Text(formattedTime),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.timer_rounded, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${duration.inHours}h ${duration.inMinutes.remainder(60)}min',
                ),
                const Spacer(),
                Text(
                  '\$${double.parse(booking['price']).toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (booking['notes'] != null && booking['notes'].isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Notes: ${booking['notes']}',
                style: theme.textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 8),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final status = booking['status'];

    if (status == 'pending') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _cancelBooking(context),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _confirmBooking(context),
              child: const Text('Confirm'),
            ),
          ),
        ],
      );
    }

    return const SizedBox();
  }

  void _cancelBooking(BuildContext context) {
    // Implement cancellation
  }

  void _confirmBooking(BuildContext context) {
    // Implement confirmation
  }
}

class StatusIndicator extends StatelessWidget {
  final String status;

  const StatusIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color color;
    IconData icon;

    switch (status) {
      case 'pending':
        color = theme.colorScheme.primaryContainer;
        icon = Icons.pending_actions_rounded;
        break;
      case 'confirmed':
        color = theme.colorScheme.secondaryContainer;
        icon = Icons.check_circle_rounded;
        break;
      case 'completed':
        color = theme.colorScheme.tertiaryContainer;
        icon = Icons.done_all_rounded;
        break;
      case 'cancelled':
        color = theme.colorScheme.errorContainer;
        icon = Icons.cancel_rounded;
        break;
      default:
        color = theme.colorScheme.surfaceVariant;
        icon = Icons.help_rounded;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, size: 18, color: theme.colorScheme.onPrimaryContainer),
    );
  }
}

class _EmptyBookingsState extends StatelessWidget {
  const _EmptyBookingsState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text('No bookings found', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Your upcoming bookings will appear here',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
