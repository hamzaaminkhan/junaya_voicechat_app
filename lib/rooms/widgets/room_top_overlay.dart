import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:junaya_voicechat_app/rooms/models/voice_room_model.dart';

class RoomTopOverlay extends StatelessWidget {
  final VoiceRoom room;

  final RoomUser? owner;

  final String mediaBaseUrl;

  final bool socketConnected;

  final bool voiceConnected;

  final String? ownerPublicId;

  final int? ownerVipLevel;

  final VoidCallback onOwnerTap;

  final VoidCallback onMembersTap;

  final VoidCallback onCloseTap;

  const RoomTopOverlay({
    super.key,
    required this.room,
    required this.owner,
    required this.mediaBaseUrl,
    required this.socketConnected,
    required this.voiceConnected,
    required this.onOwnerTap,
    required this.onMembersTap,
    required this.onCloseTap,
    this.ownerPublicId,
    this.ownerVipLevel,
  });

  @override
  Widget build(BuildContext context) {
    final ownerName =
    owner?.name.trim().isNotEmpty == true
        ? owner!.name.trim()
        : room.name;

    final publicId =
    ownerPublicId?.trim().isNotEmpty == true
        ? ownerPublicId!.trim()
        : owner?.junayaId?.trim().isNotEmpty == true
        ? owner!.junayaId!.trim()
        : room.id;

    final vipLevel =
        ownerVipLevel ??
            owner?.vipLevel ??
            0;

    return SizedBox(
      height: 245,

      child: Stack(
        clipBehavior: Clip.none,
        children: [

          // ==========================================================
          // OWNER AVATAR
          // ==========================================================

          Positioned(
            left: 28,
            top: 28,

            child: GestureDetector(
              onTap: onOwnerTap,

              child: _OwnerAvatar(
                avatar: owner?.avatar,
                name: ownerName,
                mediaBaseUrl: mediaBaseUrl,
              ),
            ),
          ),

          // ==========================================================
          // ROOM NAME
          // ==========================================================

          Positioned(
            left: 142,
            top: 37,
            right: 115,

            child: Text(
              ownerName,

              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w700,
                height: 1.05,

                shadows: const [
                  Shadow(
                    color: Colors.black38,
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
          ),

          // ==========================================================
          // ROOM ID
          // ==========================================================

          Positioned(
            left: 142,
            top: 75,

            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                Text(
                  'ID: $publicId',

                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(width: 6),

                _VipDiamond(
                  level: vipLevel,
                ),
              ],
            ),
          ),

          // ==========================================================
          // REFRESH
          // ==========================================================

          Positioned(
            right: 54,
            top: 31,

            child: IconButton(
              onPressed: onMembersTap,

              padding: EdgeInsets.zero,

              constraints:
              const BoxConstraints(
                minWidth: 42,
                minHeight: 42,
              ),

              icon: const Icon(
                Icons.refresh_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),

          // ==========================================================
          // UP CHEVRON
          // ==========================================================

          Positioned(
            right: 7,
            top: 34,

            child: IconButton(
              onPressed: onCloseTap,

              padding: EdgeInsets.zero,

              constraints:
              const BoxConstraints(
                minWidth: 42,
                minHeight: 42,
              ),

              icon: const Icon(
                Icons.keyboard_arrow_up_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),

          // ==========================================================
          // TROPHY / ROOM RANK
          // ==========================================================

          Positioned(
            left: 28,
            top: 145,

            child: _RoomRank(
              rank: room.roomRank,
            ),
          ),

          // ==========================================================
          // SMALL OWNER AVATAR
          // ==========================================================

          Positioned(
            right: 61,
            top: 143,

            child: GestureDetector(
              onTap: onOwnerTap,

              child: _SmallOwnerAvatar(
                avatar: owner?.avatar,
                name: ownerName,
                mediaBaseUrl: mediaBaseUrl,
              ),
            ),
          ),

          // ==========================================================
          // VOICE STATUS
          // ==========================================================

          Positioned(
            right: 8,
            top: 142,

            child: _VoiceStatusButton(
              connected:
              socketConnected &&
                  voiceConnected,
            ),
          ),
        ],
      ),
    );
  }
}


// ============================================================================
// OWNER AVATAR
// ============================================================================

class _OwnerAvatar extends StatelessWidget {
  final String? avatar;

  final String name;

  final String mediaBaseUrl;

  const _OwnerAvatar({
    required this.avatar,
    required this.name,
    required this.mediaBaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 92,

      padding: const EdgeInsets.all(2),

      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),

        border: Border.all(
          color: Colors.black,
          width: 2,
        ),

        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),

        child: _RoomImage(
          source: avatar,
          mediaBaseUrl: mediaBaseUrl,
          fallbackName: name,
        ),
      ),
    );
  }
}


// ============================================================================
// SMALL OWNER AVATAR
// ============================================================================

class _SmallOwnerAvatar extends StatelessWidget {
  final String? avatar;

  final String name;

  final String mediaBaseUrl;

  const _SmallOwnerAvatar({
    required this.avatar,
    required this.name,
    required this.mediaBaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,

      padding: const EdgeInsets.all(2),

      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),

      child: ClipOval(
        child: _RoomImage(
          source: avatar,
          mediaBaseUrl: mediaBaseUrl,
          fallbackName: name,
        ),
      ),
    );
  }
}


// ============================================================================
// VIP DIAMOND
// ============================================================================

class _VipDiamond extends StatelessWidget {
  final int level;

  const _VipDiamond({
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,

      decoration: BoxDecoration(
        color: const Color(0xFF44205E),

        borderRadius:
        BorderRadius.circular(6),

        border: Border.all(
          color: const Color(0xFFFFD85A),
          width: 1,
        ),
      ),

      child: Center(
        child: Text(
          '$level',

          style: GoogleFonts.poppins(
            color: const Color(0xFFFFD85A),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}


// ============================================================================
// ROOM RANK
// ============================================================================

class _RoomRank extends StatelessWidget {
  final int rank;

  const _RoomRank({
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,

      padding:
      const EdgeInsets.symmetric(
        horizontal: 14,
      ),

      decoration: BoxDecoration(
        color: const Color(0x552D075B),

        borderRadius:
        const BorderRadius.only(
          topRight: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          const Text(
            '🏆',
            style: TextStyle(
              fontSize: 24,
            ),
          ),

          const SizedBox(width: 12),

          Text(
            '$rank',

            style: GoogleFonts.poppins(
              color: const Color(0xFFFFD45C),
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}


// ============================================================================
// VOICE STATUS BUTTON
// ============================================================================

class _VoiceStatusButton extends StatelessWidget {
  final bool connected;

  const _VoiceStatusButton({
    required this.connected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,

      decoration: BoxDecoration(
        color: const Color(0x442F1163),
        shape: BoxShape.circle,
      ),

      child: Icon(
        Icons.equalizer_rounded,

        color: connected
            ? const Color(0xFF35E5D2)
            : Colors.white54,

        size: 29,
      ),
    );
  }
}


// ============================================================================
// ROOM IMAGE
// ============================================================================

class _RoomImage extends StatelessWidget {
  final String? source;

  final String mediaBaseUrl;

  final String fallbackName;

  const _RoomImage({
    required this.source,
    required this.mediaBaseUrl,
    required this.fallbackName,
  });

  @override
  Widget build(BuildContext context) {
    final value =
        source?.trim() ?? '';

    if (value.isEmpty) {
      return _fallback();
    }

    if (value.startsWith('http://') ||
        value.startsWith('https://')) {
      return Image.network(
        value,

        fit: BoxFit.cover,

        filterQuality:
        FilterQuality.medium,

        errorBuilder:
            (_, _, _) {
          return _fallback();
        },
      );
    }

    if (value.startsWith('/')) {
      final base =
      mediaBaseUrl.endsWith('/')
          ? mediaBaseUrl.substring(
        0,
        mediaBaseUrl.length - 1,
      )
          : mediaBaseUrl;

      return Image.network(
        '$base$value',

        fit: BoxFit.cover,

        filterQuality:
        FilterQuality.medium,

        errorBuilder:
            (_, _, _) {
          return _fallback();
        },
      );
    }

    return Image.asset(
      value,

      fit: BoxFit.cover,

      filterQuality:
      FilterQuality.medium,

      errorBuilder:
          (_, _, _) {
        return _fallback();
      },
    );
  }

  Widget _fallback() {
    final cleanName =
    fallbackName.trim();

    final initial =
    cleanName.isEmpty
        ? '?'
        : cleanName.characters.first
        .toUpperCase();

    return Container(
      color: const Color(0xFF461553),

      alignment: Alignment.center,

      child: Text(
        initial,

        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}