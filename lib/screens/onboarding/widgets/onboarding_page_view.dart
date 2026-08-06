import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../models/onboarding_page_model.dart';
import 'onboarding_illustrations.dart';

/// A single onboarding page — illustration + title + subtitle.
class OnboardingPageView extends StatelessWidget {
  const OnboardingPageView({
    super.key,
    required this.page,
    required this.index,
  });

  final OnboardingPageModel page;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: OnboardingIllustration(type: page.illustrationType),
          ),
          Flexible(
            flex: 3,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 4.h),
                  Text(
                    page.title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.displayMedium.copyWith(fontSize: 32.sp),
                  )
                      .animate(key: ValueKey('title-$index'))
                      .fadeIn(duration: 450.ms, curve: Curves.easeOut)
                      .slideY(
                        begin: 0.18,
                        end: 0,
                        duration: 500.ms,
                        curve: Curves.easeOutCubic,
                      ),
                  SizedBox(height: 12.h),
                  Text(
                    page.subtitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 16.sp,
                      height: 1.55,
                    ),
                  )
                      .animate(key: ValueKey('subtitle-$index'))
                      .fadeIn(
                        delay: 80.ms,
                        duration: 450.ms,
                        curve: Curves.easeOut,
                      )
                      .slideY(
                        begin: 0.14,
                        end: 0,
                        delay: 80.ms,
                        duration: 500.ms,
                        curve: Curves.easeOutCubic,
                      ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
