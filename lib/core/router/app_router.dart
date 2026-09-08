import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/auth/auth_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../global/auth_global.dart';
import '../../screens/dashboard/dashboard_shell.dart';
import '../../screens/experts/experts_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/sessions/sessions_screen.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/experts/counsellor_detail_screen.dart';
import '../../screens/wallet/wallet_screen.dart';
import '../../screens/call/audio_call_screen.dart';
import '../../screens/call/video_call_screen.dart';
import '../constants/app_constants.dart';

/// Central GoRouter configuration for UnTense.
abstract final class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    refreshListenable: authProvider,
    redirect: (context, state) {
      final isLoggedIn = authProvider.isLoggedIn;
      final location = state.matchedLocation;
      // If not logged in, redirect to auth unless already on auth, register, splash, or onboarding
      if (!isLoggedIn &&
          location != AppRoutes.auth &&
          location != AppRoutes.register &&
          location != AppRoutes.splash &&
          location != AppRoutes.onboarding) {
        return AppRoutes.auth;
      }
      // If logged in and trying to access login, register, splash or onboarding, redirect to home
      if (isLoggedIn &&
          (location == AppRoutes.auth ||
              location == AppRoutes.register ||
              location == AppRoutes.splash ||
              location == AppRoutes.onboarding)) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AuthScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final offset = Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: offset, child: child),
            );
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final offset = Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: offset, child: child),
            );
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.counsellorDetail,
        name: 'counsellorDetail',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return CounsellorDetailScreen(counsellorId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.wallet,
        name: 'wallet',
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: AppRoutes.audioCall,
        name: 'audioCall',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return AudioCallScreen(
            channelName: extra['channelName'] ?? 'untense_audio_channel',
            userName: extra['userName'] ?? 'Expert Counsellor',
            userTitle: extra['userTitle'] ?? 'Mental Wellness Expert',
            avatarUrl: extra['avatarUrl'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.videoCall,
        name: 'videoCall',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return VideoCallScreen(
            channelName: extra['channelName'] ?? 'untense_video_channel',
            userName: extra['userName'] ?? 'Expert Counsellor',
            userTitle: extra['userTitle'] ?? 'Mental Wellness Expert',
            avatarUrl: extra['avatarUrl'],
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return DashboardShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.experts,
                name: 'experts',
                builder: (context, state) => const ExpertsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.sessions,
                name: 'sessions',
                builder: (context, state) => const SessionsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
