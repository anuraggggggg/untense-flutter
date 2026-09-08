import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Professional notification, bottom sheet, and error presentation helpers.
abstract final class AppNotifications {
  /// Show professional error bottom sheet with clean bullet points and field errors
  static Future<void> showErrorBottomSheet({
    required BuildContext context,
    required String title,
    required String message,
    List<String> fieldErrors = const [],
    String buttonText = 'Got It',
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          top: 24.h,
          bottom: MediaQuery.of(ctx).padding.bottom + 24.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 44.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(99.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Header Icon & Title
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.error,
                    size: 26.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Main Message
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            // Bullet list of field errors
            if (fieldErrors.isNotEmpty) ...[
              SizedBox(height: 14.h),
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: fieldErrors
                      .map(
                        (err) => Padding(
                          padding: EdgeInsets.only(bottom: 6.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '• ',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  err,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],

            SizedBox(height: 24.h),

            // Dismiss Button
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                elevation: 0,
              ),
              child: Text(
                buttonText,
                style: AppTextStyles.button.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show professional success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_rounded, color: Colors.white, size: 18.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Show professional info / info snackbar
  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: Colors.white, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
