import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/counsellor.dart';
import '../../providers/counsellor_provider.dart';
import '../../widgets/common_widgets.dart';

class CounsellorDetailScreen extends StatefulWidget {
  const CounsellorDetailScreen({
    super.key,
    required this.counsellorId,
  });

  final String counsellorId;

  @override
  State<CounsellorDetailScreen> createState() => _CounsellorDetailScreenState();
}

class _CounsellorDetailScreenState extends State<CounsellorDetailScreen> {
  Counsellor? _counsellor;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCounsellor();
  }

  Future<void> _loadCounsellor() async {
    final provider = context.read<CounsellorProvider>();
    final found = await provider.getCounsellorById(widget.counsellorId);
    if (mounted) {
      setState(() {
        _counsellor = found;
        _isLoading = false;
      });
    }
  }

  void _showActionFeedback(String mode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$mode booking will be available soon'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _startAudioCall(Counsellor counsellor) {
    context.push(
      AppRoutes.audioCall,
      extra: {
        'channelName': 'channel_${counsellor.id}',
        'userName': counsellor.fullName,
        'userTitle': counsellor.professionalTitle,
        'avatarUrl': counsellor.profileImage,
      },
    );
  }

  void _startVideoCall(Counsellor counsellor) {
    context.push(
      AppRoutes.videoCall,
      extra: {
        'channelName': 'channel_${counsellor.id}',
        'userName': counsellor.fullName,
        'userTitle': counsellor.professionalTitle,
        'avatarUrl': counsellor.profileImage,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _counsellor?.fullName ?? 'Counsellor Profile',
          style: AppTextStyles.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _counsellor == null
              ? Center(
                  child: Text(
                    'Counsellor not found',
                    style: AppTextStyles.bodyMedium,
                  ),
                )
              : _buildProfileContent(_counsellor!),
    );
  }

  Widget _buildProfileContent(Counsellor counsellor) {
    return AmbientBackground(
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header Card
              SoftCard(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 84.w,
                            height: 84.w,
                            decoration: BoxDecoration(
                              gradient: AppColors.brandGradient,
                              borderRadius: BorderRadius.circular(28.r),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: counsellor.profileImage.isNotEmpty
                                ? Image.network(
                                    counsellor.profileImage,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Center(
                                      child: Text(
                                        counsellor.fullName.characters.first,
                                        style: AppTextStyles.displayMedium
                                            .copyWith(
                                          color: AppColors.textOnPrimary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      counsellor.fullName.characters.first,
                                      style:
                                          AppTextStyles.displayMedium.copyWith(
                                        color: AppColors.textOnPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                          ),
                          if (counsellor.availableNow)
                            Positioned(
                              right: 2,
                              bottom: 2,
                              child: Container(
                                width: 18.w,
                                height: 18.w,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.surface,
                                    width: 2.5,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            counsellor.fullName,
                            style: AppTextStyles.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (counsellor.verified) ...[
                          SizedBox(width: 6.w),
                          Icon(
                            Icons.verified_rounded,
                            size: 20.sp,
                            color: AppColors.primary,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      counsellor.professionalTitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Quick Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatItem(
                          label: 'Experience',
                          value: '${counsellor.experienceYears} Years',
                        ),
                        Container(
                          height: 24.h,
                          width: 1,
                          color: AppColors.border,
                        ),
                        _StatItem(
                          label: 'Rating',
                          value: '★ ${counsellor.rating} (${counsellor.reviewCount})',
                        ),
                        Container(
                          height: 24.h,
                          width: 1,
                          color: AppColors.border,
                        ),
                        _StatItem(
                          label: 'Age',
                          value: '${counsellor.age} yrs',
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),

              SizedBox(height: 16.h),

              // Location & Availability Card
              SoftCard(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      color: counsellor.availableNow
                          ? AppColors.secondary
                          : AppColors.primary,
                      size: 24.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            counsellor.availableNow
                                ? 'Available Now for Instant Sessions'
                                : 'Next Available Slot',
                            style: AppTextStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            counsellor.availableNow
                                ? 'Duration: ${counsellor.sessionDuration}'
                                : '${counsellor.nextAvailableSlot} (${counsellor.sessionDuration})',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 60.ms, duration: 350.ms),

              SizedBox(height: 20.h),

              // Pricing Options Section
              Text('Session Pricing', style: AppTextStyles.headlineSmall),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: _PriceCard(
                      icon: Icons.chat_bubble_outline_rounded,
                      title: 'Chat',
                      price: '₹${counsellor.chatPrice.toInt()}',
                      onTap: () => _showActionFeedback('Chat'),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _PriceCard(
                      icon: Icons.call_outlined,
                      title: 'Audio',
                      price: '₹${counsellor.audioPrice.toInt()}',
                      onTap: () => _startAudioCall(counsellor),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _PriceCard(
                      icon: Icons.videocam_outlined,
                      title: 'Video',
                      price: '₹${counsellor.videoPrice.toInt()}',
                      onTap: () => _startVideoCall(counsellor),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 100.ms, duration: 350.ms),

              SizedBox(height: 24.h),

              // About Section
              Text('About', style: AppTextStyles.headlineSmall),
              SizedBox(height: 8.h),
              SoftCard(
                child: Text(
                  counsellor.bio,
                  style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
                ),
              ),

              SizedBox(height: 20.h),

              // Specialities Section
              Text('Specialities', style: AppTextStyles.headlineSmall),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: counsellor.specialities
                    .map(
                      (spec) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryMuted,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Text(
                          spec,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

              SizedBox(height: 20.h),

              // Languages Section
              Text('Languages Spoken', style: AppTextStyles.headlineSmall),
              SizedBox(height: 8.h),
              SoftCard(
                child: Text(
                  counsellor.languages.join(', '),
                  style: AppTextStyles.bodyMedium,
                ),
              ),

              SizedBox(height: 20.h),

              // Qualifications Section
              Text('Qualifications', style: AppTextStyles.headlineSmall),
              SizedBox(height: 8.h),
              SoftCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: counsellor.qualifications
                      .map(
                        (qual) => Padding(
                          padding: EdgeInsets.only(bottom: 6.h),
                          child: Row(
                            children: [
                              Icon(
                                Icons.school_outlined,
                                size: 18.sp,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  qual,
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(fontSize: 11.sp),
        ),
      ],
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({
    required this.icon,
    required this.title,
    required this.price,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String price;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      onTap: onTap,
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 22.sp),
          SizedBox(height: 6.h),
          Text(
            title,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            price,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
