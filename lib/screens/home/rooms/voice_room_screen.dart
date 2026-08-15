import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'room_screen.dart';

/// Backward-compatible entry point for routes that already open
/// VoiceRoomScreen(roomId: ...).
///
/// Firestore is intentionally removed. Room state now comes from the
/// Socket.IO backend through RoomScreen.
class VoiceRoomScreen extends StatefulWidget {
  final String roomId;
  final String? currentUserId;
  final String? currentUserName;
  final String? currentUserAvatar;
  final String socketServerUrl;

  const VoiceRoomScreen({
    super.key,
    required this.roomId,
    this.currentUserId,
    this.currentUserName,
    this.currentUserAvatar,
    this.socketServerUrl = '',
  });

  @override
  State<VoiceRoomScreen> createState() => _VoiceRoomScreenState();
}

class _VoiceRoomScreenState extends State<VoiceRoomScreen> {
  late final String _resolvedUserId;
  late final String _resolvedUserName;

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
  }

  @override
  Widget build(BuildContext context) {
    return RoomScreen(
      roomId: widget.roomId,
      currentUserId: _resolvedUserId,
      currentUserName: _resolvedUserName,
      currentUserAvatar: widget.currentUserAvatar,
      socketServerUrl: widget.socketServerUrl,
    );
  }
}
