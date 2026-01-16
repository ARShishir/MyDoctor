import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 🔁 CHANGE THIS IMPORT TO YOUR ACTUAL DASHBOARD FILE
import 'user_dashboard_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'ঔষধ নেওয়ার সময় হয়েছে',
      'message': 'সকাল ৮:০০ টায় Napa 500mg নেওয়ার সময় হয়েছে।',
      'minutesAgo': 1,
      'read': false,
      'icon': Icons.medication_outlined,
    },
    {
      'title': 'ডাক্তারের অ্যাপয়েন্টমেন্ট',
      'message': 'আজ বিকাল ৪:০০ টায় ডা. রহমানের সাথে অ্যাপয়েন্টমেন্ট আছে।',
      'minutesAgo': 20,
      'read': false,
      'icon': Icons.calendar_month_outlined,
    },
    {
      'title': 'ঔষধ সম্পন্ন',
      'message': 'আপনি আজকের সব ঔষধ সময়মতো নিয়েছেন।',
      'minutesAgo': 1440,
      'read': true,
      'icon': Icons.check_circle_outline,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final unreadCount =
        _notifications.where((e) => e['read'] == false).length;

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
            if (unreadCount > 0)
              TextButton(
                onPressed: _markAllAsRead,
                child: const Text('Mark all'),
              ),
          ],
        ),
        body: _notifications.isEmpty
            ? const _EmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final item = _notifications[index];
                  return _NotificationCard(
                    data: item,
                    timeText: _formatTime(item['minutesAgo']),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _notifications[index]['read'] = true;
                      });
                    },
                  );
                },
              ),
      ),
    );
  }

  // 🔁 ALWAYS GO TO DASHBOARD
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

  String _formatTime(int minutes) {
    if (minutes < 60) return '$minutes min ago';
    if (minutes < 1440) return '${minutes ~/ 60} hr ago';
    return '${minutes ~/ 1440} day ago';
  }
}

/// ---------------- CARD ----------------

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String timeText;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.data,
    required this.timeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRead = data['read'];
    final colorScheme = Theme.of(context).colorScheme;

    return Opacity(
      opacity: isRead ? 0.55 : 1,
      child: Card(
        elevation: isRead ? 1 : 4,
        margin: const EdgeInsets.only(bottom: 14),
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
                  child: Icon(
                    data['icon'],
                    color: colorScheme.primary,
                  ),
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
                                fontWeight:
                                    isRead ? FontWeight.w500 : FontWeight.w700,
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
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            isRead ? 'Seen $timeText' : 'Received $timeText',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
