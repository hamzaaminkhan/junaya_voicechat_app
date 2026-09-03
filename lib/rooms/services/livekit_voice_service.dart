import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

typedef LiveKitVoidCallback = void Function();
typedef LiveKitRemoteUserCallback = void Function(String identity);
typedef LiveKitErrorCallback = void Function(String message);

class LiveKitVoiceService extends ChangeNotifier {
  LiveKitVoiceService({
    this.onRemoteUserJoined,
    this.onRemoteUserLeft,
    this.onError,
  });

  final LiveKitRemoteUserCallback? onRemoteUserJoined;
  final LiveKitRemoteUserCallback? onRemoteUserLeft;
  final LiveKitErrorCallback? onError;

  Room? _room;
  EventsListener<RoomEvent>? _eventsListener;

  bool _connected = false;
  bool _micEnabled = false;
  bool _disposed = false;

  String? _roomName;
  String? _identity;

  bool get connected => _connected;
  bool get micEnabled => _micEnabled;
  Room? get room => _room;
  String? get roomName => _roomName;
  String? get identity => _identity;

  Future<bool> joinRoom({
    required String serverUrl,
    required String token,
    required String roomName,
    required String identity,
  }) async {
    if (_disposed) return false;

    final cleanUrl = serverUrl.trim();
    final cleanToken = token.trim();

    if (cleanUrl.isEmpty || cleanToken.isEmpty) {
      _emitError('LiveKit server URL or token is missing.');
      return false;
    }

    try {
      await leaveRoom(notify: false);

      final room = Room();
      _room = room;
      _roomName = roomName;
      _identity = identity;

      _eventsListener = room.createListener()
        ..on<ParticipantConnectedEvent>((event) {
          debugPrint(
            '✅ LiveKit remote participant joined: '
                '${event.participant.identity}',
          );
          onRemoteUserJoined?.call(event.participant.identity);
        })
        ..on<ParticipantDisconnectedEvent>((event) {
          debugPrint(
            '👋 LiveKit remote participant left: '
                '${event.participant.identity}',
          );
          onRemoteUserLeft?.call(event.participant.identity);
        })
        ..on<RoomDisconnectedEvent>((event) {
          debugPrint('❌ LiveKit room disconnected');

          _connected = false;
          _micEnabled = false;
          _safeNotifyListeners();
        });

      debugPrint(
        '🎧 Connecting LiveKit: '
            'room=$roomName identity=$identity url=$cleanUrl',
      );

      await room.connect(cleanUrl, cleanToken);

      _connected = true;
      _micEnabled =
          room.localParticipant?.isMicrophoneEnabled() ?? false;

      debugPrint(
        '✅ LiveKit connected: '
            'room=$roomName identity=$identity mic=$_micEnabled',
      );

      _safeNotifyListeners();
      return true;
    } catch (e, stackTrace) {
      _connected = false;
      _micEnabled = false;

      debugPrint('❌ LiveKit join failed: $e');
      debugPrintStack(stackTrace: stackTrace);

      _emitError('LiveKit join failed: $e');
      _safeNotifyListeners();
      return false;
    }
  }

  /// Ensures Android has RECORD_AUDIO permission before microphone capture.
  ///
  /// On Flutter Web, browser permission is handled when LiveKit attempts to
  /// access getUserMedia, so permission_handler is intentionally skipped.
  Future<bool> _ensureMicrophonePermission() async {
    if (kIsWeb) {
      return true;
    }

    try {
      var status = await Permission.microphone.status;

      debugPrint('🎤 Microphone permission before request: $status');

      if (status.isGranted) {
        return true;
      }

      status = await Permission.microphone.request();

      debugPrint('🎤 Microphone permission after request: $status');

      if (status.isGranted) {
        return true;
      }

      if (status.isPermanentlyDenied) {
        _emitError(
          'Microphone permission is permanently denied. '
              'Enable Microphone in Android Settings > Apps > '
              'Junaya > Permissions.',
        );
        return false;
      }

      if (status.isRestricted) {
        _emitError(
          'Microphone access is restricted on this device.',
        );
        return false;
      }

      _emitError('Microphone permission required.');
      return false;
    } catch (e) {
      _emitError('Unable to request microphone permission: $e');
      return false;
    }
  }

  Future<bool> becomeSpeaker() async {
    final room = _room;

    if (!_connected || room == null) {
      _emitError('LiveKit is not connected.');
      return false;
    }

    final permissionGranted = await _ensureMicrophonePermission();

    if (!permissionGranted) {
      return false;
    }

    try {
      final participant = room.localParticipant;

      if (participant == null) {
        _emitError('LiveKit local participant is unavailable.');
        return false;
      }

      debugPrint(
        '🎤 Enabling microphone for '
            '${participant.identity}',
      );

      await participant.setMicrophoneEnabled(true);

      _micEnabled = participant.isMicrophoneEnabled();

      debugPrint(
        _micEnabled
            ? '✅ LiveKit microphone enabled'
            : '❌ LiveKit microphone did not become enabled',
      );

      _safeNotifyListeners();

      if (!_micEnabled) {
        _emitError('LiveKit microphone could not be enabled.');
      }

      return _micEnabled;
    } catch (e, stackTrace) {
      _micEnabled = false;

      debugPrint('❌ Unable to enable LiveKit microphone: $e');
      debugPrintStack(stackTrace: stackTrace);

      _emitError('Unable to enable LiveKit microphone: $e');
      _safeNotifyListeners();
      return false;
    }
  }

  Future<void> becomeListener() async {
    final participant = _room?.localParticipant;

    if (participant == null) {
      _micEnabled = false;
      _safeNotifyListeners();
      return;
    }

    try {
      debugPrint(
        '🔇 Disabling microphone for ${participant.identity}',
      );

      await participant.setMicrophoneEnabled(false);

      _micEnabled = false;
      _safeNotifyListeners();
    } catch (e) {
      _emitError('Unable to disable LiveKit microphone: $e');
    }
  }

  Future<bool> setMuted(bool muted) async {
    final participant = _room?.localParticipant;

    if (!_connected || participant == null) {
      _emitError('LiveKit is not connected.');
      return false;
    }

    // If the user is trying to unmute, make sure microphone permission still
    // exists. Android users can revoke it from system settings at any time.
    if (!muted) {
      final permissionGranted = await _ensureMicrophonePermission();

      if (!permissionGranted) {
        return false;
      }
    }

    try {
      await participant.setMicrophoneEnabled(!muted);

      _micEnabled = participant.isMicrophoneEnabled();
      _safeNotifyListeners();

      debugPrint(
        muted
            ? '🔇 LiveKit microphone muted'
            : '🎤 LiveKit microphone unmuted',
      );

      return true;
    } catch (e) {
      _emitError('Unable to update LiveKit microphone: $e');
      return false;
    }
  }

  Future<bool> setSpeakerEnabled(bool enabled) async {
    final room = _room;

    if (!_connected || room == null) {
      return false;
    }

    try {
      await room.setSpeakerOn(enabled);

      debugPrint(
        enabled
            ? '🔊 LiveKit speaker output enabled'
            : '🔇 LiveKit speaker output disabled',
      );

      return true;
    } catch (e) {
      _emitError('Unable to change audio output: $e');
      return false;
    }
  }

  Future<void> leaveRoom({bool notify = true}) async {
    final listener = _eventsListener;
    _eventsListener = null;
    listener?.dispose();

    final room = _room;
    _room = null;

    _connected = false;
    _micEnabled = false;
    _roomName = null;
    _identity = null;

    if (room != null) {
      try {
        await room.disconnect();
      } catch (_) {
        // Room may already be disconnected.
      }
    }

    if (notify) {
      _safeNotifyListeners();
    }
  }

  void _emitError(String message) {
    debugPrint('LiveKitVoiceService: $message');
    onError?.call(message);
  }

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    if (_disposed) return;

    _disposed = true;
    unawaited(leaveRoom(notify: false));
    super.dispose();
  }
}
