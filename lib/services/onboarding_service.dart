import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';

/// Persists lightweight app preferences.
class OnboardingService {
  OnboardingService({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<bool> hasCompletedOnboarding() async {
    final prefs = await _instance;
    return prefs.getBool(AppConstants.prefsOnboardingComplete) ?? false;
  }

  Future<void> markOnboardingComplete() async {
    final prefs = await _instance;
    await prefs.setBool(AppConstants.prefsOnboardingComplete, true);
  }

  Future<void> resetOnboarding() async {
    final prefs = await _instance;
    await prefs.remove(AppConstants.prefsOnboardingComplete);
  }
}
