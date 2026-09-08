import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:junaya_voicechat_app/rooms/models/voice_room_model.dart';


// ============================================================================
// ROOM SEAT GRID
// ============================================================================

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

  static const int _minSeats = 1;
  static const int _maxSeats = 25;
  static const int _columns = 5;

  // ==========================================================================
  // BUILD VISIBLE SEATS
  // ==========================================================================

  List<RoomSeat> _buildVisibleSeats() {
    final int safeSeatCount = seatCount.clamp(
      _minSeats,
      _maxSeats,
    );

    // ------------------------------------------------------------------------
    // Convert the existing seat list into a lookup map.
    //
    // This avoids repeatedly looping through the complete seat list.
    // ------------------------------------------------------------------------

    final Map<int, RoomSeat> seatsByNumber = {
      for (final seat in seats)
        if (seat.number >= _minSeats &&
            seat.number <= _maxSeats)
          seat.number: seat,
    };

    return List<RoomSeat>.generate(
      safeSeatCount,
          (index) {
        final int number = index + 1;

        return seatsByNumber[number] ??
            RoomSeat(
              number: number,
              status: RoomSeatStatus.empty,
            );
      },
    );
  }

  // ==========================================================================
  // RESPONSIVE AVATAR SIZE
  // ==========================================================================

  double _avatarSizeForSeatCount(int count) {
    // ================================================================
    // 1–5 SEATS
    // Large seats
    // ================================================================

    if (count <= 5) {
      return 100;
    }

    // ================================================================
    // 6–10 SEATS
    // ================================================================

    if (count <= 10) {
      return 92;
    }

    // ================================================================
    // 11–15 SEATS
    // Default room size
    // ================================================================

    if (count <= 15) {
      return 84;
    }

    // ================================================================
    // 16–20 SEATS
    // ================================================================

    if (count <= 20) {
      return 76;
    }

    // ================================================================
    // 21–25 SEATS
    // Maximum room size
    // ================================================================

    return 68;
  }

  Widget _buildCenteredSmallGrid(
      BuildContext context,
      List<RoomSeat> visibleSeats,
      double avatarSize,
      double rowHeight,
      ) {
    final double actualSize = math.min(
      avatarSize,
      rowHeight - 20,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int index = 0;
            index < visibleSeats.length;
            index++)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: _RoomSeatTile(
                  key: ValueKey(
                    'room-seat-${visibleSeats[index].number}',
                  ),
                  seat: visibleSeats[index],
                  currentUserId: currentUserId,
                  mediaBaseUrl: mediaBaseUrl,
                  avatarSize: actualSize,
                  onTap: () {
                    onSeatTap(index);
                  },
                  onLongPress: isRoomOwner
                      ? () {
                    onSeatLongPress(index);
                  }
                      : null,
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<RoomSeat> visibleSeats =
    _buildVisibleSeats();

    if (visibleSeats.isEmpty) {
      return const SizedBox.shrink();
    }

    final int visibleSeatCount =
        visibleSeats.length;

    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final double availableWidth =
            constraints.maxWidth;

        final double horizontalPadding =
        availableWidth < 360
            ? 8
            : 14;

        final double usableWidth =
        math.max(
          0,
          availableWidth -
              horizontalPadding * 2,
        );

        final double columnWidth =
            usableWidth / _columns;

        final double desiredAvatarSize =
        _avatarSizeForSeatCount(
          visibleSeatCount,
        );

        final double avatarSize =
        math.min(
          desiredAvatarSize,
          columnWidth - 8,
        );

        final int rows =
        (visibleSeatCount / _columns).ceil();

        final double rowSpacing =
        visibleSeatCount <= 5 ? 12.0 : 8.0;

        final double rowHeight =
        math.max(
          1.0,
          (constraints.maxHeight -
              (rowSpacing * (rows - 1))) /
              rows,
        );

        final Widget seatLayout;

        if (visibleSeatCount <= 5) {
          seatLayout = _buildCenteredSmallGrid(
            context,
            visibleSeats,
            avatarSize,
            rowHeight,
          );
        } else {
          seatLayout = GridView.builder(
            physics:
            const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: visibleSeats.length,
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _columns,
              crossAxisSpacing: 0,
              mainAxisSpacing: rowSpacing,
              mainAxisExtent: rowHeight,
            ),
            itemBuilder: (context, index) {
              final RoomSeat seat =
              visibleSeats[index];

        return Center(
          child: _RoomSeatTile(
            key: ValueKey(
              'room-seat-${seat.number}',
            ),
            seat: seat,
            currentUserId: currentUserId,
            mediaBaseUrl: mediaBaseUrl,
            avatarSize: math.min(
              avatarSize,
              rowHeight - 20,
            ),
            onTap: () {
              onSeatTap(index);
            },
            onLongPress: isRoomOwner
                ? () {
              onSeatLongPress(index);
            }
                : null,
          ),
        );
      },
    );
  }


        return RepaintBoundary(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
            ),
            child: seatLayout,
          ),
        );
      },
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

  final double avatarSize;

  final VoidCallback onTap;

  final VoidCallback? onLongPress;

  const _RoomSeatTile({
    super.key,
    required this.seat,
    required this.currentUserId,
    required this.mediaBaseUrl,
    required this.avatarSize,
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

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SeatCircle(
            seat: seat,
            user: user,
            isMe: isMe,
            isSpeaking: isSpeaking,
            mediaBaseUrl: mediaBaseUrl,
            size: avatarSize,
          ),

          const SizedBox(height: 5),

          if (user == null)
            _EmptySeatNumber(
              number: seat.number,
              locked: seat.isLocked,
            )
          else
            _OccupiedUserName(
              name: user.name,
              isMe: isMe,
              maxWidth: avatarSize,
            ),
        ],
      ),
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

  final double size;

  const _SeatCircle({
    required this.seat,
    required this.user,
    required this.isMe,
    required this.isSpeaking,
    required this.mediaBaseUrl,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final bool locked = seat.isLocked;

    final double iconSize =
    (size * .39).clamp(
      20.0,
      32.0,
    );

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 180,
      ),
      curve: Curves.easeOut,
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,

        // --------------------------------------------------------------------
        // GLASS SEAT
        // --------------------------------------------------------------------

        color: Colors.white.withValues(
          alpha: .16,
        ),

        border: Border.all(
          color: isSpeaking || isMe
              ? const Color(0xFFFFD45C)
              : Colors.white.withValues(
            alpha: .32,
          ),
          width: isSpeaking || isMe
              ? 2
              : 1,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: .14,
            ),
            blurRadius: 5,
            offset: const Offset(
              0,
              2,
            ),
          ),

          if (isSpeaking)
            BoxShadow(
              color: const Color(
                0xFFFFD45C,
              ).withValues(
                alpha: .25,
              ),
              blurRadius: 10,
              spreadRadius: 1,
            ),
        ],
      ),

      child: ClipOval(
        child: _buildContent(
          locked: locked,
          iconSize: iconSize,
        ),
      ),
    );
  }

  Widget _buildContent({
    required bool locked,
    required double iconSize,
  }) {
    // ========================================================================
    // LOCKED
    // ========================================================================

    if (locked) {
      return Container(
        color: Colors.black.withValues(
          alpha: .24,
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.lock_rounded,
          color: Colors.white70,
          size: iconSize * .85,
        ),
      );
    }

    // ========================================================================
    // EMPTY
    // ========================================================================

    if (user == null) {
      return Center(
        child: Icon(
          Icons.mic_none_rounded,
          color: Colors.white,
          size: iconSize,
        ),
      );
    }

    // ========================================================================
    // OCCUPIED
    // ========================================================================

    final RoomUser occupiedUser = user!;

    return Stack(
      fit: StackFit.expand,
      children: [
        _RoomAvatarImage(
          source: occupiedUser.avatar,
          mediaBaseUrl: mediaBaseUrl,
          fallbackName: occupiedUser.name,
        ),

        // --------------------------------------------------------------------
        // MUTED
        // --------------------------------------------------------------------

        if (occupiedUser.isMuted)
          Container(
            color: Colors.black.withValues(
              alpha: .42,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.mic_off_rounded,
              color: const Color(
                0xFFFF737C,
              ),
              size: iconSize * .9,
            ),
          ),

        // --------------------------------------------------------------------
        // HOST
        // --------------------------------------------------------------------

        if (occupiedUser.isHost)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: math.max(
                18,
                size * .28,
              ),
              height: math.max(
                18,
                size * .28,
              ),
              decoration: const BoxDecoration(
                color: Color(
                  0xFFFFC83D,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.workspace_premium_rounded,
                color: const Color(
                  0xFF3A1850,
                ),
                size: math.max(
                  11,
                  size * .17,
                ),
              ),
            ),
          ),

        // --------------------------------------------------------------------
        // SPEAKING INDICATOR
        // --------------------------------------------------------------------

        if (occupiedUser.isSpeaking &&
            !occupiedUser.isMuted)
          Positioned(
            left: size * .11,
            right: size * .11,
            bottom: size * .08,
            child: Container(
              height: math.max(
                3,
                size * .05,
              ),
              decoration: BoxDecoration(
                color: const Color(
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
  Widget build(BuildContext context) {
    return Text(
      '$number',
      style: GoogleFonts.poppins(
        color: locked
            ? Colors.white24
            : Colors.white54,
        fontSize: 11,
        fontWeight: FontWeight.w500,
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

  final double maxWidth;

  const _OccupiedUserName({
    required this.name,
    required this.isMe,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: math.min(
          maxWidth,
          82,
        ),
      ),
      child: Container(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withValues(
            alpha: .30,
          ),
          borderRadius:
          BorderRadius.circular(9),
          border: Border.all(
            color: isMe
                ? const Color(
              0xFFFFD45C,
            )
                : Colors.white.withValues(
              alpha: .10,
            ),
            width: isMe ? 1 : .6,
          ),
        ),
        child: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: isMe
                ? const Color(
              0xFFFFD45C,
            )
                : Colors.white,
            fontSize: 8.5,
            fontWeight: FontWeight.w600,
            height: 1,
          ),
        ),
      ),
    );
  }
}


// ============================================================================
// AVATAR IMAGE
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
    final String value =
        source?.trim() ?? '';

    if (value.isEmpty) {
      return _fallback();
    }

    // ========================================================================
    // FULL URL
    // ========================================================================

    if (value.startsWith('http://') ||
        value.startsWith('https://')) {
      return Image.network(
        value,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return _fallback();
        },
      );
    }

    // ========================================================================
    // SERVER PATH
    // ========================================================================

    if (value.startsWith('/')) {
      final String base =
      mediaBaseUrl.endsWith('/')
          ? mediaBaseUrl.substring(
        0,
        mediaBaseUrl.length - 1,
      )
          : mediaBaseUrl;

      return Image.network(
        '$base$value',
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return _fallback();
        },
      );
    }

    // ========================================================================
    // LOCAL ASSET
    // ========================================================================

    return Image.asset(
      value,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      errorBuilder: (
          context,
          error,
          stackTrace,
          ) {
        return _fallback();
      },
    );
  }

  Widget _fallback() {
    final String name =
    fallbackName.trim();

    final String initial =
    name.isEmpty
        ? '?'
        : name.substring(
      0,
      1,
    ).toUpperCase();

    return Container(
      color: const Color(
        0xFF4B1764,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 27,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}