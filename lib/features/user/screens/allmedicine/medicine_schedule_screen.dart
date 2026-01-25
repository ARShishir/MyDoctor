// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../widgets/empty_state_widget.dart';
import '../../../../backend/supabase/repository.dart';

/// ===============================
/// MEDICINE SCHEDULE SCREEN
/// ===============================
class MedicineScheduleScreen extends StatefulWidget {
  const MedicineScheduleScreen({super.key});

  @override
  State<MedicineScheduleScreen> createState() => _MedicineScheduleScreenState();
}

class _MedicineScheduleScreenState extends State<MedicineScheduleScreen> {
  List<Map<String, dynamic>> _schedules = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    setState(() => _loading = true);
    try {
      final items = await SupabaseRepository.fetchMedicines();
      // transform DB items to local representation
      final mapped = items.map((e) {
        String timeStr = e['time'] ?? '08:00';
        final parts = timeStr.split(':');
        final hour = int.tryParse(parts[0]) ?? 8;
        final minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
        return {
          'id': e['id'],
          'medicine': e['medicine'],
          'dosage': e['dosage'],
          'time': TimeOfDay(hour: hour, minute: minute),
          'frequency': e['frequency'] ?? '',
          'color': e['color'] ?? '#FF2196F3',
          'taken': e['taken'] ?? false,
        };
      }).toList();
      setState(() => _schedules = mapped);
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final takenCount = _schedules.where((e) => e['taken'] == true).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('আজকের ঔষধ'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// Progress Card
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: _ProgressCard(total: _schedules.length, taken: takenCount),
          ),

          /// Search bar
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMedium),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ঔষধ খুঁজুন...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  // Dynamic filtering
                  // We'll filter in _buildGroupedSchedules
                });
              },
            ),
          ),

          const SizedBox(height: 12),

          /// Medicine List
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _schedules.isNotEmpty
                    ? ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingMedium),
                        children: _buildGroupedSchedules(context),
                      )
                    : const EmptyStateWidget(
                        icon: Icons.medical_services_outlined,
                        title: 'কোনো ঔষধ নেই',
                        subtitle: 'নতুন ঔষধ যোগ করুন',
                      ),
          ),
        ],
      ),

          floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_medicine',
        icon: const Icon(Icons.add),
        label: const Text('নতুন ঔষধ'),
        onPressed: () async {
          final result = await showDialog<Map<String, dynamic>>(
            context: context,
            builder: (_) => const AddMedicineDialog(),
          );

              if (result != null) {
                // convert to DB payload
                final time = result['time'] as TimeOfDay;
                final hh = time.hour.toString().padLeft(2, '0');
                final mm = time.minute.toString().padLeft(2, '0');
                final color = result['color'] as Color;
                final colorHex = '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
                final payload = {
                  'medicine': result['medicine'],
                  'dosage': result['dosage'],
                  'frequency': result['frequency'],
                  'time': '$hh:$mm',
                  'color': colorHex,
                  'taken': result['taken'] ?? false,
                };
                try {
                  await SupabaseRepository.addMedicine(payload);
                  await _loadMedicines();
                } catch (_) {}
              }
        },
      ),
    );
  }

  /// Group medicines by time
  List<Widget> _buildGroupedSchedules(BuildContext context) {
    final morning = _schedules.where((e) => e['time'].hour < 12).toList();
    final afternoon =
        _schedules.where((e) => e['time'].hour >= 12 && e['time'].hour < 18).toList();
    final night = _schedules.where((e) => e['time'].hour >= 18).toList();

    final Map<String, List<Map<String, dynamic>>> groups = {
      '🌅 সকাল': morning,
      '🌞 দুপুর': afternoon,
      '🌙 রাত': night,
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
                      final newVal = !_schedules[index]['taken'];
                      setState(() => _schedules[index]['taken'] = newVal);
                      // persist
                      final id = _schedules[index]['id'];
                      if (id != null) {
                        SupabaseRepository.updateMedicineTaken(id, newVal).catchError((_) {});
                      }
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
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('আজকের অগ্রগতি', style: Theme.of(context).textTheme.titleMedium),
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

  const MedicineCard({super.key, required this.data, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final taken = data['taken'] as bool;
    Color _parseColor(dynamic v) {
      if (v is int) return Color(v);
      if (v is String) {
        final s = v.replaceFirst('#', '');
        try {
          return Color(int.parse('0x$s'));
        } catch (_) {}
      }
      return Colors.blue;
    }

    final color = _parseColor(data['color']);

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
                _TimeBlock(time: data['time'], color: color),
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
                              color: Colors.green, fontWeight: FontWeight.w600),
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
            Text(data['medicine'], style: Theme.of(context).textTheme.titleLarge),
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
          Text(time.format(context),
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

/// ---------------- ADD MEDICINE DIALOG ----------------
class AddMedicineDialog extends StatefulWidget {
  const AddMedicineDialog({super.key});

  @override
  State<AddMedicineDialog> createState() => _AddMedicineDialogState();
}

class _AddMedicineDialogState extends State<AddMedicineDialog> {
  final _medicineController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  Color _selectedColor = Colors.blue;

  Future<void> _pickTime() async {
    final time = await showTimePicker(context: context, initialTime: _selectedTime);
    if (time != null) setState(() => _selectedTime = time);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('নতুন ঔষধ যোগ করুন'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _medicineController,
              decoration: const InputDecoration(labelText: 'ঔষধের নাম'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _dosageController,
              decoration: const InputDecoration(labelText: 'ডোজ'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _frequencyController,
              decoration: const InputDecoration(labelText: 'নিয়ম'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _pickTime,
                  icon: const Icon(Icons.access_time),
                  label: Text('সময়: ${_selectedTime.format(context)}'),
                ),
                const SizedBox(width: 16),
                DropdownButton<Color>(
                  value: _selectedColor,
                  items: const [
                    DropdownMenuItem(value: Colors.blue, child: Text('Blue')),
                    DropdownMenuItem(value: Colors.redAccent, child: Text('Red')),
                    DropdownMenuItem(value: Colors.green, child: Text('Green')),
                    DropdownMenuItem(value: Colors.purple, child: Text('Purple')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _selectedColor = value);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('বাতিল')),
        ElevatedButton(
            onPressed: () {
              if (_medicineController.text.isEmpty || _dosageController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('সব তথ্য পূরণ করুন')),
                );
                return;
              }

              Navigator.pop(context, {
                'medicine': _medicineController.text,
                'dosage': _dosageController.text,
                'frequency': _frequencyController.text.isEmpty
                    ? 'প্রতিদিন'
                    : _frequencyController.text,
                'time': _selectedTime,
                'color': _selectedColor,
                'taken': false,
              });
            },
            child: const Text('সংরক্ষণ')),
      ],
    );
  }
}
