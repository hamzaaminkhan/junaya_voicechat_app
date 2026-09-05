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

  /// Number of seats configured for this room.
  ///
  /// Allowed range: 1 - 25.
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

  // ------------------------------------------------------------
  // COLUMN COUNT
  // ------------------------------------------------------------

  int _getColumnCount(int count) {
    if (count <= 2) {
      return 2;
    }

    if (count <= 6) {
      return 3;
    }

    if (count <= 12) {
      return 4;
    }

    return 5;
  }

  // ------------------------------------------------------------
  // SEAT HEIGHT
  // ------------------------------------------------------------

  double _getSeatHeight(int count) {
    if (count <= 4) {
      return 150;
    }

    if (count <= 9) {
      return 130;
    }

    if (count <= 16) {
      return 115;
    }

    return 105;
  }

  // ------------------------------------------------------------
  // NORMALIZE SEATS
  // ------------------------------------------------------------

  List<RoomSeat> _buildVisibleSeats() {
    final safeSeatCount = seatCount.clamp(1, 25);

    final result = <RoomSeat>[];

    for (
    int number = 1;
    number <= safeSeatCount;
    number++
    ) {
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

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final visibleSeats = _buildVisibleSeats();

    if (visibleSeats.isEmpty) {
      return const SizedBox.shrink();
    }

    final columns = _getColumnCount(
      visibleSeats.length,
    );

    final seatHeight = _getSeatHeight(
      visibleSeats.length,
    );

    return RepaintBoundary(
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(
          18,
          10,
          18,
          18,
        ),

        physics:
        const NeverScrollableScrollPhysics(),

        shrinkWrap: true,

        itemCount: visibleSeats.length,

        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisExtent: seatHeight,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),

        itemBuilder: (context, index) {
          final seat = visibleSeats[index];

          return _RoomSeatTile(
            key: ValueKey(
              'room-seat-${seat.number}',
            ),

            seat: seat,

            currentUserId: currentUserId,

            mediaBaseUrl: mediaBaseUrl,

            // IMPORTANT:
            // Always send the actual seat number.
            // Do NOT send index.
            onTap: () {
              onSeatTap(seat.number);
            },

            onLongPress: isRoomOwner
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
    seat.isOccupied ? seat.user : null;

    final bool isMe =
        user?.id == currentUserId;

    final bool isSpeaking =
        user?.isSpeaking == true &&
            user?.isMuted != true;

    return Semantics(
      button: true,

      label: _semanticLabel(user),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          onTap: onTap,

          onLongPress: onLongPress,

          borderRadius:
          BorderRadius.circular(50),

          child: SizedBox(
            width: double.infinity,

            height: double.infinity,

            child: Stack(
              alignment: Alignment.topCenter,

              clipBehavior: Clip.none,

              children: [
                // ----------------------------------------------------------
                // GLASS MIC
                // ----------------------------------------------------------

                Positioned(
                  top: 8,

                  child: _GlassMicCircle(
                    seat: seat,

                    user: user,

                    isMe: isMe,

                    isSpeaking: isSpeaking,

                    mediaBaseUrl:
                    mediaBaseUrl,
                  ),
                ),

                // ----------------------------------------------------------
                // SEAT NUMBER
                //
                // Empty / locked seats show number.
                // Occupied seats hide number.
                // ----------------------------------------------------------

                if (user == null)
                  Positioned(
                    top: 88,

                    child: _SeatNumber(
                      number: seat.number,

                      locked: seat.isLocked,
                    ),
                  ),

                // ----------------------------------------------------------
                // USER NAME
                // ----------------------------------------------------------

                if (user != null)
                  Positioned(
                    left: 8,

                    right: 8,

                    bottom: 5,

                    child: _GlassNameStrip(
                      name: user.name,

                      isMe: isMe,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _semanticLabel(RoomUser? user) {
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
// GLASS MIC CIRCLE
// ============================================================================

class _GlassMicCircle extends StatelessWidget {
  final RoomSeat seat;

  final RoomUser? user;

  final bool isMe;

  final bool isSpeaking;

  final String mediaBaseUrl;

  const _GlassMicCircle({
    required this.seat,
    required this.user,
    required this.isMe,
    required this.isSpeaking,
    required this.mediaBaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    Color glowColor;

    if (seat.isLocked) {
      glowColor = Colors.white24;
    } else if (isSpeaking) {
      glowColor =
      const Color(0xFFFFD15B);
    } else if (isMe) {
      glowColor =
      const Color(0xFFE38AFF);
    } else {
      glowColor = Colors.white;
    }

    return AnimatedContainer(
      duration:
      const Duration(milliseconds: 180),

      width: 76,

      height: 76,

      padding:
      const EdgeInsets.all(2),

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        color: Colors.white.withValues(
          alpha: .10,
        ),

        border: Border.all(
          color: Colors.white.withValues(
            alpha: .30,
          ),
          width: 1.1,
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
              alpha: .18,
            ),
            blurRadius: 12,
            offset:
            const Offset(0, 5),
          ),
        ],
      ),

      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5,
            sigmaY: 5,
          ),

          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    // ------------------------------------------------------------
    // LOCKED
    // ------------------------------------------------------------

    if (seat.isLocked) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(
            alpha: .07,
          ),
        ),
        child: const Icon(
          Icons.lock_rounded,
          color: Colors.white70,
          size: 30,
        ),
      );
    }

    // ------------------------------------------------------------
    // EMPTY
    // ------------------------------------------------------------

    if (user == null) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(
                alpha: .18,
              ),
              Colors.white.withValues(
                alpha: .05,
              ),
            ],
          ),
        ),
        child: Icon(
          Icons.mic_none_rounded,
          color: Colors.white.withValues(
            alpha: .88,
          ),
          size: 39,
        ),
      );
    }

    // ------------------------------------------------------------
    // OCCUPIED
    // ------------------------------------------------------------

    final RoomUser occupiedUser = user!;

    return Stack(
      fit: StackFit.expand,
      children: [
        _RoomAvatarImage(
          source: occupiedUser.avatar,
          mediaBaseUrl: mediaBaseUrl,
          fallbackName: occupiedUser.name,
        ),

        // ----------------------------------------------------------
        // MUTED
        // ----------------------------------------------------------

        if (occupiedUser.isMuted)
          Container(
            color: Colors.black.withValues(
              alpha: .30,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.mic_off_rounded,
              color: Color(0xFFFF737C),
              size: 30,
            ),
          ),

        // ----------------------------------------------------------
        // HOST
        // ----------------------------------------------------------

        if (occupiedUser.isHost)
          Positioned(
            right: 1,
            top: 1,
            child: Container(
              width: 23,
              height: 23,
              decoration: const BoxDecoration(
                color: Color(0xFFFFC23D),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.workspace_premium_rounded,
                color: Colors.black,
                size: 14,
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

class _SeatNumber extends StatelessWidget {
  final int number;

  final bool locked;

  const _SeatNumber({
    required this.number,
    required this.locked,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$number',

      style: GoogleFonts.poppins(
        color: locked
            ? Colors.white54
            : Colors.white.withValues(
          alpha: .72,
        ),

        fontSize: 13,

        fontWeight:
        FontWeight.w500,

        shadows: const [
          Shadow(
            color: Colors.black45,
            blurRadius: 5,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// GLASS USERNAME STRIP
// ============================================================================

class _GlassNameStrip
    extends StatelessWidget {
  final String name;

  final bool isMe;

  const _GlassNameStrip({
    required this.name,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isMe
        ? const Color(0xFFFFD15B)
        : Colors.white;

    return ClipRRect(
      borderRadius:
      BorderRadius.circular(18),

      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),

        child: Container(
          height: 28,

          padding:
          const EdgeInsets.symmetric(
            horizontal: 9,
          ),

          alignment:
          Alignment.center,

          decoration: BoxDecoration(
            color:
            Colors.white.withValues(
              alpha: .12,
            ),

            borderRadius:
            BorderRadius.circular(
              18,
            ),

            border: Border.all(
              color:
              borderColor.withValues(
                alpha:
                isMe ? .55 : .22,
              ),

              width: .8,
            ),
          ),

          child: FittedBox(
            fit:
            BoxFit.scaleDown,

            child: Text(
              name,

              maxLines: 1,

              textAlign:
              TextAlign.center,

              style:
              GoogleFonts.poppins(
                color: isMe
                    ? const Color(
                  0xFFFFD15B,
                )
                    : Colors.white,

                fontSize: 14.5,

                fontWeight:
                FontWeight.w600,

                height: 1,

                shadows: const [
                  Shadow(
                    color:
                    Colors.black54,
                    blurRadius: 5,
                  ),
                ],
              ),
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
  Widget build(BuildContext context) {
    final value =
        source?.trim() ?? '';

    if (value.isEmpty) {
      return _fallback();
    }

    // ------------------------------------------------------------
    // FULL URL
    // ------------------------------------------------------------

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

    // ------------------------------------------------------------
    // SERVER RELATIVE PATH
    // ------------------------------------------------------------

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

    // ------------------------------------------------------------
    // LOCAL ASSET
    // ------------------------------------------------------------

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
      const Color(0xFF32115B),

      alignment:
      Alignment.center,

      child: Text(
        initial,

        style:
        GoogleFonts.poppins(
          color: Colors.white,

          fontSize: 28,

          fontWeight:
          FontWeight.w700,
        ),
      ),
    );
  }
}