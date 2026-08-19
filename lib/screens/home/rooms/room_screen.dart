import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/core/config/app_config.dart';
import 'package:junaya_voicechat_app/controllers/room_controller.dart';
import 'package:junaya_voicechat_app/models/voice_room_model.dart';
import 'package:junaya_voicechat_app/services/livekit_voice_service.dart';

import 'room_profile_screen.dart';
import 'room_socket_service.dart';

class RoomScreen extends StatefulWidget {
  /// Optional Socket.IO override from --dart-define.
  ///
  /// Real phone:
  /// flutter run --dart-define=SOCKET_URL=https://your-domain.example
  ///
  /// Emulator:
  /// flutter run --dart-define=SOCKET_URL=http://10.0.2.2:5000
  static const String environmentSocketUrl = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: '',
  );

  final String roomId;
  final String? currentUserId;
  final String? currentUserName;
  final String? currentUserAvatar;
  final String socketServerUrl;
  final bool enableRealtime;

  const RoomScreen({
    super.key,
    this.roomId = 'junaya-main',
    this.currentUserId,
    this.currentUserName,
    this.currentUserAvatar,
    this.socketServerUrl = '',
    this.enableRealtime = true,
  });

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  static const Color _bg = Color(0xFF10002F);
  static const Color _pink = Color(0xFFFF48ED);
  static const Color _cyan = Color(0xFF18C5C7);

  int _tab = 0;
  late final RoomController _roomController;
  late final RoomSocketService _socketService;
  late final LiveKitVoiceService _liveKitVoiceService;
  late final String _resolvedUserId;
  late final String _resolvedUserName;

  bool _socketConnected = false;
  String? _socketError;

  bool _liveKitConnected = false;
  String? _liveKitError;

  bool _exitSheetOpen = false;
  bool _isLeavingRoom = false;
  bool _roomExitHandled = false;

  final List<String> _activityMessages = [
    'Welcome to Junaya Voice Room 👋',
  ];

  final TextEditingController _chatController = TextEditingController();

  String get _resolvedSocketServerUrl {
    final widgetOverride = widget.socketServerUrl.trim();

    if (widgetOverride.isNotEmpty) {
      return widgetOverride;
    }

    final envOverride = RoomScreen.environmentSocketUrl.trim();

    if (envOverride.isNotEmpty) {
      return envOverride;
    }

    return AppConfig.socketBaseUrl;
  }

  final List<_RoomChatEntry> _chatMessages = [
    const _RoomChatEntry(
      name: 'System',
      message: 'Welcome to Junaya Voice Room.',
      badge: 'ROOM',
      isSystem: true,
    ),
  ];

  @override
  void initState() {
    super.initState();

    final suppliedId = widget.currentUserId?.trim() ?? '';
    final suppliedName = widget.currentUserName?.trim() ?? '';
    final uniqueSuffix = DateTime.now().microsecondsSinceEpoch.toString();
    final platformPrefix = kIsWeb ? 'web' : 'android';

    _resolvedUserId = suppliedId.isNotEmpty
        ? suppliedId
        : '${platformPrefix}_$uniqueSuffix';
    _resolvedUserName = suppliedName.isNotEmpty
        ? suppliedName
        : 'Guest ${uniqueSuffix.substring(uniqueSuffix.length - 4)}';

    _roomController = RoomController(
      currentUserId: _resolvedUserId,
      currentUserName: _resolvedUserName,
      currentUserAvatar: widget.currentUserAvatar,
    );
    _roomController.setLoading(widget.enableRealtime);

    _roomController.addListener(_roomUpdated);

    _socketService = RoomSocketService();

    _liveKitVoiceService = LiveKitVoiceService(
      onRemoteUserJoined: (identity) {
        debugPrint('LiveKit remote user joined: $identity');
      },
      onRemoteUserLeft: (identity) {
        debugPrint('LiveKit remote user left: $identity');
      },
      onError: (message) {
        if (!mounted) return;

        setState(() {
          _liveKitError = message;
        });

        _showMessage(message);
      },
    );

    _liveKitVoiceService.addListener(_liveKitUpdated);

    if (widget.enableRealtime) {
      _connectRealtimeRoom();
    }
  }

  void _connectRealtimeRoom() {
    debugPrint(
      '🌐 SOCKET CONNECT START: '
          'url=$_resolvedSocketServerUrl '
          'platform=${kIsWeb ? "WEB" : "ANDROID"} '
          'room=${widget.roomId} '
          'user=${_roomController.currentUserId}',
    );

    _socketService.connect(
      serverUrl: _resolvedSocketServerUrl,
      onConnected: () {
        debugPrint(
          '✅ SOCKET CONNECTED: '
              'url=$_resolvedSocketServerUrl '
              'user=${_roomController.currentUserId}',
        );

        if (!mounted) return;

        setState(() {
          _socketConnected = true;
          _socketError = null;
        });

        _socketService.joinRoom(
          roomId: widget.roomId,
          userId: _roomController.currentUserId,
          name: _roomController.currentUserName,
          avatar: _roomController.currentUserAvatar,
          onResult: (ok, error) {
            debugPrint(
              '🚪 ROOM JOIN RESULT: '
                  'ok=$ok '
                  'error=$error '
                  'room=${widget.roomId} '
                  'user=${_roomController.currentUserId}',
            );

            if (!mounted) return;

            if (!ok) {
              final message = error ?? 'Unable to join the room.';
              setState(() => _socketError = message);
              _roomController.setError(message);
              return;
            }

            _roomController.setLoading(false);
            _startLiveKit();
          },
        );
      },
      onDisconnected: (reason) {
        if (_roomExitHandled) return;

        debugPrint(
          '⚠️ SOCKET DISCONNECTED: '
              'reason=$reason '
              'url=$_resolvedSocketServerUrl',
        );

        if (!mounted) return;

        setState(() {
          _socketConnected = false;
        });

        if (_roomController.room == null) {
          _roomController.setError('Room connection was lost.');
        }
      },
      onError: (message) {
        debugPrint(
          '❌ SOCKET ERROR: '
              '$message '
              'url=$_resolvedSocketServerUrl',
        );
        debugPrint(
          '📱 REAL PHONE CHECK: open '
              '$_resolvedSocketServerUrl/health in the phone browser.',
        );

        if (!mounted) return;

        setState(() {
          _socketConnected = false;
          _socketError = message;
        });

        _roomController.setError(message);
      },
      onRoomUpdate: (data) {
        debugPrint(
          '🔥 ROOM UPDATE: '
              'online=${data['onlineUsers']} '
              'members=${data['members']}',
        );

        _roomController.updateRoomFromServer(data);
      },
      onUserJoined: (data) {
        final name = data['name']?.toString() ?? 'A user';

        _addActivity('$name joined the room');

        _addChatEntry(
          _RoomChatEntry(
            name: 'System',
            message: '$name joined the room',
            badge: 'ROOM',
            isSystem: true,
          ),
        );
      },
      onUserLeft: (data) {
        final name = data['name']?.toString() ?? 'A user';

        _addActivity('$name left the room');

        _addChatEntry(
          _RoomChatEntry(
            name: 'System',
            message: '$name left the room',
            badge: 'ROOM',
            isSystem: true,
          ),
        );
      },
      onRoomEnded: (data) {
        _handleRoomEnded(data);
      },
      onChatMessage: (data) {
        final rawUser = data['user'];

        String userId = '';
        String name = 'User';
        String? avatar;

        if (rawUser is Map) {
          userId = rawUser['id']?.toString() ?? '';
          name = rawUser['name']?.toString() ?? 'User';
          avatar = rawUser['avatar']?.toString();
        }

        final message = data['message']?.toString().trim() ?? '';

        if (message.isEmpty) return;

        _addChatEntry(
          _RoomChatEntry(
            userId: userId,
            name: name,
            avatar: avatar,
            message: message,
            isMe: userId == _roomController.currentUserId,
          ),
        );

        _addActivity('$name: $message');
      },
    );
  }

  void _liveKitUpdated() {
    if (!mounted) return;

    setState(() {
      _liveKitConnected = _liveKitVoiceService.connected;
    });
  }

  void _requestLiveKitToken({
    required void Function(Map<String, dynamic> livekit) onSuccess,
    bool showErrors = true,
  }) {
    if (!_socketConnected) {
      if (showErrors) {
        _showMessage('Socket connection is required for voice.');
      }
      return;
    }

    _socketService.requestLiveKitToken(
      roomId: widget.roomId,
      identity: _roomController.currentUserId,
      name: _roomController.currentUserName,
      // Connect with publish permission but keep the mic disabled until
      // the socket server confirms that this user owns a mic seat.
      role: 'subscriber',
      onResult: (ok, livekit, error) {
        if (!mounted) return;

        if (!ok || livekit == null) {
          final message = error ?? 'Unable to obtain secure LiveKit token.';

          setState(() {
            _liveKitError = message;
          });

          if (showErrors) {
            _showMessage(message);
          }
          return;
        }

        setState(() {
          _liveKitError = null;
        });

        onSuccess(livekit);
      },
    );
  }

  void _startLiveKit() {
    if (_liveKitVoiceService.connected) {
      return;
    }

    _requestLiveKitToken(
      onSuccess: (livekit) async {
        final serverUrl =
            livekit['serverUrl']?.toString() ??
                livekit['url']?.toString() ??
                livekit['wsUrl']?.toString() ??
                '';
        final token = livekit['token']?.toString() ?? '';
        final roomName = livekit['roomName']?.toString() ?? widget.roomId;
        final identity =
            livekit['identity']?.toString() ?? _roomController.currentUserId;

        if (serverUrl.isEmpty || token.isEmpty) {
          const message = 'Invalid LiveKit voice configuration.';
          setState(() {
            _liveKitConnected = false;
            _liveKitError = message;
          });
          _showMessage(message);
          return;
        }

        final connected = await _liveKitVoiceService.joinRoom(
          serverUrl: serverUrl,
          token: token,
          roomName: roomName,
          identity: identity,
        );

        if (!mounted) return;

        setState(() {
          _liveKitConnected = connected;
          if (connected) {
            _liveKitError = null;
          }
        });
      },
    );
  }

  Future<void> _enableLiveKitMicAfterSeatJoin({
    required int seatIndex,
  }) async {
    if (!_liveKitVoiceService.connected) {
      _showMessage('LiveKit voice is not connected yet.');
      _rollbackMicSeat(seatIndex);
      return;
    }

    // The backend has already promoted this participant in LiveKit.
    // Give the permission update a brief moment to reach the client.
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final enabled = await _liveKitVoiceService.becomeSpeaker();

    if (!mounted) return;

    if (!enabled) {
      _rollbackMicSeat(seatIndex);
      return;
    }

    _addActivity('Your microphone is now live on Mic ${seatIndex + 1} 🎙️');
    _showMessage('Microphone is live');
  }

  void _rollbackMicSeat(int seatIndex) {
    if (!_socketConnected) return;

    _socketService.leaveSeat(
      roomId: widget.roomId,
      userId: _roomController.currentUserId,
      onResult: (_, _) {},
    );

    _liveKitVoiceService.becomeListener();

    _showMessage(
      'Mic ${seatIndex + 1} was released because voice could not start.',
    );
  }

  void _roomUpdated() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _showExitRoomSheet() async {
    if (!mounted || _exitSheetOpen || _isLeavingRoom) return;

    final room = _roomController.room;

    if (room == null) {
      await _finishRoomExit();
      return;
    }

    _exitSheetOpen = true;

    try {
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (sheetContext) {
          final isOwner = _roomController.isRoomOwner;
          final isOnMic = _roomController.isOnMic;

          return SafeArea(
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
              decoration: BoxDecoration(
                color: const Color(0xFF190837),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: _pink.withValues(alpha: .22)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 28,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _pink.withValues(alpha: .12),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFFF8DF4),
                      size: 27,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Text(
                    isOwner ? 'Leave your room?' : 'Leave voice room?',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    isOwner
                        ? 'Leave and pass host to the next member, or end the room for everyone.'
                        : isOnMic
                        ? 'Your mic seat will be released and your voice connection will stop.'
                        : 'You will disconnect from this room and stop hearing the conversation.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white60,
                      fontSize: 11.5,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _exitActionTile(
                    icon: isOwner
                        ? Icons.person_off_outlined
                        : Icons.logout_rounded,
                    title: isOwner ? 'Leave & transfer host' : 'Leave room',
                    subtitle: isOwner
                        ? 'The next member becomes room host.'
                        : 'Disconnect from this voice room.',
                    color: const Color(0xFFFFC857),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _leaveRoomProfessionally();
                    },
                  ),
                  if (isOwner) ...[
                    const SizedBox(height: 9),
                    _exitActionTile(
                      icon: Icons.power_settings_new_rounded,
                      title: 'End room for everyone',
                      subtitle: 'All members will be disconnected.',
                      color: const Color(0xFFFF5E7A),
                      onTap: () {
                        Navigator.pop(sheetContext);
                        _endRoomForEveryone();
                      },
                    ),
                  ],
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: .15),
                        ),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'Stay in room',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } finally {
      _exitSheetOpen = false;
    }
  }

  Widget _exitActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: .22)),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .14),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: color.withValues(alpha: .9),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _leaveRoomProfessionally() {
    if (_isLeavingRoom || _roomExitHandled) return;

    setState(() => _isLeavingRoom = true);

    if (!_socketConnected) {
      _finishRoomExit();
      return;
    }

    _socketService.leaveRoom(
      roomId: widget.roomId,
      userId: _roomController.currentUserId,
      onResult: (ok, error) {
        if (!mounted || _roomExitHandled) return;

        if (!ok) {
          setState(() => _isLeavingRoom = false);
          _showMessage(error ?? 'Unable to leave the room.');
          return;
        }

        _finishRoomExit();
      },
    );
  }

  void _endRoomForEveryone() {
    if (_isLeavingRoom || _roomExitHandled) return;

    if (!_roomController.isRoomOwner) {
      _showMessage('Only the room owner can end the room.');
      return;
    }

    if (!_socketConnected) {
      _showMessage('Room connection is required to end the room.');
      return;
    }

    setState(() => _isLeavingRoom = true);

    _socketService.endRoom(
      roomId: widget.roomId,
      userId: _roomController.currentUserId,
      onResult: (ok, error) {
        if (!mounted || _roomExitHandled) return;

        if (!ok) {
          setState(() => _isLeavingRoom = false);
          _showMessage(error ?? 'Unable to end the room.');
          return;
        }

        _finishRoomExit();
      },
    );
  }

  Future<void> _handleRoomEnded(Map<String, dynamic> data) async {
    if (!mounted || _roomExitHandled) return;

    final rawEndedBy = data['endedBy'];
    String endedById = '';

    if (rawEndedBy is Map) {
      endedById = rawEndedBy['id']?.toString() ?? '';
    }

    if (endedById != _roomController.currentUserId) {
      _showMessage('The host ended this room.');
      await Future<void>.delayed(const Duration(milliseconds: 450));
    }

    await _finishRoomExit();
  }

  Future<void> _finishRoomExit() async {
    if (_roomExitHandled) return;

    _roomExitHandled = true;

    try {
      await _liveKitVoiceService.leaveRoom();
    } catch (_) {
      // Dispose will perform a final cleanup if LiveKit is already gone.
    }

    if (!mounted) return;

    Navigator.of(context).maybePop();
  }

  @override
  void dispose() {
    if (_socketConnected && !_roomExitHandled) {
      _socketService.leaveRoom(
        roomId: widget.roomId,
        userId: _roomController.currentUserId,
      );
    }

    _socketService.dispose();

    _liveKitVoiceService.removeListener(_liveKitUpdated);
    _liveKitVoiceService.dispose();

    _roomController.removeListener(_roomUpdated);
    _roomController.dispose();
    _chatController.dispose();

    super.dispose();
  }

  VoiceRoom get _room => _roomController.room!;

  void _openRoomProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RoomProfileScreen()),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: GoogleFonts.poppins(
              color: const Color(0xFFFFD76A),
              fontWeight: FontWeight.w600,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF2E1255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
  }

  void _addActivity(String message) {
    setState(() {
      _activityMessages.insert(0, message);
      if (_activityMessages.length > 20) {
        _activityMessages.removeLast();
      }
    });
  }

  void _addChatEntry(_RoomChatEntry entry) {
    if (!mounted) return;

    setState(() {
      _chatMessages.insert(0, entry);

      if (_chatMessages.length > 100) {
        _chatMessages.removeLast();
      }

      _tab = 1;
    });
  }

  void _sendChatMessage() {
    final message = _chatController.text.trim();

    if (message.isEmpty) return;

    if (!_socketConnected) {
      _showMessage('Connect to the room before sending a message.');
      return;
    }

    _socketService.sendChatMessage(
      roomId: widget.roomId,
      userId: _roomController.currentUserId,
      name: _roomController.currentUserName,
      message: message,
      onResult: (ok, error) {
        if (!mounted) return;

        if (ok) {
          _chatController.clear();
          setState(() => _tab = 1);
        } else {
          _showMessage(error ?? 'Unable to send message');
        }
      },
    );
  }

  void _showChatComposer() {
    setState(() => _tab = 1);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            decoration: const BoxDecoration(
              color: Color(0xFF160633),
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatController,
                      autofocus: true,
                      textInputAction: TextInputAction.send,
                      maxLength: 250,
                      onSubmitted: (_) {
                        _sendChatMessage();
                        if (_chatController.text.trim().isEmpty &&
                            Navigator.canPop(sheetContext)) {
                          Navigator.pop(sheetContext);
                        }
                      },
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Say something...',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                        prefixIcon: const Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: Color(0xFFFFD76A),
                          size: 19,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF250D49),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(
                            color: _pink.withValues(alpha: .25),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: const BorderSide(
                            color: Color(0xFFFFD76A),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        final hadText = _chatController.text.trim().isNotEmpty;

                        _sendChatMessage();

                        if (hadText && Navigator.canPop(sheetContext)) {
                          Navigator.pop(sheetContext);
                        }
                      },
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFFFFD76A), Color(0xFFFFA61E)],
                          ),
                        ),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Color(0xFF2B0D3E),
                          size: 21,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _joinMicRealtime(int index) {
    if (!_socketConnected) {
      _showMessage('Room connection is required to take a mic seat.');
      return;
    }

    _socketService.joinSeat(
      roomId: widget.roomId,
      seatNumber: index + 1,
      userId: _roomController.currentUserId,
      name: _roomController.currentUserName,
      avatar: _roomController.currentUserAvatar,
      onResult: (ok, error) {
        if (!mounted) return;

        if (ok) {
          _addActivity('You joined Mic ${index + 1} 🎙️');
          _showMessage('You joined Mic ${index + 1}');

          _enableLiveKitMicAfterSeatJoin(seatIndex: index);
        } else {
          _showMessage(error ?? 'Unable to join mic');
        }
      },
    );
  }

  void _leaveMicRealtime() {
    _liveKitVoiceService.becomeListener();

    if (!_socketConnected) {
      _showMessage('Room connection is required to leave the mic seat.');
      return;
    }

    _socketService.leaveSeat(
      roomId: widget.roomId,
      userId: _roomController.currentUserId,
      onResult: (ok, error) {
        if (!mounted) return;

        if (ok) {
          _addActivity('You left the mic seat.');
          _showMessage('You left the mic');

        } else {
          _showMessage(error ?? 'Unable to leave mic');
        }
      },
    );
  }

  void _toggleMicRealtime() {
    if (!_roomController.isOnMic || !_liveKitVoiceService.connected) {
      _showMessage('Take a mic seat first.');
      return;
    }

    _roomController.toggleMicrophone();

    final muted = !_roomController.microphoneEnabled;

    _liveKitVoiceService.setMuted(muted);

    if (_socketConnected) {
      _socketService.setMicMuted(
        roomId: widget.roomId,
        userId: _roomController.currentUserId,
        muted: muted,
        onResult: (ok, error) {
          if (!mounted || ok) return;

          _showMessage(error ?? 'Unable to update microphone');
        },
      );
    }

    _showMessage(muted ? 'Microphone muted' : 'Microphone enabled');
  }

  void _setSeatLockRealtime(int index, {required bool lock}) {
    final seat = _room.seats[index];

    if (!_socketConnected) {
      _showMessage('Room connection is required to change mic locks.');
      return;
    }

    void onResult(bool ok, String? error) {
      if (!mounted) return;

      if (ok) {
        _showMessage(
          lock ? 'Mic ${seat.number} locked' : 'Mic ${seat.number} unlocked',
        );
      } else {
        _showMessage(error ?? 'Unable to update seat');
      }
    }

    if (lock) {
      _socketService.lockSeat(
        roomId: widget.roomId,
        seatNumber: seat.number,
        userId: _roomController.currentUserId,
        onResult: onResult,
      );
    } else {
      _socketService.unlockSeat(
        roomId: widget.roomId,
        seatNumber: seat.number,
        userId: _roomController.currentUserId,
        onResult: onResult,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRoom = _roomController.room;

    if (currentRoom == null) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            _showExitRoomSheet();
          }
        },
        child: Scaffold(
          backgroundColor: _bg,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_roomController.loading)
                      const CircularProgressIndicator(
                        color: Color(0xFFFF48ED),
                      )
                    else
                      const Icon(
                        Icons.cloud_off_rounded,
                        color: Color(0xFFFFD76A),
                        size: 42,
                      ),
                    const SizedBox(height: 16),
                    Text(
                      _roomController.loading
                          ? 'Joining room...'
                          : (_roomController.error ??
                          _socketError ??
                          'Room could not be loaded.'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    if (!_roomController.loading) ...[
                      const SizedBox(height: 14),
                      OutlinedButton.icon(
                        onPressed: widget.enableRealtime
                            ? () {
                          _roomController.clearError();
                          _roomController.setLoading(true);
                          _connectRealtimeRoom();
                        }
                            : null,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Retry'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showExitRoomSheet();
        }
      },
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double screenWidth = constraints.maxWidth > 430
                  ? 400
                  : constraints.maxWidth;

              return Center(
                child: SizedBox(
                  width: screenWidth,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              _buildStageHeader(),
                              _buildMicGrid(),
                              _buildTabs(),
                              _buildRoomActions(),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                      _buildBottomBar(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStageHeader() {
    return SizedBox(
      height: 205,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/backgrounds/space_bg.jpeg',
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) {
              return const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF090023),
                      Color(0xFF25004E),
                      Color(0xFF10002F),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              );
            },
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: .03),
                    Colors.transparent,
                    _bg.withValues(alpha: .48),
                    _bg,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0, .42, .78, 1],
                ),
              ),
            ),
          ),
          Positioned(
            left: 18,
            top: 20,
            right: 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _openRoomProfile,
                  child: Container(
                    width: 56,
                    height: 56,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFF35DFF),
                        width: 1.4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEB3DFF).withValues(alpha: .20),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.asset(
                        'assets/users/profile.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const ColoredBox(
                          color: Color(0xFF32115B),
                          child: Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _room.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _socketConnected
                                    ? const Color(0xFF53E68A)
                                    : const Color(0xFFFFD76A),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _liveKitConnected
                                    ? const Color(0xFF31E8F7)
                                    : Colors.white24,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'ID:${_room.id}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  color: Colors.white.withValues(alpha: .94),
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Transform.rotate(
                              angle: .78,
                              child: Container(
                                width: 17,
                                height: 17,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFFD79B7E),
                                    width: .9,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.diamond_outlined,
                                  color: Color(0xFFD79B7E),
                                  size: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                _headerIconButton(
                  icon: Icons.people_alt_outlined,
                  onTap: _showMemberSheet,
                ),
                _headerIconButton(
                  icon: Icons.keyboard_arrow_up_rounded,
                  onTap: _showExitRoomSheet,
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 108,
            child: Container(
              width: 88,
              height: 32,
              padding: const EdgeInsets.only(left: 19, right: 11),
              decoration: BoxDecoration(
                color: const Color(0xFF160037).withValues(alpha: .72),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
                border: Border.all(color: _pink.withValues(alpha: .30)),
              ),
              child: Row(
                children: [
                  const Text('🏆', style: TextStyle(fontSize: 14)),
                  const Spacer(),
                  Text(
                    '${_room.roomRank}',
                    style: const TextStyle(
                      color: Color(0xFFFFD943),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 18,
            top: 107,
            child: Row(
              children: [
                GestureDetector(
                  onTap: _openRoomProfile,
                  child: Container(
                    width: 39,
                    height: 39,
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF442373),
                      border: Border.all(color: Colors.white54),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/users/profile.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const ColoredBox(
                          color: Color(0xFF32115B),
                          child: Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 42,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF21154F).withValues(alpha: .90),
                    border: Border.all(color: _pink.withValues(alpha: .45)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.graphic_eq_rounded,
                        color: Color(0xFF31E8F7),
                        size: 17,
                      ),
                      Text(
                        '${_room.onlineUsers}',
                        maxLines: 1,
                        style: const TextStyle(
                          color: Color(0xFF31E8F7),
                          height: .9,
                          fontSize: 7.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 36,
          height: 40,
          child: Icon(icon, color: Colors.white, size: 27),
        ),
      ),
    );
  }

  Widget _buildMicGrid() {
    final seatCount = _room.seats.length;
    final columns = seatCount >= 12 ? 4 : 5;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 2, 18, 2),
      child: GridView.builder(
        itemCount: seatCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: .92,
        ),
        itemBuilder: (context, index) {
          return _buildMicSeat(index);
        },
      ),
    );
  }

  Widget _buildMicSeat(int index) {
    final seat = _room.seats[index];
    final user = seat.user;
    final isMe = user?.id == _roomController.currentUserId;

    return InkWell(
      onTap: () => _handleSeatTap(index),
      onLongPress: _roomController.isRoomOwner
          ? () => _showOwnerSeatControls(index)
          : null,
      borderRadius: BorderRadius.circular(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 52,
                height: 52,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: user?.isSpeaking == true
                      ? const LinearGradient(
                    colors: [
                      Color(0xFFFF48ED),
                      Color(0xFF7E54FF),
                      Color(0xFF18C5C7),
                    ],
                  )
                      : null,
                  color: user?.isSpeaking == true
                      ? null
                      : const Color(0xFF251149).withValues(alpha: .72),
                  border: user?.isSpeaking == true
                      ? null
                      : Border.all(
                    color: seat.isLocked
                        ? Colors.white24
                        : _pink.withValues(alpha: .46),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: user?.isSpeaking == true
                          ? _pink.withValues(alpha: .35)
                          : _pink.withValues(alpha: .07),
                      blurRadius: user?.isSpeaking == true ? 12 : 7,
                    ),
                  ],
                ),
                child: ClipOval(child: _seatContent(seat)),
              ),
              if (user?.isHost == true)
                Positioned(
                  top: -7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFA82D),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'HOST',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 6,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              if (user?.isMuted == true)
                Positioned(
                  right: -1,
                  bottom: -1,
                  child: Container(
                    width: 17,
                    height: 17,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE23D5F),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mic_off_rounded,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            user != null
                ? user.name
                : seat.isLocked
                ? 'Locked'
                : '${seat.number}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: isMe ? const Color(0xFFFFA0F5) : const Color(0xFFE38BEA),
              fontSize: 9.5,
              height: 1,
              fontWeight: isMe ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _seatContent(RoomSeat seat) {
    final user = seat.user;

    if (user != null) {
      if (user.avatar != null && user.avatar!.isNotEmpty) {
        return Image.asset(
          user.avatar!,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _avatarFallback(user.name),
        );
      }
      return _avatarFallback(user.name);
    }

    return ColoredBox(
      color: const Color(0xFF251149).withValues(alpha: .72),
      child: Icon(
        seat.isLocked ? Icons.lock_rounded : Icons.mic_rounded,
        color: seat.isLocked ? Colors.white30 : const Color(0xFFF18FFF),
        size: 23,
      ),
    );
  }

  Widget _avatarFallback(String name) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7A35CE), Color(0xFF3E65CC)],
        ),
      ),
      child: Text(
        name.isEmpty ? 'U' : name[0].toUpperCase(),
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 17,
        ),
      ),
    );
  }

  void _handleSeatTap(int index) {
    final seat = _room.seats[index];

    if (seat.isLocked) {
      _showMessage('This mic seat is locked.');
      return;
    }

    if (seat.isOccupied) {
      _showSeatUserSheet(index);
      return;
    }

    if (_roomController.isOnMic) {
      _showMessage(
        'You are already sitting on Mic ${_roomController.mySeatIndex! + 1}.',
      );
      return;
    }

    _showJoinMicSheet(index);
  }

  void _showJoinMicSheet(int index) {
    final seat = _room.seats[index];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A0839),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _pink.withValues(alpha: .22)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 20),
                const Icon(Icons.mic_rounded, color: _pink, size: 34),
                const SizedBox(height: 12),
                Text(
                  'Mic ${seat.number}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Do you want to take this mic seat?',
                  style: GoogleFonts.poppins(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(45),
                          side: const BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(color: Colors.white70),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);

                          _joinMicRealtime(index);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _pink,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(45),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Take Seat',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSeatUserSheet(int index) {
    final seat = _room.seats[index];
    final user = seat.user;
    if (user == null) return;

    final isMe = user.id == _roomController.currentUserId;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF190837),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _pink.withValues(alpha: .20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: const Color(0xFF45217B),
                  backgroundImage: user.avatar != null
                      ? AssetImage(user.avatar!)
                      : null,
                  child: user.avatar == null
                      ? Text(
                    user.name.isEmpty ? 'U' : user.name[0].toUpperCase(),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  user.name,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  user.isHost
                      ? 'Room Owner • Mic ${seat.number}'
                      : 'Mic ${seat.number}',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 18),
                if (isMe)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _toggleMicRealtime();
                          },
                          icon: Icon(
                            _roomController.microphoneEnabled
                                ? Icons.mic_off_rounded
                                : Icons.mic_rounded,
                            size: 18,
                          ),
                          label: Text(
                            _roomController.microphoneEnabled
                                ? 'Mute'
                                : 'Unmute',
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(44),
                            side: BorderSide(
                              color: _pink.withValues(alpha: .35),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _leaveMicRealtime();
                          },
                          icon: const Icon(Icons.logout_rounded, size: 18),
                          label: const Text('Leave Mic'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDA345B),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            minimumSize: const Size.fromHeight(44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: _sheetAction(
                          icon: Icons.person_outline_rounded,
                          text: 'Profile',
                          onTap: () {
                            Navigator.pop(context);
                            _openRoomProfile();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _sheetAction(
                          icon: Icons.card_giftcard_rounded,
                          text: 'Gift',
                          onTap: () {
                            Navigator.pop(context);
                            _showGiftSheet();
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sheetAction({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(44),
        side: BorderSide(color: _pink.withValues(alpha: .25)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _showOwnerSeatControls(int index) {
    final seat = _room.seats[index];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF190837),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Mic ${seat.number} Controls',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);

                    _setSeatLockRealtime(index, lock: !seat.isLocked);
                  },
                  leading: Icon(
                    seat.isLocked
                        ? Icons.lock_open_rounded
                        : Icons.lock_rounded,
                    color: _pink,
                  ),
                  title: Text(
                    seat.isLocked ? 'Unlock Mic' : 'Lock Mic',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: Column(
        children: [
          Row(
            children: [
              _tabButton('All', 0),
              const SizedBox(width: 26),
              _tabButton('Chat', 1),
            ],
          ),
          const SizedBox(height: 6),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(height: 1, color: _pink.withValues(alpha: .28)),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                left: _tab == 0 ? 0 : 50,
                child: Container(
                  width: 44,
                  height: 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFFFF82FF),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF60FD).withValues(alpha: .65),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String text, int index) {
    final bool active = _tab == index;

    return GestureDetector(
      onTap: () => setState(() => _tab = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: active ? Colors.white : const Color(0xFF8B438E),
            fontSize: 13,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildRoomActions() {
    if (_tab == 1) {
      return _buildChatPanel();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 0),
      child: Column(
        children: [
          _buildAnnouncementCard(),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _quickAction(
                      'Revise your room announcement !',
                      Icons.edit_outlined,
                          () => _showMessage('Announcement editor'),
                    ),
                    const SizedBox(height: 9),
                    _quickAction(
                      _roomController.isOnMic
                          ? 'Leave your mic seat'
                          : 'Take a seat and join the party',
                      _roomController.isOnMic
                          ? Icons.logout_rounded
                          : Icons.mic_none_rounded,
                          () {
                        if (_roomController.isOnMic) {
                          _leaveMicRealtime();
                          return;
                        }

                        final emptyIndex = _room.seats.indexWhere(
                              (seat) => seat.isEmpty,
                        );

                        if (emptyIndex == -1) {
                          _showMessage('No empty mic seat available.');
                          return;
                        }

                        _showJoinMicSheet(emptyIndex);
                      },
                    ),
                    const SizedBox(height: 9),
                    _quickAction(
                      'Share your room with friends !',
                      Icons.share_rounded,
                          () => _showMessage('Share room'),
                    ),
                    const SizedBox(height: 12),
                    _buildTreasureBanner(),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  _sideReward(
                    'LUCKY',
                    Icons.emoji_events_rounded,
                    const Color(0xFFD78A1D),
                  ),
                  const SizedBox(height: 8),
                  _sideReward(
                    'VIP',
                    Icons.rocket_launch_rounded,
                    const Color(0xFF4A53D8),
                  ),
                  const SizedBox(height: 8),
                  _sideReward(
                    '3',
                    Icons.stars_rounded,
                    const Color(0xFFF6A300),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard() {
    return Container(
      constraints: const BoxConstraints(minHeight: 84),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFF130235).withValues(alpha: .74),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _pink.withValues(alpha: .30)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF7B21D6), Color(0xFFCB2FFF)],
              ),
              boxShadow: [
                BoxShadow(color: _pink.withValues(alpha: .18), blurRadius: 8),
              ],
            ),
            child: const Icon(
              Icons.campaign_rounded,
              color: Color(0xFFFFE158),
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _room.announcement,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 11.5,
                height: 1.25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 58,
            height: 34,
            child: OutlinedButton(
              onPressed: () => _showMessage('Announcement editor'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: const Color(0xFFFFE72D),
                side: const BorderSide(color: Color(0xFFFFE72D), width: 1.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Edit',
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickAction(String title, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF33C6C4), Color(0xFF149CA8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: .12)),
            boxShadow: [
              BoxShadow(color: _cyan.withValues(alpha: .10), blurRadius: 8),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Icon(icon, color: Colors.white, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTreasureBanner() {
    final message = _activityMessages.isEmpty
        ? 'Welcome to Junaya.'
        : _activityMessages.first;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: const Color(0xFF12012D),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: _pink.withValues(alpha: .26)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_rounded,
            color: Color(0xFFFFD76A),
            size: 15,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 9.8,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'GO›',
            style: GoogleFonts.poppins(
              color: const Color(0xFFFFD76A),
              fontSize: 16,
              fontWeight: FontWeight.w800,
              shadows: const [Shadow(color: Color(0xFFFFB300), blurRadius: 8)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sideReward(String label, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => _showMessage(label == '3' ? 'Rewards' : label),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          gradient: LinearGradient(
            colors: [color.withValues(alpha: .94), const Color(0xFF371045)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(color: Colors.white.withValues(alpha: .20)),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: .15), blurRadius: 7),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Icon(icon, color: Colors.white, size: 26),
            Positioned(
              bottom: 3,
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 6.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (label == '3')
              Positioned(
                right: -4,
                top: -5,
                child: Container(
                  width: 17,
                  height: 17,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatPanel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Column(
        children: [
          if (_chatMessages.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Text(
                'No messages yet.',
                style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11),
              ),
            )
          else
            ..._chatMessages.take(30).map((entry) => _chatMessage(entry)),
          const SizedBox(height: 4),
          InkWell(
            onTap: _showChatComposer,
            borderRadius: BorderRadius.circular(22),
            child: Ink(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 13),
              decoration: BoxDecoration(
                color: const Color(0xFF210941),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: _pink.withValues(alpha: .20)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: Color(0xFFFFD76A),
                    size: 17,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Say something...',
                      style: GoogleFonts.poppins(
                        color: Colors.white38,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.send_rounded,
                    color: Colors.white54,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatMessage(_RoomChatEntry entry) {
    final Color nameColor = entry.isSystem
        ? const Color(0xFFFFD76A)
        : entry.isMe
        ? const Color(0xFF53E68A)
        : const Color(0xFFE890FF);

    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.fromLTRB(9, 8, 10, 8),
      decoration: entry.isSystem
          ? BoxDecoration(
        color: const Color(0xFFFFD76A).withValues(alpha: .06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFFFD76A).withValues(alpha: .16),
        ),
      )
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _chatAvatar(entry),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  if (entry.badge != null)
                    TextSpan(
                      text: '[${entry.badge}] ',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFFFD76A),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  TextSpan(
                    text: entry.isMe ? 'You: ' : '${entry.name}: ',
                    style: GoogleFonts.poppins(
                      color: nameColor,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: entry.message,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 10.5,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatAvatar(_RoomChatEntry entry) {
    if (entry.isSystem) {
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: const Color(0xFFFFD76A).withValues(alpha: .14),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.notifications_rounded,
          color: Color(0xFFFFD76A),
          size: 15,
        ),
      );
    }

    if (entry.avatar != null && entry.avatar!.isNotEmpty) {
      return ClipOval(
        child: Image.asset(
          entry.avatar!,
          width: 28,
          height: 28,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) {
            return _chatAvatarFallback(entry.name);
          },
        ),
      );
    }

    return _chatAvatarFallback(entry.name);
  }

  Widget _chatAvatarFallback(String name) {
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF6E2AB0), Color(0xFF314AA7)],
        ),
      ),
      child: Text(
        name.isEmpty ? 'U' : name[0].toUpperCase(),
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final items = <_RoomBottomItem>[
      _RoomBottomItem(icon: Icons.grid_view_rounded, onTap: _openRoomProfile),
      _RoomBottomItem(
        icon: _roomController.speakerEnabled
            ? Icons.volume_up_rounded
            : Icons.volume_off_rounded,
        onTap: () {
          _roomController.toggleSpeaker();

          _liveKitVoiceService.setSpeakerEnabled(_roomController.speakerEnabled);

          _showMessage(
            _roomController.speakerEnabled
                ? 'Room sound enabled'
                : 'Room sound muted',
          );
        },
      ),
      _RoomBottomItem(
        icon: Icons.chat_bubble_rounded,
        onTap: _showChatComposer,
      ),
      _RoomBottomItem(
        icon: Icons.mail_rounded,
        showNotificationDot: true,
        onTap: () => _showMessage('Messages'),
      ),
      _RoomBottomItem(
        icon: Icons.sports_esports_rounded,
        isGame: true,
        onTap: () => _showMessage('Games'),
      ),
      _RoomBottomItem(
        icon: Icons.card_giftcard_rounded,
        isGift: true,
        onTap: _showGiftSheet,
      ),
    ];

    return SafeArea(
      top: false,
      child: Container(
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: _bg,
          border: Border(top: BorderSide(color: _pink.withValues(alpha: .08))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .18),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(items.length, (index) {
            final item = items[index];

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: item.onTap,
                customBorder: const CircleBorder(),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: item.isGift
                            ? const LinearGradient(
                          colors: [Color(0xFF7C24D8), Color(0xFF3E125E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : item.isGame
                            ? const LinearGradient(
                          colors: [Color(0xFF4826A8), Color(0xFF231045)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : null,
                        color: (item.isGift || item.isGame)
                            ? null
                            : const Color(0xFF2A1154).withValues(alpha: .82),
                        border: Border.all(
                          color: item.isGift
                              ? const Color(0xFFFF65EB).withValues(alpha: .55)
                              : _pink.withValues(alpha: .35),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: item.isGift
                                ? const Color(0xFFFF48ED).withValues(alpha: .22)
                                : _pink.withValues(alpha: .09),
                            blurRadius: item.isGift ? 10 : 7,
                          ),
                        ],
                      ),
                      child: item.isGift
                          ? const Center(
                        child: Text(
                          '🎁',
                          style: TextStyle(fontSize: 24, height: 1),
                        ),
                      )
                          : item.isGame
                          ? const Center(
                        child: Text(
                          '🎮',
                          style: TextStyle(fontSize: 24, height: 1),
                        ),
                      )
                          : Icon(item.icon, color: Colors.white, size: 21),
                    ),
                    if (item.showNotificationDot)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF3E5F),
                            shape: BoxShape.circle,
                            border: Border.all(color: _bg, width: 1.2),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _showMemberSheet() {
    final members = _room.members;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * .55,
          decoration: const BoxDecoration(
            color: Color(0xFF160633),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Room Members (${members.length})',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: members.isEmpty
                    ? Center(
                  child: Text(
                    'No online members',
                    style: GoogleFonts.poppins(
                      color: Colors.white38,
                    ),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: members.length,
                  itemBuilder: (_, index) {
                    final user = members[index];

                    final seatIndex = _room.seats.indexWhere(
                          (seat) => seat.user?.id == user.id,
                    );

                    final isOnMic = seatIndex != -1;

                    String role;

                    if (user.isHost) {
                      role = 'Room Owner';
                    } else if (user.isAdmin) {
                      role = 'Admin';
                    } else if (isOnMic) {
                      role = 'On Mic ${_room.seats[seatIndex].number}';
                    } else {
                      role = 'Listener';
                    }

                    return _memberTile(
                      user.name,
                      role,
                      user.isHost,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _memberTile(String name, String role, bool host) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF45217B),
        child: Icon(
          host ? Icons.workspace_premium : Icons.person,
          color: Colors.white,
          size: 20,
        ),
      ),
      title: Text(
        name,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        role,
        style: GoogleFonts.poppins(color: Colors.white38, fontSize: 9.5),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white24),
    );
  }

  void _showGiftSheet() {
    final gifts = [
      ['🌹', 'Rose', '10'],
      ['❤️', 'Love', '20'],
      ['🎁', 'Box', '50'],
      ['💎', 'Diamond', '100'],
      ['👑', 'Crown', '500'],
      ['🚀', 'Rocket', '1000'],
      ['🏎️', 'Car', '2500'],
      ['🏰', 'Castle', '5000'],
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          decoration: const BoxDecoration(
            color: Color(0xFF160633),
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    'Gifts',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.monetization_on_rounded,
                    color: Color(0xFFFFC442),
                    size: 17,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '12,500',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFFFD766),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              GridView.builder(
                shrinkWrap: true,
                itemCount: gifts.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 7,
                  childAspectRatio: .86,
                ),
                itemBuilder: (_, index) {
                  final gift = gifts[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);

                      _addActivity('You sent ${gift[1]} ${gift[0]}');

                      _showMessage('${gift[1]} sent successfully');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .045),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .05),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(gift[0], style: const TextStyle(fontSize: 28)),
                          const SizedBox(height: 4),
                          Text(
                            gift[1],
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 9.5,
                            ),
                          ),
                          Text(
                            '🪙 ${gift[2]}',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFFFCE58),
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMoreSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
          decoration: const BoxDecoration(
            color: Color(0xFF160633),
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _moreAction(Icons.share_rounded, 'Share', () {
                    Navigator.pop(context);
                    _showMessage('Share room');
                  }),
                  _moreAction(Icons.settings_outlined, 'Room', () {
                    Navigator.pop(context);
                    _showMessage('Room settings');
                  }),
                  _moreAction(Icons.report_outlined, 'Report', () {
                    Navigator.pop(context);
                    _showMessage('Report room');
                  }),
                  _moreAction(Icons.logout_rounded, 'Leave', () {
                    Navigator.pop(context);
                    Navigator.maybePop(context);
                  }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _moreAction(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .06),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 21),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.poppins(color: Colors.white60, fontSize: 9.5),
          ),
        ],
      ),
    );
  }
}

class _RoomChatEntry {
  final String userId;
  final String name;
  final String? avatar;
  final String message;
  final String? badge;
  final bool isSystem;
  final bool isMe;

  const _RoomChatEntry({
    this.userId = '',
    required this.name,
    this.avatar,
    required this.message,
    this.badge,
    this.isSystem = false,
    this.isMe = false,
  });
}

class _RoomBottomItem {
  final IconData icon;
  final VoidCallback onTap;
  final bool showNotificationDot;
  final bool isGame;
  final bool isGift;

  const _RoomBottomItem({
    required this.icon,
    required this.onTap,
    this.showNotificationDot = false,
    this.isGame = false,
    this.isGift = false,
  });
}
