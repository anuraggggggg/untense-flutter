import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/config/agora_config.dart';

enum CallType { audio, video }

class AgoraCallService extends ChangeNotifier {
  RtcEngine? _engine;
  bool _isInitialized = false;
  bool _isJoined = false;
  int? _remoteUid;
  bool _isAudioMuted = false;
  bool _isVideoMuted = false;
  bool _isSpeakerPhone = true;
  CallType _currentCallType = CallType.audio;

  RtcEngine? get engine => _engine;
  bool get isInitialized => _isInitialized;
  bool get isJoined => _isJoined;
  int? get remoteUid => _remoteUid;
  bool get isAudioMuted => _isAudioMuted;
  bool get isVideoMuted => _isVideoMuted;
  bool get isSpeakerPhone => _isSpeakerPhone;
  CallType get currentCallType => _currentCallType;

  /// Request required runtime permissions (Mic & Camera)
  Future<bool> requestPermissions({required bool isVideo}) async {
    final statusMic = await Permission.microphone.request();
    if (!statusMic.isGranted) return false;

    if (isVideo) {
      final statusCam = await Permission.camera.request();
      if (!statusCam.isGranted) return false;
    }
    return true;
  }

  /// Initialize Agora Engine
  Future<void> initializeEngine({required CallType callType}) async {
    _currentCallType = callType;
    if (_engine != null) return;

    try {
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(
        const RtcEngineContext(
          appId: AgoraConfig.appId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      _registerEventHandlers();

      if (callType == CallType.video) {
        await _engine!.enableVideo();
        await _engine!.startPreview();
      } else {
        await _engine!.enableAudio();
      }

      await _engine!.setEnableSpeakerphone(true);

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Agora Initialization Error: $e');
    }
  }

  void _registerEventHandlers() {
    _engine?.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint('Agora: Joined channel ${connection.channelId} with uid ${connection.localUid}');
          _isJoined = true;
          notifyListeners();
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint('Agora: Remote user $remoteUid joined');
          _remoteUid = remoteUid;
          notifyListeners();
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          debugPrint('Agora: Remote user $remoteUid left. Reason: $reason');
          if (_remoteUid == remoteUid) {
            _remoteUid = null;
          }
          notifyListeners();
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          debugPrint('Agora: Left channel');
          _isJoined = false;
          _remoteUid = null;
          notifyListeners();
        },
        onError: (ErrorCodeType err, String msg) {
          debugPrint('Agora Error [$err]: $msg');
        },
      ),
    );
  }

  /// Join a channel
  Future<void> joinChannel({
    required String channelId,
    required int uid,
    String? customToken,
  }) async {
    if (_engine == null) return;

    final token = customToken ?? await AgoraConfig.getRtcToken(
      channelName: channelId,
      uid: uid,
    );

    await _engine!.joinChannel(
      token: token,
      channelId: channelId,
      uid: uid,
      options: ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
        publishCameraTrack: _currentCallType == CallType.video,
        publishMicrophoneTrack: true,
        autoSubscribeAudio: true,
        autoSubscribeVideo: _currentCallType == CallType.video,
      ),
    );
  }

  /// Mute or unmute local audio
  Future<void> toggleAudioMute() async {
    if (_engine == null) return;
    _isAudioMuted = !_isAudioMuted;
    await _engine!.muteLocalAudioStream(_isAudioMuted);
    notifyListeners();
  }

  /// Mute or unmute local video (Video Call only)
  Future<void> toggleVideoMute() async {
    if (_engine == null || _currentCallType != CallType.video) return;
    _isVideoMuted = !_isVideoMuted;
    await _engine!.muteLocalVideoStream(_isVideoMuted);
    if (_isVideoMuted) {
      await _engine!.stopPreview();
    } else {
      await _engine!.startPreview();
    }
    notifyListeners();
  }

  /// Switch front/back camera
  Future<void> switchCamera() async {
    if (_engine == null || _currentCallType != CallType.video) return;
    await _engine!.switchCamera();
  }

  /// Toggle Speakerphone / Earpiece
  Future<void> toggleSpeakerphone() async {
    if (_engine == null) return;
    _isSpeakerPhone = !_isSpeakerPhone;
    await _engine!.setEnableSpeakerphone(_isSpeakerPhone);
    notifyListeners();
  }

  /// Leave channel and clean up resources
  Future<void> leaveAndRelease() async {
    if (_engine == null) return;
    try {
      if (_isJoined) {
        await _engine!.leaveChannel();
      }
      await _engine!.release();
    } catch (e) {
      debugPrint('Error disposing Agora engine: $e');
    } finally {
      _engine = null;
      _isInitialized = false;
      _isJoined = false;
      _remoteUid = null;
      _isAudioMuted = false;
      _isVideoMuted = false;
      notifyListeners();
    }
  }
}
