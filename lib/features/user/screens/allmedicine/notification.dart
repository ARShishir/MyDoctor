import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 🔁 CHANGE THIS IMPORT TO YOUR ACTUAL DASHBOARD FILE
import '../user_dashboard_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'title': 'ঔষধ নেওয়ার সময় হয়েছে',
      'message': 'সকাল ৮:০০ টায় Napa 500mg নেওয়ার সময় হয়েছে।',
      'date': DateTime.now().subtract(const Duration(minutes: 10)),
      'read': false,
      'icon': Icons.medication_outlined,
      'type': 'medicine',
    },
    {
      'id': 2,
      'title': 'ডাক্তারের অ্যাপয়েন্টমেন্ট',
      'message': 'আজ বিকাল ৪:০০ টায় ডা. রহমানের সাথে অ্যাপয়েন্টমেন্ট আছে।',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'read': false,
      'icon': Icons.calendar_month_outlined,
      'type': 'appointment',
    },
    {
      'id': 3,
      'title': 'ঔষধ সম্পন্ন',
      'message': 'আপনি আজকের সব ঔষধ সময়মতো নিয়েছেন।',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'read': true,
      'icon': Icons.check_circle_outline,
      'type': 'success',
    },
  ];

  Timer? _timer;
  int _nextNotificationId = 4;

  @override
  void initState() {
    super.initState();
    // প্রতি 1 মিনিট পর নতুন notification add হবে
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _addAutoNotification();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _addAutoNotification() {
    final now = DateTime.now();
    setState(() {
      _notifications.insert(0, {
        'id': _nextNotificationId++,
        'title': 'নতুন আপডেট',
        'message': 'নতুন notification ${_nextNotificationId - 1}',
        'date': now,
        'read': false,
        'icon': Icons.notifications,
        'type': 'auto',
      });
    });

    // Optional: Haptic feedback when new notification arrives
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Group notifications by date
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    final todayNotifications = _notifications
        .where((n) =>
            n['date'].year == today.year &&
            n['date'].month == today.month &&
            n['date'].day == today.day)
        .toList();

    final yesterdayNotifications = _notifications
        .where((n) =>
            n['date'].year == yesterday.year &&
            n['date'].month == yesterday.month &&
            n['date'].day == yesterday.day)
        .toList();

    final olderNotifications = _notifications
        .where((n) =>
            n['date'].isBefore(yesterday) &&
            !(n['date'].year == yesterday.year &&
                n['date'].month == yesterday.month &&
                n['date'].day == yesterday.day))
        .toList();

    final hasData = _notifications.isNotEmpty;

    return WillPopScope(
      onWillPop: () async {
        _goHome(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          centerTitle: true,
          backgroundColor: colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => _goHome(context),
          ),
          actions: [
            if (_notifications.any((n) => !n['read']))
              TextButton(
                  onPressed: _markAllAsRead, child: const Text('Mark all'))
          ],
        ),
        body: hasData
            ? ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (todayNotifications.isNotEmpty)
                    _buildSection('Today', todayNotifications),
                  if (yesterdayNotifications.isNotEmpty)
                    _buildSection('Yesterday', yesterdayNotifications),
                  if (olderNotifications.isNotEmpty)
                    _buildSection('Older', olderNotifications),
                ],
              )
            : const _EmptyState(),
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...notifications.map((n) => _DismissibleNotificationCard(
              key: ValueKey(n['id']),
              data: n,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  n['read'] = true;
                });
              },
              onDelete: () {
                setState(() {
                  _notifications.removeWhere((e) => e['id'] == n['id']);
                });
              },
            )),
        const SizedBox(height: 16),
      ],
    );
  }

  void _goHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const UserDashboardScreen()),
      (route) => false,
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n['read'] = true;
      }
    });
  }
}

/// ---------------- Dismissible Notification Card ----------------
class _DismissibleNotificationCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _DismissibleNotificationCard({
    required super.key,
    required this.data,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRead = data['read'];
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey(data['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) => onDelete(),
      child: Opacity(
        opacity: isRead ? 0.6 : 1,
        child: Card(
          elevation: isRead ? 1 : 4,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(data['icon'], color: colorScheme.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                data['title'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isRead
                                      ? FontWeight.w500
                                      : FontWeight.w700,
                                ),
                              ),
                            ),
                            if (!isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          data['message'],
                          style: TextStyle(
                              color: Colors.grey[700], height: 1.4),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _formatTimeSince(data['date']),
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimeSince(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) return '${difference.inHours} hr ago';
    return '${difference.inDays} day ago';
  }
}

/// ---------------- EMPTY ----------------
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_off_outlined,
              size: 72, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No notifications',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text('You’re all caught up!',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
