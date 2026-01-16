import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';

class PharmacyProfileScreen extends StatelessWidget {
  final Map<String, dynamic> pharmacy;

  const PharmacyProfileScreen({
    super.key,
    required this.pharmacy,
  });

  @override
  Widget build(BuildContext context) {
    final color = pharmacy['color'] as Color;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ফার্মেসির বিস্তারিত'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===============================
            /// HEADER CARD
            /// ===============================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
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
                    child: const Icon(
                      Icons.local_pharmacy,
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
                          pharmacy['name'],
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pharmacy',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  _OpenStatus(isOpen: pharmacy['isOpen']),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ===============================
            /// INFO TILES
            /// ===============================
            Row(
              children: [
                _InfoTile(
                  icon: Icons.star,
                  label: 'Rating',
                  value: pharmacy['rating'].toString(),
                  color: Colors.amber,
                ),
                const SizedBox(width: 12),
                _InfoTile(
                  icon: Icons.location_on,
                  label: 'Distance',
                  value: pharmacy['distance'],
                  color: Colors.redAccent,
                ),
                const SizedBox(width: 12),
                _InfoTile(
                  icon: Icons.schedule,
                  label: 'Hours',
                  value: pharmacy['openHours'],
                  color: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// ===============================
            /// CONTACT INFO
            /// ===============================
            _SectionTitle(title: 'যোগাযোগ'),
            const SizedBox(height: 12),

            _InfoRow(
              icon: Icons.call,
              text: pharmacy['phone'],
            ),
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.location_city,
              text: pharmacy['address'],
            ),

            const SizedBox(height: 24),

            /// ===============================
            /// ACTION BUTTONS
            /// ===============================
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.call),
                    label: const Text('কল করুন'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: color,
                      side: BorderSide(color: color),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('${pharmacy['phone']} এ কল করা হচ্ছে...'),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                    ),
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

            /// ===============================
            /// ABOUT SECTION
            /// ===============================
            _SectionTitle(title: 'ফার্মেসি সম্পর্কে'),
            const SizedBox(height: 8),
            Text(
              '${pharmacy['name']} একটি নির্ভরযোগ্য ফার্মেসি যেখানে সব ধরনের ওষুধ এবং স্বাস্থ্যসেবা পণ্য পাওয়া যায়।',
              style: TextStyle(
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =================================================
/// COMPONENTS
/// =================================================

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
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 15),
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isOpen
            ? Colors.green.withOpacity(0.15)
            : Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isOpen ? 'খোলা আছে' : 'বন্ধ',
        style: TextStyle(
          color: isOpen ? Colors.green : Colors.red,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
