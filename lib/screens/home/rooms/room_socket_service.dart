import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

typedef SocketDataCallback = void Function(Map<String, dynamic> data);
typedef SocketTextCallback = void Function(String message);
typedef SocketVoidCallback = void Function();

class RoomSocketService {
  IO.Socket? _socket;
  SocketDataCallback? _onRoomUpdate;

  bool get isConnected => _socket?.connected == true;
  String? get socketId => _socket?.id;

  void connect({
    required String serverUrl,
    required String token,
    SocketVoidCallback? onConnected,
    SocketTextCallback? onDisconnected,
    SocketTextCallback? onError,
    SocketDataCallback? onRoomUpdate,
    SocketDataCallback? onUserJoined,
    SocketDataCallback? onUserLeft,
    SocketDataCallback? onRoomEnded,
    SocketDataCallback? onChatMessage,
  }) {
    dispose();
    _onRoomUpdate = onRoomUpdate;

    final cleanToken = token.trim();
    if (cleanToken.isEmpty) {
      onError?.call('Authentication token is missing. Please sign in again.');
      return;
    }

    final bearerToken = 'Bearer $cleanToken';

    // Socket.IO auth works on mobile and web. Extra headers are also supplied
    // for native clients; the backend accepts either location.
    final builder = IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .enableReconnection()
        .enableForceNew()
        .setAuth({'token': bearerToken})
        .setExtraHeaders({'Authorization': bearerToken});

    _socket = IO.io(serverUrl.trim(), builder.build());
    final socket = _socket!;

    socket.onConnect((_) {
      debugPrint('✅ Authenticated Socket.IO connected: id=${socket.id}');
      onConnected?.call();
    });

    socket.onDisconnect((reason) {
      debugPrint('⚠️ Socket.IO disconnected: $reason');
      onDisconnected?.call(reason?.toString() ?? 'Disconnected');
    });

    socket.onConnectError((error) {
      final message = _friendlyConnectionError(error);
      debugPrint('❌ Socket.IO connect error: $message');
      onError?.call(message);
    });

    socket.onError((error) {
      final message = error?.toString() ?? 'Socket error';
      debugPrint('❌ Socket.IO error: $message');
      onError?.call(message);
    });

    socket.on('room:update', (data) {
      final parsed = _toMap(data);
      if (parsed != null) _onRoomUpdate?.call(parsed);
    });

    socket.on('user:joined', (data) {
      final parsed = _toMap(data);
      if (parsed != null) onUserJoined?.call(parsed);
    });

    socket.on('user:left', (data) {
      final parsed = _toMap(data);
      if (parsed != null) onUserLeft?.call(parsed);
    });

    socket.on('room:ended', (data) {
      final parsed = _toMap(data);
      if (parsed != null) onRoomEnded?.call(parsed);
    });

    socket.on('chat:message', (data) {
      final parsed = _toMap(data);
      if (parsed != null) onChatMessage?.call(parsed);
    });

    socket.connect();
  }

  void getRoom({
    required String roomId,
    void Function(bool ok, Map<String, dynamic>? room, String? error)? onResult,
  }) {
    final socket = _socket;

    if (socket == null || !socket.connected) {
      onResult?.call(false, null, 'Socket is not connected.');
      return;
    }

    socket.emitWithAck(
      'room:get',
      {'roomId': roomId},
      ack: (data) {
        final result = _toMap(data);
        if (result == null) {
          onResult?.call(false, null, 'Invalid room response.');
          return;
        }

        final ok = result['ok'] == true;
        final room = _toMap(result['room']);

        if (ok && room != null) _onRoomUpdate?.call(room);

        onResult?.call(ok, room, ok ? null : result['error']?.toString());
      },
    );
  }

  void joinRoom({
    required String roomId,
    String? roomName,
    void Function(bool ok, String? error)? onResult,
  }) {
    final socket = _socket;

    if (socket == null || !socket.connected) {
      onResult?.call(false, 'Socket is not connected.');
      return;
    }

    socket.emitWithAck(
      'room:join',
      {
        'roomId': roomId,
        if (roomName != null && roomName.trim().isNotEmpty)
          'roomName': roomName.trim(),
      },
      ack: (data) {
        final result = _toMap(data);

        if (result == null) {
          onResult?.call(false, 'Invalid room join response.');
          return;
        }

        final ok = result['ok'] == true;

        if (ok) {
          final room = _toMap(result['room']);
          if (room != null) _onRoomUpdate?.call(room);
        }

        onResult?.call(ok, ok ? null : result['error']?.toString());
      },
    );
  }

  void leaveRoom({
    required String roomId,
    void Function(bool ok, String? error)? onResult,
  }) {
    _emitWithResult('room:leave', {'roomId': roomId}, onResult);
  }

  void endRoom({
    required String roomId,
    void Function(bool ok, String? error)? onResult,
  }) {
    _emitWithResult('room:end', {'roomId': roomId}, onResult);
  }

  void joinSeat({
    required String roomId,
    required int seatNumber,
    void Function(bool ok, String? error)? onResult,
  }) {
    _emitWithResult(
      'seat:join',
      {'roomId': roomId, 'seatNumber': seatNumber},
      onResult,
    );
  }

  void leaveSeat({
    required String roomId,
    void Function(bool ok, String? error)? onResult,
  }) {
    _emitWithResult('seat:leave', {'roomId': roomId}, onResult);
  }

  void setMicMuted({
    required String roomId,
    required bool muted,
    void Function(bool ok, String? error)? onResult,
  }) {
    _emitWithResult(
      'mic:set',
      {'roomId': roomId, 'muted': muted},
      onResult,
    );
  }

  void lockSeat({
    required String roomId,
    required int seatNumber,
    void Function(bool ok, String? error)? onResult,
  }) {
    _emitWithResult(
      'seat:lock',
      {'roomId': roomId, 'seatNumber': seatNumber},
      onResult,
    );
  }

  void unlockSeat({
    required String roomId,
    required int seatNumber,
    void Function(bool ok, String? error)? onResult,
  }) {
    _emitWithResult(
      'seat:unlock',
      {'roomId': roomId, 'seatNumber': seatNumber},
      onResult,
    );
  }

  void requestLiveKitToken({
    required String roomId,
    required void Function(
      bool ok,
      Map<String, dynamic>? livekit,
      String? error,
    ) onResult,
  }) {
    final socket = _socket;

    if (socket == null || !socket.connected) {
      onResult(false, null, 'Socket is not connected.');
      return;
    }

    socket.emitWithAck(
      'livekit:token',
      {'roomId': roomId},
      ack: (data) {
        final result = _toMap(data);

        if (result == null) {
          onResult(false, null, 'Invalid LiveKit token response.');
          return;
        }

        final ok = result['ok'] == true;
        if (!ok) {
          onResult(
            false,
            null,
            result['error']?.toString() ?? 'Unable to get LiveKit token.',
          );
          return;
        }

        final rawLiveKit = result['livekit'];
        if (rawLiveKit is! Map) {
          onResult(false, null, 'LiveKit token payload is missing.');
          return;
        }

        onResult(true, Map<String, dynamic>.from(rawLiveKit), null);
      },
    );
  }

  void sendChatMessage({
    required String roomId,
    required String message,
    void Function(bool ok, String? error)? onResult,
  }) {
    _emitWithResult(
      'chat:send',
      {'roomId': roomId, 'message': message},
      onResult,
    );
  }

  void _emitWithResult(
    String event,
    Map<String, dynamic> payload,
    void Function(bool ok, String? error)? onResult,
  ) {
    final socket = _socket;

    if (socket == null || !socket.connected) {
      onResult?.call(false, 'Socket is not connected.');
      return;
    }

    socket.emitWithAck(
      event,
      payload,
      ack: (data) {
        final result = _toMap(data);

        if (result == null) {
          onResult?.call(false, 'Invalid server response.');
          return;
        }

        final ok = result['ok'] == true;
        onResult?.call(ok, ok ? null : result['error']?.toString());
      },
    );
  }

  String _friendlyConnectionError(dynamic error) {
    final raw = error?.toString() ?? 'Connection error';

    if (raw.contains('AUTH_TOKEN_EXPIRED')) {
      return 'Your session expired. Please retry the room connection.';
    }
    if (raw.contains('AUTH_REQUIRED') || raw.contains('AUTH_INVALID')) {
      return 'Secure room authentication failed. Please sign in again.';
    }
    if (raw.contains('AUTH_USER_NOT_FOUND')) {
      return 'Your Junaya account could not be found.';
    }

    return raw;
  }

  Map<String, dynamic>? _toMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  void disconnect() {
    _socket?.disconnect();
  }

  void dispose() {
    final socket = _socket;
    _socket = null;
    _onRoomUpdate = null;
    socket?.dispose();
  }
}
