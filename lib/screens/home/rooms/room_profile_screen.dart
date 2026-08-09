import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'room_settings_screen.dart';

class RoomProfileScreen extends StatefulWidget {
  const RoomProfileScreen({super.key});

  @override
  State<RoomProfileScreen> createState() => _RoomProfileScreenState();
}

class _RoomProfileScreenState extends State<RoomProfileScreen> {
  static const Color _bg = Color(0xFF16003E);
  static const Color _purple = Color(0xFF9C48F5);
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 22),
                child: _buildProfileCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 18, 18, 3),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.asset(
                'assets/users/profile.png',
                width: 63,
                height: 63,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 63,
                  height: 63,
                  color: const Color(0xFF39205F),
                  child: const Icon(Icons.person, color: Colors.white),
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
                  '87012534',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(.37),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'ID:87012534',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(.36),
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Transform.rotate(
                      angle: .78,
                      child: Container(
                        width: 21,
                        height: 21,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Icon(
                          Icons.diamond_outlined,
                          color: Colors.white24,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() {}),
            icon: Icon(
              Icons.refresh_rounded,
              color: Colors.white.withOpacity(.35),
              size: 34,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.keyboard_arrow_up_rounded,
              color: Colors.white.withOpacity(.35),
              size: 34,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(.20)),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6E35AE),
            Color(0xFF4A2185),
            Color(0xFF201057),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.22),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -90,
            top: 160,
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF8A50D7).withOpacity(.13),
                  width: 38,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/users/profile.png',
                      width: 105,
                      height: 105,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 105,
                        height: 105,
                        color: const Color(0xFF36195D),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 55,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '87012534',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          'Follower:  0',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFD7BAFF),
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() {}),
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 37,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _buildTabs(),
              const SizedBox(height: 28),
              if (_tab == 0) _buildProfileTab(),
              if (_tab == 1) _emptyTab('No members yet'),
              if (_tab == 2) _emptyTab('No recent activity'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        _profileTab('Profile', 0),
        const SizedBox(width: 30),
        _profileTab('Member', 1),
        const SizedBox(width: 30),
        _profileTab('Activity', 2),
      ],
    );
  }

  Widget _profileTab(String title, int index) {
    final active = _tab == index;
    return GestureDetector(
      onTap: () => setState(() => _tab = index),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: active ? Colors.white : const Color(0xFFE0C9FF),
              fontSize: 19,
              fontWeight: active ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: active ? 25 : 0,
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

  Widget _buildProfileTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Announcement',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Welcome to join my party!',
          style: GoogleFonts.poppins(
            color: const Color(0xFFE6D6FF),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 34),
        Text(
          'Country',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              width: 40,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Text('🇵🇰', style: TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 10),
            Text(
              'Pakistan',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),
        Text(
          'Level',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 15),
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
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    'Rules',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 18,
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
            minHeight: 14,
            color: _purple,
            backgroundColor: const Color(0xFFD5B6FF),
          ),
        ),
        const SizedBox(height: 9),
        Text(
          'To upgrade： 0/100',
          style: GoogleFonts.poppins(
            color: const Color(0xFFDCC7F8),
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 50),
        Row(
          children: [
            Expanded(
              child: _bigButton(
                icon: Icons.rocket_launch_outlined,
                label: 'Top',
                onTap: () {},
                colors: const [Color(0xFF983DEC), Color(0xFF9C44E7)],
              ),
            ),
            const SizedBox(width: 42),
            Expanded(
              child: _bigButton(
                icon: Icons.hexagon_outlined,
                label: 'Setting',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RoomSettingsScreen(),
                    ),
                  );
                },
                colors: const [Color(0xFF8B62DD), Color(0xFF9E74E3)],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _bigButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required List<Color> colors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 63,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 29),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyTab(String text) {
    return SizedBox(
      height: 480,
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.white54,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
