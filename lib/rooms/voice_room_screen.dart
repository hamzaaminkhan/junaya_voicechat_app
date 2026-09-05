import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'room_screen.dart';

/// Main entry point for opening a Junaya voice room.
///
/// This screen intentionally remains a lightweight route wrapper.
/// The actual room UI and room behavior are handled by [RoomScreen].
///
/// Backend:
/// - Socket.IO is handled by RoomScreen / room services.
/// - Firestore is not used here.
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
  State<VoiceRoomScreen> createState() {
    return _VoiceRoomScreenState();
  }
}

class _VoiceRoomScreenState
    extends State<VoiceRoomScreen> {

  late final String _resolvedUserId;

  late final String _resolvedUserName;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _resolveCurrentUser();
  }

  void _resolveCurrentUser() {
    final suppliedId =
        widget.currentUserId?.trim() ?? '';

    final suppliedName =
        widget.currentUserName?.trim() ?? '';

    final uniqueSuffix =
    DateTime.now()
        .microsecondsSinceEpoch
        .toString();

    final platformPrefix =
    kIsWeb
        ? 'web'
        : 'android';

    // ------------------------------------------------------------
    // USER ID
    // ------------------------------------------------------------

    if (suppliedId.isNotEmpty) {
      _resolvedUserId =
          suppliedId;
    } else {
      _resolvedUserId =
      '${platformPrefix}_$uniqueSuffix';
    }

    // ------------------------------------------------------------
    // USER NAME
    // ------------------------------------------------------------

    if (suppliedName.isNotEmpty) {
      _resolvedUserName =
          suppliedName;
    } else {
      final suffix =
      uniqueSuffix.length >= 4
          ? uniqueSuffix.substring(
        uniqueSuffix.length - 4,
      )
          : uniqueSuffix;

      _resolvedUserName =
      'Guest $suffix';
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    return RoomScreen(
      roomId: widget.roomId,

      currentUserId:
      _resolvedUserId,

      currentUserName:
      _resolvedUserName,

      currentUserAvatar:
      widget.currentUserAvatar,

      socketServerUrl:
      widget.socketServerUrl,
    );
  }
}