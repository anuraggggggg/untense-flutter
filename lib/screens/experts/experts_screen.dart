import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/counsellor_provider.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/counsellor_card.dart';

/// Experts tab — live API integration with shimmer loading & filters.
class ExpertsScreen extends StatefulWidget {
  const ExpertsScreen({super.key});

  @override
  State<ExpertsScreen> createState() => _ExpertsScreenState();
}

class _ExpertsScreenState extends State<ExpertsScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CounsellorProvider>().fetchCounsellors();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSortBottomSheet(BuildContext context) {
    final provider = context.read<CounsellorProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(99.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Sort Counsellors',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.h),
              _SortTile(
                title: 'Highest Rating',
                subtitle: 'Sort by top user ratings',
                icon: Icons.star_rounded,
                selected: provider.sortBy == 'rating',
                onTap: () {
                  provider.setSortBy('rating');
                  Navigator.pop(ctx);
                },
              ),
              SizedBox(height: 10.h),
              _SortTile(
                title: 'Price: Low to High',
                subtitle: 'Most affordable sessions first',
                icon: Icons.arrow_downward_rounded,
                selected: provider.sortBy == 'price_low',
                onTap: () {
                  provider.setSortBy('price_low');
                  Navigator.pop(ctx);
                },
              ),
              SizedBox(height: 10.h),
              _SortTile(
                title: 'Price: High to Low',
                subtitle: 'Premium expert consultants first',
                icon: Icons.arrow_upward_rounded,
                selected: provider.sortBy == 'price_high',
                onTap: () {
                  provider.setSortBy('price_high');
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CounsellorProvider>();
    final counsellors = provider.filteredCounsellors;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => provider.fetchCounsellors(),
          color: AppColors.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Find experts', style: AppTextStyles.headlineLarge)
                            .animate()
                            .fadeIn(duration: 350.ms),
                        IconButton(
                          onPressed: () => _showSortBottomSheet(context),
                          icon: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Icon(
                              Icons.tune_rounded,
                              color: AppColors.primary,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Psychologists, therapists, counsellors & coaches.',
                      style: AppTextStyles.bodyMedium,
                    ),
                    SizedBox(height: 16.h),

                    // Search Bar with Clear Button
                    SoftCard(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 2.h,
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => provider.setSearchQuery(val),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search by name, category or specialty',
                          hintStyle: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textMuted,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: AppColors.textMuted,
                            size: 22.sp,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.cancel_rounded,
                                    color: AppColors.textMuted,
                                    size: 18.sp,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    provider.setSearchQuery('');
                                  },
                                )
                              : null,
                          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // Dynamic Filter Category Chips
                    SizedBox(
                      height: 36.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.categories.length,
                        separatorBuilder: (_, index) => SizedBox(width: 8.w),
                        itemBuilder: (context, index) {
                          final filter = provider.categories[index];
                          final selected = filter == provider.selectedCategory;
                          return GestureDetector(
                            onTap: () => provider.setSelectedCategory(filter),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(99),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                              child: Text(
                                filter,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: selected
                                      ? AppColors.textOnPrimary
                                      : AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Content List: Shimmer Loading vs Counsellor List
              Expanded(
                child: provider.isLoading
                    ? ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 120.h),
                        itemCount: 4,
                        separatorBuilder: (_, index) => SizedBox(height: 12.h),
                        itemBuilder: (_, index) => const _ShimmerCounsellorCard(),
                      )
                    : counsellors.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 48.sp,
                                  color: AppColors.textMuted,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'No experts match your query.',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Try selecting a different category or clearing your search.',
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 120.h),
                            itemCount: counsellors.length,
                            separatorBuilder: (_, index) =>
                                SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              final counsellor = counsellors[index];
                              return CounsellorCard(
                                counsellor: counsellor,
                                onViewProfile: () {
                                  context.push(
                                    AppRoutes.counsellorDetailPath(counsellor.id),
                                  );
                                },
                              )
                                  .animate()
                                  .fadeIn(
                                    delay: (50 * index).ms,
                                    duration: 350.ms,
                                  )
                                  .slideY(
                                    begin: 0.05,
                                    end: 0,
                                    delay: (50 * index).ms,
                                  );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shimmer Skeleton Loading Widget
class _ShimmerCounsellorCard extends StatelessWidget {
  const _ShimmerCounsellorCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54.w,
                height: 54.w,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(18.r),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 140.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 90.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Container(
                width: 70.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(99.r),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 90.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(99.r),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            height: 1.h,
            color: AppColors.border,
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 60.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              Container(
                width: 85.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat()).shimmer(
          duration: 1200.ms,
          color: AppColors.primary.withValues(alpha: 0.12),
        );
  }
}

class _SortTile extends StatelessWidget {
  const _SortTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? AppColors.primary : AppColors.textMuted,
              size: 22.sp,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                      color: selected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }
}
