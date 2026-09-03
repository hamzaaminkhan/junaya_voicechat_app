import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:junaya_voicechat_app/rooms/models/voice_room_model.dart';


/// Top section of the room.

/// - Room name
/// - Room ID
/// - VIP level
/// - Header strip
/// - Close button
/// - Maximum 4 top users
/// - Remaining user count
/// - Online count
/// - Ranking frames for levels 1, 2 and 3
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

    // ------------------------------------------------------------
    // TOP USERS
    // ------------------------------------------------------------

    final topUsers = <RoomUser>[];

    for (final member in room.members) {
      if (owner != null &&
          member.id == owner!.id) {
        continue;
      }

      topUsers.add(member);

      if (topUsers.length == 4) {
        break;
      }
    }

    final totalMembers =
        room.members.length;

    final hiddenCount =
    totalMembers > topUsers.length
        ? totalMembers - topUsers.length
        : 0;

    return SizedBox(
      height: 190,

      child: Stack(
        clipBehavior: Clip.none,
        children: [

          // ==========================================================
          // OWNER
          // ==========================================================

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

          // ==========================================================
          // ROOM NAME
          // ==========================================================

          Positioned(
            left: 132,
            top: 39,
            right: 220,

            child: Text(
              ownerName,

              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                height: 1.05,
                fontWeight: FontWeight.w600,

                shadows: const [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 7,
                  ),
                ],
              ),
            ),
          ),

          // ==========================================================
          // ROOM ID
          // ==========================================================

          Positioned(
            left: 132,
            top: 68,

            child: Text(
              'ID: $publicId',

              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 11.5,
                height: 1,
                fontWeight: FontWeight.w400,

                shadows: const [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
          ),

          // ==========================================================
          // VIP LEVEL
          // ==========================================================

          Positioned(
            left: 255,
            top: 61,

            child: _VipBadge(
              level: vipLevel,
            ),
          ),

          // ==========================================================
          // RECTANGULAR STRIP
          // ==========================================================

          Positioned(
            left: 132,
            top: 94,

            child: _HeaderStrip(
              rank: room.roomRank,
            ),
          ),

          // ==========================================================
          // CLOSE
          // ==========================================================

          Positioned(
            top: 5,
            right: 4,

            child: Tooltip(
              message: 'Leave room',

              child: IconButton(
                onPressed: onCloseTap,

                padding: EdgeInsets.zero,

                constraints:
                const BoxConstraints.tightFor(
                  width: 46,
                  height: 46,
                ),

                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
            ),
          ),

          // ==========================================================
          // TOP 4 USERS
          // ==========================================================

          Positioned(
            top: 67,
            right: 8,

            child: GestureDetector(
              onTap: onMembersTap,

              behavior: HitTestBehavior.opaque,

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.end,

                children: [

                  Row(
                    mainAxisSize:
                    MainAxisSize.min,

                    children: [

                      if (topUsers.isNotEmpty)
                        SizedBox(
                          width:
                          _avatarRowWidth(
                            topUsers.length,
                          ),

                          height: 50,

                          child: Stack(
                            clipBehavior:
                            Clip.none,

                            children:
                            List.generate(
                              topUsers.length,
                                  (index) {
                                final user =
                                topUsers[index];

                                // For now the member
                                // ordering represents
                                // the top-user ranking.
                                final rank =
                                _rankingLevel(
                                  index,
                                );

                                return Positioned(
                                  left:
                                  index * 36,

                                  child:
                                  _MiniAvatar(
                                    user: user,
                                    rank: rank,
                                    mediaBaseUrl:
                                    mediaBaseUrl,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                      if (hiddenCount > 0) ...[
                        const SizedBox(
                          width: 6,
                        ),

                        _MoreUsers(
                          count: hiddenCount,
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 6),

                  // ====================================================
                  // ONLINE
                  // ====================================================

                  Row(
                    mainAxisSize:
                    MainAxisSize.min,

                    children: [

                      _OnlineIndicator(
                        connected:
                        socketConnected &&
                            voiceConnected,
                      ),

                      const SizedBox(width: 7),

                      Text(
                        'Online: ${room.onlineUsers}',

                        style:
                        GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12.5,
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

  // ------------------------------------------------------------
  // RANKING LEVEL
  // ------------------------------------------------------------

  int _rankingLevel(int index) {
    if (index == 0) {
      return 1;
    }

    if (index == 1) {
      return 2;
    }

    return 3;
  }

  // ------------------------------------------------------------
  // AVATAR ROW WIDTH
  // ------------------------------------------------------------

  double _avatarRowWidth(int count) {
    if (count <= 0) {
      return 0;
    }

    return 48 + ((count - 1) * 36);
  }
}


// ============================================================================
// MORE USERS
// ============================================================================

class _MoreUsers extends StatelessWidget {
  final int count;

  const _MoreUsers({
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,

      alignment: Alignment.center,

      decoration: BoxDecoration(
        color: Colors.black.withValues(
          alpha: .52,
        ),

        shape: BoxShape.circle,

        border: Border.all(
          color: Colors.white38,
          width: 1,
        ),
      ),

      child: Text(
        '+$count',

        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}


// ============================================================================
// ONLINE INDICATOR
// ============================================================================

class _OnlineIndicator extends StatelessWidget {
  final bool connected;

  const _OnlineIndicator({
    required this.connected,
  });

  @override
  Widget build(BuildContext context) {
    final color = connected
        ? const Color(0xFF00E977)
        : const Color(0xFFFFC94A);

    return Container(
      width: 9,
      height: 9,

      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,

        boxShadow: [
          BoxShadow(
            color: color.withValues(
              alpha: .5,
            ),
            blurRadius: 7,
          ),
        ],
      ),
    );
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
      height: 32,

      constraints:
      const BoxConstraints(
        minWidth: 150,
      ),

      padding:
      const EdgeInsets.symmetric(
        horizontal: 11,
      ),

      decoration: BoxDecoration(
        color: Colors.black.withValues(
          alpha: .28,
        ),

        borderRadius:
        BorderRadius.circular(7),

        border: Border.all(
          color: Colors.white.withValues(
            alpha: .18,
          ),

          width: .8,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: .18,
            ),

            blurRadius: 8,

            offset: const Offset(
              0,
              3,
            ),
          ),
        ],
      ),

      child: Row(
        mainAxisSize:
        MainAxisSize.min,

        children: [

          const Icon(
            Icons.emoji_events_rounded,
            color: Color(0xFFFFC13D),
            size: 17,
          ),

          const SizedBox(width: 6),

          Text(
            _compactNumber(rank),

            style: GoogleFonts.poppins(
              color:
              const Color(0xFFFFD261),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(width: 4),

          const Icon(
            Icons.chevron_right_rounded,
            color: Colors.white70,
            size: 17,
          ),
        ],
      ),
    );
  }

  String _compactNumber(int value) {
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
      height: 28,

      padding:
      const EdgeInsets.symmetric(
        horizontal: 8,
      ),

      alignment: Alignment.center,

      decoration: BoxDecoration(
        color:
        const Color(0xFF160B24)
            .withValues(alpha: .78),

        borderRadius:
        BorderRadius.circular(7),

        border: Border.all(
          color:
          const Color(0xFF8B38D0)
              .withValues(alpha: .8),

          width: 1,
        ),
      ),

      child: Row(
        mainAxisSize:
        MainAxisSize.min,

        children: [

          const Icon(
            Icons.diamond_outlined,
            color: Color(0xFFB84BFF),
            size: 14,
          ),

          const SizedBox(width: 5),

          Text(
            'Lv. $level',

            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 11,
              height: 1,
              fontWeight: FontWeight.w600,
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
        clipBehavior: Clip.none,
        alignment: Alignment.center,

        children: [

          Container(
            width: size,
            height: size,

            padding:
            const EdgeInsets.all(4),

            decoration: BoxDecoration(
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
                  color: Color(0x66FF9D2E),
                  blurRadius: 14,
                ),

                BoxShadow(
                  color: Color(0x449F4CFF),
                  blurRadius: 18,
                ),
              ],
            ),

            child: Container(
              padding:
              const EdgeInsets.all(3),

              decoration: BoxDecoration(
                color:
                const Color(0xFF08040B),

                borderRadius:
                BorderRadius.circular(23),

                border: Border.all(
                  color:
                  const Color(0xFFFFD977),
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
                color: Color(0xFF4C225E),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.workspace_premium_rounded,
                color: Color(0xFFFFD25A),
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

                decoration: BoxDecoration(
                  gradient:
                  const LinearGradient(
                    colors: [
                      Color(0xFF6D1EFF),
                      Color(0xFFD66AFF),
                    ],
                  ),

                  border: Border.all(
                    color:
                    const Color(0xFFFFD15D),
                    width: 1.5,
                  ),
                ),

                child: Transform.rotate(
                  angle: -.785,

                  child: const Icon(
                    Icons.diamond_rounded,
                    color: Colors.white,
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
// MINI AVATAR + RANKING
// ============================================================================

class _MiniAvatar extends StatelessWidget {
  final RoomUser user;

  final int rank;

  final String mediaBaseUrl;

  const _MiniAvatar({
    required this.user,
    required this.rank,
    required this.mediaBaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    final ranking = _RankingStyle.fromLevel(
      rank,
    );

    return SizedBox(
      width: 58,
      height: 58,

      child: Stack(
        clipBehavior: Clip.none,

        children: [

          // ----------------------------------------------------------
          // RANK CIRCLE
          // ----------------------------------------------------------

          Positioned(
            left: 5,
            top: 5,

            child: Container(
              width: 48,
              height: 48,

              padding:
              const EdgeInsets.all(2.5),

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                gradient:
                LinearGradient(
                  colors: ranking.circleColors,
                ),

                boxShadow: [
                  BoxShadow(
                    color: ranking.glowColor
                        .withValues(
                      alpha: .38,
                    ),

                    blurRadius: 8,
                  ),
                ],
              ),

              child: Container(
                padding:
                const EdgeInsets.all(1.5),

                decoration: BoxDecoration(
                  color:
                  const Color(0xFF09050D),

                  shape: BoxShape.circle,

                  border: Border.all(
                    color:
                    ranking.innerBorder,
                    width: 1,
                  ),
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
              ),
            ),
          ),

          // ----------------------------------------------------------
          // CROWN
          // ----------------------------------------------------------

          Positioned(
            top: -5,
            right: -2,

            child: Container(
              width: 23,
              height: 23,

              alignment: Alignment.center,

              decoration: BoxDecoration(
                color:
                ranking.crownBackground,

                shape: BoxShape.circle,

                border: Border.all(
                  color:
                  ranking.crownColor
                      .withValues(
                    alpha: .65,
                  ),

                  width: .8,
                ),
              ),

              child: Icon(
                Icons.workspace_premium_rounded,

                color:
                ranking.crownColor,

                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ============================================================================
// RANKING STYLE
// ============================================================================

class _RankingStyle {
  final List<Color> circleColors;

  final Color innerBorder;

  final Color crownColor;

  final Color crownBackground;

  final Color glowColor;

  const _RankingStyle({
    required this.circleColors,
    required this.innerBorder,
    required this.crownColor,
    required this.crownBackground,
    required this.glowColor,
  });

  factory _RankingStyle.fromLevel(
      int level,
      ) {
    switch (level) {

    // --------------------------------------------------------------
    // LEVEL 1 — GOLD
    // --------------------------------------------------------------

      case 1:
        return const _RankingStyle(
          circleColors: [
            Color(0xFFFFF09A),
            Color(0xFFFFC22E),
            Color(0xFFE88700),
          ],

          innerBorder:
          Color(0xFFFFE78A),

          crownColor:
          Color(0xFFFFD83D),

          crownBackground:
          Color(0xFF6B4510),

          glowColor:
          Color(0xFFFFC83D),
        );

    // --------------------------------------------------------------
    // LEVEL 2 — METAL
    // --------------------------------------------------------------

      case 2:
        return const _RankingStyle(
          circleColors: [
            Color(0xFFE4E7EC),
            Color(0xFF8E96A3),
            Color(0xFF535B68),
          ],

          innerBorder:
          Color(0xFFD4D8DF),

          crownColor:
          Color(0xFFD6DAE2),

          crownBackground:
          Color(0xFF414751),

          glowColor:
          Color(0xFFB9C0CC),
        );

    // --------------------------------------------------------------
    // LEVEL 3 — SILVER
    // --------------------------------------------------------------

      default:
        return const _RankingStyle(
          circleColors: [
            Color(0xFFF5F5F5),
            Color(0xFFC4C7CC),
            Color(0xFF8C9198),
          ],

          innerBorder:
          Color(0xFFE4E5E7),

          crownColor:
          Color(0xFFE8E9EC),

          crownBackground:
          Color(0xFF5B5E64),

          glowColor:
          Color(0xFFD5D7DB),
        );
    }
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
        fit: BoxFit.cover,
        filterQuality:
        FilterQuality.medium,

        errorBuilder:
            (_, _, _) => _fallback(),
      );
    }

    return Image.asset(
      value,
      fit: BoxFit.cover,
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
      const Color(0xFF4A1B52),

      alignment:
      Alignment.center,

      child: Text(
        initial,

        style:
        GoogleFonts.playfairDisplay(
          color: Colors.white,
          fontSize: 28,
          fontWeight:
          FontWeight.w600,
        ),
      ),
    );
  }
}