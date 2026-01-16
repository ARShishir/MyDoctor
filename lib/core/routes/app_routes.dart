import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';

import '../../features/user/screens/user_dashboard_screen.dart';
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
    initialLocation: '/splash',

    redirect: (context, state) {
      final location = state.uri.path;

      /// -------------------------------
      /// NOT LOGGED IN
      /// -------------------------------
      if (!isLoggedIn) {
        /// splash, login, register allow
        if (location == '/splash' ||
            location == '/login' ||
            location == '/register') {
          return null;
        }

        /// block all other routes
        return '/login';
      }

      /// -------------------------------
      /// LOGGED IN
      /// -------------------------------
      if (isLoggedIn) {
        /// login/register/splash এ যেতে দিবে না
        if (location == '/login' ||
            location == '/register' ||
            location == '/splash') {
          return '/user';
        }
      }

      return null;
    },

    routes: [
      /// -------------------------------
      /// AUTH
      /// -------------------------------
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),

      /// -------------------------------
      /// USER AREA
      /// -------------------------------
      GoRoute(
        path: '/user',
        builder: (_, __) => const UserDashboardScreen(),
        routes: [
          GoRoute(
            path: 'profile',
            builder: (_, __) => const UserProfileScreen(),
          ),
        ],
      ),
    ],
  );
});
