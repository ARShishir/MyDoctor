import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';

class HospitalProfileScreen extends StatelessWidget {
  final Map<String, dynamic>? service;
  const HospitalProfileScreen({super.key, this.service});

  @override
  Widget build(BuildContext context) {
  // final colorScheme = Theme.of(context).colorScheme; // Material3 required

    final name = service?['name'] ?? 'হাসপাতাল';
    final type = service?['type'] ?? 'Type';
    final rating = service?['rating'] ?? 0.0;
    final distance = service?['distance'] ?? '0 km';
    final openHours = service?['openHours'] ?? '24/7';
    final isOpen = service?['isOpen'] ?? true;
    final phone = service?['phone'] ?? '';
    final address = service?['address'] ?? '';
    final color = service?['color'] ?? Colors.blue;
    final icon = service?['icon'] ?? Icons.local_hospital;

    return Scaffold(
      appBar: AppBar(
        title: const Text('হাসপাতালের বিস্তারিত'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusLarge),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          type,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  _OpenStatus(isOpen: isOpen),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Info Row
            Row(
              children: [
                _InfoTile(
                  icon: Icons.star,
                  label: 'Rating',
                  value: rating.toString(),
                  color: Colors.amber,
                ),
                const SizedBox(width: 12),
                _InfoTile(
                  icon: Icons.location_on,
                  label: 'Distance',
                  value: distance,
                  color: Colors.redAccent,
                ),
                const SizedBox(width: 12),
                _InfoTile(
                  icon: Icons.schedule,
                  label: 'Hours',
                  value: openHours,
                  color: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Contact Section
            _SectionTitle(title: 'যোগাযোগ'),
            const SizedBox(height: 12),
            if (phone.isNotEmpty)
              _InfoRow(icon: Icons.call, text: phone),
            if (phone.isNotEmpty) const SizedBox(height: 10),
            if (address.isNotEmpty)
              _InfoRow(icon: Icons.location_city, text: address),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.call),
                    label: const Text('কল করুন'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('কল করা হচ্ছে...'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.directions),
                    label: const Text('লোকেশন'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ম্যাপ ফিচার শীঘ্রই আসছে'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // About Section
            _SectionTitle(title: 'হাসপাতাল সম্পর্কে'),
            const SizedBox(height: 8),
            Text(
              '$name একটি আধুনিক চিকিৎসা সেবা কেন্দ্র।',
              style: TextStyle(
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),

            const SizedBox(height: 32),

            // Book Appointment
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.calendar_month),
                label: const Text('অ্যাপয়েন্টমেন্ট বুক করুন'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Appointment feature coming soon'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Components
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _OpenStatus extends StatelessWidget {
  final bool isOpen;
  const _OpenStatus({required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOpen
            ? Colors.green.withOpacity(0.15)
            : Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isOpen ? 'খোলা' : 'বন্ধ',
        style: TextStyle(
          color: isOpen ? Colors.green : Colors.red,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
