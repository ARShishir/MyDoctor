import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/user/screens/user_dashboard_screen.dart';
import '../../features/user/screens/user_profile_screen.dart';

/// -------------------------------
/// AUTH STATE
/// -------------------------------
final authProvider = StateProvider<bool>((ref) => false);

/// -------------------------------
/// APP ROUTER
/// -------------------------------
final appRouterProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(authProvider);

  final router = GoRouter(
    initialLocation: '/splash',

    redirect: (context, state) {
      final loc = state.uri.path;

      /// -------------------------------
      /// NOT LOGGED IN
      /// -------------------------------
      if (!isLoggedIn) {
        if (loc == '/splash' || loc == '/login' || loc == '/register') {
          return null;
        }
        return '/login';
      }

      /// -------------------------------
      /// LOGGED IN
      /// -------------------------------
      if (isLoggedIn) {
        // login / register → splash
        if (loc == '/login' || loc == '/register') {
          return '/splash';
        }

        // splash → user
        if (loc == '/splash') {
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

  /// 🔄 auth state change হলে router refresh
  ref.listen<bool>(authProvider, (_, __) {
    router.refresh();
  });

  return router;
});
