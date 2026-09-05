import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_text_styles.dart';
import '../providers/auth_provider.dart';
import '../providers/wallet_provider.dart';

/// Premium navigation drawer for UnTense app shell.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, this.navigationShell});

  final StatefulNavigationShell? navigationShell;

  @override
  Widget build(BuildContext context) {
    final walletBalance = context.watch<WalletProvider>().balance;
    final formattedBalance = walletBalance % 1 == 0
        ? '₹${walletBalance.toInt()}'
        : '₹${walletBalance.toStringAsFixed(1)}';

    return Drawer(
      backgroundColor: AppColors.background,
      width: 300.w,
      child: SafeArea(
        child: Column(
          children: [
            // ── Drawer Header ──────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(4.w),
                            child: Image.asset(
                              AppConstants.logoPath,
                              height: 36.h,
                              width: 36.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Untense',
                                style: AppTextStyles.headlineSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Mindfulness & Wellness',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Divider(
                        color: Colors.white.withValues(alpha: 0.2), height: 1),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 14.r,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.2),
                              child: Icon(
                                Icons.person_rounded,
                                size: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'User Profile',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Text(
                            formattedBalance,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Menu List Items ────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                children: [
                  _DrawerTile(
                    icon: Icons.home_rounded,
                    title: 'Home',
                    onTap: () {
                      Navigator.pop(context);
                      if (navigationShell != null) {
                        navigationShell!.goBranch(0);
                      } else {
                        context.go(AppRoutes.home);
                      }
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.psychology_rounded,
                    title: 'Explore Experts',
                    onTap: () {
                      Navigator.pop(context);
                      if (navigationShell != null) {
                        navigationShell!.goBranch(1);
                      } else {
                        context.go(AppRoutes.experts);
                      }
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.calendar_month_rounded,
                    title: 'My Sessions',
                    onTap: () {
                      Navigator.pop(context);
                      if (navigationShell != null) {
                        navigationShell!.goBranch(2);
                      } else {
                        context.go(AppRoutes.sessions);
                      }
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.account_balance_wallet_rounded,
                    title: 'Wallet & Balance',
                    subtitle: formattedBalance,
                    onTap: () {
                      Navigator.pop(context);
                      context.push(AppRoutes.wallet);
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.person_rounded,
                    title: 'Profile & Settings',
                    onTap: () {
                      Navigator.pop(context);
                      if (navigationShell != null) {
                        navigationShell!.goBranch(3);
                      } else {
                        context.go(AppRoutes.profile);
                      }
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(height: 1),
                  ),
                  _DrawerTile(
                    icon: Icons.shield_outlined,
                    title: 'Privacy & Security',
                    onTap: () => Navigator.pop(context),
                  ),
                  _DrawerTile(
                    icon: Icons.headset_mic_outlined,
                    title: 'Help & Support',
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // ── Logout & Version Section ───────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      await context.read<AuthProvider>().logout();
                      if (context.mounted) {
                        context.go(AppRoutes.auth);
                      }
                    },
                    borderRadius: BorderRadius.circular(14.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: Colors.red.shade600,
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Sign Out',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: Colors.red.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'UnTense v1.0.0 • Calm & Mindful Wellness',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textMuted.withValues(alpha: 0.6),
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20.sp,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              )
            : null,
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textMuted.withValues(alpha: 0.5),
          size: 18.sp,
        ),
      ),
    );
  }
}
