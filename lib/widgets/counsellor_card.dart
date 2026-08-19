import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../models/counsellor.dart';
import 'common_widgets.dart';

class CounsellorCard extends StatelessWidget {
  const CounsellorCard({
    super.key,
    required this.counsellor,
    required this.onViewProfile,
  });

  final Counsellor counsellor;
  final VoidCallback onViewProfile;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      onTap: onViewProfile,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Photo / Avatar
              Stack(
                children: [
                  Container(
                    width: 54.w,
                    height: 54.w,
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: counsellor.profileImage.isNotEmpty
                        ? Image.network(
                            counsellor.profileImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                              child: Text(
                                counsellor.fullName.characters.first,
                                style: AppTextStyles.headlineSmall.copyWith(
                                  color: AppColors.textOnPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              counsellor.fullName.characters.first,
                              style: AppTextStyles.headlineSmall.copyWith(
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
                        width: 14.w,
                        height: 14.w,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.surface, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            counsellor.fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                        if (counsellor.verified) ...[
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.verified_rounded,
                            size: 16.sp,
                            color: AppColors.primary,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      counsellor.professionalTitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14.sp,
                          color: AppColors.textMuted,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            '${counsellor.location} · ${counsellor.experienceYears} yrs exp',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Specialities tags
          if (counsellor.specialities.isNotEmpty)
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: counsellor.specialities
                  .take(3)
                  .map(
                    (tag) => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryMuted,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        tag,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          SizedBox(height: 14.h),
          const Divider(),
          SizedBox(height: 10.h),
          Row(
            children: [
              // Rating
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 16.sp,
                    color: const Color(0xFFF5B942),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${counsellor.rating}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    ' (${counsellor.reviewCount})',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
              const Spacer(),
              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Starts from',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11.sp,
                      color: AppColors.textMuted,
                    ),
                  ),
                  Text(
                    '₹${counsellor.startingPrice.toInt()}',
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12.w),
              // View Profile Button
              GestureDetector(
                onTap: onViewProfile,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'View Profile',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
