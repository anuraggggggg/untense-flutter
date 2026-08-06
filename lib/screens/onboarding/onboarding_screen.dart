import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/common_widgets.dart';
import 'onboarding_controller.dart';
import 'widgets/onboarding_page_view.dart';

/// Premium three-page onboarding experience for UnTense.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final OnboardingController _controller;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<OnboardingProvider>();
    _controller = OnboardingController(provider)..init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finishAndNavigate() async {
    if (_navigating) return;
    _navigating = true;
    await _controller.getStarted();
    if (!mounted) return;
    context.go(AppRoutes.auth);
  }

  Future<void> _onSkip() async {
    if (_navigating) return;
    _navigating = true;
    await _controller.skip();
    if (!mounted) return;
    context.go(AppRoutes.auth);
  }

  Future<void> _onPrimaryPressed() async {
    final provider = context.read<OnboardingProvider>();
    if (provider.isLastPage) {
      await _finishAndNavigate();
    } else {
      await _controller.goToNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: AmbientBackground(
          child: SafeArea(
            child: Column(
              children: [
                // Top bar — logo + skip
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 12.w, 0),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'untense_logo',
                        child: Image.asset(
                          AppConstants.logoPath,
                          height: 44.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Spacer(),
                      if (!provider.isLastPage)
                        SkipButton(onPressed: _onSkip)
                            .animate()
                            .fadeIn(duration: 400.ms),
                    ],
                  ),
                ),

                // Pages
                Expanded(
                  child: PageView.builder(
                    controller: _controller.pageController,
                    onPageChanged: _controller.onPageChanged,
                    itemCount: provider.pageCount,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return OnboardingPageView(
                        page: provider.pages[index],
                        index: index,
                      );
                    },
                  ),
                ),

                // Bottom controls
                Padding(
                  padding: EdgeInsets.fromLTRB(28.w, 8.h, 28.w, 28.h),
                  child: Column(
                    children: [
                      OnboardingPageIndicator(
                        count: provider.pageCount,
                        currentIndex: provider.currentPage,
                      ),
                      SizedBox(height: 28.h),
                      PrimaryButton(
                        label: provider.isLastPage ? 'Get Started' : 'Next',
                        onPressed: _onPrimaryPressed,
                        icon: provider.isLastPage
                            ? Icons.arrow_forward_rounded
                            : null,
                      )
                          .animate(key: ValueKey(provider.isLastPage))
                          .fadeIn(duration: 280.ms)
                          .scale(
                            begin: const Offset(0.97, 0.97),
                            end: const Offset(1, 1),
                            duration: 280.ms,
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
