import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/core/config/app_config.dart';
import 'package:junaya_voicechat_app/controllers/room_controller.dart';
import 'package:junaya_voicechat_app/core/storage/token_storage.dart';
import 'package:junaya_voicechat_app/models/voice_room_model.dart';
import 'package:junaya_voicechat_app/routes/app_routes.dart';
import 'package:junaya_voicechat_app/services/backend_auth_service.dart';
import 'package:junaya_voicechat_app/services/livekit_voice_service.dart';

import 'room_profile_screen.dart';
import 'room_socket_service.dart';
import 'widgets/room_bottom_controls.dart';
import 'widgets/room_chat_panel.dart';
import 'widgets/room_seat_grid.dart';
import 'widgets/room_top_overlay.dart';

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
  final String backgroundAsset;
  final bool enableRealtime;

  const RoomScreen({
    super.key,
    this.roomId = 'junaya-main',
    this.currentUserId,
    this.currentUserName,
    this.currentUserAvatar,
    this.socketServerUrl = '',
    this.backgroundAsset = 'assets/rooms/mralex.png',
    this.enableRealtime = true,
  });

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> with WidgetsBindingObserver {
  static const Color _pink = Color(0xFFFF48ED);

  late final RoomController _roomController;
  late final RoomSocketService _socketService;
  late final LiveKitVoiceService _liveKitVoiceService;

  bool _socketConnected = false;
  String? _socketError;

  bool _liveKitConnected = false;

  bool _exitSheetOpen = false;
  bool _isLeavingRoom = false;
  bool _roomExitHandled = false;

  final List<String> _activityMessages = [
    'Welcome to Junaya Voice Room 👋',
  ];

  final TextEditingController _chatController = TextEditingController();

  String? _currentJunayaId;
  int _currentVipLevel = 0;

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

  final List<RoomChatDisplayItem> _chatMessages = [
    const RoomChatDisplayItem(
      name: 'System',
      message: 'Welcome to Junaya Voice Room.',
      badge: 'ROOM',
      isSystem: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _enterImmersiveRoomMode();
    // The room identity is resolved from /api/auth/me before Socket.IO
    // connects. Widget-supplied IDs are never trusted for authorization.
    _roomController = RoomController(
      currentUserId: '',
      currentUserName: 'Authenticating...',
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

        _showMessage(message);
      },
    );

    _liveKitVoiceService.addListener(_liveKitUpdated);

    if (widget.enableRealtime) {
      _connectRealtimeRoom();
    }
  }

  void _enterImmersiveRoomMode() {
    if (kIsWeb) return;

    if (defaultTargetPlatform == TargetPlatform.android) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _restoreSystemUi() async {
    if (kIsWeb) return;

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_roomExitHandled) {
      _enterImmersiveRoomMode();
    }
  }

  Future<void> _connectRealtimeRoom() async {
    _roomController.setLoading(true);

    try {
      // This API call also exercises the Dio refresh-token interceptor. If the
      // 15-minute access token expired, it is refreshed before Socket.IO uses it.
      final user = await BackendAuthService.instance.getCurrentUser();
      final accessToken = await TokenStorage.getAccessToken();

      final userId = user['id']?.toString().trim() ?? '';
      final username = user['username']?.toString().trim() ?? '';
      final avatar = user['avatar']?.toString();
      final junayaId = user['junayaId']?.toString().trim();
      final vipLevel = int.tryParse(user['vipLevel']?.toString() ?? '') ?? 0;

      if (userId.isEmpty || username.isEmpty) {
        throw Exception('Authenticated user identity is incomplete.');
      }

      if (accessToken == null || accessToken.trim().isEmpty) {
        throw Exception('Authentication token is missing. Please sign in again.');
      }

      if (!mounted) return;

      _roomController.setAuthenticatedUser(
        id: userId,
        name: username,
        avatar: avatar,
      );

      setState(() {
        _currentJunayaId = junayaId;
        _currentVipLevel = vipLevel;
      });

      debugPrint(
        '🌐 AUTHENTICATED SOCKET CONNECT START: '
            'url=$_resolvedSocketServerUrl '
            'platform=${kIsWeb ? "WEB" : "ANDROID"} '
            'room=${widget.roomId} '
            'user=$userId',
      );

      _socketService.connect(
        serverUrl: _resolvedSocketServerUrl,
        token: accessToken,
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
        onRoomUpdate: (roomJson) {
          if (!mounted) return;
          _roomController.updateRoomFromServer(roomJson);
        },
        onUserJoined: (data) {
          final name = data['name']?.toString() ?? 'A user';
          _addActivity('$name joined the room');

          _addChatEntry(
            RoomChatDisplayItem(
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
            RoomChatDisplayItem(
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

          String chatUserId = '';
          String name = 'User';
          String? avatar;
          int vipLevel = 0;

          if (rawUser is Map) {
            chatUserId = rawUser['id']?.toString() ?? '';
            name = rawUser['name']?.toString() ?? 'User';
            avatar = rawUser['avatar']?.toString();
            vipLevel = int.tryParse(rawUser['vipLevel']?.toString() ?? '') ?? 0;
          }

          final message = data['message']?.toString().trim() ?? '';
          if (message.isEmpty) return;

          _addChatEntry(
            RoomChatDisplayItem(
              userId: chatUserId,
              name: name,
              avatar: avatar,
              vipLevel: vipLevel,
              message: message,
              isMe: chatUserId == _roomController.currentUserId,
            ),
          );

          _addActivity('$name: $message');
        },
      );
    } catch (error) {
      if (!mounted) return;

      final message = error.toString().replaceFirst('Exception: ', '');
      setState(() {
        _socketConnected = false;
        _socketError = message;
      });
      _roomController.setError(message);
    }
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
      onResult: (ok, livekit, error) {
        if (!mounted) return;

        if (!ok || livekit == null) {
          final message = error ?? 'Unable to obtain secure LiveKit token.';

          if (showErrors) {
            _showMessage(message);
          }
          return;
        }

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

    // Leaving the UI should never trap the user in the room because a socket
    // acknowledgement is late or lost. The backend also cleans membership on
    // disconnect, so this acknowledgement is best-effort for the exit flow.
    _socketService.leaveRoom(
      roomId: widget.roomId,
      onResult: (ok, error) {
        if (!mounted || _roomExitHandled) return;

        if (!ok) {
          debugPrint('Room leave acknowledgement failed: $error');
        }

        _finishRoomExit();
      },
    );

    Future<void>.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted || _roomExitHandled) return;
      _finishRoomExit();
    });
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

    await _restoreSystemUi();

    if (!mounted) return;

    // PopScope intentionally intercepts the Android/system back action while
    // inside a voice room, so maybePop() can leave this route stuck. A finished
    // room exit always returns to Junaya's main Home screen explicitly.
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _restoreSystemUi();
    if (_socketConnected && !_roomExitHandled) {
      _socketService.leaveRoom(
        roomId: widget.roomId,
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

  Future<void> _openRoomProfile() async {
    await _restoreSystemUi();
    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RoomProfileScreen()),
    );

    if (mounted && !_roomExitHandled) {
      _enterImmersiveRoomMode();
    }
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

  void _addChatEntry(RoomChatDisplayItem entry) {
    if (!mounted) return;

    setState(() {
      _chatMessages.add(entry);

      if (_chatMessages.length > 100) {
        _chatMessages.removeAt(0);
      }

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
      message: message,
      onResult: (ok, error) {
        if (!mounted) return;

        if (ok) {
          _chatController.clear();

        } else {
          _showMessage(error ?? 'Unable to send message');
        }
      },
    );
  }

  void _showChatComposer() {
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

    if (!_liveKitConnected) {
      _showMessage('Voice is still connecting. Try the mic again in a moment.');
      return;
    }

    _socketService.joinSeat(
      roomId: widget.roomId,
      seatNumber: index + 1,
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
        onResult: onResult,
      );
    } else {
      _socketService.unlockSeat(
        roomId: widget.roomId,
        seatNumber: seat.number,
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
          backgroundColor: const Color(0xFF05030A),
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_roomController.loading)
                      const CircularProgressIndicator(
                        color: Color(0xFFFFC44F),
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

    final roomOwner = _findRoomOwner(currentRoom);
    final ownerIsCurrentUser =
        currentRoom.ownerId == _roomController.currentUserId;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showExitRoomSheet();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF05030A),
        body: LayoutBuilder(
          builder: (context, constraints) {
            const designWidth = 738.0;
            const designHeight = 1600.0;

            // The client's approved reference is 738 x 1600. Building the room
            // on that exact coordinate system and uniformly scaling it keeps
            // the header, 5x5 microphones, chat and controls aligned across
            // phones instead of reflowing each section independently.
            return Center(
              child: ClipRect(
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      width: designWidth,
                      height: designHeight,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          RepaintBoundary(
                            child: Image.asset(
                              widget.backgroundAsset,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              filterQuality: FilterQuality.high,
                              errorBuilder: (_, _, _) {
                                return const DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF0B0713),
                                        Color(0xFF26121A),
                                        Color(0xFF05030A),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            right: 0,
                            height: 210,
                            child: IgnorePointer(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withValues(alpha: .58),
                                      Colors.black.withValues(alpha: .18),
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            right: 0,
                            child: RoomTopOverlay(
                              room: currentRoom,
                              owner: roomOwner,
                              mediaBaseUrl: AppConfig.apiBaseUrl,
                              socketConnected: _socketConnected,
                              voiceConnected: _liveKitConnected,
                              ownerPublicId: ownerIsCurrentUser
                                  ? _currentJunayaId
                                  : roomOwner?.junayaId,
                              ownerVipLevel: ownerIsCurrentUser
                                  ? _currentVipLevel
                                  : roomOwner?.vipLevel,
                              onOwnerTap: _openRoomProfile,
                              onMembersTap: _showMemberSheet,
                              onCloseTap: _showExitRoomSheet,
                            ),
                          ),
                          // Bring the 5x5 mic stage up directly beneath the
                          // header/artwork instead of reserving a large empty
                          // middle band. The grid itself adds generous row and
                          // column spacing, so the room feels open without
                          // wasting the upper half of the stage.
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 330,
                            height: 820,
                            child: RoomSeatGrid(
                              seats: currentRoom.seats,
                              currentUserId: _roomController.currentUserId,
                              mediaBaseUrl: AppConfig.apiBaseUrl,
                              isRoomOwner: _roomController.isRoomOwner,
                              onSeatTap: _handleSeatTap,
                              onSeatLongPress: _showOwnerSeatControls,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 1228,
                            height: 278,
                            child: RoomChatPanel(
                              messages: _chatMessages,
                              onTap: _showChatComposer,
                              rightActionInset: 122,
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 1218,
                            child: RoomSideActionRail(
                              onLucky: () => _showMessage('Lucky Feedback'),
                              onVip: () => _showMessage('VIP room features'),
                              onRewards: () => _showMessage('Room rewards'),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: RoomBottomControls(
                              onChat: _showChatComposer,
                              onEmoji: _showChatComposer,
                              onMedia: () =>
                                  _showMessage('Media sharing is coming next.'),
                              onTools: _showMoreSheet,
                              onGift: _showGiftSheet,
                              onGame: () => _showMessage('Games'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  RoomUser? _findRoomOwner(VoiceRoom room) {
    for (final member in room.members) {
      if (member.id == room.ownerId) {
        return member;
      }
    }

    if (room.ownerId == _roomController.currentUserId) {
      return RoomUser(
        id: _roomController.currentUserId,
        name: _roomController.currentUserName,
        avatar: _roomController.currentUserAvatar,
        junayaId: _currentJunayaId,
        vipLevel: _currentVipLevel,
        isHost: true,
      );
    }

    return room.members.isEmpty ? null : room.members.first;
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
                Container(
                  width: 68,
                  height: 68,
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFC54B), Color(0xFF9D4CFF)],
                    ),
                  ),
                  child: ClipOval(
                    child: _roomAvatarImage(
                      source: user.avatar,
                      name: user.name,
                    ),
                  ),
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
                      user,
                      role,
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

  Widget _memberTile(RoomUser user, String role) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
      leading: Container(
        width: 42,
        height: 42,
        padding: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: user.isHost
              ? const LinearGradient(
                  colors: [Color(0xFFFFC54B), Color(0xFF9D4CFF)],
                )
              : const LinearGradient(
                  colors: [Color(0xFF5D327A), Color(0xFF31214D)],
                ),
        ),
        child: ClipOval(
          child: _roomAvatarImage(
            source: user.avatar,
            name: user.name,
          ),
        ),
      ),
      title: Text(
        user.name,
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
      trailing: user.isHost
          ? const Icon(
              Icons.workspace_premium_rounded,
              color: Color(0xFFFFC54B),
              size: 20,
            )
          : const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white24,
            ),
    );
  }

  Widget _roomAvatarImage({
    required String? source,
    required String name,
  }) {
    final value = source?.trim() ?? '';

    Widget fallback() {
      return Container(
        alignment: Alignment.center,
        color: const Color(0xFF45217B),
        child: Text(
          name.trim().isEmpty ? 'J' : name.trim()[0].toUpperCase(),
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    if (value.isEmpty) return fallback();

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return Image.network(
        value,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback(),
      );
    }

    if (value.startsWith('/')) {
      final base = AppConfig.apiBaseUrl.endsWith('/')
          ? AppConfig.apiBaseUrl.substring(0, AppConfig.apiBaseUrl.length - 1)
          : AppConfig.apiBaseUrl;
      return Image.network(
        '$base$value',
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback(),
      );
    }

    return Image.asset(
      value,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => fallback(),
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
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Container(
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
                Wrap(
                  alignment: WrapAlignment.spaceAround,
                  runAlignment: WrapAlignment.center,
                  spacing: 18,
                  runSpacing: 16,
                  children: [
                    _moreAction(Icons.share_rounded, 'Share', () {
                      Navigator.pop(sheetContext);
                      _showMessage('Share room');
                    }),
                    _moreAction(
                      _roomController.speakerEnabled
                          ? Icons.volume_up_rounded
                          : Icons.volume_off_rounded,
                      'Sound',
                      () {
                        Navigator.pop(sheetContext);
                        _roomController.toggleSpeaker();
                        _liveKitVoiceService.setSpeakerEnabled(
                          _roomController.speakerEnabled,
                        );
                        _showMessage(
                          _roomController.speakerEnabled
                              ? 'Room sound enabled'
                              : 'Room sound muted',
                        );
                      },
                    ),
                    _moreAction(
                      _roomController.isOnMic
                          ? (_roomController.microphoneEnabled
                              ? Icons.mic_rounded
                              : Icons.mic_off_rounded)
                          : Icons.mic_none_rounded,
                      'Mic',
                      () {
                        Navigator.pop(sheetContext);
                        if (_roomController.isOnMic) {
                          _toggleMicRealtime();
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
                    _moreAction(Icons.settings_outlined, 'Room', () {
                      Navigator.pop(sheetContext);
                      _showMessage('Room settings');
                    }),
                    _moreAction(Icons.report_outlined, 'Report', () {
                      Navigator.pop(sheetContext);
                      _showMessage('Report room');
                    }),
                    _moreAction(Icons.logout_rounded, 'Leave', () {
                      Navigator.pop(sheetContext);
                      Future<void>.delayed(Duration.zero, _showExitRoomSheet);
                    }),
                  ],
                ),
              ],
            ),
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
