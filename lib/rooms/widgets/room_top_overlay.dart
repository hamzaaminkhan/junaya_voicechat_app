import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/rooms/models/voice_room_model.dart';


/// Reference-sized header designed for a 738 x 1600 room canvas.
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
    (owner?.name.trim().isNotEmpty ?? false)
        ? owner!.name.trim()
        : room.name;

    final publicId =
    ownerPublicId?.trim().isNotEmpty == true
        ? ownerPublicId!.trim()
        : (owner?.junayaId?.trim().isNotEmpty == true
        ? owner!.junayaId!.trim()
        : room.id);

    final vipLevel =
        ownerVipLevel ??
            owner?.vipLevel ??
            0;

    /*
     * ------------------------------------------------------------
     * TOP USERS
     * ------------------------------------------------------------
     *
     * Requirement:
     *
     * Cross کے نیچے صرف 4 User Profiles
     * باقی Users کی Total Counting
     *
     * Owner is included in the four.
     */

    final allMembers = <RoomUser>[];

    if (owner != null) {
      allMembers.add(owner!);
    }

    for (final member in room.members) {
      if (owner != null &&
          member.id == owner!.id) {
        continue;
      }

      allMembers.add(member);
    }

    final visibleMembers =
    allMembers.take(4).toList();

    final hiddenMemberCount =
    allMembers.length >
        visibleMembers.length
        ? allMembers.length -
        visibleMembers.length
        : 0;

    return SizedBox(
      height: 190,

      child: Stack(
        clipBehavior: Clip.none,

        children: [

          // ============================================================
          // OWNER
          // ============================================================

          Positioned(
            left: 4,
            top: 5,

            child: GestureDetector(
              onTap: onOwnerTap,

              child: _OwnerFrame(
                size: 106,
                avatar: owner?.avatar,
                name: ownerName,
                mediaBaseUrl: mediaBaseUrl,
              ),
            ),
          ),


          // ============================================================
          // ROOM NAME
          // ============================================================

          Positioned(
            left: 132,
            top: 39,
            right: 220,

            child: Text(
              ownerName.toUpperCase(),

              maxLines: 1,

              overflow:
              TextOverflow.ellipsis,

              style: GoogleFonts.poppins(
                color: Colors.white,

                // Slightly smaller.
                fontSize: 21,

                height: 1.05,

                fontWeight:
                FontWeight.w600,

                letterSpacing: .1,

                shadows: const [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 7,
                  ),
                  Shadow(
                    color: Colors.black54,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),


          // ============================================================
          // ID
          // ============================================================

          Positioned(
            left: 132,
            top: 72,

            child: Text(
              'ID: $publicId',

              maxLines: 1,

              overflow:
              TextOverflow.ellipsis,

              style: GoogleFonts.poppins(
                color:
                Colors.white.withValues(
                  alpha: .88,
                ),

                fontSize: 14,

                height: 1,

                fontWeight:
                FontWeight.w400,

                shadows: const [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
          ),


          // ============================================================
          // VIP LEVEL
          // ============================================================

          Positioned(
            left: 255,
            top: 65,

            child: _VipBadge(
              level: vipLevel,
            ),
          ),


          // ============================================================
          // DECORATIVE RECTANGLE / STRIP
          // ============================================================

          Positioned(
            left: 132,
            top: 105,
            child: _HeaderStrip(
              rank: room.roomRank,
            ),
          ),


          // ============================================================
          // CLOSE
          // ============================================================

          Positioned(
            top: 8,
            right: 4,

            child: Tooltip(
              message: 'Leave room',

              child: IconButton(
                onPressed: onCloseTap,

                padding:
                EdgeInsets.zero,

                constraints:
                const BoxConstraints
                    .tightFor(
                  width: 50,
                  height: 50,
                ),

                icon: const Icon(
                  Icons.close_rounded,

                  color: Colors.white,

                  size: 38,
                ),
              ),
            ),
          ),


          // ============================================================
          // TOP 4 USERS
          // ============================================================

          Positioned(
            top: 67,
            right: 12,

            child: GestureDetector(
              onTap: onMembersTap,

              behavior:
              HitTestBehavior.opaque,

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.end,

                children: [

                  Row(
                    mainAxisSize:
                    MainAxisSize.min,

                    children: [

                      if (visibleMembers
                          .isNotEmpty)
                        SizedBox(
                          width:
                          _avatarRowWidth(
                            visibleMembers.length,
                          ),

                          height: 48,

                          child: Stack(
                            clipBehavior:
                            Clip.none,

                            children:
                            List.generate(
                              visibleMembers.length,
                                  (index) {
                                return Positioned(
                                  left:
                                  index * 37,

                                  child:
                                  _MiniAvatar(
                                    user:
                                    visibleMembers[
                                    index],

                                    mediaBaseUrl:
                                    mediaBaseUrl,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),


                      if (hiddenMemberCount >
                          0) ...[
                        const SizedBox(
                          width: 5,
                        ),

                        Container(
                          width: 48,
                          height: 48,

                          alignment:
                          Alignment.center,

                          decoration:
                          BoxDecoration(
                            color: Colors.black
                                .withValues(
                              alpha: .55,
                            ),

                            shape:
                            BoxShape.circle,

                            border:
                            Border.all(
                              color:
                              Colors.white54,

                              width: 1,
                            ),
                          ),

                          child: Text(
                            '+$hiddenMemberCount',

                            style:
                            GoogleFonts.poppins(
                              color:
                              Colors.white,

                              fontSize: 14,

                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),


                  const SizedBox(
                    height: 6,
                  ),


                  // ======================================================
                  // ONLINE
                  // ======================================================

                  Row(
                    mainAxisSize:
                    MainAxisSize.min,

                    children: [

                      Container(
                        width: 10,
                        height: 10,

                        decoration:
                        BoxDecoration(
                          shape:
                          BoxShape.circle,

                          color: socketConnected &&
                              voiceConnected
                              ? const Color(
                            0xFF00E977,
                          )
                              : const Color(
                            0xFFFFC94A,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color:
                              (socketConnected &&
                                  voiceConnected
                                  ? const Color(
                                0xFF00E977,
                              )
                                  : const Color(
                                0xFFFFC94A,
                              ))
                                  .withValues(
                                alpha: .5,
                              ),

                              blurRadius: 7,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        width: 7,
                      ),

                      Text(
                        'Online: ${room.onlineUsers}',

                        style:
                        GoogleFonts.poppins(
                          color:
                          Colors.white,

                          fontSize: 14,

                          height: 1,

                          fontWeight:
                          FontWeight.w400,

                          shadows: const [
                            Shadow(
                              color:
                              Colors.black,
                              blurRadius: 5,
                            ),
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


  double _avatarRowWidth(
      int count,
      ) {
    if (count <= 0) {
      return 0;
    }

    return 48 +
        ((count - 1) * 37);
  }
}


// ============================================================================
// HEADER STRIP
// ============================================================================

class _HeaderStrip extends StatelessWidget {
  final int rank;

  const _HeaderStrip({
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,

      constraints:
      const BoxConstraints(
        minWidth: 150,
      ),

      padding:
      const EdgeInsets.symmetric(
        horizontal: 11,
      ),

      decoration:
      BoxDecoration(
        borderRadius:
        BorderRadius.circular(9),

        color: Colors.black
            .withValues(
          alpha: .32,
        ),

        border: Border.all(
          color: Colors.white
              .withValues(
            alpha: .16,
          ),

          width: .8,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(
              alpha: .18,
            ),

            blurRadius: 8,

            offset:
            const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        mainAxisSize:
        MainAxisSize.min,

        children: [

          const Icon(
            Icons.emoji_events_rounded,

            color:
            Color(0xFFFFC13D),

            size: 18,
          ),

          const SizedBox(
            width: 6,
          ),

          Text(
            _compactNumber(rank),

            style:
            GoogleFonts.poppins(
              color:
              const Color(
                0xFFFFD261,
              ),

              fontSize: 14,

              fontWeight:
              FontWeight.w600,
            ),
          ),

          const SizedBox(
            width: 4,
          ),

          const Icon(
            Icons.chevron_right_rounded,

            color:
            Colors.white70,

            size: 18,
          ),
        ],
      ),
    );
  }

  String _compactNumber(
      int value,
      ) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(
        value >= 10000000 ? 0 : 1,
      )}M';
    }

    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(
        value >= 10000 ? 0 : 2,
      )}K';
    }

    return '$value';
  }
}


// ============================================================================
// VIP BADGE
// ============================================================================

class _VipBadge extends StatelessWidget {
  final int level;

  const _VipBadge({
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,

      padding:
      const EdgeInsets.symmetric(
        horizontal: 9,
      ),

      alignment:
      Alignment.center,

      decoration:
      BoxDecoration(
        color: const Color(
          0xFF160B24,
        ).withValues(
          alpha: .78,
        ),

        borderRadius:
        BorderRadius.circular(7),

        border: Border.all(
          color:
          const Color(
            0xFF8B38D0,
          ).withValues(
            alpha: .8,
          ),

          width: 1,
        ),
      ),

      child: Row(
        mainAxisSize:
        MainAxisSize.min,

        children: [

          const Icon(
            Icons.diamond_outlined,

            color:
            Color(0xFFB84BFF),

            size: 15,
          ),

          const SizedBox(
            width: 5,
          ),

          Text(
            'Lv. $level',

            style:
            GoogleFonts.poppins(
              color:
              Colors.white,

              fontSize: 12,

              height: 1,

              fontWeight:
              FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}


// ============================================================================
// OWNER FRAME
// ============================================================================

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
        clipBehavior:
        Clip.none,

        alignment:
        Alignment.center,

        children: [

          Container(
            width: size,
            height: size,

            padding:
            const EdgeInsets.all(4),

            decoration:
            BoxDecoration(
              borderRadius:
              BorderRadius.circular(27),

              gradient:
              const SweepGradient(
                colors: [
                  Color(0xFFFFD84F),
                  Color(0xFFFF7A2D),
                  Color(0xFFAD42FF),
                  Color(0xFFFFD84F),
                ],
              ),

              boxShadow: const [
                BoxShadow(
                  color:
                  Color(0x66FF9D2E),

                  blurRadius: 14,
                ),

                BoxShadow(
                  color:
                  Color(0x449F4CFF),

                  blurRadius: 18,
                ),
              ],
            ),

            child: Container(
              padding:
              const EdgeInsets.all(3),

              decoration:
              BoxDecoration(
                color:
                const Color(
                  0xFF08040B,
                ),

                borderRadius:
                BorderRadius.circular(23),

                border:
                Border.all(
                  color:
                  const Color(
                    0xFFFFD977,
                  ),

                  width: 1,
                ),
              ),

              child: ClipRRect(
                borderRadius:
                BorderRadius.circular(20),

                child: _RoomImage(
                  source: avatar,

                  mediaBaseUrl:
                  mediaBaseUrl,

                  fallbackName:
                  name,
                ),
              ),
            ),
          ),


          // Crown
          Positioned(
            top: -4,

            child: Container(
              width: 30,
              height: 30,

              decoration:
              const BoxDecoration(
                color:
                Color(0xFF4C225E),

                shape:
                BoxShape.circle,
              ),

              child: const Icon(
                Icons.workspace_premium_rounded,

                color:
                Color(0xFFFFD25A),

                size: 22,
              ),
            ),
          ),


          // Bottom diamond
          Positioned(
            bottom: -6,

            child: Transform.rotate(
              angle: .785,

              child: Container(
                width: 32,
                height: 32,

                decoration:
                BoxDecoration(
                  gradient:
                  const LinearGradient(
                    colors: [
                      Color(0xFF6D1EFF),
                      Color(0xFFD66AFF),
                    ],
                  ),

                  border:
                  Border.all(
                    color:
                    const Color(
                      0xFFFFD15D,
                    ),

                    width: 1.5,
                  ),
                ),

                child: Transform.rotate(
                  angle: -.785,

                  child: const Icon(
                    Icons.diamond_rounded,

                    color:
                    Colors.white,

                    size: 18,
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


// ============================================================================
// MINI AVATAR
// ============================================================================

class _MiniAvatar extends StatelessWidget {
  final RoomUser user;

  final String mediaBaseUrl;

  const _MiniAvatar({
    required this.user,
    required this.mediaBaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,

      padding:
      const EdgeInsets.all(2),

      decoration:
      BoxDecoration(
        shape:
        BoxShape.circle,

        gradient:
        const LinearGradient(
          colors: [
            Color(0xFFFFC34B),
            Color(0xFF9D5FFF),
          ],
        ),

        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 6,
          ),
        ],
      ),

      child: ClipOval(
        child: _RoomImage(
          source: user.avatar,

          mediaBaseUrl:
          mediaBaseUrl,

          fallbackName:
          user.name,
        ),
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
        FilterQuality.medium,

        errorBuilder:
            (_, _, _) => _fallback(),
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

        fit:
        BoxFit.cover,

        filterQuality:
        FilterQuality.medium,

        errorBuilder:
            (_, _, _) => _fallback(),
      );
    }

    return Image.asset(
      value,

      fit:
      BoxFit.cover,

      filterQuality:
      FilterQuality.medium,

      errorBuilder:
          (_, _, _) => _fallback(),
    );
  }

  Widget _fallback() {
    final name =
    fallbackName.trim();

    final initial =
    name.isEmpty
        ? '?'
        : name.characters
        .first
        .toUpperCase();

    return Container(
      color:
      const Color(
        0xFF4A1B52,
      ),

      alignment:
      Alignment.center,

      child: Text(
        initial,

        style:
        GoogleFonts.playfairDisplay(
          color:
          Colors.white,

          fontSize: 42,

          fontWeight:
          FontWeight.w600,
        ),
      ),
    );
  }
}