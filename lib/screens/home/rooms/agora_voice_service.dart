import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

typedef AgoraVoidCallback = void Function();
typedef AgoraErrorCallback = void Function(String message);
typedef AgoraRemoteUserCallback = void Function(int uid);

class AgoraVoiceService extends ChangeNotifier {
  AgoraVoiceService({
    this.onTokenWillExpire,
    this.onRemoteUserJoined,
    this.onRemoteUserLeft,
    this.onError,
  });

  final AgoraVoidCallback? onTokenWillExpire;
  final AgoraRemoteUserCallback? onRemoteUserJoined;
  final AgoraRemoteUserCallback? onRemoteUserLeft;
  final AgoraErrorCallback? onError;

  RtcEngine? _engine;

  bool _initialized = false;
  bool _joined = false;
  bool _publishing = false;
  bool _muted = false;
  bool _speakerEnabled = true;

  String? _channelId;
  int? _localUid;

  final Set<int> _remoteUids = <int>{};

  bool get initialized => _initialized;
  bool get joined => _joined;
  bool get publishing => _publishing;
  bool get muted => _muted;
  bool get speakerEnabled => _speakerEnabled;

  String? get channelId => _channelId;
  int? get localUid => _localUid;
  Set<int> get remoteUids => Set.unmodifiable(_remoteUids);

  Future<void> initializeAndJoinAsAudience({
    required String appId,
    required String token,
    required String channelId,
    required int uid,
  }) async {
    if (_joined && _channelId == channelId && _localUid == uid) {
      await renewToken(token);
      return;
    }

    if (_engine != null) {
      await disposeVoice();
    }

    final engine = createAgoraRtcEngine();
    _engine = engine;

    try {
      await engine.initialize(
        RtcEngineContext(
          appId: appId,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );

      _initialized = true;
      _channelId = channelId;
      _localUid = uid;

      engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            _joined = true;
            _localUid = connection.localUid ?? uid;
            notifyListeners();
          },
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            _joined = false;
            _publishing = false;
            _remoteUids.clear();
            notifyListeners();
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            _remoteUids.add(remoteUid);
            onRemoteUserJoined?.call(remoteUid);
            notifyListeners();
          },
          onUserOffline:
              (
                RtcConnection connection,
                int remoteUid,
                UserOfflineReasonType reason,
              ) {
                _remoteUids.remove(remoteUid);
                onRemoteUserLeft?.call(remoteUid);
                notifyListeners();
              },
          onTokenPrivilegeWillExpire:
              (RtcConnection connection, String oldToken) {
                onTokenWillExpire?.call();
              },
        ),
      );

      await engine.enableAudio();

      // Voice rooms should play through the loudspeaker unless a wired /
      // Bluetooth audio device takes control of the route.
      await engine.setDefaultAudioRouteToSpeakerphone(true);

      await engine.joinChannel(
        token: token,
        channelId: channelId,
        uid: uid,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleAudience,
          autoSubscribeAudio: true,
          autoSubscribeVideo: false,
          publishMicrophoneTrack: false,
          publishCameraTrack: false,
        ),
      );

      _speakerEnabled = true;
      _publishing = false;
      _muted = false;
      notifyListeners();
    } catch (error) {
      onError?.call('Agora join failed: $error');
      rethrow;
    }
  }

  Future<bool> becomeBroadcaster({required String publisherToken}) async {
    final engine = _engine;

    if (engine == null || !_initialized) {
      onError?.call('Agora voice engine is not ready.');
      return false;
    }

    final permission = await Permission.microphone.request();

    if (!permission.isGranted) {
      onError?.call('Microphone permission is required to take a mic seat.');
      return false;
    }

    try {
      await engine.renewToken(publisherToken);

      await engine.enableLocalAudio(true);

      await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

      await engine.updateChannelMediaOptions(
        const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          autoSubscribeAudio: true,
          autoSubscribeVideo: false,
          publishMicrophoneTrack: true,
          publishCameraTrack: false,
        ),
      );

      await engine.muteLocalAudioStream(false);

      _publishing = true;
      _muted = false;
      notifyListeners();
      return true;
    } catch (error) {
      onError?.call('Unable to publish microphone audio: $error');
      return false;
    }
  }

  Future<void> becomeAudience({String? subscriberToken}) async {
    final engine = _engine;

    if (engine == null || !_initialized) {
      return;
    }

    try {
      // Stop sending audio immediately.
      await engine.muteLocalAudioStream(true);

      await engine.updateChannelMediaOptions(
        const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleAudience,
          autoSubscribeAudio: true,
          autoSubscribeVideo: false,
          publishMicrophoneTrack: false,
          publishCameraTrack: false,
        ),
      );

      await engine.setClientRole(role: ClientRoleType.clientRoleAudience);

      await engine.enableLocalAudio(false);

      if (subscriberToken != null && subscriberToken.trim().isNotEmpty) {
        await engine.renewToken(subscriberToken);
      }

      _publishing = false;
      _muted = false;
      notifyListeners();
    } catch (error) {
      onError?.call('Unable to switch to audience: $error');
    }
  }

  Future<void> setMuted(bool value) async {
    final engine = _engine;

    if (engine == null || !_publishing) {
      return;
    }

    try {
      await engine.muteLocalAudioStream(value);
      _muted = value;
      notifyListeners();
    } catch (error) {
      onError?.call('Unable to change microphone state: $error');
    }
  }

  Future<void> setSpeakerEnabled(bool value) async {
    final engine = _engine;

    _speakerEnabled = value;
    notifyListeners();

    if (engine == null || !_joined) {
      return;
    }

    try {
      await engine.setEnableSpeakerphone(value);
    } catch (error) {
      onError?.call('Unable to change speaker route: $error');
    }
  }

  Future<void> renewToken(String token) async {
    final engine = _engine;

    if (engine == null || token.trim().isEmpty) {
      return;
    }

    try {
      await engine.renewToken(token);
    } catch (error) {
      onError?.call('Unable to renew Agora token: $error');
    }
  }

  Future<void> leaveChannel() async {
    final engine = _engine;

    if (engine == null) return;

    try {
      await engine.leaveChannel();
    } catch (error) {
      debugPrint('Agora leave error: $error');
    }

    _joined = false;
    _publishing = false;
    _remoteUids.clear();
    notifyListeners();
  }

  Future<void> disposeVoice() async {
    final engine = _engine;

    if (engine == null) return;

    try {
      if (_joined) {
        await engine.leaveChannel();
      }
      await engine.release();
    } catch (error) {
      debugPrint('Agora dispose error: $error');
    } finally {
      _engine = null;
      _initialized = false;
      _joined = false;
      _publishing = false;
      _muted = false;
      _channelId = null;
      _localUid = null;
      _remoteUids.clear();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // Flutter dispose cannot await. Start cleanup and release the notifier.
    disposeVoice();
    super.dispose();
  }
}
