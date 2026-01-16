import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';

class HospitalProfileScreen extends StatelessWidget {
  const HospitalProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
            /// HEADER CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.08),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusLarge),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_hospital,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'City Care Hospital',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Hospital',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const _OpenStatus(isOpen: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// INFO ROW
            Row(
              children: const [
                _InfoTile(
                  icon: Icons.star,
                  label: 'Rating',
                  value: '4.5',
                  color: Colors.amber,
                ),
                SizedBox(width: 12),
                _InfoTile(
                  icon: Icons.location_on,
                  label: 'Distance',
                  value: '1.2 km',
                  color: Colors.redAccent,
                ),
                SizedBox(width: 12),
                _InfoTile(
                  icon: Icons.schedule,
                  label: 'Hours',
                  value: '24/7',
                  color: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// CONTACT SECTION
            _SectionTitle(title: 'যোগাযোগ'),
            const SizedBox(height: 12),

            _InfoRow(
              icon: Icons.call,
              text: '01712-345678',
            ),
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.location_city,
              text: 'ধানমন্ডি, ঢাকা',
            ),

            const SizedBox(height: 24),

            /// ACTION BUTTONS
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

            /// ABOUT SECTION
            _SectionTitle(title: 'হাসপাতাল সম্পর্কে'),
            const SizedBox(height: 8),
            Text(
              'City Care Hospital একটি আধুনিক চিকিৎসা সেবা কেন্দ্র যেখানে ২৪ ঘন্টা জরুরি সেবা, বিশেষজ্ঞ ডাক্তার এবং উন্নত ডায়াগনস্টিক সুবিধা রয়েছে।',
              style: TextStyle(
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),

            const SizedBox(height: 32),

            /// BOOK APPOINTMENT
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

/// ---------------- COMPONENTS ----------------

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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
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

  const _InfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(fontSize: 15),
        ),
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
