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
            12,
            16,
            0,
          ),
          child: Column(
            children: [
              _buildTopRow(),

              const SizedBox(height: 14),

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

              const SizedBox(height: 7),

              Row(
                children: [
                  Text(
                    'ID:$junayaId',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(.9),
                      fontSize: 15,
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
        ),

        const SizedBox(width: 12),

        // --------------------------------------------------------
        // COLLAPSE
        // --------------------------------------------------------

        _buildActionButton(
          icon: Icons.keyboard_arrow_up_rounded,
          onTap: onCollapse,
        ),
      ],
    );
  }

  // ============================================================
  // HOST AVATAR
  // ============================================================

  Widget _buildHostAvatar() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(.12),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildAvatarImage(
        avatar: hostAvatar,
        fallbackText: hostName,
        iconSize: 34,
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
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 38,
        height: 38,
        child: Icon(
          icon,
          color: Colors.white,
          size: 32,
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
          height: 48,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.10),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                color: Color(0xffffd75a),
                size: 27,
              ),

              const SizedBox(width: 12),

              Text(
                _formatSending(totalSending),
                style: const TextStyle(
                  color: Color(0xffffd75a),
                  fontSize: 17,
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
            width: 48,
            height: 48,
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
      width: 48,
      height: 48,
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
        iconSize: 24,
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