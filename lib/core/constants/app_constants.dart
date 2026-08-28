import 'package:flutter/animation.dart';

/// App-wide constants for UnTense.
abstract final class AppConstants {
  static const String appName = 'UnTense';
  static const String logoPath = 'assets/logo.png';

  // ── Spacing ────────────────────────────────────────────
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacingXxl = 48;

  // ── Radius ─────────────────────────────────────────────
  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 24;
  static const double radiusXl = 32;
  static const double radiusFull = 999;

  // ── Onboarding ─────────────────────────────────────────
  static const int onboardingPageCount = 3;
  static const Duration pageAnimationDuration = Duration(milliseconds: 420);
  static const Curve pageAnimationCurve = Curves.easeOutCubic;

  // ── Prefs keys ─────────────────────────────────────────
  static const String prefsOnboardingComplete = 'onboarding_complete';
}

/// Named routes used by GoRouter.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';

  /// Dashboard shell branches
  static const String home = '/home';
  static const String experts = '/experts';
  static const String sessions = '/sessions';
  static const String profile = '/profile';
  static const String wallet = '/wallet';
  static const String counsellorDetail = '/experts/:id';
  static String counsellorDetailPath(String id) => '/experts/$id';

  static const String audioCall = '/audio-call';
  static const String videoCall = '/video-call';
}
