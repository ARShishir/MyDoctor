import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../widgets/empty_state_widget.dart';

class LocalPharmacyScreen extends StatelessWidget {
  const LocalPharmacyScreen({super.key});

  // Dummy pharmacy data
  final List<Map<String, dynamic>> _pharmacies = const [
    {
      'name': 'Green Life Pharmacy',
      'distance': '300 m',
      'rating': 4.6,
      'isOpen': true,
      'phone': '01234-567890',
      'color': Colors.green,
    },
    {
      'name': 'City Medico',
      'distance': '750 m',
      'rating': 4.2,
      'isOpen': true,
      'phone': '01700-111222',
      'color': Colors.teal,
    },
    {
      'name': 'Care Plus Pharmacy',
      'distance': '1.4 km',
      'rating': 4.0,
      'isOpen': false,
      'phone': '01888-999000',
      'color': Colors.blue,
    },
    {
      'name': 'Health Mart',
      'distance': '2.0 km',
      'rating': 4.8,
      'isOpen': true,
      'phone': '01999-333444',
      'color': Colors.greenAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasData = _pharmacies.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('কাছাকাছি ফার্মেসি'),
        centerTitle: true,
      ),

      /// ===============================
      /// BODY
      /// ===============================
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'ফার্মেসি খুঁজুন...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor:
                          colorScheme.surfaceVariant.withOpacity(0.4),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusLarge),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filledTonal(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          Expanded(
            child: hasData
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingMedium,
                    ),
                    itemCount: _pharmacies.length,
                    itemBuilder: (context, index) {
                      final pharmacy = _pharmacies[index];
                      return _PharmacyCard(pharmacy: pharmacy);
                    },
                  )
                : const EmptyStateWidget(
                    icon: Icons.local_pharmacy_outlined,
                    title: 'কোনো ফার্মেসি পাওয়া যায়নি',
                    subtitle: 'লোকেশন পরিবর্তন করে আবার চেষ্টা করুন',
                  ),
          ),
        ],
      ),

      /// ===============================
      /// FLOATING ACTION BUTTON
      /// ===============================
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add pharmacy',
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('নতুন ফার্মেসি'),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('নতুন ফার্মেসি যোগ ফিচার শীঘ্রই আসছে'),
            ),
          );
        },
      ),
    );
  }
}

class _PharmacyCard extends StatelessWidget {
  final Map<String, dynamic> pharmacy;
  const _PharmacyCard({required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    final color = pharmacy['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_pharmacy,
                  color: color,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  pharmacy['name'],
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              _OpenStatus(isOpen: pharmacy['isOpen']),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Icon(Icons.location_on,
                  size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(pharmacy['distance']),
              const SizedBox(width: 16),
              const Icon(Icons.star,
                  size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(pharmacy['rating'].toString()),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.call),
                  label: const Text('কল'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color,
                    side: BorderSide(color: color),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${pharmacy['phone']} এ কল করা হচ্ছে...'),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.directions),
                  label: const Text('দিকনির্দেশ'),
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
        ],
      ),
    );
  }
}

class _OpenStatus extends StatelessWidget {
  final bool isOpen;
  const _OpenStatus({required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOpen
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isOpen ? 'খোলা আছে' : 'বন্ধ',
        style: TextStyle(
          color: isOpen ? Colors.green : Colors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
