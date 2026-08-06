import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/onboarding_provider.dart';

/// Brand splash — decides onboarding vs. auth entry.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final provider = context.read<OnboardingProvider>();
    await Future.wait([
      provider.initialize(),
      Future<void>.delayed(const Duration(milliseconds: 1600)),
    ]);

    if (!mounted) return;

    if (provider.isCompleted) {
      context.go(AppRoutes.auth);
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'untense_logo',
                child: Image.asset(
                  AppConstants.logoPath,
                  width: 160.w,
                  fit: BoxFit.contain,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                  .scale(
                    begin: const Offset(0.86, 0.86),
                    end: const Offset(1, 1),
                    duration: 700.ms,
                    curve: Curves.easeOutBack,
                  ),
              SizedBox(height: 20.h),
              Text(
                'Feel lighter. Feel heard.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                  letterSpacing: 0.2,
                ),
              )
                  .animate()
                  .fadeIn(delay: 350.ms, duration: 500.ms)
                  .slideY(begin: 0.2, end: 0, delay: 350.ms, duration: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}
