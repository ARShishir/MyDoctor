import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../widgets/user_header.dart';

import 'medical_documents_screen.dart';
import 'medicine_schedule_screen.dart';
import 'hospital_services_screen.dart';
import 'local_pharmacy.dart';
import 'notification.dart';
/// ===============================
/// DASHBOARD ACTION CARD
/// ===============================
class DashboardActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const DashboardActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}



/// ===============================
/// USER DASHBOARD SCREEN
/// ===============================
class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Doctors'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: true,
              label: const Text('3'),
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const NotificationScreen()),
                (route) => false,
              );
            },
          ),

          const SizedBox(width: 8),
        ],
      ),

      /// ===============================
      /// BODY (UNCHANGED)
      /// ===============================
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 1200));
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.all(AppDimensions.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const UserHeader(),
                    const SizedBox(height: 32),

                    Text(
                      'দ্রুত সেবা',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 16),

                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.05,
                      children: [
                        DashboardActionCard(
                          title: 'মেডিকেল ডকুমেন্ট',
                          subtitle: 'রিপোর্ট, প্রেসক্রিপশন',
                          icon:
                              Icons.medical_information_outlined,
                          color: Colors.blue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const MedicalDocumentsScreen(),
                              ),
                            );
                          },
                        ),
                        DashboardActionCard(
                          title: 'প্রেসক্রিপশন',
                          subtitle: 'সকল ঔষধের তালিকা',
                          icon: Icons.receipt_long_outlined,
                          color: Colors.teal,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const MedicineScheduleScreen(),
                              ),
                            );
                          },
                        ),
                        DashboardActionCard(
                          title: 'কাছের হাসপাতাল',
                          subtitle: 'লোকেশন অনুযায়ী',
                          icon:
                              Icons.local_hospital_outlined,
                          color: Colors.redAccent,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const NearbyServicesScreen(),
                              ),
                            );
                          },
                        ),
                       

                        DashboardActionCard(
                          title: 'ফার্মেসি',
                          subtitle: 'ঔষধ খুঁজুন',
                          icon:
                              Icons.local_pharmacy_outlined,
                          color: Colors.deepPurple,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const LocalPharmacyScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                 TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MedicineScheduleScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('সব দেখুন'),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),


                  const SizedBox(height: 40),


                    const SizedBox(height: 12),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      /// ===============================
      /// FLOATING ACTION BUTTON
      /// ===============================
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_medicine',
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('নতুন ঔষধ'),
        onPressed: () {},
      ),

      /// ===============================
      /// BOTTOM NAVIGATION BAR (NEW)
      /// ===============================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colorScheme.primary,
        onTap: (index) {
          setState(() => _currentIndex = index);

          switch (index) {
            case 0:
              break; // Dashboard (current)
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        const MedicineScheduleScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        const NearbyServicesScreen()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        const LocalPharmacyScreen()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'ড্যাশবোর্ড',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication_outlined),
            label: 'ঔষধ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital_outlined),
            label: 'হাসপাতাল',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_pharmacy_outlined),
            label: 'ফার্মেসি',
          ),
        ],
      ),
    );
  }
}
