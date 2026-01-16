import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';

import '../../features/user/screens/user_dashboard_screen.dart';
import '../../features/doctor/screens/doctor_dashboard_screen.dart';
import '../../features/hospital/screens/hospital_dashboard_screen.dart';
import '../../features/pharmacy/screens/pharmacy_dashboard_screen.dart';
import '../../features/admin/screens/admin_dashboard_screen.dart';
import '../../features/user/screens/user_profile_screen.dart';

/// -------------------------------
/// MOCK AUTH STATE
/// -------------------------------
final authProvider = StateProvider<bool>((ref) => false);

/// -------------------------------
/// APP ROUTER
/// -------------------------------
final appRouterProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final location = state.uri.path;

      /// App open → Splash → Login
      if (location == '/') {
        return '/login';
      }

      /// Login না করলে user routes block
      if (!isLoggedIn && location.startsWith('/user')) {
        return '/login';
      }

      /// Login হয়ে গেলে আবার login page এ যাবে না
      if (isLoggedIn && location == '/login') {
        return '/user';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),

      /// Dashboards
      GoRoute(
        path: '/user',
        builder: (_, __) => const UserDashboardScreen(),
      ),
      GoRoute(
        path: '/doctor',
        builder: (_, __) => const DoctorDashboardScreen(),
      ),
      GoRoute(
        path: '/hospital',
        builder: (_, __) => const HospitalDashboardScreen(),
      ),
      GoRoute(
        path: '/pharmacy',
        builder: (_, __) => const PharmacyDashboardScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (_, __) => const AdminDashboardScreen(),
      ),

      GoRoute(
        path: '/user/profile',
        builder: (_, __) => const UserProfileScreen(),
      ),
    ],
  );
});
