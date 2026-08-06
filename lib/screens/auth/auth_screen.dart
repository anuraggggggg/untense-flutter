import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

/// Placeholder auth entry — wired for post-onboarding navigation.
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AmbientBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Column(
              children: [
                SizedBox(height: 48.h),
                Hero(
                  tag: 'untense_logo',
                  child: Image.asset(
                    AppConstants.logoPath,
                    height: 88.h,
                    fit: BoxFit.contain,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .scale(
                      begin: const Offset(0.94, 0.94),
                      end: const Offset(1, 1),
                      duration: 500.ms,
                    ),
                SizedBox(height: 36.h),
                Text(
                  'Welcome to UnTense',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headlineLarge,
                )
                    .animate()
                    .fadeIn(delay: 100.ms, duration: 450.ms)
                    .slideY(begin: 0.12, end: 0, delay: 100.ms),
                SizedBox(height: 12.h),
                Text(
                  'Sign in to connect with trusted experts and start feeling lighter.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge,
                )
                    .animate()
                    .fadeIn(delay: 180.ms, duration: 450.ms),
                const Spacer(),
                PrimaryButton(
                  label: 'Continue with Email',
                  onPressed: () => context.go(AppRoutes.home),
                )
                    .animate()
                    .fadeIn(delay: 260.ms, duration: 400.ms)
                    .slideY(begin: 0.1, end: 0, delay: 260.ms),
                SizedBox(height: 12.h),
                SoftButton(
                  label: 'Continue as Guest',
                  onPressed: () => context.go(AppRoutes.home),
                )
                    .animate()
                    .fadeIn(delay: 320.ms, duration: 400.ms),
                SizedBox(height: 16.h),
                Text(
                  'By continuing, you agree to our Terms & Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall,
                ),
                SizedBox(height: 28.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
