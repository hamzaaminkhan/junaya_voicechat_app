import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/rooms/models/voice_room_model.dart';

// ============================================================================
// ROOM PROFILE SCREEN
// ============================================================================

class RoomProfileScreen extends StatefulWidget {
  final VoiceRoom room;

  const RoomProfileScreen({
    super.key,
    required this.room,
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

  // --------------------------------------------------------------------------
  // TAB
  // --------------------------------------------------------------------------

  int _selectedTab = 0;

  // --------------------------------------------------------------------------
  // TEMPORARY PROFILE DATA
  //
  // These are intentionally temporary.
  // Later we will connect them to the real user/room data.
  // --------------------------------------------------------------------------

  static const String _temporaryCountry = 'Pakistan';

  static const String _temporaryFlag = '🇵🇰';

  static const int _temporaryLevel = 2;

  static const int _temporaryLevelProgress = 150;

  static const int _temporaryLevelTarget = 500;


  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17052D),

      body: SafeArea(
        bottom: false,

        child: Stack(
          children: [

            // ==============================================================
            // BACKGROUND
            // ==============================================================

            _buildBackground(),

            // ==============================================================
            // MAIN CONTENT
            // ==============================================================

            Column(
              children: [

                // ==========================================================
                // CONTENT
                // ==========================================================

                Expanded(
                  child: _buildContent(),
                ),

                // ==========================================================
                // FIXED BOTTOM ACTIONS
                // ==============================================================

                _buildBottomActions(),
              ],
            ),
          ],
        ),
      ),
    );
  }




  // ==========================================================================
  // BACKGROUND
  // ==========================================================================

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
            Color(0xFF32117A),
            Color(0xFF4A168E),
            Color(0xFF16042D),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // CONTENT
  // ==========================================================================

  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),

      padding: const EdgeInsets.fromLTRB(
        12,
        4,
        12,
        110,
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,

        children: [

          // --------------------------------------------------------------------
          // ROOM CARD
          // --------------------------------------------------------------------

          _buildRoomCard(),

          const SizedBox(height: 12),

          // --------------------------------------------------------------------
          // TABS
          // --------------------------------------------------------------------

          _buildTabs(),

          const SizedBox(height: 14),

          // --------------------------------------------------------------------
          // TAB CONTENT
          // --------------------------------------------------------------------

          _buildSelectedTab(),
        ],
      ),
    );
  }


  // ==========================================================================
  // ROOM CARD
  //
  // Part 1 only creates the shell.
  // We will make the contents production-level in Part 2.
  // ==========================================================================

  // ============================================================================
// ROOM INFORMATION CARD
// ============================================================================

  Widget _buildRoomCard() {
    final room = widget.room;

    final roomName = room.name.trim().isEmpty
        ? 'Junaya Voice Room'
        : room.name.trim();

    final roomId = room.id.toString();

    final seatCount = room.seatCount;

    final initial = roomName.isEmpty
        ? '?'
        : roomName.substring(0, 1).toUpperCase();

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(
        14,
        14,
        14,
        13,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFF6E35A0).withValues(
          alpha: 0.78,
        ),

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.08,
          ),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          // ======================================================================
          // ROOM HEADER
          // ======================================================================

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              // ------------------------------------------------------------------
              // ROOM AVATAR
              // ------------------------------------------------------------------

              Container(
                width: 70,
                height: 70,

                decoration: BoxDecoration(
                  color: const Color(0xFF4D1D73),

                  borderRadius:
                  BorderRadius.circular(14),

                  border: Border.all(
                    color: Colors.white.withValues(
                      alpha: 0.12,
                    ),
                  ),
                ),

                child: Center(
                  child: Text(
                    initial,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 13),

              // ------------------------------------------------------------------
              // ROOM NAME + ID
              // ------------------------------------------------------------------

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 3,
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(
                        roomName,

                        maxLines: 1,

                        overflow:
                        TextOverflow.ellipsis,

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        'Room ID: $roomId',

                        maxLines: 1,

                        overflow:
                        TextOverflow.ellipsis,

                        style: TextStyle(
                          color: Colors.white.withValues(
                            alpha: 0.48,
                          ),
                          fontSize: 9,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Row(
                        children: [

                          const Icon(
                            Icons.mic_none_rounded,
                            color: Colors.white54,
                            size: 14,
                          ),

                          const SizedBox(width: 5),

                          Text(
                            '$seatCount Seats',

                            style: TextStyle(
                              color: Colors.white.withValues(
                                alpha: 0.68,
                              ),
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ------------------------------------------------------------------
              // REFRESH
              // ------------------------------------------------------------------

              Material(
                color: Colors.transparent,

                child: InkWell(
                  borderRadius:
                  BorderRadius.circular(22),

                  onTap: () {
                    // Room refresh will be connected
                    // when we wire the real room
                    // refresh logic.
                  },

                  child: const SizedBox(
                    width: 34,
                    height: 34,

                    child: Center(
                      child: Icon(
                        Icons.refresh_rounded,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ======================================================================
          // ROOM STATS
          // ======================================================================

          Row(
            children: [

              Expanded(
                child: _buildRoomStat(
                  icon:
                  Icons.people_outline_rounded,
                  value: '1',
                  label: 'Online',
                ),
              ),

              Expanded(
                child: _buildRoomStat(
                  icon:
                  Icons.mic_none_rounded,
                  value: '0',
                  label: 'On Mic',
                ),
              ),

              Expanded(
                child: _buildRoomStat(
                  icon:
                  Icons.star_border_rounded,
                  value: '0',
                  label: 'Score',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// ============================================================================
// ROOM STAT
// ============================================================================

  Widget _buildRoomStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white.withValues(
            alpha: 0.45,
          ),
          size: 14,
        ),

        const SizedBox(width: 5),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 1),

            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(
                  alpha: 0.38,
                ),
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
    const labels = [
      'Profile',
      'Member',
      'Activity',
    ];

    return Row(
      children: [

        for (int i = 0; i < labels.length; i++)
          Expanded(
            child: GestureDetector(
              behavior:
              HitTestBehavior.opaque,

              onTap: () {
                setState(() {
                  _selectedTab = i;
                });
              },

              child: Padding(
                padding:
                const EdgeInsets.symmetric(
                  vertical: 9,
                ),

                child: Column(
                  children: [

                    Text(
                      labels[i],

                      style: TextStyle(
                        color: i == _selectedTab
                            ? Colors.white
                            : Colors.white54,

                        fontSize: 11,

                        fontWeight:
                        i == _selectedTab
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 7),

                    AnimatedContainer(
                      duration:
                      const Duration(
                        milliseconds: 180,
                      ),

                      width:
                      i == _selectedTab
                          ? 22
                          : 0,

                      height: 2,

                      decoration:
                      BoxDecoration(
                        color:
                        const Color(
                          0xFFB94CFF,
                        ),

                        borderRadius:
                        BorderRadius.circular(
                          4,
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

  // ============================================================================
// PROFILE TAB
// ============================================================================

  Widget _buildProfileTab() {
    return Column(
      key: const ValueKey('profile'),

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        // ========================================================================
        // ANNOUNCEMENT
        // ========================================================================

        _buildProfileSectionTitle(
          'Announcement',
        ),

        const SizedBox(height: 8),

        Container(
          width: double.infinity,

          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),

          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.055,
            ),

            borderRadius:
            BorderRadius.circular(14),

            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.045,
              ),
            ),
          ),

          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Container(
                width: 30,
                height: 30,

                decoration: BoxDecoration(
                  color: const Color(0xFF18D4C3)
                      .withValues(
                    alpha: 0.14,
                  ),

                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.campaign_outlined,
                  color: Color(0xFF18D4C3),
                  size: 16,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  widget.room.announcement
                      .trim()
                      .isNotEmpty
                      ? widget.room.announcement.trim()
                      : 'Welcome to join my party!',

                  maxLines: 4,

                  overflow:
                  TextOverflow.ellipsis,

                  style: TextStyle(
                    color: Colors.white.withValues(
                      alpha: 0.70,
                    ),
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        // ========================================================================
        // COUNTRY
        // ========================================================================

        _buildProfileSectionTitle(
          'Country',
        ),

        const SizedBox(height: 8),

        Container(
          width: double.infinity,

          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 11,
          ),

          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.055,
            ),

            borderRadius:
            BorderRadius.circular(14),
          ),

          child: Row(
            children: [

              const Text(
                _temporaryFlag,
                style: TextStyle(
                  fontSize: 22,
                ),
              ),

              const SizedBox(width: 9),

              Text(
                _temporaryCountry,

                style: TextStyle(
                  color: Colors.white.withValues(
                    alpha: 0.75,
                  ),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        // ========================================================================
        // LEVEL
        // ========================================================================

        _buildProfileSectionTitle(
          'Level',
        ),

        const SizedBox(height: 8),

        Container(
          width: double.infinity,

          padding: const EdgeInsets.fromLTRB(
            14,
            13,
            14,
            12,
          ),

          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.055,
            ),

            borderRadius:
            BorderRadius.circular(14),
          ),

          child: Column(
            children: [

              // ------------------------------------------------------------------
              // LEVEL HEADER
              // ------------------------------------------------------------------

              Row(
                children: [

                  Container(
                    width: 42,
                    height: 42,

                    decoration: BoxDecoration(
                      color: const Color(0xFF18D4C3)
                          .withValues(
                        alpha: 0.14,
                      ),

                      borderRadius:
                      BorderRadius.circular(12),
                    ),

                    child: Center(
                      child: Text(
                        '$_temporaryLevel',

                        style: const TextStyle(
                          color: Color(0xFF18D4C3),
                          fontSize: 17,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Text(
                          'Level $_temporaryLevel',

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          'Room experience level',

                          style: TextStyle(
                            color: Colors.white
                                .withValues(
                              alpha: 0.38,
                            ),
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    'Rules',

                    style: TextStyle(
                      color: Colors.white.withValues(
                        alpha: 0.55,
                      ),
                      fontSize: 9,
                    ),
                  ),

                  const SizedBox(width: 2),

                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white38,
                    size: 17,
                  ),
                ],
              ),

              const SizedBox(height: 13),

              // ------------------------------------------------------------------
              // PROGRESS
              // ------------------------------------------------------------------

              _buildLevelProgress(),

              const SizedBox(height: 7),

              Row(
                children: [

                  Text(
                    '$_temporaryLevelProgress / '
                        '$_temporaryLevelTarget',

                    style: TextStyle(
                      color: Colors.white.withValues(
                        alpha: 0.42,
                      ),
                      fontSize: 8,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    'To upgrade',

                    style: TextStyle(
                      color: Colors.white.withValues(
                        alpha: 0.35,
                      ),
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }


// ============================================================================
// PROFILE SECTION TITLE
// ============================================================================

  Widget _buildProfileSectionTitle(
      String title,
      ) {
    return Text(
      title,

      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }


// ============================================================================
// LEVEL PROGRESS
// ============================================================================

  Widget _buildLevelProgress() {
    final progress =
    (_temporaryLevelProgress /
        _temporaryLevelTarget)
        .clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius:
      BorderRadius.circular(20),

      child: LinearProgressIndicator(
        value: progress,

        minHeight: 7,

        backgroundColor:
        Colors.white.withValues(
          alpha: 0.16,
        ),

        valueColor:
        const AlwaysStoppedAnimation<Color>(
          Color(0xFF18D4C3),
        ),
      ),
    );
  }


// ============================================================================
// MEMBER TAB
// ============================================================================

  Widget _buildMemberTab() {
    final members = widget.room.members;

    return Column(
      key: const ValueKey('member'),

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Row(
          children: [

            _buildProfileSectionTitle(
              'Members',
            ),

            const Spacer(),

            Text(
              '${members.length}',

              style: TextStyle(
                color: Colors.white.withValues(
                  alpha: 0.42,
                ),
                fontSize: 10,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        if (members.isEmpty)

          _buildEmptyTabState(
            icon:
            Icons.people_outline_rounded,
            text:
            'No members in this room.',
          )

        else

          Column(
            children: [

              for (final member in members)
                Padding(
                  padding:
                  const EdgeInsets.only(
                    bottom: 7,
                  ),

                  child: _buildMemberTile(
                    member,
                  ),
                ),
            ],
          ),
      ],
    );
  }


// ============================================================================
// MEMBER TILE
// ============================================================================

  Widget _buildMemberTile(
      RoomUser member,
      ) {
    final name =
    member.name.trim().isEmpty
        ? 'User'
        : member.name.trim();

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 9,
      ),

      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.055,
        ),

        borderRadius:
        BorderRadius.circular(14),

        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.035,
          ),
        ),
      ),

      child: Row(
        children: [

          _buildAvatar(
            name: name,
            size: 40,
            radius: 11,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  name,

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  member.isHost
                      ? 'Room Owner'
                      : 'Member',

                  style: TextStyle(
                    color: Colors.white.withValues(
                      alpha: 0.38,
                    ),
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),

          if (member.isHost)
            const Icon(
              Icons.workspace_premium_rounded,
              color: Color(0xFFFFD34D),
              size: 18,
            ),
        ],
      ),
    );
  }


// ============================================================================
// ACTIVITY TAB
// ============================================================================

  Widget _buildActivityTab() {
    return Column(
      key: const ValueKey('activity'),

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        _buildProfileSectionTitle(
          'Activity',
        ),

        const SizedBox(height: 10),

        _buildEmptyTabState(
          icon:
          Icons.history_rounded,
          text:
          'Room activity will appear here.',
        ),
      ],
    );
  }


// ============================================================================
// EMPTY STATE
// ============================================================================

  Widget _buildEmptyTabState({
    required IconData icon,
    required String text,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 20,
      ),

      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.045,
        ),

        borderRadius:
        BorderRadius.circular(14),
      ),

      child: Column(
        children: [

          Icon(
            icon,
            color: Colors.white.withValues(
              alpha: 0.25,
            ),
            size: 30,
          ),

          const SizedBox(height: 8),

          Text(
            text,

            textAlign: TextAlign.center,

            style: TextStyle(
              color: Colors.white.withValues(
                alpha: 0.38,
              ),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }



  // ==========================================================================
  // MEMBER TAB
  // ==========================================================================

  // ==========================================================================
  // ACTIVITY TAB
  // ==========================================================================


  // ==========================================================================
  // AVATAR
  // ==========================================================================

  Widget _buildAvatar({
    required String name,
    required double size,
    required double radius,
  }) {
    final firstLetter =
    name.trim().isEmpty
        ? '?'
        : name.trim()[0].toUpperCase();

    return Container(
      width: size,
      height: size,

      decoration: BoxDecoration(
        color: const Color(0xFF4E217A),

        borderRadius:
        BorderRadius.circular(radius),

        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.12,
          ),
        ),
      ),

      child: Center(
        child: Text(
          firstLetter,

          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.32,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ============================================================================
// BOTTOM ACTION BAR
// ============================================================================

  Widget _buildBottomActions() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(
        18,
        10,
        18,
        14,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFF241044).withValues(
          alpha: 0.96,
        ),

        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(
              alpha: 0.06,
            ),
          ),
        ),
      ),

      child: Row(
        children: [

          // ======================================================================
          // TOP
          // ======================================================================

          Expanded(
            child: _buildBottomButton(
              icon: Icons.rocket_launch_rounded,
              label: 'Top',
              backgroundColor:
              const Color(0xFFFF5E6C),
              onTap: () {
                // Connect to real Top functionality later.
              },
            ),
          ),

          const SizedBox(width: 12),

          // ======================================================================
          // SETTING
          // ======================================================================

          Expanded(
            child: _buildBottomButton(
              icon: Icons.settings_rounded,
              label: 'Setting',
              backgroundColor:
              const Color(0xFF18D4C3),
              onTap: () {
                // Connect to real room settings later.
              },
            ),
          ),
        ],
      ),
    );
  }


// ============================================================================
// BOTTOM ACTION BUTTON
// ============================================================================

  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required VoidCallback onTap,
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
            color: backgroundColor,

            borderRadius:
            BorderRadius.circular(28),

            boxShadow: [
              BoxShadow(
                color: backgroundColor.withValues(
                  alpha: 0.18,
                ),

                blurRadius: 12,

                offset: const Offset(
                  0,
                  4,
                ),
              ),
            ],
          ),

          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [

              Icon(
                icon,
                color: Colors.white,
                size: 19,
              ),

              const SizedBox(width: 7),

              Text(
                label,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
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

}