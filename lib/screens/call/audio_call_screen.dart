import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../services/agora_call_service.dart';

class AudioCallScreen extends StatefulWidget {
  const AudioCallScreen({
    super.key,
    required this.channelName,
    required this.userName,
    this.userTitle = 'Mental Wellness Expert',
    this.avatarUrl,
  });

  final String channelName;
  final String userName;
  final String userTitle;
  final String? avatarUrl;

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  late AgoraCallService _callService;
  Timer? _timer;
  int _secondsElapsed = 0;
  bool _isPermissionGranted = true;

  @override
  void initState() {
    super.initState();
    _callService = AgoraCallService();
    _initCall();
  }

  Future<void> _initCall() async {
    final granted = await _callService.requestPermissions(isVideo: false);
    if (!mounted) return;
    if (!granted) {
      setState(() {
        _isPermissionGranted = false;
      });
      return;
    }

    await _callService.initializeEngine(callType: CallType.audio);
    await _callService.joinChannel(
      channelId: widget.channelName,
      uid: DateTime.now().millisecondsSinceEpoch % 100000,
    );

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_callService.isJoined && mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _endCall() async {
    _timer?.cancel();
    await _callService.leaveAndRelease();
    if (mounted) {
      context.pop();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _callService.leaveAndRelease();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _callService,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: !_isPermissionGranted
              ? _buildPermissionDeniedUI()
              : Consumer<AgoraCallService>(
                  builder: (context, callService, child) {
                    final statusText = !callService.isJoined
                        ? 'Connecting...'
                        : callService.remoteUid != null
                            ? _formatDuration(_secondsElapsed)
                            : 'Waiting for expert to join...';

                    return Stack(
                      children: [
                        // Ambient Pulsing Gradient Background
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment.center,
                                radius: 1.2,
                                colors: [
                                  Color(0xFF1E3A75),
                                  AppColors.primary,
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Content Column
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Header
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 16.h,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                    onPressed: _endCall,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 8.w,
                                        height: 8.w,
                                        decoration: BoxDecoration(
                                          color: callService.isJoined
                                              ? AppColors.secondary
                                              : Colors.amber,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Encrypted Audio Call',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 32.w),
                                ],
                              ),
                            ),

                            // Avatar & User Info
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Pulsing Avatar Container
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    if (callService.isJoined)
                                      Container(
                                        width: 170.w,
                                        height: 170.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.secondary.withValues(alpha: 0.15),
                                        ),
                                      )
                                          .animate(
                                            onPlay: (controller) => controller.repeat(),
                                          )
                                          .scaleXY(
                                            begin: 0.9,
                                            end: 1.25,
                                            duration: 1800.ms,
                                            curve: Curves.easeInOut,
                                          )
                                          .fadeOut(
                                            begin: 0.6,
                                            duration: 1800.ms,
                                          ),
                                    Container(
                                      width: 130.w,
                                      height: 130.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.secondarySoft,
                                          width: 3.w,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.secondary.withValues(alpha: 0.3),
                                            blurRadius: 24,
                                            spreadRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: widget.avatarUrl != null && widget.avatarUrl!.isNotEmpty
                                            ? Image.network(
                                                widget.avatarUrl!,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) =>
                                                    _buildAvatarFallback(),
                                              )
                                            : _buildAvatarFallback(),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24.h),
                                Text(
                                  widget.userName,
                                  style: AppTextStyles.headlineMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  widget.userTitle,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Text(
                                    statusText,
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: AppColors.secondarySoft,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Call Action Buttons Toolbar
                            Container(
                              margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 36.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 16.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(36.r),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Mute Button
                                  _buildControlButton(
                                    icon: callService.isAudioMuted
                                        ? Icons.mic_off_rounded
                                        : Icons.mic_rounded,
                                    label: callService.isAudioMuted ? 'Unmute' : 'Mute',
                                    isActive: callService.isAudioMuted,
                                    activeColor: Colors.orange,
                                    onPressed: () => callService.toggleAudioMute(),
                                  ),

                                  // End Call Button
                                  _buildControlButton(
                                    icon: Icons.call_end_rounded,
                                    label: 'End',
                                    isActive: true,
                                    activeColor: AppColors.error,
                                    iconSize: 32,
                                    onPressed: _endCall,
                                  ),

                                  // Speakerphone Button
                                  _buildControlButton(
                                    icon: callService.isSpeakerPhone
                                        ? Icons.volume_up_rounded
                                        : Icons.volume_down_rounded,
                                    label: callService.isSpeakerPhone ? 'Speaker' : 'Earpiece',
                                    isActive: callService.isSpeakerPhone,
                                    activeColor: AppColors.secondary,
                                    onPressed: () => callService.toggleSpeakerphone(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildAvatarFallback() {
    return Container(
      color: AppColors.primarySoft,
      child: Icon(
        Icons.person_rounded,
        size: 64.w,
        color: AppColors.secondarySoft,
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isActive = false,
    Color activeColor = AppColors.secondary,
    double iconSize = 24,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: isActive ? activeColor : Colors.white.withValues(alpha: 0.15),
            foregroundColor: Colors.white,
            padding: EdgeInsets.all(14.w),
          ),
          icon: Icon(icon, size: iconSize.w),
          onPressed: onPressed,
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white70,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionDeniedUI() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic_off_rounded, size: 64.w, color: AppColors.error),
            SizedBox(height: 16.h),
            Text(
              'Microphone Permission Required',
              style: AppTextStyles.headlineSmall.copyWith(color: Colors.white),
            ),
            SizedBox(height: 8.h),
            Text(
              'Please grant microphone permission in device settings to start audio calls.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
