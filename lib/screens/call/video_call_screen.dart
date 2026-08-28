import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../services/agora_call_service.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({
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
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
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
    final granted = await _callService.requestPermissions(isVideo: true);
    if (!mounted) return;
    if (!granted) {
      setState(() {
        _isPermissionGranted = false;
      });
      return;
    }

    await _callService.initializeEngine(callType: CallType.video);
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
        backgroundColor: Colors.black,
        body: SafeArea(
          child: !_isPermissionGranted
              ? _buildPermissionDeniedUI()
              : Consumer<AgoraCallService>(
                  builder: (context, callService, child) {
                    return Stack(
                      children: [
                        // Remote Video View or Waiting Overlay
                        Positioned.fill(
                          child: callService.remoteUid != null
                              ? AgoraVideoView(
                                  controller: VideoViewController.remote(
                                    rtcEngine: callService.engine!,
                                    canvas: VideoCanvas(uid: callService.remoteUid!),
                                    connection: RtcConnection(channelId: widget.channelName),
                                  ),
                                )
                              : _buildWaitingOverlay(callService),
                        ),

                        // Floating Local Camera Preview PIP
                        if (callService.engine != null && !callService.isVideoMuted)
                          Positioned(
                            top: 20.h,
                            right: 20.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Container(
                                width: 110.w,
                                height: 160.h,
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: AgoraVideoView(
                                  controller: VideoViewController(
                                    rtcEngine: callService.engine!,
                                    canvas: const VideoCanvas(uid: 0),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Header Bar with Back Button & Status
                        Positioned(
                          top: 16.h,
                          left: 16.w,
                          right: callService.engine != null && !callService.isVideoMuted ? 140.w : 16.w,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: _endCall,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      widget.userName,
                                      style: AppTextStyles.labelLarge.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      callService.remoteUid != null
                                          ? _formatDuration(_secondsElapsed)
                                          : 'Connecting...',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.secondarySoft,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Call Action Controls Toolbar
                        Positioned(
                          bottom: 24.h,
                          left: 20.w,
                          right: 20.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(36.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Toggle Mic
                                _buildControlButton(
                                  icon: callService.isAudioMuted
                                      ? Icons.mic_off_rounded
                                      : Icons.mic_rounded,
                                  label: callService.isAudioMuted ? 'Unmute' : 'Mute',
                                  isActive: callService.isAudioMuted,
                                  activeColor: Colors.orange,
                                  onPressed: () => callService.toggleAudioMute(),
                                ),

                                // Toggle Video
                                _buildControlButton(
                                  icon: callService.isVideoMuted
                                      ? Icons.videocam_off_rounded
                                      : Icons.videocam_rounded,
                                  label: callService.isVideoMuted ? 'Cam Off' : 'Cam On',
                                  isActive: callService.isVideoMuted,
                                  activeColor: Colors.orange,
                                  onPressed: () => callService.toggleVideoMute(),
                                ),

                                // Switch Camera
                                _buildControlButton(
                                  icon: Icons.cameraswitch_rounded,
                                  label: 'Flip',
                                  onPressed: () => callService.switchCamera(),
                                ),

                                // End Call
                                _buildControlButton(
                                  icon: Icons.call_end_rounded,
                                  label: 'End',
                                  isActive: true,
                                  activeColor: AppColors.error,
                                  iconSize: 28,
                                  onPressed: _endCall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildWaitingOverlay(AgoraCallService callService) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            Color(0xFF162A50),
            Color(0xFF081226),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.secondarySoft,
                  width: 2.w,
                ),
              ),
              child: ClipOval(
                child: widget.avatarUrl != null && widget.avatarUrl!.isNotEmpty
                    ? Image.network(
                        widget.avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildAvatarFallback(),
                      )
                    : _buildAvatarFallback(),
              ),
            ).animate(onPlay: (c) => c.repeat()).scaleXY(
                  begin: 0.95,
                  end: 1.05,
                  duration: 1500.ms,
                  curve: Curves.easeInOut,
                ),
            SizedBox(height: 24.h),
            Text(
              widget.userName,
              style: AppTextStyles.headlineSmall.copyWith(color: Colors.white),
            ),
            SizedBox(height: 8.h),
            Text(
              !callService.isJoined
                  ? 'Initializing Agora Video...'
                  : 'Waiting for expert to connect...',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
            ),
            SizedBox(height: 20.h),
            const CircularProgressIndicator(color: AppColors.secondary),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarFallback() {
    return Container(
      color: AppColors.primarySoft,
      child: Icon(
        Icons.person_rounded,
        size: 54.w,
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
    double iconSize = 22,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: isActive ? activeColor : Colors.white.withValues(alpha: 0.18),
            foregroundColor: Colors.white,
            padding: EdgeInsets.all(12.w),
          ),
          icon: Icon(icon, size: iconSize.w),
          onPressed: onPressed,
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white70,
            fontSize: 11.sp,
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
            Icon(Icons.videocam_off_rounded, size: 64.w, color: AppColors.error),
            SizedBox(height: 16.h),
            Text(
              'Camera & Mic Required',
              style: AppTextStyles.headlineSmall.copyWith(color: Colors.white),
            ),
            SizedBox(height: 8.h),
            Text(
              'Please allow camera and microphone permissions in settings for video calling.',
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
