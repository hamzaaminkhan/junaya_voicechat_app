import 'dart:ui';

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

  // ============================================================
  // CONSTANTS
  // ============================================================

  static const int _columns = 5;

  // ============================================================
  // NORMALIZE SEATS
  // ============================================================

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

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final visibleSeats = _buildVisibleSeats();

    if (visibleSeats.isEmpty) {
      return const SizedBox.shrink();
    }

    return RepaintBoundary(
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(
          20,
          2,
          20,
          2,
        ),

        shrinkWrap: true,

        physics:
        const NeverScrollableScrollPhysics(),

        itemCount: visibleSeats.length,

        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _columns,

          mainAxisSpacing: 1,

          crossAxisSpacing: 4,

          mainAxisExtent: 96,
        ),

        itemBuilder: (
            context,
            index,
            ) {
          final seat =
          visibleSeats[index];

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
              onSeatTap(
                seat.number,
              );
            },

            onLongPress:
            isRoomOwner
                ? () {
              onSeatLongPress(
                seat.number,
              );
            }
                : null,
          );
        },
      ),
    );
  }
}

// ============================================================================
// ROOM SEAT TILE
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
    final RoomUser? user =
    seat.isOccupied
        ? seat.user
        : null;

    final bool isMe =
        user?.id == currentUserId;

    final bool isSpeaking =
        user?.isSpeaking == true &&
            user?.isMuted != true;

    return Semantics(
      button: true,

      label: _semanticLabel(user),

      child: GestureDetector(
        behavior:
        HitTestBehavior.opaque,

        onTap: onTap,

        onLongPress:
        onLongPress,

        child: SizedBox(
          width: double.infinity,

          height: double.infinity,

          child: Stack(
            clipBehavior:
            Clip.none,

            alignment:
            Alignment.topCenter,

            children: [

              // ============================================================
              // MIC / AVATAR
              // ============================================================

              Positioned(
                top: 2,

                child: _SeatCircle(
                  seat: seat,

                  user: user,

                  isMe: isMe,

                  isSpeaking:
                  isSpeaking,

                  mediaBaseUrl:
                  mediaBaseUrl,
                ),
              ),

              // ============================================================
              // SEAT NUMBER
              // ============================================================

              if (user == null)
                Positioned(
                  top: 70,

                  child: _SeatNumber(
                    number:
                    seat.number,

                    locked:
                    seat.isLocked,
                  ),
                ),

              // ============================================================
              // USER NAME
              // ============================================================

              if (user != null)
                Positioned(
                  left: 2,

                  right: 2,

                  bottom: 3,

                  child:
                  _UserNameBadge(
                    name: user.name,

                    isMe: isMe,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _semanticLabel(
      RoomUser? user,
      ) {
    if (seat.isLocked) {
      return 'Mic ${seat.number}, locked';
    }

    if (user == null) {
      return 'Mic ${seat.number}, empty';
    }

    return 'Mic ${seat.number}, ${user.name}';
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
    final Color glowColor;

    if (seat.isLocked) {
      glowColor = Colors.white24;
    } else if (isSpeaking) {
      glowColor =
      const Color(0xFFFFD45C);
    } else if (isMe) {
      glowColor =
      const Color(0xFFE68AFF);
    } else {
      glowColor =
          Colors.white;
    }

    return AnimatedContainer(
      duration:
      const Duration(
        milliseconds: 180,
      ),

      width: 68,

      height: 68,

      padding:
      const EdgeInsets.all(2),

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        color:
        Colors.white.withValues(
          alpha: .10,
        ),

        border: Border.all(
          color:
          Colors.white.withValues(
            alpha: .22,
          ),

          width: 1,
        ),

        boxShadow: [
          if (isSpeaking)
            BoxShadow(
              color:
              glowColor.withValues(
                alpha: .45,
              ),

              blurRadius: 18,

              spreadRadius: 2,
            ),

          BoxShadow(
            color:
            Colors.black.withValues(
              alpha: .20,
            ),

            blurRadius: 9,

            offset:
            const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5,

            sigmaY: 5,
          ),

          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    // ============================================================
    // LOCKED
    // ============================================================

    if (seat.isLocked) {
      return Container(
        alignment:
        Alignment.center,

        decoration:
        BoxDecoration(
          shape: BoxShape.circle,

          color:
          Colors.white.withValues(
            alpha: .07,
          ),
        ),

        child: const Icon(
          Icons.lock_rounded,

          color:
          Colors.white70,

          size: 28,
        ),
      );
    }

    // ============================================================
    // EMPTY
    // ============================================================

    if (user == null) {
      return Container(
        alignment:
        Alignment.center,

        decoration:
        BoxDecoration(
          shape: BoxShape.circle,

          gradient:
          LinearGradient(
            begin:
            Alignment.topLeft,

            end:
            Alignment.bottomRight,

            colors: [
              Colors.white.withValues(
                alpha: .20,
              ),

              Colors.white.withValues(
                alpha: .07,
              ),
            ],
          ),
        ),

        child: Icon(
          Icons.mic_none_rounded,

          color:
          Colors.white.withValues(
            alpha: .88,
          ),

          size: 32,
        ),
      );
    }

    // ============================================================
    // OCCUPIED
    // ============================================================

    final occupiedUser = user!;

    return Stack(
      fit: StackFit.expand,

      children: [

        // Avatar
        _RoomAvatarImage(
          source:
          occupiedUser.avatar,

          mediaBaseUrl:
          mediaBaseUrl,

          fallbackName:
          occupiedUser.name,
        ),

        // ============================================================
        // MUTED
        // ============================================================

        if (occupiedUser.isMuted)
          Container(
            color:
            Colors.black.withValues(
              alpha: .30,
            ),

            alignment:
            Alignment.center,

            child: const Icon(
              Icons.mic_off_rounded,

              color:
              Color(0xFFFF737C),

              size: 28,
            ),
          ),

        // ============================================================
        // HOST
        // ============================================================

        if (occupiedUser.isHost)
          Positioned(
            right: 1,

            top: 1,

            child: Container(
              width: 22,

              height: 22,

              decoration:
              const BoxDecoration(
                color:
                Color(0xFFFFC23D),

                shape:
                BoxShape.circle,
              ),

              child: const Icon(
                Icons
                    .workspace_premium_rounded,

                color: Colors.black,

                size: 13,
              ),
            ),
          ),

        // ============================================================
        // SPEAKING
        // ============================================================

        if (occupiedUser.isSpeaking &&
            !occupiedUser.isMuted)
          Positioned(
            left: 5,

            right: 5,

            bottom: 5,

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
                  5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ============================================================================
// SEAT NUMBER
// ============================================================================

class _SeatNumber
    extends StatelessWidget {
  final int number;

  final bool locked;

  const _SeatNumber({
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
            ? Colors.white38
            : Colors.white.withValues(
          alpha: .38,
        ),

        fontSize: 12,

        fontWeight:
        FontWeight.w500,

        shadows: const [
          Shadow(
            color:
            Colors.black45,

            blurRadius: 4,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// USER NAME
// ============================================================================

class _UserNameBadge
    extends StatelessWidget {
  final String name;

  final bool isMe;

  const _UserNameBadge({
    required this.name,
    required this.isMe,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return ClipRRect(
      borderRadius:
      BorderRadius.circular(
        14,
      ),

      child: BackdropFilter(
        filter:
        ImageFilter.blur(
          sigmaX: 5,

          sigmaY: 5,
        ),

        child: Container(
          height: 22,

          padding:
          const EdgeInsets.symmetric(
            horizontal: 6,
          ),

          alignment:
          Alignment.center,

          decoration:
          BoxDecoration(
            color:
            Colors.black.withValues(
              alpha: .12,
            ),

            borderRadius:
            BorderRadius.circular(
              14,
            ),

            border: Border.all(
              color: isMe
                  ? const Color(
                0xFFFFD45C,
              )
                  : Colors.white
                  .withValues(
                alpha: .15,
              ),

              width: .7,
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

              fontSize: 9.5,

              fontWeight:
              FontWeight.w600,

              height: 1,
            ),
          ),
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

    // ============================================================
    // EMPTY AVATAR
    // ============================================================

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

        fit: BoxFit.cover,

        filterQuality:
        FilterQuality.medium,

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

        fit: BoxFit.cover,

        filterQuality:
        FilterQuality.medium,

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
    final name =
    fallbackName.trim();

    final initial = name.isEmpty
        ? '?'
        : name
        .substring(0, 1)
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

          fontSize: 26,

          fontWeight:
          FontWeight.w700,
        ),
      ),
    );
  }
}