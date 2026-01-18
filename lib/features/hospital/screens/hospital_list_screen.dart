import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../hospital/screens/hospital_profile_screen.dart';
class NearbyServicesScreen extends StatelessWidget {
  const NearbyServicesScreen({super.key});

  final List<Map<String, dynamic>> _services = const [
    {
      'name': 'City Care Hospital',
      'type': 'Hospital',
      'distance': '1.2 km',
      'rating': 4.5,
      'isOpen': true,
      'color': Colors.blue,
      'icon': Icons.local_hospital,
      'phone': '01712-345678',
      'address': 'ধানমন্ডি, ঢাকা',
      'openHours': '24/7',
    },
    {
      'name': 'Lifeline Diagnostic Center',
      'type': 'Diagnostic',
      'distance': '800 m',
      'rating': 4.2,
      'isOpen': true,
      'color': Colors.purple,
      'icon': Icons.biotech,
      'phone': '01712-345678',
      'address': 'মিরপুর, ঢাকা',
      'openHours': '24 Hours',
    },
    {
      'name': 'Green Pharmacy',
      'type': 'Pharmacy',
      'distance': '500 m',
      'rating': 4.6,
      'isOpen': true,
      'color': Colors.green,
      'icon': Icons.local_pharmacy,
      'phone': '01712-345678',
      'address': 'বনানী, ঢাকা',
      'openHours': '24 Hours',
    },
    {
      'name': 'Health Plus Clinic',
      'type': 'Clinic',
      'distance': '2.1 km',
      'rating': 4.7,
      'isOpen': true,
      'color': Colors.orange,
      'icon': Icons.medical_services,
      'phone': '01712-345678',
      'address': 'উত্তরা, ঢাকা',
      'openHours': '9 AM - 10 PM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('কাছাকাছি সেবা'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'হাসপাতাল, ফার্মেসি খুঁজুন...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor:
                          colorScheme.surfaceContainerHighest.withOpacity(0.4),
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMedium,
              ),
              itemCount: _services.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HospitalProfileScreen(
                          // service: _services[index],
                        ),
                      ),
                    );
                  },
                  child: _ServiceCard(service: _services[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add hospital',
        icon: const Icon(Icons.add),
        label: const Text('নতুন হাসপাতাল'),
        onPressed: () {},
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final color = service['color'] as Color;

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
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(service['icon'], color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['name'],
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      service['type'],
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              _OpenStatus(isOpen: service['isOpen']),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.location_on,
                  size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(service['distance']),
              const SizedBox(width: 16),
              const Icon(Icons.star,
                  size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(service['rating'].toString()),
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
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
