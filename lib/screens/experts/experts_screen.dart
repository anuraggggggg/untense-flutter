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

/// Experts tab — discover trusted professionals.
class ExpertsScreen extends StatefulWidget {
  const ExpertsScreen({super.key});

  @override
  State<ExpertsScreen> createState() => _ExpertsScreenState();
}

class _ExpertsScreenState extends State<ExpertsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CounsellorProvider>();
    final counsellors = provider.filteredCounsellors;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Find experts', style: AppTextStyles.headlineLarge)
                      .animate()
                      .fadeIn(duration: 350.ms),
                  SizedBox(height: 6.h),
                  Text(
                    'Psychologists, therapists, counsellors & coaches.',
                    style: AppTextStyles.bodyMedium,
                  ),
                  SizedBox(height: 18.h),
                  SoftCard(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 4.h,
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => provider.setSearchQuery(val),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search by name or specialty',
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
                        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
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
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : counsellors.isEmpty
                      ? Center(
                          child: Text(
                            'No counsellors match your search.',
                            style: AppTextStyles.bodyMedium,
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
                                  delay: (60 * index).ms,
                                  duration: 350.ms,
                                )
                                .slideY(
                                  begin: 0.06,
                                  end: 0,
                                  delay: (60 * index).ms,
                                );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

