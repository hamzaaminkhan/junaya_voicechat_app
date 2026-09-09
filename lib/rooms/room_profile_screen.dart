import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:junaya_voicechat_app/rooms/models/voice_room_model.dart';

class RoomProfileScreen extends StatefulWidget {
  // ================================================================
  // ROOM
  // ================================================================

  final VoiceRoom room;

  // ================================================================
  // WALLPAPER
  // ================================================================

  final dynamic selectedWallpaper;

  final ValueChanged<dynamic>? onWallpaperChanged;

  // ================================================================
  // ACTIONS
  // ================================================================

  final VoidCallback? onRefresh;

  final VoidCallback? onTop;

  final VoidCallback? onSettings;

  const RoomProfileScreen({
    super.key,
    required this.room,
    this.selectedWallpaper,
    this.onWallpaperChanged,
    this.onRefresh,
    this.onTop,
    this.onSettings,
  });

  @override
  State<RoomProfileScreen> createState() =>
      _RoomProfileScreenState();
}


// ============================================================================
// STATE
// ============================================================================

class _RoomProfileScreenState
    extends State<RoomProfileScreen> {

  // ================================================================
  // TABS
  // ================================================================

  int _selectedTab = 0;

  // ================================================================
  // COLORS
  // ================================================================

  static const Color _background =
  Color(0xFF16052F);

  static const Color _accent =
  Color(0xFFB55CFF);

  static const Color _cyan =
  Color(0xFF18D4C3);

  static const Color _yellow =
  Color(0xFFFFD45C);


  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: Container(
        width: double.infinity,

        constraints: BoxConstraints(
          maxHeight:
          MediaQuery.of(context).size.height * .90,
        ),

        decoration: const BoxDecoration(
          color: _background,

          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),

        child: Column(
          children: [

            // ==========================================================
            // HANDLE
            // ==========================================================

            const SizedBox(height: 10),

            Container(
              width: 42,
              height: 4,

              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius:
                BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 8),

            // ==========================================================
            // HEADER
            // ==========================================================

            _buildHeader(),

            // ==========================================================
            // CONTENT
            // ==========================================================

            Expanded(
              child: SingleChildScrollView(
                physics:
                const BouncingScrollPhysics(),

                padding: const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  20,
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,

                  children: [

                    _buildRoomHeaderCard(),

                    const SizedBox(height: 18),

                    _buildTabs(),

                    const SizedBox(height: 18),

                    AnimatedSwitcher(
                      duration:
                      const Duration(
                        milliseconds: 180,
                      ),

                      child:
                      _buildSelectedTab(),
                    ),
                  ],
                ),
              ),
            ),

            // ==========================================================
            // BOTTOM ACTIONS
            // ==========================================================

            _buildBottomActions(),
          ],
        ),
      ),
    );
  }


  // ==========================================================================
  // HEADER
  // ==========================================================================

  Widget _buildHeader() {
    final room = widget.room;
    final owner = room.owner;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        2,
        14,
        12,
      ),

      child: Row(
        children: [

          // --------------------------------------------------------------
          // OWNER AVATAR
          // --------------------------------------------------------------

          _buildAvatar(
            avatar: owner?.avatar,
            name: owner?.name ?? room.name,
            size: 40,
          ),

          const SizedBox(width: 11),

          // --------------------------------------------------------------
          // TITLE
          // --------------------------------------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  'Room Profile',

                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  'Room ID: ${room.id}',

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style: GoogleFonts.poppins(
                    color: Colors.white38,
                    fontSize: 8.5,
                  ),
                ),
              ],
            ),
          ),

          // --------------------------------------------------------------
          // REFRESH
          // --------------------------------------------------------------

          _headerButton(
            icon: Icons.refresh_rounded,
            onTap: widget.onRefresh,
          ),

          const SizedBox(width: 2),

          // --------------------------------------------------------------
          // CLOSE
          // --------------------------------------------------------------

          _headerButton(
            icon:
            Icons.keyboard_arrow_down_rounded,

            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }


  // ==========================================================================
  // ROOM HEADER CARD
  // ==========================================================================

  Widget _buildRoomHeaderCard() {
    final room = widget.room;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
            Color(0xFF6935A8),
            Color(0xFF452079),
          ],
        ),

        borderRadius:
        BorderRadius.circular(20),

        border: Border.all(
          color: Colors.white
              .withValues(alpha: .07),
        ),
      ),

      child: Column(
        children: [

          // ==============================================================
          // ROOM INFO
          // ==============================================================

          Row(
            children: [

              _buildRoomAvatar(
                room,
                size: 72,
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(
                      room.name,

                      maxLines: 2,

                      overflow:
                      TextOverflow.ellipsis,

                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Room ID: ${room.id}',

                      maxLines: 1,

                      overflow:
                      TextOverflow.ellipsis,

                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 9,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [

                        const Icon(
                          Icons.mic_rounded,
                          color: _yellow,
                          size: 14,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          '${room.seatCount} Seats',

                          style:
                          GoogleFonts.poppins(
                            color:
                            Colors.white70,
                            fontSize: 9.5,
                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              _headerButton(
                icon:
                Icons.refresh_rounded,
                onTap: widget.onRefresh,
              ),
            ],
          ),

          const SizedBox(height: 15),

          // ==============================================================
          // ROOM STATS
          // ==============================================================

          _buildRoomStats(),
        ],
      ),
    );
  }


  // ==========================================================================
  // ROOM STATS
  // ==========================================================================

  Widget _buildRoomStats() {
    final room = widget.room;

    return Row(
      children: [

        Expanded(
          child: _buildStat(
            Icons.people_alt_outlined,
            '${room.onlineUsers}',
            'Online',
          ),
        ),

        Expanded(
          child: _buildStat(
            Icons.mic_none_rounded,
            '${room.occupiedSeatCount}',
            'On Mic',
          ),
        ),

        Expanded(
          child: _buildStat(
            Icons.emoji_events_outlined,
            '${room.roomRank}',
            'Rank',
          ),
        ),
      ],
    );
  }


  Widget _buildStat(
      IconData icon,
      String value,
      String label,
      ) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.center,

      children: [

        Icon(
          icon,
          color: Colors.white38,
          size: 16,
        ),

        const SizedBox(width: 5),

        Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Text(
              value,

              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 10.5,
                fontWeight:
                FontWeight.w600,
              ),
            ),

            Text(
              label,

              style: GoogleFonts.poppins(
                color: Colors.white30,
                fontSize: 7,
              ),
            ),
          ],
        ),
      ],
    );
  }


  // ==========================================================================
  // TABS
  // ==========================================================================

  Widget _buildTabs() {
    const tabs = [
      'Profile',
      'Member',
      'Activity',
    ];

    return Row(
      children: [

        for (int i = 0;
        i < tabs.length;
        i++)

          Expanded(
            child: GestureDetector(
              behavior:
              HitTestBehavior.opaque,

              onTap: () {
                if (_selectedTab == i) {
                  return;
                }

                setState(() {
                  _selectedTab = i;
                });
              },

              child: Padding(
                padding:
                const EdgeInsets.symmetric(
                  vertical: 5,
                ),

                child: Column(
                  children: [

                    Text(
                      tabs[i],

                      style:
                      GoogleFonts.poppins(
                        color:
                        _selectedTab == i
                            ? Colors.white
                            : Colors.white38,

                        fontSize: 11.5,

                        fontWeight:
                        _selectedTab == i
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 6),

                    AnimatedContainer(
                      duration:
                      const Duration(
                        milliseconds: 180,
                      ),

                      width:
                      _selectedTab == i
                          ? 22
                          : 0,

                      height: 3,

                      decoration:
                      BoxDecoration(
                        color: _accent,

                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }


  // ==========================================================================
  // SELECTED TAB
  // ==========================================================================

  Widget _buildSelectedTab() {
    switch (_selectedTab) {

      case 1:
        return _buildMemberTab();

      case 2:
        return _buildActivityTab();

      case 0:
      default:
        return _buildProfileTab();
    }
  }


  // ==========================================================================
  // PROFILE TAB
  // ==========================================================================

  Widget _buildProfileTab() {
    final room = widget.room;
    final owner = room.owner;

    return Column(
      key: const ValueKey(
        'profile_tab',
      ),

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        // --------------------------------------------------------------
        // OWNER
        // --------------------------------------------------------------

        if (owner != null)
          _buildOwnerCard(owner),

        const SizedBox(height: 14),

        // --------------------------------------------------------------
        // ANNOUNCEMENT
        // --------------------------------------------------------------

        _buildSectionTitle(
          'Announcement',
        ),

        const SizedBox(height: 7),

        Text(
          room.announcement.trim().isNotEmpty
              ? room.announcement
              : 'Welcome to join my party!',

          style: GoogleFonts.poppins(
            color: Colors.white60,
            fontSize: 10.5,
            height: 1.45,
          ),
        ),

        const SizedBox(height: 18),

        // --------------------------------------------------------------
        // COUNTRY
        // --------------------------------------------------------------

        _buildCountryCard(),

        const SizedBox(height: 12),

        // --------------------------------------------------------------
        // LEVEL
        // --------------------------------------------------------------

        _buildLevelCard(),

        const SizedBox(height: 12),

        // --------------------------------------------------------------
        // MIC
        // --------------------------------------------------------------

        _buildMicCard(),
      ],
    );
  }


  // ==========================================================================
  // OWNER
  // ==========================================================================

  Widget _buildOwnerCard(RoomUser owner) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(11),

      decoration: BoxDecoration(
        color: Colors.white
            .withValues(alpha: .045),

        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color: Colors.white
              .withValues(alpha: .06),
        ),
      ),

      child: Row(
        children: [

          _buildAvatar(
            avatar: owner.avatar,
            name: owner.name,
            size: 44,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Row(
                  children: [

                    Text(
                      'Room Owner',

                      style:
                      GoogleFonts.poppins(
                        color:
                        Colors.white38,
                        fontSize: 8,
                      ),
                    ),

                    const SizedBox(width: 5),

                    const Icon(
                      Icons
                          .workspace_premium_rounded,
                      color: _yellow,
                      size: 12,
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                Text(
                  owner.name,

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                if (owner.junayaId != null &&
                    owner.junayaId!
                        .trim()
                        .isNotEmpty)

                  Text(
                    'ID ${owner.junayaId}',

                    style:
                    GoogleFonts.poppins(
                      color:
                      Colors.white30,
                      fontSize: 7.5,
                    ),
                  ),
              ],
            ),
          ),

          if (owner.vipLevel > 0)
            _buildVipBadge(
              owner.vipLevel,
            ),
        ],
      ),
    );
  }


  // ==========================================================================
  // COUNTRY
  // ==========================================================================

  Widget _buildCountryCard() {
    // Temporary fake data.
    // VoiceRoom currently has no country field.

    const country = 'Pakistan';
    const flag = '🇵🇰';

    return _buildInfoCard(
      child: Row(
        children: [

          Container(
            width: 40,
            height: 40,

            alignment:
            Alignment.center,

            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: .055),
              shape: BoxShape.circle,
            ),

            child: const Text(
              flag,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                _smallLabel(
                  'Country',
                ),

                const SizedBox(height: 2),

                Text(
                  country,

                  style:
                  GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          _temporaryBadge(),
        ],
      ),
    );
  }


  // ==========================================================================
  // LEVEL
  // ==========================================================================

  Widget _buildLevelCard() {
    // Temporary fake data.
    // VoiceRoom currently has no level fields.

    const int level = 2;
    const double progress = .30;

    final percentage =
    (progress * 100).round();

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
            const Color(0xFF59268D)
                .withValues(alpha: .72),

            const Color(0xFF32155C)
                .withValues(alpha: .72),
          ],
        ),

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color: _accent
              .withValues(alpha: .13),
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Container(
                width: 42,
                height: 42,

                alignment:
                Alignment.center,

                decoration: BoxDecoration(
                  color: _accent
                      .withValues(alpha: .14),

                  shape: BoxShape.circle,

                  border: Border.all(
                    color: _accent
                        .withValues(alpha: .18),
                  ),
                ),

                child: Text(
                  '$level',

                  style:
                  GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    _smallLabel(
                      'Room Level',
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'LV $level',

                      style:
                      GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '$percentage%',

                style:
                GoogleFonts.poppins(
                  color: _cyan,
                  fontSize: 11,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          ClipRRect(
            borderRadius:
            BorderRadius.circular(20),

            child: LinearProgressIndicator(
              minHeight: 8,

              value: progress,

              backgroundColor:
              Colors.white
                  .withValues(alpha: .10),

              valueColor:
              const AlwaysStoppedAnimation<
                  Color>(
                _cyan,
              ),
            ),
          ),

          const SizedBox(height: 7),

          Row(
            children: [

              _smallLabel(
                'Progress',
              ),

              const Spacer(),

              Text(
                '$percentage / 100',

                style:
                GoogleFonts.poppins(
                  color: Colors.white38,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  // ==========================================================================
  // MIC CARD
  // ==========================================================================

  Widget _buildMicCard() {
    final room = widget.room;

    return _buildInfoCard(
      child: Row(
        children: [

          Container(
            width: 40,
            height: 40,

            alignment:
            Alignment.center,

            decoration: BoxDecoration(
              color: _accent
                  .withValues(alpha: .14),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.mic_rounded,
              color: Colors.white70,
              size: 20,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  'Mic Seats',

                  style:
                  GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  '${room.seatCount} mic seats configured',

                  style:
                  GoogleFonts.poppins(
                    color: Colors.white38,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),

          Text(
            '${room.seatCount}/25',

            style:
            GoogleFonts.poppins(
              color: _yellow,
              fontSize: 10,
              fontWeight:
              FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }


  // ==========================================================================
  // MEMBER TAB
  // ==========================================================================

  Widget _buildMemberTab() {
    final members = widget.room.members;

    return Column(
      key: const ValueKey(
        'member_tab',
      ),

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Row(
          children: [

            _buildSectionTitle(
              'Members',
            ),

            const SizedBox(width: 6),

            Text(
              '${members.length}',

              style:
              GoogleFonts.poppins(
                color: Colors.white38,
                fontSize: 9,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        if (members.isEmpty)

          _buildEmptyState(
            icon:
            Icons.people_outline_rounded,

            title:
            'No members',

            subtitle:
            'There are no members in this room yet.',
          )

        else

          ListView.separated(
            shrinkWrap: true,

            physics:
            const NeverScrollableScrollPhysics(),

            itemCount:
            members.length,

            separatorBuilder:
                (_, __) =>
            const SizedBox(height: 7),

            itemBuilder:
                (context, index) {

              final member =
              members[index];

              return _buildMemberTile(
                member,
              );
            },
          ),
      ],
    );
  }


  // ==========================================================================
  // MEMBER TILE
  // ==========================================================================

  Widget _buildMemberTile(
      RoomUser member,
      ) {
    final isOwner =
        member.id ==
            widget.room.ownerId ||
            member.isHost;

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),

      decoration: BoxDecoration(
        color: Colors.white
            .withValues(alpha: .045),

        borderRadius:
        BorderRadius.circular(15),

        border: Border.all(
          color: Colors.white
              .withValues(alpha: .055),
        ),
      ),

      child: Row(
        children: [

          _buildAvatar(
            avatar: member.avatar,
            name: member.name,
            size: 40,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Row(
                  children: [

                    Flexible(
                      child: Text(
                        member.name,

                        maxLines: 1,

                        overflow:
                        TextOverflow.ellipsis,

                        style:
                        GoogleFonts.poppins(
                          color:
                          Colors.white,
                          fontSize: 11,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),

                    if (isOwner) ...[
                      const SizedBox(width: 5),

                      _buildRoleBadge(
                        'Owner',
                      ),
                    ]
                    else if (member.isAdmin) ...[
                      const SizedBox(width: 5),

                      _buildRoleBadge(
                        'Admin',
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 2),

                Row(
                  children: [

                    if (member.junayaId != null &&
                        member.junayaId!
                            .trim()
                            .isNotEmpty)

                      Flexible(
                        child: Text(
                          'ID ${member.junayaId}',

                          maxLines: 1,

                          overflow:
                          TextOverflow.ellipsis,

                          style:
                          GoogleFonts.poppins(
                            color:
                            Colors.white38,
                            fontSize: 8,
                          ),
                        ),
                      ),

                    if (member.vipLevel > 0) ...[
                      const SizedBox(width: 6),

                      Text(
                        'VIP ${member.vipLevel}',

                        style:
                        GoogleFonts.poppins(
                          color: _yellow,
                          fontSize: 8,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          if (member.isSpeaking)
            const Icon(
              Icons.graphic_eq_rounded,
              color: _cyan,
              size: 18,
            )
          else if (member.isMuted)
            const Icon(
              Icons.mic_off_rounded,
              color: Colors.white30,
              size: 17,
            ),
        ],
      ),
    );
  }


  // ==========================================================================
  // ACTIVITY TAB
  // ==========================================================================

  Widget _buildActivityTab() {
    return Column(
      key: const ValueKey(
        'activity_tab',
      ),

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        _buildSectionTitle(
          'Activity',
        ),

        const SizedBox(height: 10),

        _buildEmptyState(
          icon:
          Icons.history_rounded,

          title:
          'No activity yet',

          subtitle:
          'Room activity will appear here.',
        ),
      ],
    );
  }


  // ==========================================================================
  // EMPTY STATE
  // ==========================================================================

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 25,
      ),

      decoration: BoxDecoration(
        color: Colors.white
            .withValues(alpha: .035),

        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color: Colors.white
              .withValues(alpha: .05),
        ),
      ),

      child: Column(
        children: [

          Icon(
            icon,
            color: Colors.white24,
            size: 30,
          ),

          const SizedBox(height: 8),

          Text(
            title,

            style:
            GoogleFonts.poppins(
              color: Colors.white60,
              fontSize: 10,
              fontWeight:
              FontWeight.w600,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            subtitle,

            textAlign:
            TextAlign.center,

            style:
            GoogleFonts.poppins(
              color: Colors.white30,
              fontSize: 8.5,
            ),
          ),
        ],
      ),
    );
  }


  // ==========================================================================
  // BOTTOM ACTIONS
  // ==========================================================================

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        14,
      ),

      decoration: BoxDecoration(
        color: _background,

        border: Border(
          top: BorderSide(
            color: Colors.white
                .withValues(alpha: .06),
          ),
        ),
      ),

      child: Row(
        children: [

          Expanded(
            child: _buildBottomButton(
              icon:
              Icons.rocket_launch_rounded,

              title: 'Top',

              color:
              const Color(0xFFFF626D),

              onTap: widget.onTop,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: _buildBottomButton(
              icon:
              Icons.settings_rounded,

              title: 'Setting',

              color: _cyan,

              onTap: widget.onSettings,
            ),
          ),
        ],
      ),
    );
  }


  // ==========================================================================
  // BOTTOM BUTTON
  // ==========================================================================

  Widget _buildBottomButton({
    required IconData icon,
    required String title,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius:
        BorderRadius.circular(28),

        child: Container(
          height: 50,

          decoration: BoxDecoration(
            color: color,

            borderRadius:
            BorderRadius.circular(28),
          ),

          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [

              Icon(
                icon,
                color: Colors.white,
                size: 21,
              ),

              const SizedBox(width: 7),

              Text(
                title,

                style:
                GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // ==========================================================================
  // INFO CARD
  // ==========================================================================

  Widget _buildInfoCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(13),

      decoration: BoxDecoration(
        color: Colors.white
            .withValues(alpha: .045),

        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color: Colors.white
              .withValues(alpha: .06),
        ),
      ),

      child: child,
    );
  }


  // ==========================================================================
  // SECTION TITLE
  // ==========================================================================

  Widget _buildSectionTitle(
      String title,
      ) {
    return Text(
      title,

      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 12,
        fontWeight:
        FontWeight.w600,
      ),
    );
  }


  // ==========================================================================
  // SMALL LABEL
  // ==========================================================================

  Widget _smallLabel(
      String text,
      ) {
    return Text(
      text,

      style: GoogleFonts.poppins(
        color: Colors.white38,
        fontSize: 8,
      ),
    );
  }


  // ==========================================================================
  // TEMP BADGE
  // ==========================================================================

  Widget _temporaryBadge() {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),

      decoration: BoxDecoration(
        color: Colors.white
            .withValues(alpha: .05),

        borderRadius:
        BorderRadius.circular(7),
      ),

      child: Text(
        'TEMP',

        style: GoogleFonts.poppins(
          color: Colors.white30,
          fontSize: 6.5,
          fontWeight:
          FontWeight.w600,
        ),
      ),
    );
  }


  // ==========================================================================
  // VIP BADGE
  // ==========================================================================

  Widget _buildVipBadge(
      int level,
      ) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),

      decoration: BoxDecoration(
        color: _yellow
            .withValues(alpha: .10),

        borderRadius:
        BorderRadius.circular(8),

        border: Border.all(
          color: _yellow
              .withValues(alpha: .20),
        ),
      ),

      child: Text(
        'VIP $level',

        style: GoogleFonts.poppins(
          color: _yellow,
          fontSize: 7.5,
          fontWeight:
          FontWeight.w600,
        ),
      ),
    );
  }


  // ==========================================================================
  // ROLE BADGE
  // ==========================================================================

  Widget _buildRoleBadge(
      String text,
      ) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 2,
      ),

      decoration: BoxDecoration(
        color: _yellow
            .withValues(alpha: .12),

        borderRadius:
        BorderRadius.circular(5),
      ),

      child: Text(
        text,

        style: GoogleFonts.poppins(
          color: _yellow,
          fontSize: 7,
          fontWeight:
          FontWeight.w600,
        ),
      ),
    );
  }


  // ==========================================================================
  // ROOM AVATAR
  // ==========================================================================

  Widget _buildRoomAvatar(
      VoiceRoom room, {
        double size = 70,
      }) {
    final owner = room.owner;

    return _buildAvatar(
      avatar: owner?.avatar,
      name: owner?.name ?? room.name,
      size: size,
      radius: 16,
    );
  }


  // ==========================================================================
  // AVATAR
  // ==========================================================================

  Widget _buildAvatar({
    required String? avatar,
    required String name,
    required double size,
    double? radius,
  }) {
    final source =
        avatar?.trim() ?? '';

    final borderRadius =
        radius ?? size / 2;

    Widget fallback() {
      return Container(
        width: size,
        height: size,

        alignment:
        Alignment.center,

        decoration: BoxDecoration(
          color:
          const Color(0xFF6B2878),

          borderRadius:
          BorderRadius.circular(
            borderRadius,
          ),
        ),

        child: Text(
          _avatarLetter(name),

          style:
          GoogleFonts.poppins(
            color: Colors.white,
            fontSize: size * .32,
            fontWeight:
            FontWeight.w700,
          ),
        ),
      );
    }

    if (source.isEmpty) {
      return fallback();
    }

    final isNetwork =
        source.startsWith('http://') ||
            source.startsWith('https://');

    final image = isNetwork
        ? Image.network(
      source,
      width: size,
      height: size,
      fit: BoxFit.cover,

      errorBuilder:
          (_, __, ___) =>
          fallback(),
    )
        : Image.asset(
      source,
      width: size,
      height: size,
      fit: BoxFit.cover,

      errorBuilder:
          (_, __, ___) =>
          fallback(),
    );

    return ClipRRect(
      borderRadius:
      BorderRadius.circular(
        borderRadius,
      ),

      child: image,
    );
  }


  // ==========================================================================
  // AVATAR LETTER
  // ==========================================================================

  String _avatarLetter(
      String name,
      ) {
    final value =
    name.trim();

    if (value.isEmpty) {
      return '?';
    }

    return value.characters
        .first
        .toUpperCase();
  }


  // ==========================================================================
  // HEADER BUTTON
  // ==========================================================================

  Widget _headerButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius:
        BorderRadius.circular(20),

        child: Padding(
          padding:
          const EdgeInsets.all(7),

          child: Icon(
            icon,
            color: Colors.white70,
            size: 21,
          ),
        ),
      ),
    );
  }
}