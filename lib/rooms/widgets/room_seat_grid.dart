import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:junaya_voicechat_app/rooms/models/voice_room_model.dart';

class RoomSeatGrid extends StatelessWidget {
  final List<RoomSeat> seats;

  final String currentUserId;

  final String mediaBaseUrl;

  final bool isRoomOwner;

  final ValueChanged<int> onSeatTap;

  final ValueChanged<int> onSeatLongPress;

  final int seatCount;

  const RoomSeatGrid({
    super.key,
    required this.seats,
    required this.seatCount,
    required this.currentUserId,
    required this.mediaBaseUrl,
    required this.isRoomOwner,
    required this.onSeatTap,
    required this.onSeatLongPress,
  });

  static const int _columns = 5;

  List<RoomSeat> _buildVisibleSeats() {
    final safeSeatCount = seatCount.clamp(1, 25);

    final result = <RoomSeat>[];

    for (int number = 1; number <= safeSeatCount; number++) {
      RoomSeat? existingSeat;

      for (final seat in seats) {
        if (seat.number == number) {
          existingSeat = seat;
          break;
        }
      }

      result.add(
        existingSeat ??
            RoomSeat(
              number: number,
              status: RoomSeatStatus.empty,
            ),
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final visibleSeats = _buildVisibleSeats();

    if (visibleSeats.isEmpty) {
      return const SizedBox.shrink();
    }

    return RepaintBoundary(
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 4,
        ),

        shrinkWrap: true,

        physics:
        const NeverScrollableScrollPhysics(),

        itemCount: visibleSeats.length,

        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _columns,

          crossAxisSpacing: 7,

          mainAxisSpacing: 8,

          mainAxisExtent: 122,
        ),

        itemBuilder: (
            context,
            index,
            ) {
          final seat = visibleSeats[index];

          return _RoomSeatTile(
            key: ValueKey(
              'room-seat-${seat.number}',
            ),

            seat: seat,

            currentUserId:
            currentUserId,

            mediaBaseUrl:
            mediaBaseUrl,

            onTap: () {
              onSeatTap(index);
            },

            onLongPress:
            isRoomOwner
                ? () {
              onSeatLongPress(index);
            }
                : null,
          );
        },
      ),
    );
  }
}


// ============================================================================
// SEAT TILE
// ============================================================================

class _RoomSeatTile extends StatelessWidget {
  final RoomSeat seat;

  final String currentUserId;

  final String mediaBaseUrl;

  final VoidCallback onTap;

  final VoidCallback? onLongPress;

  const _RoomSeatTile({
    super.key,
    required this.seat,
    required this.currentUserId,
    required this.mediaBaseUrl,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final user =
    seat.isOccupied
        ? seat.user
        : null;

    final isMe =
        user?.id == currentUserId;

    final isSpeaking =
        user?.isSpeaking == true &&
            user?.isMuted != true;

    return GestureDetector(
      behavior:
      HitTestBehavior.opaque,

      onTap: onTap,

      onLongPress:
      onLongPress,

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.18),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.mic_none_rounded,
              color: Colors.white.withValues(alpha: 1.50),
              size: 36,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            '${seat.number}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      )
    );
  }
}


// ============================================================================
// SEAT CIRCLE
// ============================================================================

class _SeatCircle extends StatelessWidget {
  final RoomSeat seat;

  final RoomUser? user;

  final bool isMe;

  final bool isSpeaking;

  final String mediaBaseUrl;

  const _SeatCircle({
    required this.seat,
    required this.user,
    required this.isMe,
    required this.isSpeaking,
    required this.mediaBaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    final bool locked =
        seat.isLocked;

    return AnimatedContainer(
      duration:
      const Duration(
        milliseconds: 180,
      ),

      width: 82,

      height: 82,

      padding:
      const EdgeInsets.all(2),

      decoration: BoxDecoration(
        shape:
        BoxShape.circle,

        color:
        const Color(0xFF261936)
            .withValues(
          alpha: .78,
        ),

        border: Border.all(
          color: isSpeaking
              ? const Color(
            0xFFFFD45C,
          )
              : isMe
              ? const Color(
            0xFFFFD45C,
          )
              : Colors.white
              .withValues(
            alpha: .16,
          ),

          width:
          isSpeaking || isMe
              ? 2
              : 1,
        ),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black
                .withValues(
              alpha: .28,
            ),

            blurRadius: 8,

            offset:
            const Offset(
              0,
              4,
            ),
          ),

          if (isSpeaking)
            BoxShadow(
              color:
              const Color(
                0xFFFFD45C,
              ).withValues(
                alpha: .30,
              ),

              blurRadius: 14,

              spreadRadius: 1,
            ),
        ],
      ),

      child: ClipOval(
        child: _buildContent(
          locked,
        ),
      ),
    );
  }

  Widget _buildContent(
      bool locked,
      ) {
    // ============================================================
    // LOCKED
    // ============================================================

    if (locked) {
      return Container(
        color:
        const Color(0xFF171020)
            .withValues(
          alpha: .92,
        ),

        alignment:
        Alignment.center,

        child: const Icon(
          Icons.lock_rounded,

          color:
          Colors.white38,

          size: 27,
        ),
      );
    }

    // ============================================================
    // EMPTY
    // ============================================================

    if (user == null) {
      return Container(
        width: 82,
        height: 82,

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          // White, transparent glass
          color: Colors.white.withValues(
            alpha: 0.18,
          ),

          // Subtle white glass border
          border: Border.all(
            color: Colors.white.withValues(
              alpha: 0.25,
            ),
            width: 1,
          ),
        ),

        alignment: Alignment.center,

        child: Icon(
          Icons.mic_none_rounded,

          color: Colors.white.withValues(
            alpha: 0.85,
          ),

          size: 36,
        ),
      );
    }

    // ============================================================
    // OCCUPIED
    // ============================================================

    final occupiedUser =
    user!;

    return Stack(
      fit:
      StackFit.expand,

      children: [
        _RoomAvatarImage(
          source:
          occupiedUser.avatar,

          mediaBaseUrl:
          mediaBaseUrl,

          fallbackName:
          occupiedUser.name,
        ),

        // --------------------------------------------------------
        // DARK OVERLAY
        // --------------------------------------------------------



        // --------------------------------------------------------
        // MUTED
        // --------------------------------------------------------

        if (occupiedUser.isMuted)
          Container(
            color:
            Colors.black
                .withValues(
              alpha: .42,
            ),

            alignment:
            Alignment.center,

            child: const Icon(
              Icons.mic_off_rounded,

              color:
              Color(0xFFFF737C),

              size: 30,
            ),
          ),

        // --------------------------------------------------------
        // HOST
        // --------------------------------------------------------

        if (occupiedUser.isHost)
          Positioned(
            right: 0,

            top: 0,

            child: Container(
              width: 23,

              height: 23,

              decoration:
              const BoxDecoration(
                color:
                Color(0xFFFFC83D),

                shape:
                BoxShape.circle,
              ),

              child: const Icon(
                Icons
                    .workspace_premium_rounded,

                color:
                Color(0xFF3A1850),

                size: 14,
              ),
            ),
          ),

        // --------------------------------------------------------
        // SPEAKING INDICATOR
        // --------------------------------------------------------

        if (occupiedUser.isSpeaking &&
            !occupiedUser.isMuted)
          Positioned(
            left: 9,

            right: 9,

            bottom: 7,

            child: Container(
              height: 4,

              decoration:
              BoxDecoration(
                color:
                const Color(
                  0xFFFFD45C,
                ),

                borderRadius:
                BorderRadius.circular(
                  10,
                ),
              ),
            ),
          ),
      ],
    );
  }
}


// ============================================================================
// EMPTY SEAT NUMBER
// ============================================================================

class _EmptySeatNumber
    extends StatelessWidget {
  final int number;

  final bool locked;

  const _EmptySeatNumber({
    required this.number,
    required this.locked,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Text(
      '$number',

      style:
      GoogleFonts.poppins(
        color: locked
            ? Colors.white24
            : Colors.white54,

        fontSize: 12,

        fontWeight:
        FontWeight.w500,

        height: 1,
      ),
    );
  }
}


// ============================================================================
// OCCUPIED USER NAME
// ============================================================================

class _OccupiedUserName
    extends StatelessWidget {
  final String name;

  final bool isMe;

  const _OccupiedUserName({
    required this.name,
    required this.isMe,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      constraints:
      const BoxConstraints(
        maxWidth: 78,
      ),

      padding:
      const EdgeInsets.symmetric(
        horizontal: 7,

        vertical: 3,
      ),

      decoration:
      BoxDecoration(
        color:
        Colors.black.withValues(
          alpha: .35,
        ),

        borderRadius:
        BorderRadius.circular(
          10,
        ),

        border: Border.all(
          color: isMe
              ? const Color(
            0xFFFFD45C,
          )
              : Colors.white
              .withValues(
            alpha: .10,
          ),

          width: isMe ? 1 : .6,
        ),
      ),

      child: Text(
        name,

        maxLines: 1,

        overflow:
        TextOverflow.ellipsis,

        textAlign:
        TextAlign.center,

        style:
        GoogleFonts.poppins(
          color: isMe
              ? const Color(
            0xFFFFD45C,
          )
              : Colors.white,

          fontSize: 9,

          fontWeight:
          FontWeight.w600,

          height: 1,
        ),
      ),
    );
  }
}


// ============================================================================
// AVATAR
// ============================================================================

class _RoomAvatarImage
    extends StatelessWidget {
  final String? source;

  final String mediaBaseUrl;

  final String fallbackName;

  const _RoomAvatarImage({
    required this.source,
    required this.mediaBaseUrl,
    required this.fallbackName,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    final value =
        source?.trim() ?? '';

    if (value.isEmpty) {
      return _fallback();
    }

    // ============================================================
    // FULL URL
    // ============================================================

    if (value.startsWith(
      'http://',
    ) ||
        value.startsWith(
          'https://',
        )) {
      return Image.network(
        value,

        fit:
        BoxFit.cover,

        filterQuality:
        FilterQuality.high,

        errorBuilder:
            (_, _, _) {
          return _fallback();
        },
      );
    }

    // ============================================================
    // SERVER PATH
    // ============================================================

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

        fit:
        BoxFit.cover,

        filterQuality:
        FilterQuality.high,

        errorBuilder:
            (_, _, _) {
          return _fallback();
        },
      );
    }

    // ============================================================
    // LOCAL ASSET
    // ============================================================

    return Image.asset(
      value,

      fit:
      BoxFit.cover,

      filterQuality:
      FilterQuality.high,

      errorBuilder:
          (_, _, _) {
        return _fallback();
      },
    );
  }

  Widget _fallback() {
    final name =
    fallbackName.trim();

    final initial =
    name.isEmpty
        ? '?'
        : name
        .substring(
      0,
      1,
    )
        .toUpperCase();

    return Container(
      color:
      const Color(0xFF4B1764),

      alignment:
      Alignment.center,

      child: Text(
        initial,

        style:
        GoogleFonts.poppins(
          color: Colors.white,

          fontSize: 27,

          fontWeight:
          FontWeight.w700,
        ),
      ),
    );
  }
}