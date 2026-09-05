import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:junaya_voicechat_app/rooms/room_socket_service.dart';
import 'package:junaya_voicechat_app/rooms/widgets/room_wallpaper_picker.dart';

class RoomSettingsScreen extends StatefulWidget {
  final String roomId;

  /// Current number of mic seats in the room.
  final int currentMicCount;

  final RoomSocketService socketService;

  /// Called immediately when the user selects a new mic count.
  final ValueChanged<int>? onMicCountChanged;

  const RoomSettingsScreen({
    super.key,
    required this.roomId,
    required this.currentMicCount,
    required this.socketService,
    this.onMicCountChanged,
  });

  @override
  State<RoomSettingsScreen> createState() {
    return _RoomSettingsScreenState();
  }
}

class _RoomSettingsScreenState
    extends State<RoomSettingsScreen> {
  // ------------------------------------------------------------
  // COLORS
  // ------------------------------------------------------------

  static const Color _pageBg =
  Color(0xFF090020);

  static const Color _bg =
  Color(0xFF12002E);

  static const Color _purple =
  Color(0xFFA84CF4);

  static const Color _border =
  Color(0xFF4A1466);

  static const Color _tileBg =
  Color(0xFF160235);

  // ------------------------------------------------------------
  // ROOM SETTINGS
  // ------------------------------------------------------------

  late int micCount;

  String roomName = '87012534';

  String announcement =
      'Welcome to join my party!';

  int diceCount = 1;

  bool sendEmojis = false;

  bool adminsOpenGames = false;

  bool followersTakeMic = true;

  // ------------------------------------------------------------
  // WALLPAPER
  // ------------------------------------------------------------

  String _selectedWallpaperId = 'mralex';

  // ------------------------------------------------------------
  // INIT
  // ------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    micCount = _normalizeSeatCount(
      widget.currentMicCount,
    );
  }

  // ------------------------------------------------------------
  // SEAT COUNT
  // ------------------------------------------------------------

  int _normalizeSeatCount(int value) {
    if (value < 1) {
      return 1;
    }

    if (value > 25) {
      return 25;
    }

    return value;
  }

  void _changeMicCount(int value) {
    final count = _normalizeSeatCount(value);

    if (count == micCount) {
      return;
    }

    setState(() {
      micCount = count;
    });

    widget.onMicCountChanged?.call(count);

    _message(
      'Room now has $count mic seats.',
    );
  }

  // ------------------------------------------------------------
  // WALLPAPER
  // ------------------------------------------------------------

  void _openWallpaperPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.72,
          child: RoomWallpaperPicker(
            selectedWallpaperId:
            _selectedWallpaperId,
            onWallpaperSelected: (wallpaper) {
              setState(() {
                _selectedWallpaperId =
                    wallpaper.id;
              });

              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  String _wallpaperDisplayName(String id) {
    switch (id) {
      case 'mralex':
        return 'Mr Alex';

      case 'room1':
        return 'Wallpaper 1';

      case 'room2':
        return 'Wallpaper 2';

      case 'room3':
        return 'Wallpaper 3';

      case 'room4':
        return 'Wallpaper 4';

      case 'room5':
        return 'Wallpaper 5';

      case 'room6':
        return 'Wallpaper 6';

      case 'room7':
        return 'Wallpaper 7';

      case 'room8':
        return 'Wallpaper 8';

      default:
        return 'Default';
    }
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 420,
            ),
            child: Container(
              color: _bg,
              child: Column(
                children: [
                  _buildTopBar(),

                  Expanded(
                    child: SingleChildScrollView(
                      physics:
                      const BouncingScrollPhysics(),
                      padding:
                      const EdgeInsets.fromLTRB(
                        16,
                        4,
                        16,
                        24,
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          _buildProfileTitle(),

                          const SizedBox(height: 12),

                          _buildNotice(),

                          const SizedBox(height: 14),

                          _buildRoomNameTile(),

                          const SizedBox(height: 7),

                          _buildAnnouncementTile(),

                          const SizedBox(height: 7),

                          _buildMicCountTile(),

                          const SizedBox(height: 7),

                          _buildWallpaperTile(),

                          const SizedBox(height: 7),

                          _buildThemeTile(),

                          const SizedBox(height: 7),

                          _buildRoomFrameTile(),

                          const SizedBox(height: 18),

                          _buildPasswordTile(),

                          const SizedBox(height: 7),

                          _buildDiceTile(),

                          const SizedBox(height: 7),

                          _buildEmojiSwitch(),

                          const SizedBox(height: 7),

                          _buildGamesSwitch(),

                          const SizedBox(height: 7),

                          _buildFollowersSwitch(),

                          const SizedBox(height: 7),

                          _buildGuestTextTile(),

                          const SizedBox(height: 18),

                          _buildBlockedListTile(),
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

  // ------------------------------------------------------------
  // TOP BAR
  // ------------------------------------------------------------

  Widget _buildTopBar() {
    return SizedBox(
      height: 64,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 12,
            top: 11,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pop(
                    context,
                    micCount,
                  );
                },
                customBorder:
                const CircleBorder(),
                child: Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                    const Color(0xFF2B0A4B),
                    border: Border.all(
                      color:
                      _purple.withValues(
                        alpha: .35,
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding:
                    EdgeInsets.only(left: 2),
                    child: Icon(
                      Icons
                          .arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),

          IgnorePointer(
            child: Text(
              'Setting',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 19,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // PROFILE
  // ------------------------------------------------------------

  Widget _buildProfileTitle() {
    return Row(
      children: [
        Text(
          'Profile',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight:
            FontWeight.w500,
          ),
        ),

        const Spacer(),

        ClipRRect(
          borderRadius:
          BorderRadius.circular(10),
          child: Image.asset(
            'assets/users/profile.png',
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder:
                (_, _, _) {
              return Container(
                width: 48,
                height: 48,
                color:
                const Color(0xFF3A185F),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // NOTICE
  // ------------------------------------------------------------

  Widget _buildNotice() {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.fromLTRB(
        13,
        12,
        13,
        12,
      ),
      decoration: BoxDecoration(
        color:
        const Color(0xFF140039)
            .withValues(alpha: .38),
        borderRadius:
        BorderRadius.circular(10),
        border: Border.all(
          color: _border,
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Padding(
            padding:
            EdgeInsets.only(top: 1),
            child: Icon(
              Icons.info_rounded,
              color: Color(0xFFB267FF),
              size: 19,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              'Never upload inappropriate content that violates our policies or personal information (phone number, account number, address, kid picture, etc.), all contents will be reviewed by AI and human team. Once illegal content is detected, it may result in content deletion/profile reset/account suspension.',
              style: GoogleFonts.poppins(
                color:
                const Color(0xFFB892CF),
                fontSize: 9.8,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ROOM NAME
  // ------------------------------------------------------------

  Widget _buildRoomNameTile() {
    return _tile(
      icon: Icons.home_rounded,
      title: 'Room Name',
      value: roomName,
      onTap: () {
        _editText(
          title: 'Room Name',
          initialValue: roomName,
          onSaved: (value) {
            setState(() {
              roomName = value;
            });
          },
        );
      },
    );
  }

  // ------------------------------------------------------------
  // ANNOUNCEMENT
  // ------------------------------------------------------------

  Widget _buildAnnouncementTile() {
    return _tile(
      icon: Icons.campaign_rounded,
      title: 'Announcement',
      value: announcement,
      valueMaxWidth: 160,
      onTap: () {
        _editText(
          title: 'Announcement',
          initialValue: announcement,
          onSaved: (value) {
            setState(() {
              announcement = value;
            });
          },
        );
      },
    );
  }

  // ------------------------------------------------------------
  // MIC COUNT
  // ------------------------------------------------------------

  Widget _buildMicCountTile() {
    return _tile(
      icon: Icons.mic_rounded,
      title: 'Number of Mic',
      value: '$micCount',
      onTap: () {
        _pickNumber(
          title: 'Number of Mic',
          values: List.generate(
            25,
                (index) => index + 1,
          ),
          selected: micCount,
          onSelected: _changeMicCount,
        );
      },
    );
  }

  // ------------------------------------------------------------
  // WALLPAPER
  // ------------------------------------------------------------

  Widget _buildWallpaperTile() {
    return _tile(
      icon: Icons.wallpaper_rounded,
      title: 'Wallpaper',
      value: _wallpaperDisplayName(
        _selectedWallpaperId,
      ),
      valueMaxWidth: 120,
      onTap: _openWallpaperPicker,
    );
  }

  // ------------------------------------------------------------
  // THEME
  // ------------------------------------------------------------

  Widget _buildThemeTile() {
    return _tile(
      icon: Icons.palette_rounded,
      title: 'Theme',
      onTap: () {
        _message(
          'Theme selector coming soon.',
        );
      },
    );
  }

  // ------------------------------------------------------------
  // ROOM FRAME
  // ------------------------------------------------------------

  Widget _buildRoomFrameTile() {
    return _tile(
      icon: Icons.crop_square_rounded,
      title: 'Room Frame',
      onTap: () {
        _message(
          'Room frame selector coming soon.',
        );
      },
    );
  }

  // ------------------------------------------------------------
  // PASSWORD
  // ------------------------------------------------------------

  Widget _buildPasswordTile() {
    return _tile(
      icon: Icons.lock_rounded,
      title: 'Password',
      onTap: () {
        _editText(
          title: 'Password',
          initialValue: '',
          obscure: true,
          onSaved: (_) {
            _message(
              'Password updated.',
            );
          },
        );
      },
    );
  }

  // ------------------------------------------------------------
  // DICE
  // ------------------------------------------------------------

  Widget _buildDiceTile() {
    return _tile(
      icon: Icons.casino_rounded,
      title: 'Dice Count',
      value: '$diceCount',
      onTap: () {
        _pickNumber(
          title: 'Dice Count',
          values: const [
            1,
            2,
            3,
            4,
            5,
            6,
          ],
          selected: diceCount,
          onSelected: (value) {
            setState(() {
              diceCount = value;
            });
          },
        );
      },
    );
  }

  // ------------------------------------------------------------
  // GUEST TEXT
  // ------------------------------------------------------------

  Widget _buildGuestTextTile() {
    return _tile(
      icon: Icons.text_fields_rounded,
      title: 'Guest send text level',
      onTap: () {
        _message(
          'Guest text level selector coming soon.',
        );
      },
    );
  }

  // ------------------------------------------------------------
  // BLOCKED LIST
  // ------------------------------------------------------------

  Widget _buildBlockedListTile() {
    return _tile(
      icon: Icons.group_rounded,
      title: 'Blocked List',
      onTap: () {
        _message(
          'Blocked list coming soon.',
        );
      },
    );
  }

  // ------------------------------------------------------------
  // SWITCHES
  // ------------------------------------------------------------

  Widget _buildEmojiSwitch() {
    return _switchTile(
      icon:
      Icons.sentiment_satisfied_alt_rounded,
      title:
      'Send emojis to the chatting area',
      value: sendEmojis,
      onChanged: (value) {
        setState(() {
          sendEmojis = value;
        });
      },
    );
  }

  Widget _buildGamesSwitch() {
    return _switchTile(
      icon:
      Icons.sports_esports_rounded,
      title:
      'Only room admins can open games',
      value: adminsOpenGames,
      onChanged: (value) {
        setState(() {
          adminsOpenGames = value;
        });
      },
    );
  }

  Widget _buildFollowersSwitch() {
    return _switchTile(
      icon: Icons.mic_rounded,
      title:
      'Only room followers can take mic',
      value: followersTakeMic,
      onChanged: (value) {
        setState(() {
          followersTakeMic = value;
        });
      },
    );
  }

  // ------------------------------------------------------------
  // STANDARD TILE
  // ------------------------------------------------------------

  Widget _tile({
    required IconData icon,
    required String title,
    String? value,
    double? valueMaxWidth,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(10),
        child: Ink(
          height: 58,
          padding:
          const EdgeInsets.symmetric(
            horizontal: 13,
          ),
          decoration: BoxDecoration(
            color:
            _tileBg.withValues(alpha: .74),
            borderRadius:
            BorderRadius.circular(10),
            border: Border.all(
              color: _border,
            ),
          ),
          child: Row(
            children: [
              _iconBox(icon),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),
              ),

              if (value != null) ...[
                const SizedBox(width: 8),

                ConstrainedBox(
                  constraints:
                  BoxConstraints(
                    maxWidth:
                    valueMaxWidth ?? 105,
                  ),
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    textAlign:
                    TextAlign.right,
                    style:
                    GoogleFonts.poppins(
                      color:
                      const Color(
                        0xFFD5C2E8,
                      ),
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ],

              const SizedBox(width: 7),

              const Icon(
                Icons
                    .arrow_forward_ios_rounded,
                color:
                Color(0xFFC7A8E7),
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SWITCH TILE
  // ------------------------------------------------------------

  Widget _switchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool>
    onChanged,
  }) {
    return Container(
      height: 58,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 13,
      ),
      decoration: BoxDecoration(
        color:
        _tileBg.withValues(alpha: .74),
        borderRadius:
        BorderRadius.circular(10),
        border: Border.all(
          color: _border,
        ),
      ),
      child: Row(
        children: [
          _iconBox(icon),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow:
              TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12.6,
                height: 1.2,
                fontWeight:
                FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 6),

          SizedBox(
            width: 42,
            height: 30,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor:
                Colors.white,
                activeTrackColor:
                _purple,
                inactiveThumbColor:
                Colors.white,
                inactiveTrackColor:
                const Color(0xFF2A0A4C),
                trackOutlineColor:
                WidgetStatePropertyAll(
                  _purple.withValues(
                    alpha: .24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ICON BOX
  // ------------------------------------------------------------

  Widget _iconBox(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(8),
        gradient:
        const LinearGradient(
          colors: [
            Color(0xFF4A116E),
            Color(0xFF28105A),
          ],
        ),
      ),
      child: Icon(
        icon,
        color:
        const Color(0xFFE4A7FF),
        size: 21,
      ),
    );
  }

  // ------------------------------------------------------------
  // TEXT EDITOR
  // ------------------------------------------------------------

  Future<void> _editText({
    required String title,
    required String initialValue,
    required ValueChanged<String>
    onSaved,
    bool obscure = false,
  }) async {
    final controller =
    TextEditingController(
      text: initialValue,
    );

    final result =
    await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
          const Color(0xFF220546),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(16),
          ),
          title: Text(
            title,
            style:
            GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 17,
              fontWeight:
              FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: controller,
            obscureText: obscure,
            autofocus: true,
            style:
            GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 13,
            ),
            decoration:
            InputDecoration(
              filled: true,
              fillColor:
              Colors.black.withValues(
                alpha: .15,
              ),
              contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 11,
              ),
              enabledBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                  10,
                ),
                borderSide:
                BorderSide(
                  color:
                  _purple.withValues(
                    alpha: .4,
                  ),
                ),
              ),
              focusedBorder:
              const OutlineInputBorder(
                borderRadius:
                BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide:
                BorderSide(
                  color: _purple,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child:
              const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  controller.text.trim(),
                );
              },
              child:
              const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (!mounted) {
      return;
    }

    if (result != null &&
        result.isNotEmpty) {
      onSaved(result);
    }
  }

  // ------------------------------------------------------------
  // NUMBER PICKER
  // ------------------------------------------------------------

  Future<void> _pickNumber({
    required String title,
    required List<int> values,
    required int selected,
    required ValueChanged<int>
    onSelected,
  }) async {
    final result =
    await showModalBottomSheet<int>(
      context: context,
      backgroundColor:
      const Color(0xFF210444),
      shape:
      const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(18),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding:
            const EdgeInsets.fromLTRB(
              18,
              16,
              18,
              20,
            ),
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              children: [
                Text(
                  title,
                  style:
                  GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 14),

                if (title ==
                    'Number of Mic') ...[
                  _buildSeatRangeInfo(),

                  const SizedBox(height: 12),
                ],

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                  values.map((value) {
                    final active =
                        value == selected;

                    return ChoiceChip(
                      label:
                      Text('$value'),
                      selected:
                      active,
                      onSelected: (_) {
                        Navigator.pop(
                          sheetContext,
                          value,
                        );
                      },
                      selectedColor:
                      _purple,
                      backgroundColor:
                      const Color(
                        0xFF32105A,
                      ),
                      labelStyle:
                      const TextStyle(
                        color:
                        Colors.white,
                      ),
                      side:
                      BorderSide(
                        color:
                        _purple.withValues(
                          alpha: .35,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted) {
      return;
    }

    if (result != null) {
      onSelected(result);
    }
  }

  // ------------------------------------------------------------
  // SEAT RANGE INFO
  // ------------------------------------------------------------

  Widget _buildSeatRangeInfo() {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color:
        _purple.withValues(alpha: .08),
        borderRadius:
        BorderRadius.circular(10),
        border: Border.all(
          color:
          _purple.withValues(alpha: .20),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.mic_rounded,
            color: Color(0xFFD7A7FF),
            size: 18,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              'Choose between 1 and 25 mic seats.',
              style:
              GoogleFonts.poppins(
                color:
                Colors.white70,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // SNACKBAR
  // ------------------------------------------------------------

  void _message(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            text,
            style:
            GoogleFonts.poppins(
              fontSize: 12.5,
            ),
          ),
          behavior:
          SnackBarBehavior.floating,
          backgroundColor:
          const Color(0xFF32105A),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(12),
          ),
        ),
      );
  }
}