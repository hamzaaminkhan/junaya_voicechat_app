import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:junaya_voicechat_app/routes/app_routes.dart';
import 'package:junaya_voicechat_app/screens/home/profile/edit_profile_details_screen.dart';
import 'package:junaya_voicechat_app/screens/home/profile/sections/vip_purchase_screen.dart';
import 'package:junaya_voicechat_app/services/backend_auth_service.dart';
import 'package:junaya_voicechat_app/widgets/space_background.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const ProfileScreen({super.key, this.onBack});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _profile;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final profile = await BackendAuthService.instance.getProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = error.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  void _handleBack(BuildContext context) {
    if (widget.onBack != null) {
      widget.onBack!();
      return;
    }

    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoutes.main);
    }
  }

  Future<void> _openEditor() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileDetailsScreen(initialProfile: _profile),
      ),
    );

    if (!mounted) return;
    if (changed == true) {
      await _loadProfile();
    }
  }

  String _value(String key, [String fallback = '']) {
    final value = _profile?[key];
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  int get _vipLevel => int.tryParse(_value('vipLevel', '0')) ?? 0;

  String _formatNumber(String raw) {
    final clean = raw.replaceAll(',', '').trim();
    final number = BigInt.tryParse(clean);
    if (number == null) return raw;

    final digits = number.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  ImageProvider _avatarProvider() {
    final avatarUrl = _value('avatarUrl');
    if (avatarUrl.isNotEmpty) {
      return NetworkImage(avatarUrl);
    }
    return const AssetImage('assets/users/profile.png');
  }

  Future<void> _copyJunayaId() async {
    final id = _value('junayaId', _value('id'));
    if (id.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: id));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('User ID copied')));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.onBack == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && widget.onBack != null) {
          widget.onBack!();
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
                    Colors.transparent,
                    Colors.transparent,
                    Colors.transparent,
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
                          onPressed: _profile == null ? null : _openEditor,
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: _buildBody()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading && _profile == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.purpleAccent),
      );
    }

    if (_error != null && _profile == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, color: Colors.amber, size: 42),
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: _loadProfile,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProfile,
      color: Colors.purpleAccent,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          children: [
            const SizedBox(height: 2),
            _profileHeader(),
            const SizedBox(height: 12),
            _statsSection(),
            const SizedBox(height: 12),
            _editButton(),
            const SizedBox(height: 14),
            _menuList(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _profileHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final veryNarrow = constraints.maxWidth < 350;
        final avatarRadius = veryNarrow ? 42.0 : 47.0;
        final username = _value('username', 'Junaya User');
        final userId = _value('junayaId', _value('id', '—'));
        final coins = _formatNumber(_value('coins', '0'));
        final diamonds = _formatNumber(_value('diamonds', '0'));

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
                  backgroundColor: const Color(0xFF21152E),
                  backgroundImage: _avatarProvider(),
                ),
              ),
              SizedBox(width: veryNarrow ? 10 : 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: veryNarrow ? 17 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _smallBadge(
                          Icons.workspace_premium,
                          '$_vipLevel',
                          Colors.orange,
                        ),
                        _smallBadge(Icons.diamond, diamonds, Colors.pinkAccent),
                      ],
                    ),
                    const SizedBox(height: 5),
                    InkWell(
                      onTap: _copyJunayaId,
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                'ID: $userId',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: veryNarrow ? 10.5 : 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.copy,
                              color: Colors.white70,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: _headerMoneyCard(
                            Icons.monetization_on,
                            coins,
                            'Coins',
                            Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _headerMoneyCard(
                            Icons.diamond,
                            diamonds,
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
          _statItem(Icons.person, '0', 'Friends'),
          _statItem(Icons.person_add, '0', 'Following'),
          _statItem(Icons.groups, '0', 'Followers'),
          _statItem(Icons.remove_red_eye, '0', 'Visitors'),
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

  Widget _editButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.purpleAccent),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _profile == null ? null : _openEditor,
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
          Icons.workspace_premium,
          'VIP Purchase',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const VipPurchaseScreen()),
          ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.purpleAccent.withValues(alpha: .45)),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 1),
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
