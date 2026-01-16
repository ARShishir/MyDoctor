import 'dart:async';
import 'package:flutter/material.dart';
import 'allmedicine/medical_documents_screen.dart';  
import 'allmedicine/notification.dart';
import '../../auth/screens/login_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final String userName = "Abdur Rahman";
  final String userBio = "Flutter Developer • Health Tech Enthusiast\nDhaka, Bangladesh";
  final String profileImage = "https://avatars.githubusercontent.com/u/136100734?v=4";

  final int posts = 342;
  final int followers = 15420;
  final int following = 389;

  final List<Map<String, dynamic>> _medicalDocs = const [
    {
      'title': 'Blood Test Report',
      'date': '১৫ জানুয়ারি ২০২৬',
      'type': 'Lab Report',
      'fileType': 'PDF',
      'color': Colors.blue,
    },
    {
      'title': 'Chest X-Ray',
      'date': '০৮ জানুয়ারি ২০২৬',
      'type': 'Imaging',
      'fileType': 'JPG',
      'color': Colors.redAccent,
    },
    {
      'title': 'Doctor Prescription',
      'date': '০৫ জানুয়ারি ২০২৬',
      'type': 'Prescription',
      'fileType': 'PNG',
      'color': Colors.green,
    },
  ];

  // Auto-scroll এর জন্য কন্ট্রোলার
  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_scrollController.hasClients) {
        final currentOffset = _scrollController.offset;
        final maxOffset = _scrollController.position.maxScrollExtent;

        // যদি শেষের দিকে চলে যায় তাহলে শুরুতে ফিরে আসবে (infinite illusion)
        if (currentOffset >= maxOffset - 10) {
          _scrollController.jumpTo(0);
        } else {
          // প্রতি ১ সেকেন্ডে ১২০ pixels করে স্ক্রল (smooth feel এর জন্য)
          _scrollController.animateTo(
            currentOffset + 120,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // হেডার (SliverAppBar) – আগের মতোই রাখা হয়েছে
          SliverAppBar(
            expandedHeight: 240.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDark
                            ? [Colors.blueGrey.shade900, Colors.black87]
                            : [colorScheme.primary.withOpacity(0.82), colorScheme.primary.withOpacity(0.28)],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.55)],
                              ),
                            ),
                            padding: const EdgeInsets.all(3),
                            child: CircleAvatar(
                              radius: 44,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 41,
                                backgroundImage: NetworkImage(profileImage),
                                onBackgroundImageError: (_, __) {
                                  debugPrint("Profile image failed to load");
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            userName,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            userBio,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  height: 1.2,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildStat("Posts", posts),
                              const SizedBox(width: 32),
                              _buildStat("Followers", followers),
                              const SizedBox(width: 32),
                              _buildStat("Following", following),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // মূল কনটেন্ট
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildGlassButton("Edit Profile", Icons.edit, () {})),
                      const SizedBox(width: 12),
                      Expanded(child: _buildGlassButton("Share", Icons.share, () {})),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "মেডিকেল ডকুমেন্টস",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),

                  // Auto-scrolling Infinite Horizontal List
                SizedBox(
  height: 230,
  child: Listener(
    onPointerDown: (_) {
      // যখন আঙুল দিয়ে ধরলো → auto-scroll বন্ধ
      _autoScrollTimer?.cancel();
    },
    onPointerUp: (_) {
      // আঙুল ছেড়ে দিলে → ১ সেকেন্ড পর আবার auto-scroll শুরু
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _startAutoScroll();
        }
      });
    },
    onPointerCancel: (_) {
      // যদি কোনো কারণে ক্যানসেল হয় → আবার শুরু
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) _startAutoScroll();
      });
    },
    child: ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: _medicalDocs.length * 1000, // infinite illusion
      itemBuilder: (context, index) {
        final realIndex = index % _medicalDocs.length;
        final doc = _medicalDocs[realIndex];

        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            // সাধারণ ট্যাপ → ডিটেইল পেজে যাবে
            onTap: () {
              // এখানে তোমার prescription_card.dart এর DocumentCard এর লজিক বা নতুন স্ক্রিন
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DocumentDetailScreen(document: doc),
                ),
              );
              // অথবা যদি BottomSheet দেখাতে চাও:
              // showModalBottomSheet(...);
            },
            child: _buildMedicalCard(doc),
          ),
        );
      },
    ),
  ),
),

                  const SizedBox(height: 36),
                  _buildSection("About Me"),
                  const SizedBox(height: 12),
                  _buildGlassCard(
                    child: Text(
                      "ফ্লাটার + হেলথ টেক নিয়ে কাজ করি। সুন্দর UI/UX + পারফরম্যান্স নিয়ে প্যাশনেট।",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 36),
                  _buildSection("Settings"),
                  const SizedBox(height: 8),
                  ...[
                    _buildSettingsTile(
                      Icons.notifications,
                      "Notifications",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationScreen(),
                          ),
                        );
                      },
                    ),
                    _buildSettingsTile(
                Icons.logout,
                "Log Out",
                () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                isDestructive: true,
              ),

                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // বাকি সব ফাংশন আগের মতোই (এখানে শুধু প্রয়োজনীয় অংশ দেখানো হলো)
  Widget _buildStat(String label, int value) {
    return Column(
      children: [
        Text("$value", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }

  Widget _buildGlassButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.13),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.22)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalCard(Map<String, dynamic> doc) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 14, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: doc['color'].withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              doc['type'],
              style: TextStyle(color: doc['color'], fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            doc['title'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(doc['date'], style: Theme.of(context).textTheme.bodySmall),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  doc['fileType'],
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 18, offset: const Offset(0, 6)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSection(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isDestructive ? Colors.redAccent : null),
      title: Text(
        title,
        style: TextStyle(color: isDestructive ? Colors.redAccent : null, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}