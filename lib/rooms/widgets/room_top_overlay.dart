import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/rooms/models/voice_room_model.dart';




/// Reference-sized header designed for a 738 x 1600 room canvas.
/// The parent room canvas scales this widget uniformly for the device.
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
    final ownerName = (owner?.name.trim().isNotEmpty ?? false)
        ? owner!.name.trim()
        : room.name;
    final publicId = ownerPublicId?.trim().isNotEmpty == true
        ? ownerPublicId!.trim()
        : (owner?.junayaId?.trim().isNotEmpty == true
              ? owner!.junayaId!.trim()
              : room.id);
    final vipLevel = ownerVipLevel ?? owner?.vipLevel ?? 0;
    final visibleMembers = room.members
        .where((member) => member.id != owner?.id)
        .take(3)
        .toList();
    final hiddenMemberCount = room.members.length -
        (owner == null ? 0 : 1) -
        visibleMembers.length;

    return SizedBox(
      height: 190,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 4,
            top: 5,
            child: GestureDetector(
              onTap: onOwnerTap,
              child: _OwnerFrame(
                size: 112,
                avatar: owner?.avatar,
                name: ownerName,
                mediaBaseUrl: mediaBaseUrl,
              ),
            ),
          ),
          Positioned(
            left: 136,
            top: 44,
            right: 236,
            child: Text(
              ownerName.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 25,
                height: 1.05,
                fontWeight: FontWeight.w600,
                letterSpacing: .1,
                shadows: const [
                  Shadow(color: Colors.black, blurRadius: 7),
                  Shadow(color: Colors.black54, offset: Offset(0, 1)),
                ],
              ),
            ),
          ),
          Positioned(
            left: 136,
            top: 91,
            width: 140,
            child: Text(
              'ID: $publicId',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.white.withValues(alpha: .9),
                fontSize: 18,
                height: 1,
                fontWeight: FontWeight.w400,
                shadows: const [Shadow(color: Colors.black, blurRadius: 5)],
              ),
            ),
          ),
          Positioned(
            left: 282,
            top: 82,
            child: _VipBadge(level: vipLevel),
          ),
          Positioned(
            left: 136,
            top: 133,
            child: _RankPill(rank: room.roomRank),
          ),
          Positioned(
            top: 18,
            right: 8,
            child: Tooltip(
              message: 'Leave room',
              child: IconButton(
                onPressed: onCloseTap,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 50,
                  height: 50,
                ),
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 43,
                ),
              ),
            ),
          ),
          Positioned(
            top: 79,
            right: 17,
            child: GestureDetector(
              onTap: onMembersTap,
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (visibleMembers.isNotEmpty)
                        SizedBox(
                          width: 52 + ((visibleMembers.length - 1) * 39),
                          height: 54,
                          child: Stack(
                            children: List.generate(visibleMembers.length, (
                              index,
                            ) {
                              return Positioned(
                                left: index * 39,
                                child: _MiniAvatar(
                                  user: visibleMembers[index],
                                  mediaBaseUrl: mediaBaseUrl,
                                ),
                              );
                            }),
                          ),
                        ),
                      if (hiddenMemberCount > 0) ...[
                        const SizedBox(width: 5),
                        Container(
                          width: 54,
                          height: 54,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: .6),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white60, width: 1.2),
                          ),
                          child: Text(
                            '+$hiddenMemberCount',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: socketConnected && voiceConnected
                              ? const Color(0xFF00E977)
                              : const Color(0xFFFFC94A),
                          boxShadow: [
                            BoxShadow(
                              color: (socketConnected && voiceConnected
                                      ? const Color(0xFF00E977)
                                      : const Color(0xFFFFC94A))
                                  .withValues(alpha: .55),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 9),
                      Text(
                        'Online: ${room.onlineUsers}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          height: 1,
                          fontWeight: FontWeight.w400,
                          shadows: const [
                            Shadow(color: Colors.black, blurRadius: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VipBadge extends StatelessWidget {
  final int level;

  const _VipBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF160B24).withValues(alpha: .9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF8B38D0), width: 1.4),
        boxShadow: const [
          BoxShadow(color: Color(0x553E0067), blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.diamond_outlined,
            color: Color(0xFFB84BFF),
            size: 20,
          ),
          const SizedBox(width: 7),
          Text(
            'Lv. $level',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 17,
              height: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RankPill extends StatelessWidget {
  final int rank;

  const _RankPill({required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      constraints: const BoxConstraints(minWidth: 154),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .74),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFB79045), width: 1.2),
        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 8)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.emoji_events_rounded,
            color: Color(0xFFFFC13D),
            size: 26,
          ),
          const SizedBox(width: 12),
          Text(
            _compactNumber(rank),
            style: GoogleFonts.poppins(
              color: const Color(0xFFFFD261),
              fontSize: 23,
              height: 1,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(
            Icons.chevron_right_rounded,
            color: Colors.white,
            size: 27,
          ),
        ],
      ),
    );
  }

  String _compactNumber(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(value >= 10000000 ? 0 : 1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value >= 10000 ? 0 : 2)}K';
    }
    return '$value';
  }
}

class _OwnerFrame extends StatelessWidget {
  final double size;
  final String? avatar;
  final String name;
  final String mediaBaseUrl;

  const _OwnerFrame({
    required this.size,
    required this.avatar,
    required this.name,
    required this.mediaBaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 12,
      height: size + 16,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27),
              gradient: const SweepGradient(
                colors: [
                  Color(0xFFFFD84F),
                  Color(0xFFFF7A2D),
                  Color(0xFFAD42FF),
                  Color(0xFFFFD84F),
                ],
              ),
              boxShadow: const [
                BoxShadow(color: Color(0x77FF9D2E), blurRadius: 14),
                BoxShadow(color: Color(0x559F4CFF), blurRadius: 18),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFF08040B),
                borderRadius: BorderRadius.circular(23),
                border: Border.all(color: const Color(0xFFFFD977), width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _RoomImage(
                  source: avatar,
                  mediaBaseUrl: mediaBaseUrl,
                  fallbackName: name,
                ),
              ),
            ),
          ),
          Positioned(
            top: -4,
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFF4C225E),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 5)],
              ),
              child: const Icon(
                Icons.workspace_premium_rounded,
                color: Color(0xFFFFD25A),
                size: 25,
              ),
            ),
          ),
          Positioned(
            bottom: -6,
            child: Transform.rotate(
              angle: .785,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6D1EFF), Color(0xFFD66AFF)],
                  ),
                  border: Border.all(color: const Color(0xFFFFD15D), width: 2),
                  boxShadow: const [
                    BoxShadow(color: Color(0x774E20FF), blurRadius: 8),
                  ],
                ),
                child: Transform.rotate(
                  angle: -.785,
                  child: const Icon(
                    Icons.diamond_rounded,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniAvatar extends StatelessWidget {
  final RoomUser user;
  final String mediaBaseUrl;

  const _MiniAvatar({required this.user, required this.mediaBaseUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFFFC34B), Color(0xFF9D5FFF)],
        ),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 6)],
      ),
      child: ClipOval(
        child: _RoomImage(
          source: user.avatar,
          mediaBaseUrl: mediaBaseUrl,
          fallbackName: user.name,
        ),
      ),
    );
  }
}

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
      color: const Color(0xFF4A1B52),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.playfairDisplay(
          color: Colors.white,
          fontSize: 52,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
