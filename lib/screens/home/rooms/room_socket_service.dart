import 'package:socket_io_client/socket_io_client.dart' as IO;

typedef SocketDataCallback = void Function(Map<String, dynamic> data);
typedef SocketTextCallback = void Function(String message);
typedef SocketVoidCallback = void Function();

class RoomSocketService {
  IO.Socket? _socket;

  bool get isConnected => _socket?.connected == true;

  String? get socketId => _socket?.id;

  void connect({
    required String serverUrl,
    String? token,
    SocketVoidCallback? onConnected,
    SocketTextCallback? onDisconnected,
    SocketTextCallback? onError,
    SocketDataCallback? onRoomUpdate,
    SocketDataCallback? onUserJoined,
    SocketDataCallback? onUserLeft,
    SocketDataCallback? onChatMessage,
  }) {
    dispose();

    final headers = <String, String>{};

    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer ${token.trim()}';
    }

    final builder = IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .enableReconnection()
        .enableForceNew();

    if (headers.isNotEmpty) {
      builder.setExtraHeaders(headers);
    }

    _socket = IO.io(serverUrl, builder.build());

    final socket = _socket!;

    socket.onConnect((_) {
      onConnected?.call();
    });

    socket.onDisconnect((reason) {
      onDisconnected?.call(reason?.toString() ?? 'Disconnected');
    });

    socket.onConnectError((error) {
      onError?.call(error?.toString() ?? 'Connection error');
    });

    socket.onError((error) {
      onError?.call(error?.toString() ?? 'Socket error');
    });

    socket.on('room:update', (data) {
      final parsed = _toMap(data);
      if (parsed != null) {
        onRoomUpdate?.call(parsed);
      }
    });

    socket.on('user:joined', (data) {
      final parsed = _toMap(data);
      if (parsed != null) {
        onUserJoined?.call(parsed);
      }
    });

    socket.on('user:left', (data) {
      final parsed = _toMap(data);
      if (parsed != null) {
        onUserLeft?.call(parsed);
      }
    });

    socket.on('chat:message', (data) {
      final parsed = _toMap(data);
      if (parsed != null) {
        onChatMessage?.call(parsed);
      }
    });

    socket.connect();
  }

  void joinRoom({
    required String roomId,
    required String userId,
    required String name,
    String? avatar,
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
        'user': {'id': userId, 'name': name, 'avatar': avatar},
      },
      ack: (data) {
        final result = _toMap(data);

        if (result == null) {
          onResult?.call(false, 'Invalid room join response.');
          return;
        }

        final ok = result['ok'] == true;

        onResult?.call(ok, ok ? null : result['error']?.toString());
      },
    );
  }

  void leaveRoom({
    required String roomId,
    required String userId,
    void Function(bool ok, String? error)? onResult,
  }) {
    _emitWithResult('room:leave', {
      'roomId': roomId,
      'userId': userId,
    }, onResult);
  }

  void joinSeat({
    required String roomId,
    required int seatNumber,
    required String userId,
    required String name,
    String? avatar,
    void Function(bool ok, String? error)? onResult,
  }) {
    _emitWithResult('seat:join', {
      'roomId': roomId,
      'seatNumber': seatNumber,
      'user': {'id': userId, 'name': name, 'avatar': avatar},
    }, onResult);
  }

  void leaveSeat({
    required String roomId,
    required String userId,
    void Function(bool ok, String? error)? onResult,
  }) {
    _emitWithResult('seat:leave', {
      'roomId': roomId,
      'userId': userId,
    }, onResult);
  }

  void setMicMuted({
    required String roomId,
    required String userId,
    required bool muted,
    void Function(bool ok, String? error)? onResult,
  }) {
    _emitWithResult('mic:set', {
      'roomId': roomId,
      'userId': userId,
      'muted': muted,
    }, onResult);
  }

  void lockSeat({
    required String roomId,
    required int seatNumber,
    required String userId,
    void Function(bool ok, String? error)? onResult,
  }) {
    _emitWithResult('seat:lock', {
      'roomId': roomId,
      'seatNumber': seatNumber,
      'userId': userId,
    }, onResult);
  }

  void unlockSeat({
    required String roomId,
    required int seatNumber,
    required String userId,
    void Function(bool ok, String? error)? onResult,
  }) {
    _emitWithResult('seat:unlock', {
      'roomId': roomId,
      'seatNumber': seatNumber,
      'userId': userId,
    }, onResult);
  }

  void requestAgoraToken({
    required String roomId,
    required String role,
    required void Function(bool ok, Map<String, dynamic>? agora, String? error)
    onResult,
  }) {
    final socket = _socket;

    if (socket == null || !socket.connected) {
      onResult(false, null, 'Socket is not connected.');
      return;
    }

    socket.emitWithAck(
      'agora:token',
      {'roomId': roomId, 'role': role},
      ack: (data) {
        final result = _toMap(data);

        if (result == null) {
          onResult(false, null, 'Invalid Agora token response.');
          return;
        }

        final ok = result['ok'] == true;

        if (!ok) {
          onResult(
            false,
            null,
            result['error']?.toString() ?? 'Unable to get Agora token.',
          );
          return;
        }

        final rawAgora = result['agora'];

        if (rawAgora is! Map) {
          onResult(false, null, 'Agora token payload is missing.');
          return;
        }

        onResult(true, Map<String, dynamic>.from(rawAgora), null);
      },
    );
  }

  void sendChatMessage({
    required String roomId,
    required String userId,
    required String name,
    required String message,
    void Function(bool ok, String? error)? onResult,
  }) {
    _emitWithResult('chat:send', {
      'roomId': roomId,
      'user': {'id': userId, 'name': name},
      'message': message,
    }, onResult);
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

  Map<String, dynamic>? _toMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return null;
  }

  void disconnect() {
    final socket = _socket;

    if (socket == null) return;

    socket.disconnect();
  }

  void dispose() {
    final socket = _socket;

    if (socket == null) return;

    socket.dispose();
    _socket = null;
  }
}
