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
          onRemoteUserJoined?.call(event.participant.identity);
        })
        ..on<ParticipantDisconnectedEvent>((event) {
          onRemoteUserLeft?.call(event.participant.identity);
        })
        ..on<RoomDisconnectedEvent>((_) {
          _connected = false;
          _micEnabled = false;
          _safeNotifyListeners();
        });

      await room.connect(cleanUrl, cleanToken);

      _connected = true;
      _micEnabled = room.localParticipant?.isMicrophoneEnabled() ?? false;
      _safeNotifyListeners();
      return true;
    } catch (e) {
      _connected = false;
      _micEnabled = false;
      _emitError('LiveKit join failed: $e');
      _safeNotifyListeners();
      return false;
    }
  }

  Future<bool> becomeSpeaker() async {
    final room = _room;

    if (!_connected || room == null) {
      _emitError('LiveKit is not connected.');
      return false;
    }

    final permission = await Permission.microphone.request();

    if (!permission.isGranted) {
      _emitError('Microphone permission required.');
      return false;
    }

    try {
      final participant = room.localParticipant;

      if (participant == null) {
        _emitError('LiveKit local participant is unavailable.');
        return false;
      }

      await participant.setMicrophoneEnabled(true);
      _micEnabled = participant.isMicrophoneEnabled();
      _safeNotifyListeners();
      return _micEnabled;
    } catch (e) {
      _micEnabled = false;
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

    try {
      await participant.setMicrophoneEnabled(!muted);
      _micEnabled = participant.isMicrophoneEnabled();
      _safeNotifyListeners();
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
        // The room may already be disconnected.
      }
    }

    if (notify) {
      _safeNotifyListeners();
    }
  }

  void _emitError(String message) {
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
