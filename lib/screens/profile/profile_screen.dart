import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

import '../../providers/auth_provider.dart';

/// Profile tab inside the dashboard shell.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await context.read<AuthProvider>().logout();
    if (!context.mounted) return;
    context.go(AppRoutes.auth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 120.h),
          children: [
            Text('Profile', style: AppTextStyles.headlineLarge)
                .animate()
                .fadeIn(duration: 350.ms),
            SizedBox(height: 20.h),
            SoftCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32.r,
                    backgroundColor: AppColors.secondaryMuted,
                    child: Icon(
                      Icons.person_rounded,
                      color: AppColors.primary,
                      size: 32.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'user@gmail.com',
                          style: AppTextStyles.headlineSmall,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Dev User',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 60.ms, duration: 350.ms),
            SizedBox(height: 20.h),
            _ProfileTile(
              icon: Icons.favorite_outline_rounded,
              title: 'Wellness preferences',
              subtitle: 'Mood reminders & goals',
              onTap: () {},
            ),
            SizedBox(height: 10.h),
            _ProfileTile(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              subtitle: 'Session alerts & check-ins',
              onTap: () {},
            ),
            SizedBox(height: 10.h),
            _ProfileTile(
              icon: Icons.lock_outline_rounded,
              title: 'Privacy & safety',
              subtitle: 'How we protect your space',
              onTap: () {},
            ),
            SizedBox(height: 10.h),
            _ProfileTile(
              icon: Icons.help_outline_rounded,
              title: 'Help & support',
              subtitle: 'FAQs and contact',
              onTap: () {},
            ),
            SizedBox(height: 28.h),
            SoftButton(
              label: 'Log Out',
              onPressed: () => _logout(context),
            ),
            SizedBox(height: 12.h),
            Text(
              'UnTense · Feel lighter. Feel heard.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.secondaryMuted,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textMuted,
            size: 22.sp,
          ),
        ],
      ),
    );
  }
}
