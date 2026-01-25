// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../backend/supabase/repository.dart';
import 'pharmacy_profile_screen.dart';

class LocalPharmacyScreen extends StatefulWidget {
  const LocalPharmacyScreen({super.key});

  @override
  State<LocalPharmacyScreen> createState() => _LocalPharmacyScreenState();
}

class _LocalPharmacyScreenState extends State<LocalPharmacyScreen> {
  List<Map<String, dynamic>> _pharmacies = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadPharmacies();
  }

  Future<void> _loadPharmacies() async {
    setState(() => _loading = true);
    try {
      final items = await SupabaseRepository.fetchServices(type: 'Pharmacy');
      final mapped = items.map((e) => {
            'id': e['id'],
            'name': e['name'],
            'type': e['type'],
            'distance': e['distance'],
            'rating': e['rating'],
            'isOpen': e['is_open'] ?? true,
            'color': e['color'],
            'phone': e['phone'],
            'address': e['address'],
            'openHours': e['open_hours'],
          }).toList();
      setState(() => _pharmacies = mapped);
    } catch (_) {}
    setState(() => _loading = false);
  }

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final filteredPharmacies = _pharmacies.where((pharmacy) {
      final name = pharmacy['name'].toString().toLowerCase();
      final type = pharmacy['type'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || type.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('কাছাকাছি ফার্মেসি'),
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

          // Pharmacies List or Empty State
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : filteredPharmacies.isNotEmpty
                    ? ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingMedium),
                    itemCount: filteredPharmacies.length,
                    itemBuilder: (context, index) {
                      final pharmacy = filteredPharmacies[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PharmacyProfileScreen(pharmacy: pharmacy),
                            ),
                          );
                        },
                        child: _PharmacyCard(pharmacy: pharmacy),
                      );
                    },
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_pharmacy_outlined,
                              size: 80, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'কোনো ফার্মেসি পাওয়া যায়নি',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'লোকেশন পরিবর্তন করে আবার চেষ্টা করুন',
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
        heroTag: 'add pharmacy',
        icon: const Icon(Icons.add),
        label: const Text('নতুন ফার্মেসি'),
        onPressed: () {
          _showAddPharmacyDialog(context);
        },
      ),
    );
  }

  void _showAddPharmacyDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final distanceController = TextEditingController();
    final openHoursController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('নতুন ফার্মেসি যোগ করুন'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'নাম')),
              TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'ফোন নম্বর')),
              TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'ঠিকানা')),
              TextField(
                  controller: distanceController,
                  decoration:
                      const InputDecoration(labelText: 'দূরত্ব (e.g., 1.2 km)')),
              TextField(
                  controller: openHoursController,
                  decoration: const InputDecoration(
                      labelText: 'সেবা সময় (e.g., 8 AM - 10 PM)')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('বাতিল')),
          ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  final payload = {
                    'name': nameController.text,
                    'type': 'Pharmacy',
                    'distance': distanceController.text.isNotEmpty
                        ? distanceController.text
                        : '0 km',
                    'rating': 0.0,
                    'is_open': true,
                    'color': '#FF4CAF50',
                    'phone': phoneController.text,
                    'address': addressController.text,
                    'open_hours': openHoursController.text.isNotEmpty
                        ? openHoursController.text
                        : '24/7',
                  };
                  try {
                    await SupabaseRepository.addService(payload);
                    await _loadPharmacies();
                  } catch (_) {}
                  Navigator.pop(context);
                }
              },
              child: const Text('সংরক্ষণ')),
        ],
      ),
    );
  }
}

class _PharmacyCard extends StatelessWidget {
  final Map<String, dynamic> pharmacy;
  const _PharmacyCard({required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    Color _parseColor(dynamic v) {
      if (v is int) return Color(v);
      if (v is String) {
        final s = v.replaceFirst('#', '');
        try {
          return Color(int.parse('0x$s'));
        } catch (_) {}
      }
      return Colors.green;
    }

    final color = _parseColor(pharmacy['color']);

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
              offset: const Offset(0, 6)),
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
                    color: color.withOpacity(0.15), shape: BoxShape.circle),
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
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(pharmacy['distance']),
              const SizedBox(width: 16),
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(pharmacy['rating'].toString()),
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
        color: isOpen ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isOpen ? 'খোলা আছে' : 'বন্ধ',
        style: TextStyle(
            color: isOpen ? Colors.green : Colors.red, fontWeight: FontWeight.w600),
      ),
    );
  }
}
