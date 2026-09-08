import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/rooms/data/room_top_users.dart';
import 'package:junaya_voicechat_app/rooms/models/room_top_user_model.dart';

class RoomHeader extends StatelessWidget {
  const RoomHeader({
    super.key,
    this.roomName = '97045821',
    this.junayaId = '97045821',
    this.hostName = '97045821',
    this.hostAvatar,
    this.hostLevel = 0,
    this.totalSending = 0,
    this.onBack,
    this.onRefresh,
    this.onCollapse,
    this.onMicTap,
  });

  final String roomName;

  final String junayaId;

  final String hostName;

  final String? hostAvatar;

  final int hostLevel;

  final int totalSending;

  final VoidCallback? onBack;

  final VoidCallback? onRefresh;

  final VoidCallback? onCollapse;

  final VoidCallback? onMicTap;

  @override
  Widget build(BuildContext context) {
    final topUser =
    visibleRoomTopUsers.isNotEmpty
        ? visibleRoomTopUsers.first
        : null;

    return SizedBox(
      width: double.infinity,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            16,
            0,
          ),
          child: Column(
            children: [
              _buildTopRow(),

              const SizedBox(height: 18),

              _buildRoomStats(
                topUser: topUser,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TOP ROW
  // ============================================================

  Widget _buildTopRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // --------------------------------------------------------
        // HOST AVATAR
        // --------------------------------------------------------

        _buildHostAvatar(),

        const SizedBox(width: 14),

        // --------------------------------------------------------
        // ROOM INFORMATION
        // --------------------------------------------------------

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                roomName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),

              const SizedBox(height: 9),

              Row(
                children: [
                  Text(
                    'ID:$junayaId',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(.9),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(width: 7),

                  _buildLevelBadge(),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

// --------------------------------------------------------
// REFRESH
// --------------------------------------------------------

        _buildActionButton(
          icon: Icons.refresh_rounded,
          onTap: onRefresh,
          size: 38,
        ),

        const SizedBox(width: 12),

// --------------------------------------------------------
// COLLAPSE
// --------------------------------------------------------

        _buildActionButton(
          icon: Icons.keyboard_arrow_up_rounded,
          onTap: onCollapse,
          size: 38,
        ),
      ],
    );
  }

  // ============================================================
  // HOST AVATAR
  // ============================================================

  Widget _buildHostAvatar() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(.12),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildAvatarImage(
        avatar: hostAvatar,
        fallbackText: hostName,
        iconSize: 42,
      ),
    );
  }

  // ============================================================
  // LEVEL BADGE
  // ============================================================

  Widget _buildLevelBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff6B3A8E),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color(0xffD8A5FF),
          width: .6,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.diamond_rounded,
            color: Color(0xffE8B4FF),
            size: 11,
          ),

          const SizedBox(width: 3),

          Text(
            hostLevel.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER ACTION
  // ============================================================

  Widget _buildActionButton({
    required IconData icon,
    VoidCallback? onTap,
    double size = 32,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Icon(
          icon,
          color: Colors.white,
          size: size,
        ),
      ),
    );
  }

  // ============================================================
  // ROOM STATS
  // ============================================================

  Widget _buildRoomStats({
    RoomTopUser? topUser,
  }) {
    return Row(
      children: [
        // --------------------------------------------------------
        // TROPHY / SENDING
        // --------------------------------------------------------

        Container(
          height: 54,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.10),
            borderRadius: BorderRadius.circular(31),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                color: Color(0xffffd75a),
                size: 31,
              ),

              const SizedBox(width: 12),

              Text(
                _formatSending(totalSending),
                style: const TextStyle(
                  color: Color(0xffffd75a),
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // --------------------------------------------------------
        // TOP USER
        // --------------------------------------------------------

        if (topUser != null) ...[
          _buildTopUserAvatar(topUser),

          const SizedBox(width: 10),
        ],

        // --------------------------------------------------------
        // MIC BUTTON
        // --------------------------------------------------------

        GestureDetector(
          onTap: onMicTap,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.graphic_eq_rounded,
              color: Color(0xff21E1D2),
              size: 27,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TOP USER AVATAR
  // ============================================================

  Widget _buildTopUserAvatar(
      RoomTopUser user,
      ) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(.25),
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildAvatarImage(
        avatar: user.avatar,
        fallbackText: user.name,
        iconSize: 28,
      ),
    );
  }

  // ============================================================
  // AVATAR IMAGE
  // ============================================================

  Widget _buildAvatarImage({
    required String? avatar,
    required String fallbackText,
    required double iconSize,
  }) {
    if (avatar != null && avatar.trim().isNotEmpty) {
      return Image.network(
        avatar,
        fit: BoxFit.cover,
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return _buildAvatarFallback(
            fallbackText,
            iconSize,
          );
        },
      );
    }

    return _buildAvatarFallback(
      fallbackText,
      iconSize,
    );
  }

  Widget _buildAvatarFallback(
      String name,
      double iconSize,
      ) {
    final firstLetter =
    name.trim().isEmpty
        ? '?'
        : name.trim()[0].toUpperCase();

    return Container(
      color: const Color(0xff17091F),
      alignment: Alignment.center,
      child: Text(
        firstLetter,
        style: TextStyle(
          color: Colors.white,
          fontSize: iconSize,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ============================================================
  // NUMBER FORMAT
  // ============================================================

  String _formatSending(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }

    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }

    return value.toString();
  }
}