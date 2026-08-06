import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../models/onboarding_page_model.dart';

/// Holds onboarding state — page index and completion.
/// UI must not contain business logic; all state lives here.
class OnboardingProvider extends ChangeNotifier {
  OnboardingProvider({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;
  int _currentPage = 0;
  bool _isCompleted = false;
  bool _isInitialized = false;

  int get currentPage => _currentPage;
  bool get isCompleted => _isCompleted;
  bool get isInitialized => _isInitialized;
  bool get isLastPage =>
      _currentPage >= OnboardingContent.pages.length - 1;
  bool get isFirstPage => _currentPage == 0;
  int get pageCount => OnboardingContent.pages.length;
  OnboardingPageModel get currentPageData =>
      OnboardingContent.pages[_currentPage];
  List<OnboardingPageModel> get pages => OnboardingContent.pages;

  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    _isCompleted =
        _prefs!.getBool(AppConstants.prefsOnboardingComplete) ?? false;
    _isInitialized = true;
    notifyListeners();
  }

  void setPage(int index) {
    if (index < 0 || index >= pageCount || index == _currentPage) return;
    _currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    if (isLastPage) return;
    _currentPage += 1;
    notifyListeners();
  }

  void previousPage() {
    if (isFirstPage) return;
    _currentPage -= 1;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool(AppConstants.prefsOnboardingComplete, true);
    _isCompleted = true;
    notifyListeners();
  }

  Future<void> skipOnboarding() => completeOnboarding();

  Future<void> resetOnboarding() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.remove(AppConstants.prefsOnboardingComplete);
    _isCompleted = false;
    _currentPage = 0;
    notifyListeners();
  }
}
