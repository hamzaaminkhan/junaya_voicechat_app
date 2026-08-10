import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:junaya_voicechat_app/routes/app_routes.dart';
import 'package:junaya_voicechat_app/screens/home/profile/edit_profile_screen.dart';
import 'package:junaya_voicechat_app/screens/home/profile/edit_profile_details_screen.dart';
import 'package:junaya_voicechat_app/widgets/space_background.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const ProfileScreen({super.key, this.onBack});

  void _handleBack(BuildContext context) {
    if (onBack != null) {
      onBack!();
      return;
    }

    final navigator = Navigator.of(context);

    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoutes.main);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: onBack == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && onBack != null) {
          onBack!();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SpaceBackground(
          child: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xC7080313),
                    Color(0xB817052A),
                    Color(0xC7080313),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () => _handleBack(context),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit_square,
                            color: Colors.white,
                            size: 27,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EditProfileScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 2),
                          _profileHeader(),
                          const SizedBox(height: 12),
                          _statsSection(),
                          const SizedBox(height: 12),
                          _editButton(context),
                          const SizedBox(height: 14),
                          _menuList(context),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // PROFILE HEADER
  Widget _profileHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool veryNarrow = constraints.maxWidth < 350;

        final double avatarRadius = veryNarrow ? 42 : 47;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: veryNarrow ? 12 : 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.purpleAccent, width: 2.5),
                ),
                child: CircleAvatar(
                  radius: avatarRadius,
                  backgroundImage: const AssetImage('assets/users/profile.png'),
                ),
              ),

              SizedBox(width: veryNarrow ? 10 : 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'MR. ALEX',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: veryNarrow ? 17 : 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.male,
                          color: Colors.blueAccent,
                          size: veryNarrow ? 18 : 20,
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _smallBadge(
                          Icons.workspace_premium,
                          '0',
                          Colors.orange,
                        ),
                        _smallBadge(Icons.diamond, '0', Colors.pinkAccent),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'ID :137804327',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: veryNarrow ? 10.5 : 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.copy, color: Colors.white70, size: 14),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Expanded(
                          child: _headerMoneyCard(
                            Icons.monetization_on,
                            '128,540',
                            'Coins',
                            Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _headerMoneyCard(
                            Icons.diamond,
                            '12,900',
                            'Diamonds',
                            Colors.purpleAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _smallBadge(IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // STATS SECTION
  Widget _statsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.purpleAccent.withValues(alpha: .5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(Icons.person, '124', 'Friends'),
          _statItem(Icons.person_add, '124', 'Following'),
          _statItem(Icons.groups, '124', 'Followers'),
          _statItem(Icons.remove_red_eye, '124', 'Visitors'),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String number, String title) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.amber, size: 21),
          const SizedBox(height: 3),
          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  // EDIT PROFILE BUTTON
  Widget _editButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.purpleAccent),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditProfileDetailsScreen()),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit, color: Colors.amber, size: 20),
            SizedBox(width: 8),
            Text(
              'Edit Profile',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  // MENU LIST
  Widget _menuList(BuildContext context) {
    return Column(
      children: [
        _menuTile(
          Icons.account_balance_wallet,
          'Wallet',
          onTap: () => Navigator.pushNamed(context, AppRoutes.wallet),
        ),
        _menuTile(
          Icons.shopping_bag,
          'Store',
          onTap: () => Navigator.pushNamed(context, AppRoutes.store),
        ),
        _menuTile(
          Icons.person_add,
          'Invite Friend',
          onTap: () => Navigator.pushNamed(context, AppRoutes.inviteFriends),
        ),
        _menuTile(
          Icons.handshake,
          'Join Agency',
          onTap: () => Navigator.pushNamed(context, AppRoutes.joinAgency),
        ),
        _menuTile(
          Icons.bar_chart,
          'Level',
          onTap: () => Navigator.pushNamed(context, AppRoutes.level),
        ),
        _menuTile(
          Icons.emoji_events,
          'Medal',
          onTap: () => Navigator.pushNamed(context, AppRoutes.medal),
        ),
        _menuTile(
          Icons.shield,
          'CP Zone',
          onTap: () => Navigator.pushNamed(context, AppRoutes.cpZone),
        ),
        _menuTile(
          Icons.settings,
          'Setting',
          onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
        ),
        _menuTile(
          Icons.language,
          'Language',
          onTap: () => Navigator.pushNamed(context, AppRoutes.language),
        ),
        _menuTile(
          Icons.headset_mic,
          'Help Center',
          onTap: () => Navigator.pushNamed(context, AppRoutes.helpCenter),
        ),
      ],
    );
  }

  Widget _menuTile(IconData icon, String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: Material(
        color: const Color(0xff12071F),

        // ONLY use shape here.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.purpleAccent.withValues(alpha: .45)),
        ),

        clipBehavior: Clip.antiAlias,

        child: ListTile(
          dense: true,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 1,
          ),

          leading: Icon(icon, color: Colors.amber, size: 21),

          title: Text(
            title,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
          ),

          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white54,
            size: 15,
          ),

          onTap: onTap,
        ),
      ),
    );
  }

  Widget _headerMoneyCard(
    IconData icon,
    String value,
    String title,
    Color color,
  ) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .28),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: Colors.purpleAccent.withValues(alpha: .45),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 3),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 7.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
