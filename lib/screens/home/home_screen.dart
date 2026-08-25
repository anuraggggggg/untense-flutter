import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/counsellor.dart';
import '../../models/dashboard_models.dart';
import '../../providers/counsellor_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/quotes_banner.dart';
import '../dashboard/widgets/dashboard_widgets.dart';

/// Home tab — calm daily dashboard.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good morning';
    if (hour >= 12 && hour < 17) return 'Good afternoon';
    if (hour >= 17 && hour < 22) return 'Good evening';
    return 'Good night';
  }

  @override
  Widget build(BuildContext context) {
    final mood = context.watch<DashboardProvider>().selectedMood;
    final counsellors = context.watch<CounsellorProvider>().counsellors;
    final upcoming = DashboardContent.sessions
        .where((s) => s.status == SessionStatus.upcoming)
        .toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HomeHeader(greeting: _greeting)
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.08, end: 0),
                    SizedBox(height: 20.h),
                    const QuotesBanner()
                        .animate()
                        .fadeIn(delay: 50.ms, duration: 400.ms)
                        .slideY(begin: 0.08, end: 0, delay: 50.ms),
                    SizedBox(height: 20.h),
                    _MoodCheckIn(selected: mood)
                        .animate()
                        .fadeIn(delay: 100.ms, duration: 400.ms)
                        .slideY(begin: 0.08, end: 0, delay: 100.ms),
                    SizedBox(height: 24.h),
                    Text('How can we help?', style: AppTextStyles.headlineSmall),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Expanded(
                          child: QuickActionTile(
                            icon: Icons.chat_bubble_rounded,
                            label: 'Chat',
                            color: AppColors.secondary,
                            onTap: () => context.go(AppRoutes.sessions),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: QuickActionTile(
                            icon: Icons.call_rounded,
                            label: 'Audio',
                            color: AppColors.primary,
                            onTap: () => context.go(AppRoutes.sessions),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: QuickActionTile(
                            icon: Icons.videocam_rounded,
                            label: 'Video',
                            color: AppColors.secondarySoft,
                            onTap: () => context.go(AppRoutes.experts),
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: 140.ms, duration: 400.ms),
                    if (upcoming.isNotEmpty) ...[
                      SizedBox(height: 28.h),
                      SectionHeader(
                        title: 'Up next',
                        actionLabel: 'See all',
                        onAction: () => context.go(AppRoutes.sessions),
                      ),
                      SizedBox(height: 10.h),
                      SessionCard(session: upcoming.first)
                          .animate()
                          .fadeIn(delay: 180.ms, duration: 400.ms),
                    ],
                    SizedBox(height: 28.h),
                    SectionHeader(
                      title: 'Trusted experts',
                      actionLabel: 'Browse',
                      onAction: () => context.go(AppRoutes.experts),
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 128.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  itemCount: counsellors.length,
                  separatorBuilder: (_, index) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final counsellor = counsellors[index];
                    return _HomeCounsellorCard(
                      counsellor: counsellor,
                      onTap: () => context.push(
                        AppRoutes.counsellorDetailPath(counsellor.id),
                      ),
                    )
                        .animate()
                        .fadeIn(
                          delay: (200 + index * 60).ms,
                          duration: 400.ms,
                        )
                        .slideX(
                          begin: 0.08,
                          end: 0,
                          delay: (200 + index * 60).ms,
                        );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 120.h),
                child: SoftCard(
                  child: Row(
                    children: [
                      Container(
                        width: 52.w,
                        height: 52.w,
                        decoration: BoxDecoration(
                          gradient: AppColors.tealGlow,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(
                          Icons.spa_rounded,
                          color: Colors.white,
                          size: 26.sp,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'A quieter mind starts here',
                              style: AppTextStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Book a session with someone who truly listens.',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 280.ms, duration: 400.ms),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.greeting});

  final String greeting;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final walletBalance = context.watch<WalletProvider>().balance;
    final formattedBalance = walletBalance % 1 == 0
        ? '₹${walletBalance.toInt()}'
        : '₹${walletBalance.toStringAsFixed(1)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── App Bar matching mockup ─────────────────────────────
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Hamburger menu button
              Builder(
                builder: (ctx) => GestureDetector(
                  onTap: () {
                    Scaffold.of(ctx).openDrawer();
                  },
                  child: Icon(
                    Icons.menu_rounded,
                    size: 26.sp,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),

              // Center Logo + Brand Title
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppConstants.logoPath,
                    height: 32.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Untensed',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),

              // Right Wallet button
              GestureDetector(
                onTap: () => context.push(AppRoutes.wallet),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 24.sp,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      formattedBalance,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white70 : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        // Greeting subtitle
        Text(
          '$greeting,',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textMuted,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Welcome back',
          style: AppTextStyles.headlineLarge,
        ),
      ],
    );
  }
}

class _MoodCheckIn extends StatelessWidget {
  const _MoodCheckIn({required this.selected});

  final MoodType? selected;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<DashboardProvider>();

    return SoftCard(
      padding: EdgeInsets.all(18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling?',
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            selected == null
                ? 'A quick check-in helps us support you better.'
                : 'Feeling ${selected!.label.toLowerCase()} — we are here with you.',
            style: AppTextStyles.bodySmall,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              for (final mood in MoodType.values) ...[
                if (mood != MoodType.values.first) SizedBox(width: 8.w),
                Expanded(
                  child: _MoodChip(
                    mood: mood,
                    selected: selected == mood,
                    onTap: () => provider.selectMood(mood),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MoodChip extends StatelessWidget {
  const _MoodChip({
    required this.mood,
    required this.selected,
    required this.onTap,
  });

  final MoodType mood;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.secondary.withValues(alpha: 0.14)
              : AppColors.background,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected ? AppColors.secondary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(mood.emoji, style: TextStyle(fontSize: 20.sp)),
            SizedBox(height: 6.h),
            Text(
              mood.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: selected ? AppColors.primary : AppColors.textMuted,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeCounsellorCard extends StatelessWidget {
  const _HomeCounsellorCard({
    required this.counsellor,
    required this.onTap,
  });

  final Counsellor counsellor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      onTap: onTap,
      padding: EdgeInsets.all(14.w),
      child: SizedBox(
        width: 210.w,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    gradient: AppColors.brandGradient,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: counsellor.profileImage.isNotEmpty
                      ? Image.network(
                          counsellor.profileImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Text(
                              counsellor.fullName.characters.first,
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.textOnPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            counsellor.fullName.characters.first,
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.textOnPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                ),
                if (counsellor.availableNow)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.surface, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    counsellor.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    counsellor.professionalTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 14.sp,
                        color: const Color(0xFFF5B942),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${counsellor.rating}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '₹${counsellor.startingPrice.toInt()}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
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

