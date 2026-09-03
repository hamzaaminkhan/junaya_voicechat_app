import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/models/voice_room_model.dart';

/// 5 x 5 production room seat grid sized against the 738 x 1600 reference.
class RoomSeatGrid extends StatelessWidget {
  int _getColumnCount(int seatCount) {
    if (seatCount <= 2) return 2;
    if (seatCount <= 6) return 3;
    if (seatCount <= 12) return 4;
    return 5;
  }

  double _getSeatHeight(int seatCount) {
    if (seatCount <= 4) return 150;
    if (seatCount <= 9) return 130;
    if (seatCount <= 16) return 115;
    return 100;
  }

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

  int get columns {
    if (seatCount <= 5) return seatCount;
    return 5;
  }

  @override
  Widget build(BuildContext context) {
    if (seats.isEmpty) return const SizedBox.shrink();

    final columns = _getColumnCount(seats.length);
    final seatHeight = _getSeatHeight(seats.length);

    return RepaintBoundary(
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: seats.length,

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisExtent: seatHeight,
          mainAxisSpacing: 12,
          crossAxisSpacing: 10,
        ),

        itemBuilder: (context, index) {
          final seat = seats[index];

          return _RoomSeatTile(
            key: ValueKey('room-seat-${seat.number}'),
            seat: seat,
            currentUserId: currentUserId,
            mediaBaseUrl: mediaBaseUrl,
            onTap: () => onSeatTap(index),
            onLongPress:
            isRoomOwner ? () => onSeatLongPress(index) : null,
          );
        },
      ),
    );
  }
}

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
    final user = seat.user;
    final isMe = user?.id == currentUserId;
    final isSpeaking = user?.isSpeaking == true && user?.isMuted != true;
    final ringColor = seat.isLocked
        ? Colors.white54
        : isSpeaking
        ? const Color(0xFFFFCF4B)
        : isMe
        ? const Color(0xFFC971FF)
        : Colors.white;

    return Semantics(
      button: true,
      label: seat.isLocked
          ? 'Mic ${seat.number}, locked'
          : user == null
          ? 'Mic ${seat.number}, empty'
          : 'Mic ${seat.number}, ${user.name}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          customBorder: const CircleBorder(),
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              if (user == null)
              Positioned(
                top: 2,
                child: Transform.rotate(
                  angle: .785,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xE80B0A0C),
                      border: Border.all(
                        color: ringColor.withValues(
                          alpha: .65,
                        ),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ringColor.withValues(alpha: .22),
                          blurRadius: 7,
                        ),
                      ],
                    ),
                    child: Transform.rotate(
                      angle: -.785,
                      child: Text(
                        '${seat.number}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12.5,
                          height: 1,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 24,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 72,
                  height: 72,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: Colors.white.withValues(
                      alpha: .10,
                    ),

                    border: Border.all(
                      color: Colors.white.withValues(
                        alpha: .35,
                      ),
                      width: 1.4,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: ringColor.withValues(
                          alpha: isSpeaking ? .55 : .25,
                        ),
                        blurRadius: isSpeaking ? 18 : 10,
                        spreadRadius: 1,
                      ),

                      const BoxShadow(
                        color: Colors.black38,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(child: _seatBody(user)),
                ),
              ),
              if (user != null)
                Positioned(
                  left: 4,
                  right: 4,
                  bottom: 4,
                  child: Container(
                    height: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: .14,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isMe
                            ? const Color(0xFFFFD15B).withValues(alpha: .62)
                            : Colors.white.withValues(alpha: .22),
                        width: .8,
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        user.name,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: isMe
                              ? const Color(0xFFFFD15B)
                              : Colors.white,
                          fontSize: 14,
                          height: 1,
                          fontWeight: FontWeight.w600,
                          shadows: const [
                            Shadow(color: Colors.black, blurRadius: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _seatBody(RoomUser? user) {
    if (seat.isLocked) {
      return Container(
        color: Colors.black.withValues(alpha: .78),
        alignment: Alignment.center,
        child: const Icon(
          Icons.lock_rounded,
          color: Colors.white70,
          size: 36,
        ),
      );
    }

    if (user == null) {
      return Container(
        color: Colors.black.withValues(alpha: .76),
        alignment: Alignment.center,
        child: const Icon(
          Icons.mic_none_rounded,
          color: Colors.white,
          size: 43,
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        _RoomAvatarImage(
          source: user.avatar,
          mediaBaseUrl: mediaBaseUrl,
          fallbackName: user.name,
        ),
        if (user.isMuted)
          Container(
            color: Colors.black.withValues(alpha: .52),
            alignment: Alignment.center,
            child: const Icon(
              Icons.mic_off_rounded,
              color: Color(0xFFFF7078),
              size: 33,
            ),
          ),
        if (user.isHost)
          Positioned(
            right: 1,
            top: 1,
            child: Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                color: Color(0xFFFFC23D),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.workspace_premium_rounded,
                color: Colors.black,
                size: 16,
              ),
            ),
          ),
      ],
    );
  }
}

class _RoomAvatarImage extends StatelessWidget {
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
    final value = source?.trim() ?? '';
    if (value.isEmpty) return _fallback();

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return Image.network(
        value,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, _, _) => _fallback(),
      );
    }

    if (value.startsWith('/')) {
      final base = mediaBaseUrl.endsWith('/')
          ? mediaBaseUrl.substring(0, mediaBaseUrl.length - 1)
          : mediaBaseUrl;
      return Image.network(
        '$base$value',
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, _, _) => _fallback(),
      );
    }

    return Image.asset(
      value,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.medium,
      errorBuilder: (_, _, _) => _fallback(),
    );
  }

  Widget _fallback() {
    final initial = fallbackName.trim().isEmpty
        ? '?'
        : fallbackName.trim().characters.first.toUpperCase();

    return Container(
      color: const Color(0xFF32115B),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
