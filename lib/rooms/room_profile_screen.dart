import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:junaya_voicechat_app/rooms/room_socket_service.dart';

import 'room_settings_screen.dart';

class RoomProfileScreen extends StatefulWidget {
  final String roomId;
  final int currentMicCount;
  final RoomSocketService socketService;

  const RoomProfileScreen({
    super.key,
    required this.roomId,
    required this.currentMicCount,
    required this.socketService,
  });

  @override
  State<RoomProfileScreen> createState() => _RoomProfileScreenState();
}

class _RoomProfileScreenState extends State<RoomProfileScreen> {
  static const Color _background = Color(0xFF16003E);

  static const Color _purple = Color(0xFF9C48F5);

  static const Color _cardTop = Color(0xFF6E35AE);

  static const Color _cardMiddle = Color(0xFF4A2185);

  static const Color _cardBottom = Color(0xFF201057);

  late int _micCount;

  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();

    _micCount = _normalizeMicCount(
      widget.currentMicCount,
    );
  }

  int _normalizeMicCount(int count) {
    if (count < 1) {
      return 1;
    }

    if (count > 25) {
      return 25;
    }

    return count;
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  18,
                  10,
                  18,
                  24,
                ),
                child: _buildProfileCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        22,
        16,
        12,
        4,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 63,
              height: 63,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: Colors.white.withValues(
                    alpha: .12,
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Image.asset(
                  'assets/users/profile.png',
                  width: 63,
                  height: 63,
                  fit: BoxFit.cover,
                  errorBuilder: (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return Container(
                      color: const Color(0xFF39205F),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Room Profile',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Row(
                  children: [
                    Text(
                      'Room ID: ${widget.roomId}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white.withValues(
                          alpha: .42,
                        ),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF64F5B5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(
              Icons.refresh_rounded,
              color: Colors.white.withValues(
                alpha: .38,
              ),
              size: 29,
            ),
          ),

          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white.withValues(
                alpha: .38,
              ),
              size: 31,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // MAIN CARD
  // ------------------------------------------------------------

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        21,
        22,
        21,
        24,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: .20,
          ),
        ),
        gradient: const LinearGradient(
          colors: [
            _cardTop,
            _cardMiddle,
            _cardBottom,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: .25,
            ),
            blurRadius: 20,
            offset: const Offset(
              0,
              7,
            ),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -100,
            top: 170,
            child: Container(
              width: 290,
              height: 290,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF8A50D7).withValues(
                    alpha: .12,
                  ),
                  width: 40,
                ),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRoomIdentity(),

              const SizedBox(height: 28),

              _buildTabs(),

              const SizedBox(height: 28),

              AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 180,
                ),
                child: _buildSelectedTab(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ROOM IDENTITY
  // ------------------------------------------------------------

  Widget _buildRoomIdentity() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 105,
          height: 105,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFFC54B),
                Color(0xFF9D4CFF),
              ],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: Image.asset(
              'assets/users/profile.png',
              width: 105,
              height: 105,
              fit: BoxFit.cover,
              errorBuilder: (
                  context,
                  error,
                  stackTrace,
                  ) {
                return Container(
                  color: const Color(0xFF36195D),
                  child: const Icon(
                    Icons.meeting_room_rounded,
                    color: Colors.white,
                    size: 52,
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(width: 18),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Junaya Voice Room',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'Room ID: ${widget.roomId}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: const Color(0xFFD7BAFF),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 7),

              Row(
                children: [
                  const Icon(
                    Icons.mic_rounded,
                    color: Color(0xFFFFC857),
                    size: 17,
                  ),

                  const SizedBox(width: 5),

                  Text(
                    '$_micCount Seats',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFE7D7FF),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 4),

        IconButton(
          onPressed: () {
            setState(() {});
          },
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.refresh_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // TABS
  // ------------------------------------------------------------

  Widget _buildTabs() {
    return Row(
      children: [
        Expanded(
          child: _profileTab(
            title: 'Profile',
            index: 0,
          ),
        ),

        Expanded(
          child: _profileTab(
            title: 'Member',
            index: 1,
          ),
        ),

        Expanded(
          child: _profileTab(
            title: 'Activity',
            index: 2,
          ),
        ),
      ],
    );
  }

  Widget _profileTab({
    required String title,
    required int index,
  }) {
    final active = _selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: active
                  ? Colors.white
                  : const Color(0xFFE0C9FF),
              fontSize: 17,
              fontWeight: active
                  ? FontWeight.w700
                  : FontWeight.w400,
            ),
          ),

          const SizedBox(height: 8),

          AnimatedContainer(
            duration: const Duration(
              milliseconds: 180,
            ),
            width: active ? 26 : 0,
            height: 4,
            decoration: BoxDecoration(
              color: _purple,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

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

  // ------------------------------------------------------------
  // PROFILE TAB
  // ------------------------------------------------------------

  Widget _buildProfileTab() {
    return Column(
      key: const ValueKey('profile'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          'Announcement',
        ),

        const SizedBox(height: 10),

        Text(
          'Welcome to join my party!',
          style: GoogleFonts.poppins(
            color: const Color(0xFFE6D6FF),
            fontSize: 15.5,
            height: 1.45,
          ),
        ),

        const SizedBox(height: 32),

        _sectionTitle(
          'Country',
        ),

        const SizedBox(height: 12),

        _buildCountry(),

        const SizedBox(height: 32),

        _sectionTitle(
          'Level',
        ),

        const SizedBox(height: 14),

        _buildLevel(),

        const SizedBox(height: 36),

        _buildRoomSettingsInfo(),

        const SizedBox(height: 30),

        _buildBottomActions(),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // ------------------------------------------------------------
  // COUNTRY
  // ------------------------------------------------------------

  Widget _buildCountry() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: .18,
          ),
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF5E2AA5),
            Color(0xFF3B176D),
          ],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPakistanFlag(),

          const SizedBox(width: 12),

          Text(
            'Pakistan',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPakistanFlag() {
    return Container(
      width: 42,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: .25,
            ),
            blurRadius: 5,
            offset: const Offset(
              0,
              2,
            ),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Stack(
          children: [
            Container(
              color: const Color(0xFF01411C),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 10,
                color: Colors.white,
              ),
            ),

            Positioned(
              left: 19,
              top: 6,
              child: Container(
                width: 13,
                height: 13,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Transform.translate(
                  offset: const Offset(
                    4,
                    -2,
                  ),
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: const BoxDecoration(
                      color: Color(0xFF01411C),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),

            const Positioned(
              left: 29,
              top: 7,
              child: Icon(
                Icons.star,
                size: 7,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // LEVEL
  // ------------------------------------------------------------

  Widget _buildLevel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'LV',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFB55CFA),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  TextSpan(
                    text: ' 1',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            GestureDetector(
              onTap: _showRoomRules,
              child: Row(
                children: [
                  Text(
                    'Rules',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(width: 6),

                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: 0,
            minHeight: 13,
            color: _purple,
            backgroundColor: const Color(0xFFD5B6FF),
          ),
        ),

        const SizedBox(height: 9),

        Text(
          'To upgrade: 0/100',
          style: GoogleFonts.poppins(
            color: const Color(0xFFDCC7F8),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // ROOM SETTINGS INFO
  // ------------------------------------------------------------

  Widget _buildRoomSettingsInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: .055,
        ),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: .10,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _purple.withValues(
                alpha: .14,
              ),
            ),
            child: const Icon(
              Icons.mic_rounded,
              color: Color(0xFFD8B5FF),
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mic Seats',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '$_micCount of 25 seats configured',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),

          Text(
            '$_micCount/25',
            style: GoogleFonts.poppins(
              color: const Color(0xFFFFD76A),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BOTTOM ACTIONS
  // ------------------------------------------------------------

  Widget _buildBottomActions() {
    return Row(
      children: [
        Expanded(
          child: _bigButton(
            icon: Icons.rocket_launch_outlined,
            label: 'Top',
            colors: const [
              Color(0xFF983DEC),
              Color(0xFF9C44E7),
            ],
            onTap: _showTopUsers,
          ),
        ),

        const SizedBox(width: 18),

        Expanded(
          child: _bigButton(
            icon: Icons.settings_rounded,
            label: 'Setting',
            colors: const [
              Color(0xFF8B62DD),
              Color(0xFF9E74E3),
            ],
            onTap: _openRoomSettings,
          ),
        ),
      ],
    );
  }

  Widget _bigButton({
    required IconData icon,
    required String label,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 62,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(
                alpha: .18,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 27,
            ),

            const SizedBox(width: 9),

            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // MEMBER TAB
  // ------------------------------------------------------------

  Widget _buildMemberTab() {
    return Column(
      key: const ValueKey('member'),
      children: [
        _emptyTab(
          'Room members will appear here.',
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // ACTIVITY TAB
  // ------------------------------------------------------------

  Widget _buildActivityTab() {
    return Column(
      key: const ValueKey('activity'),
      children: [
        _emptyTab(
          'Room activity will appear here.',
        ),
      ],
    );
  }

  Widget _emptyTab(String text) {
    return SizedBox(
      height: 250,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white54,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // ROOM SETTINGS
  // ------------------------------------------------------------

  Future<void> _openRoomSettings() async {
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) {
          return RoomSettingsScreen(
            roomId: widget.roomId,
            currentMicCount: _micCount,
            socketService: widget.socketService,
            onMicCountChanged: (count) {
              if (!mounted) {
                return;
              }

              setState(() {
                _micCount = _normalizeMicCount(
                  count,
                );
              });
            },
          );
        },
      ),
    );

    if (!mounted) {
      return;
    }

    if (result != null) {
      setState(() {
        _micCount = _normalizeMicCount(
          result,
        );
      });

      // Return the new count to RoomScreen.
      Navigator.pop(
        context,
        _micCount,
      );
    }
  }

  // ------------------------------------------------------------
  // TOP USERS
  // ------------------------------------------------------------

  void _showTopUsers() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              18,
              14,
              18,
              22,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF160633),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(26),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _sheetHandle(),

                const SizedBox(height: 16),

                Text(
                  'Top Users',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 18),

                _rankingRow(
                  level: '1',
                  title: 'Golden Circle',
                  icon: '👑',
                ),

                _rankingRow(
                  level: '2',
                  title: 'Metal Circle',
                  icon: '♛',
                ),

                _rankingRow(
                  level: '3',
                  title: 'Silver Circle',
                  icon: '♔',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _rankingRow({
    required String level,
    required String title,
    required String icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 9,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: .045,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: .07,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF41206D),
            ),
            alignment: Alignment.center,
            child: Text(
              level,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(width: 11),

          Text(
            icon,
            style: const TextStyle(
              fontSize: 23,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // RULES
  // ------------------------------------------------------------

  void _showRoomRules() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              20,
              14,
              20,
              22,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF160633),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(26),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _sheetHandle(),

                const SizedBox(height: 17),

                Text(
                  'Room Rules',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 16),

                _ruleItem(
                  Icons.mic_none_rounded,
                  'Respect everyone in the room.',
                ),

                _ruleItem(
                  Icons.block_rounded,
                  'No abusive or offensive behavior.',
                ),

                _ruleItem(
                  Icons.people_outline_rounded,
                  'Follow the room owner instructions.',
                ),

                _ruleItem(
                  Icons.favorite_border_rounded,
                  'Keep the room friendly.',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _ruleItem(
      IconData icon,
      String text,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFD4A6FF),
            size: 20,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // SHEET HANDLE
  // ------------------------------------------------------------

  Widget _sheetHandle() {
    return Container(
      width: 42,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}