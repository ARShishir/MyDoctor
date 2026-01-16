import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MedicineScheduleScreen extends StatefulWidget {
  const MedicineScheduleScreen({super.key});

  @override
  State<MedicineScheduleScreen> createState() => _MedicineScheduleScreenState();
}

class _MedicineScheduleScreenState extends State<MedicineScheduleScreen> {
  final List<Map<String, dynamic>> _schedules = [
    {
      'medicine': 'Napa 500mg',
      'dosage': '১ ট্যাবলেট',
      'time': const TimeOfDay(hour: 8, minute: 0),
      'frequency': 'প্রতিদিন',
      'color': Colors.blue,
      'taken': true,
    },
    {
      'medicine': 'Vitamin C 500mg',
      'dosage': '১ ট্যাবলেট',
      'time': const TimeOfDay(hour: 9, minute: 0),
      'frequency': 'প্রতিদিন',
      'color': Colors.orange,
      'taken': false,
    },
    {
      'medicine': 'Ace 100mg',
      'dosage': '১ ট্যাবলেট',
      'time': const TimeOfDay(hour: 13, minute: 30),
      'frequency': 'প্রতিদিন',
      'color': Colors.teal,
      'taken': false,
    },
    {
      'medicine': 'Losectil 20mg',
      'dosage': '১ ক্যাপসুল',
      'time': const TimeOfDay(hour: 20, minute: 0),
      'frequency': 'রাতে খাবারের পর',
      'color': Colors.purple,
      'taken': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final takenCount = _schedules.where((e) => e['taken'] == true).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('আজকের ঔষধ'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ProgressCard(
            total: _schedules.length,
            taken: takenCount,
          ),
          const SizedBox(height: 20),
          ..._buildGroupedSchedules(context),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('নতুন ঔষধ যোগ করার ফিচার আসছে শীঘ্রই')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('নতুন ঔষধ'),
      ),
    );
  }

  List<Widget> _buildGroupedSchedules(BuildContext context) {
    final groups = {
      '🌅 সকাল': _schedules.where((e) => e['time'].hour < 12).toList(),
      '🌞 দুপুর': _schedules
          .where((e) => e['time'].hour >= 12 && e['time'].hour < 18)
          .toList(),
      '🌙 রাত': _schedules.where((e) => e['time'].hour >= 18).toList(),
    };

    return groups.entries
        .where((e) => e.value.isNotEmpty)
        .map((entry) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...entry.value.map((item) {
                  final index = _schedules.indexOf(item);
                  return MedicineCard(
                    data: item,
                    onToggle: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _schedules[index]['taken'] =
                            !_schedules[index]['taken'];
                      });
                    },
                  );
                }),
                const SizedBox(height: 16),
              ],
            ))
        .toList();
  }
}

/// ---------------- PROGRESS CARD ----------------

class _ProgressCard extends StatelessWidget {
  final int total;
  final int taken;

  const _ProgressCard({required this.total, required this.taken});

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : taken / total;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'আজকের অগ্রগতি',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(value: progress),
          ),
          const SizedBox(height: 8),
          Text('$taken / $total টি ঔষধ নেওয়া হয়েছে'),
        ],
      ),
    );
  }
}

/// ---------------- MEDICINE CARD ----------------

class MedicineCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onToggle;

  const MedicineCard({
    super.key,
    required this.data,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final bool taken = data['taken'];
    final Color color = data['color'];

    return Opacity(
      opacity: taken ? 0.55 : 1,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        elevation: taken ? 1 : 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showDetails(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _TimeBlock(
                  time: data['time'],
                  color: color,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['medicine'],
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          decoration:
                              taken ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(data['dosage']),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.repeat, size: 16),
                          const SizedBox(width: 4),
                          Text(data['frequency']),
                        ],
                      ),
                      if (taken) const SizedBox(height: 6),
                      if (taken)
                        const Text(
                          'নেয়া হয়েছে ✔',
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600),
                        ),
                    ],
                  ),
                ),
                Checkbox(
                  value: taken,
                  activeColor: color,
                  onChanged: (_) => onToggle(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['medicine'],
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text('ডোজ: ${data['dosage']}'),
            Text('সময়: ${data['time'].format(context)}'),
            Text('নিয়ম: ${data['frequency']}'),
          ],
        ),
      ),
    );
    
  }
}

/// ---------------- TIME BLOCK ----------------

class _TimeBlock extends StatelessWidget {
  final TimeOfDay time;
  final Color color;

  const _TimeBlock({required this.time, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.alarm),
          const SizedBox(height: 4),
          Text(
            time.format(context),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

