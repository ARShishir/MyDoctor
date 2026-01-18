import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../hospital/screens/hospital_profile_screen.dart';

class NearbyServicesScreen extends StatefulWidget {
  const NearbyServicesScreen({super.key});

  @override
  State<NearbyServicesScreen> createState() => _NearbyServicesScreenState();
}

class _NearbyServicesScreenState extends State<NearbyServicesScreen> {
  final List<Map<String, dynamic>> _services = [
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
      'phone': '01712-987654',
      'address': 'মিরপুর, ঢাকা',
      'openHours': '8 AM - 10 PM',
    },
    {
      'name': 'Green Pharmacy',
      'type': 'Pharmacy',
      'distance': '500 m',
      'rating': 4.6,
      'isOpen': true,
      'color': Colors.green,
      'icon': Icons.local_pharmacy,
      'phone': '01712-111222',
      'address': 'বনানী, ঢাকা',
      'openHours': '8 AM - 11 PM',
    },
    {
      'name': 'Health Plus Clinic',
      'type': 'Clinic',
      'distance': '2.1 km',
      'rating': 4.7,
      'isOpen': true,
      'color': Colors.orange,
      'icon': Icons.medical_services,
      'phone': '01712-333444',
      'address': 'উত্তরা, ঢাকা',
      'openHours': '9 AM - 10 PM',
    },
    {
      'name': 'Sunrise Hospital',
      'type': 'Hospital',
      'distance': '3.5 km',
      'rating': 4.4,
      'isOpen': false,
      'color': Colors.red,
      'icon': Icons.local_hospital,
      'phone': '01712-555666',
      'address': 'নির্বাণ, ঢাকা',
      'openHours': '24/7',
    },
    {
      'name': 'Care Diagnostics',
      'type': 'Diagnostic',
      'distance': '1.5 km',
      'rating': 4.3,
      'isOpen': true,
      'color': Colors.indigo,
      'icon': Icons.biotech,
      'phone': '01712-777888',
      'address': 'গুলশান, ঢাকা',
      'openHours': '8 AM - 8 PM',
    },
    {
      'name': 'Healthy Pharmacy',
      'type': 'Pharmacy',
      'distance': '2 km',
      'rating': 4.1,
      'isOpen': true,
      'color': Colors.teal,
      'icon': Icons.local_pharmacy,
      'phone': '01712-999000',
      'address': 'বানানী, ঢাকা',
      'openHours': '9 AM - 9 PM',
    },
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Filter services based on search query
    final filteredServices = _services.where((service) {
      final name = service['name'].toString().toLowerCase();
      final type = service['type'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || type.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('কাছাকাছি সেবা'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar + Filter
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
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

          // Services List or Empty State
          Expanded(
            child: filteredServices.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingMedium),
                    itemCount: filteredServices.length,
                    itemBuilder: (context, index) {
                      final service = filteredServices[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HospitalProfileScreen(
                                  service: service),
                            ),
                          );
                        },
                        child: _ServiceCard(service: service),
                      );
                    },
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_city_outlined,
                              size: 80, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'কোনো সেবা নেই',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'নতুন সেবা যোগ করুন',
                            style: TextStyle(color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add hospital',
        icon: const Icon(Icons.add),
        label: const Text('নতুন সেবা'),
        onPressed: () {
          _showAddServiceDialog(context);
        },
      ),
    );
  }

  void _showAddServiceDialog(BuildContext context) {
    final nameController = TextEditingController();
    final typeController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final distanceController = TextEditingController();
    final openHoursController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('নতুন সেবা যোগ করুন'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'নাম')),
              TextField(controller: typeController, decoration: const InputDecoration(labelText: 'টাইপ (Hospital/Clinic/Pharmacy/Diagnostic)')),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'ফোন নম্বর')),
              TextField(controller: addressController, decoration: const InputDecoration(labelText: 'ঠিকানা')),
              TextField(controller: distanceController, decoration: const InputDecoration(labelText: 'দূরত্ব (e.g., 1.2 km)')),
              TextField(controller: openHoursController, decoration: const InputDecoration(labelText: 'সেবা সময় (e.g., 8 AM - 10 PM)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('বাতিল')),
          ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    typeController.text.isNotEmpty) {
                  setState(() {
                    _services.add({
                      'name': nameController.text,
                      'type': typeController.text,
                      'distance': distanceController.text.isNotEmpty ? distanceController.text : '0 km',
                      'rating': 0.0,
                      'isOpen': true,
                      'color': Colors.blueGrey,
                      'icon': Icons.local_hospital,
                      'phone': phoneController.text,
                      'address': addressController.text,
                      'openHours': openHoursController.text.isNotEmpty ? openHoursController.text : '24/7',
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('সংরক্ষণ')),
        ],
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
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
                child: Icon(service['icon'], color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(service['name'], style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  Text(service['type'], style: TextStyle(color: Colors.grey[600])),
                ]),
              ),
              _OpenStatus(isOpen: service['isOpen']),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(service['distance']),
              const SizedBox(width: 16),
              const Icon(Icons.star, size: 16, color: Colors.amber),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: isOpen ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
      child: Text(isOpen ? 'খোলা' : 'বন্ধ', style: TextStyle(color: isOpen ? Colors.green : Colors.red, fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }
}
