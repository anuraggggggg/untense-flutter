import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_models.dart';
import '../dashboard/widgets/dashboard_widgets.dart';

/// Sessions tab — upcoming and past support sessions.
class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final upcoming = DashboardContent.sessions
        .where((s) => s.status == SessionStatus.upcoming)
        .toList();
    final past = DashboardContent.sessions
        .where((s) => s.status != SessionStatus.upcoming)
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
                    Text('Your sessions', style: AppTextStyles.headlineLarge)
                        .animate()
                        .fadeIn(duration: 350.ms),
                    SizedBox(height: 6.h),
                    Text(
                      'Chat, audio, and video — whenever you need support.',
                      style: AppTextStyles.bodyMedium,
                    ),
                    SizedBox(height: 24.h),
                    const SectionHeader(title: 'Upcoming'),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),
            if (upcoming.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: _EmptySessions(),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                sliver: SliverList.separated(
                  itemCount: upcoming.length,
                  separatorBuilder: (_, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    return SessionCard(session: upcoming[index])
                        .animate()
                        .fadeIn(delay: (80 * index).ms, duration: 350.ms)
                        .slideY(
                          begin: 0.06,
                          end: 0,
                          delay: (80 * index).ms,
                        );
                  },
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 12.h),
                child: const SectionHeader(title: 'Past'),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 120.h),
              sliver: SliverList.separated(
                itemCount: past.length,
                separatorBuilder: (_, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  return SessionCard(session: past[index])
                      .animate()
                      .fadeIn(delay: (80 * index).ms, duration: 350.ms);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySessions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_available_rounded,
            size: 36.sp,
            color: AppColors.secondary,
          ),
          SizedBox(height: 12.h),
          Text(
            'No upcoming sessions',
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'When you book with an expert, it will show up here.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}
