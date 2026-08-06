import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../providers/onboarding_provider.dart';

/// Coordinates PageController with [OnboardingProvider].
/// Keeps animation / navigation logic out of the UI layer.
class OnboardingController {
  OnboardingController(this._provider);

  final OnboardingProvider _provider;
  late final PageController pageController;

  void init({int initialPage = 0}) {
    pageController = PageController(initialPage: initialPage);
  }

  void dispose() {
    pageController.dispose();
  }

  void onPageChanged(int index) {
    _provider.setPage(index);
  }

  Future<void> goToNext() async {
    if (_provider.isLastPage) {
      await _provider.completeOnboarding();
      return;
    }

    await pageController.nextPage(
      duration: AppConstants.pageAnimationDuration,
      curve: AppConstants.pageAnimationCurve,
    );
  }

  Future<void> goToPrevious() async {
    if (_provider.isFirstPage) return;

    await pageController.previousPage(
      duration: AppConstants.pageAnimationDuration,
      curve: AppConstants.pageAnimationCurve,
    );
  }

  Future<void> skip() async {
    await _provider.skipOnboarding();
  }

  Future<void> getStarted() async {
    await _provider.completeOnboarding();
  }
}
