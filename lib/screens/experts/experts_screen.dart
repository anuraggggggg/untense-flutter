import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_models.dart';
import '../../widgets/common_widgets.dart';
import '../dashboard/widgets/dashboard_widgets.dart';

/// Experts tab — discover trusted professionals.
class ExpertsScreen extends StatefulWidget {
  const ExpertsScreen({super.key});

  @override
  State<ExpertsScreen> createState() => _ExpertsScreenState();
}

class _ExpertsScreenState extends State<ExpertsScreen> {
  static const _filters = [
    'All',
    'Psychologist',
    'Therapist',
    'Coach',
    'Mentor',
  ];

  String _selected = 'All';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ExpertSummary> get _filtered {
    final query = _searchController.text.trim().toLowerCase();
    return DashboardContent.featuredExperts.where((e) {
      final matchesFilter = _selected == 'All' ||
          e.role.toLowerCase().contains(_selected.toLowerCase());
      final matchesQuery = query.isEmpty ||
          e.name.toLowerCase().contains(query) ||
          e.role.toLowerCase().contains(query) ||
          e.tags.any((t) => t.toLowerCase().contains(query));
      return matchesFilter && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final experts = _filtered;

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
                    'Psychologists, therapists, coaches & mentors.',
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
                      onChanged: (_) => setState(() {}),
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
                      itemCount: _filters.length,
                      separatorBuilder: (_, index) => SizedBox(width: 8.w),
                      itemBuilder: (context, index) {
                        final filter = _filters[index];
                        final selected = filter == _selected;
                        return GestureDetector(
                          onTap: () => setState(() => _selected = filter),
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
              child: experts.isEmpty
                  ? Center(
                      child: Text(
                        'No experts match your search.',
                        style: AppTextStyles.bodyMedium,
                      ),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 120.h),
                      itemCount: experts.length,
                      separatorBuilder: (_, index) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        return ExpertCard(expert: experts[index])
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
