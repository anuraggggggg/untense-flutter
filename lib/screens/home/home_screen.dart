import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_models.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/common_widgets.dart';
import '../dashboard/widgets/dashboard_widgets.dart';

/// Home tab — calm daily dashboard.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final mood = context.watch<DashboardProvider>().selectedMood;
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
                    SizedBox(height: 24.h),
                    _MoodCheckIn(selected: mood)
                        .animate()
                        .fadeIn(delay: 80.ms, duration: 400.ms)
                        .slideY(begin: 0.08, end: 0, delay: 80.ms),
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
                  itemCount: DashboardContent.featuredExperts.length,
                  separatorBuilder: (_, index) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final expert = DashboardContent.featuredExperts[index];
                    return ExpertCard(
                      expert: expert,
                      compact: true,
                      onTap: () => context.go(AppRoutes.experts),
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
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting,',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              SizedBox(height: 2.h),
              Text('Welcome back', style: AppTextStyles.headlineLarge),
            ],
          ),
        ),
        Image.asset(
          AppConstants.logoPath,
          height: 44.h,
          fit: BoxFit.contain,
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
