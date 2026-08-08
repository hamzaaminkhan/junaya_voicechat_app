import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/space_background.dart';

class EditProfileDetailsScreen extends StatefulWidget {
  final String? backgroundAsset;

  const EditProfileDetailsScreen({
    super.key,
    this.backgroundAsset,
  });

  @override
  State<EditProfileDetailsScreen> createState() =>
      _EditProfileDetailsScreenState();
}

class _EditProfileDetailsScreenState
    extends State<EditProfileDetailsScreen> {
  String username = 'MR.ALEX';
  String gender = 'Male';
  String birthday = '2002-01-20';
  String country = 'Pakistan';
  String province = 'Punjab';
  String height = 'Click to set';
  String weight = '64 kg';
  String job = 'Click to set';
  String signature = 'Click to set';

  static const Color gold = Color(0xFFFFC94D);
  static const Color purple = Color(0xFFB25CFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _buildBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    4,
                    16,
                    28,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileHeader(),
                      const SizedBox(height: 14),
                      _buildPhotoAction(),
                      const SizedBox(height: 14),
                      _buildProfileNoticeCard(),
                      const SizedBox(height: 12),
                      _buildVoiceCard(),
                      const SizedBox(height: 12),
                      _buildDetailsCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground({
    required Widget child,
  }) {
    final asset = widget.backgroundAsset?.trim();

    if (asset != null && asset.isNotEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            asset,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return SpaceBackground(child: child);
            },
          ),
          Container(
            color: Colors.black.withOpacity(.18),
          ),
          child,
        ],
      );
    }

    return SpaceBackground(
      child: child,
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        8,
        4,
        12,
        4,
      ),
      child: SizedBox(
        height: 46,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            Expanded(
              child: Text(
                'Edit Profile',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 78,
                height: 78,
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: purple.withOpacity(.85),
                    width: 2,
                  ),
                ),
                child: const CircleAvatar(
                  backgroundColor: Color(0xFF20152D),
                  child: Icon(
                    Icons.person_rounded,
                    color: Colors.white70,
                    size: 42,
                  ),
                ),
              ),
              Positioned(
                right: -2,
                bottom: 2,
                child: GestureDetector(
                  onTap: _showPhotoMessage,
                  child: Container(
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: gold,
                      border: Border.all(
                        color: const Color(0xFF180A20),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Color(0xFF180A20),
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile photo',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Upload up to 6 photos. Review may take up to 72 hours.',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 11.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoAction() {
    return _ActionButton(
      icon: Icons.add_a_photo_outlined,
      label: 'Add profile photo',
      color: gold,
      onTap: _showPhotoMessage,
    );
  }

  Widget _buildProfileNoticeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.info_outline_rounded,
            title: 'Profile photo rules',
          ),
          const SizedBox(height: 11),
          _ruleRow(
            'VIP 6–10 and Emperor users can set a GIF avatar under 5MB.',
          ),
          const SizedBox(height: 8),
          _ruleRow(
            'After changing your avatar, wait 48 hours before editing it again.',
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: gold.withOpacity(.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: gold.withOpacity(.14),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.shield_outlined,
                  color: gold,
                  size: 18,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Avoid inappropriate content and personal information such as phone numbers, addresses, account numbers, or children’s photos. Content may be reviewed and removed if it violates policy.',
                    style: GoogleFonts.poppins(
                      color: Colors.white60,
                      fontSize: 10.8,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ruleRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: purple,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 11.3,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.graphic_eq_rounded,
            title: 'Voice card',
          ),
          const SizedBox(height: 11),
          _ActionButton(
            icon: Icons.mic_none_rounded,
            label: 'Add voice card',
            color: const Color(0xFFA8E86F),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Voice recording will be connected next.',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _ProfileTile(
            icon: Icons.person_outline_rounded,
            label: 'Username',
            value: username,
            subtitle: 'Can only be changed once',
            onTap: () {
              _editTextValue(
                title: 'Username',
                currentValue: username,
                onSaved: (value) {
                  username = value;
                },
              );
            },
          ),
          _ProfileTile(
            icon: Icons.male_rounded,
            label: 'Gender',
            value: gender,
            onTap: _selectGender,
          ),
          _ProfileTile(
            icon: Icons.calendar_today_outlined,
            label: 'Birthday',
            value: birthday,
            onTap: _selectBirthday,
          ),
          _ProfileTile(
            icon: Icons.flag_outlined,
            label: 'Country',
            value: country,
            onTap: () {
              _editTextValue(
                title: 'Country',
                currentValue: country,
                onSaved: (value) {
                  country = value;
                },
              );
            },
          ),
          _ProfileTile(
            icon: Icons.location_city_outlined,
            label: 'Province',
            value: province,
            onTap: () {
              _editTextValue(
                title: 'Province',
                currentValue: province,
                onSaved: (value) {
                  province = value;
                },
              );
            },
          ),
          _ProfileTile(
            icon: Icons.height_rounded,
            label: 'Height',
            value: height,
            onTap: () {
              _editTextValue(
                title: 'Height',
                currentValue: height,
                hintText: 'Example: 175 cm',
                onSaved: (value) {
                  height = value;
                },
              );
            },
          ),
          _ProfileTile(
            icon: Icons.monitor_weight_outlined,
            label: 'Weight',
            value: weight,
            onTap: () {
              _editTextValue(
                title: 'Weight',
                currentValue: weight,
                hintText: 'Example: 64 kg',
                onSaved: (value) {
                  weight = value;
                },
              );
            },
          ),
          _ProfileTile(
            icon: Icons.work_outline_rounded,
            label: 'Job',
            value: job,
            onTap: () {
              _editTextValue(
                title: 'Job',
                currentValue: job,
                onSaved: (value) {
                  job = value;
                },
              );
            },
          ),
          _ProfileTile(
            icon: Icons.edit_note_rounded,
            label: 'Signature',
            value: signature,
            onTap: () {
              _editTextValue(
                title: 'Signature',
                currentValue: signature,
                maxLines: 3,
                onSaved: (value) {
                  signature = value;
                },
              );
            },
          ),
          _ProfileTile(
            icon: Icons.workspace_premium_outlined,
            label: 'Title',
            value: 'Manage',
            showBottomBorder: false,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Title management will be added next.',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: purple.withOpacity(.10),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            color: purple,
            size: 18,
          ),
        ),
        const SizedBox(width: 9),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.black.withOpacity(.14),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Colors.white.withOpacity(.08),
      ),
    );
  }

  void _showPhotoMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Profile image picker will be connected next.',
        ),
      ),
    );
  }

  Future<void> _selectGender() async {
    final String? result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF0E0714),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              14,
              16,
              16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Select gender',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _genderOption(
                  icon: Icons.male_rounded,
                  label: 'Male',
                ),
                _genderOption(
                  icon: Icons.female_rounded,
                  label: 'Female',
                ),
                _genderOption(
                  icon: Icons.person_outline_rounded,
                  label: 'Prefer not to say',
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        gender = result;
      });
    }
  }

  Widget _genderOption({
    required IconData icon,
    required String label,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      leading: Icon(
        icon,
        color: purple,
        size: 21,
      ),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 13,
        ),
      ),
      onTap: () => Navigator.pop(
        context,
        label,
      ),
    );
  }

  Future<void> _selectBirthday() async {
    final DateTime initialDate =
        DateTime.tryParse(birthday) ??
            DateTime(2002, 1, 20);

    final DateTime? selectedDate =
    await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: purple,
              surface: Color(0xFF120A18),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        birthday =
        '${selectedDate.year.toString().padLeft(4, '0')}-'
            '${selectedDate.month.toString().padLeft(2, '0')}-'
            '${selectedDate.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _editTextValue({
    required String title,
    required String currentValue,
    required ValueChanged<String> onSaved,
    String? hintText,
    int maxLines = 1,
  }) async {
    final bool isEmptyValue =
        currentValue == 'Click to set';

    final TextEditingController controller =
    TextEditingController(
      text: isEmptyValue ? '' : currentValue,
    );

    final String? result =
    await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF120A18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            'Edit $title',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: controller,
            maxLines: maxLines,
            autofocus: true,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 13,
            ),
            decoration: InputDecoration(
              hintText: hintText ?? 'Enter $title',
              hintStyle: GoogleFonts.poppins(
                color: Colors.white38,
                fontSize: 12,
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(.04),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(12),
                borderSide: BorderSide(
                  color:
                  Colors.white.withOpacity(.10),
                ),
              ),
              focusedBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: gold,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  controller.text.trim(),
                );
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: gold,
                ),
              ),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (result != null &&
        result.trim().isNotEmpty) {
      setState(() {
        onSaved(result.trim());
      });
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.10),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: color.withOpacity(.24),
            ),
          ),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 19,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(.86),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final VoidCallback onTap;
  final bool showBottomBorder;

  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.subtitle,
    this.showBottomBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool unset = value == 'Click to set';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: subtitle == null ? 54 : 62,
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            border: showBottomBorder
                ? Border(
              bottom: BorderSide(
                color:
                Colors.white.withOpacity(.065),
              ),
            )
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFB25CFF)
                      .withOpacity(.08),
                  borderRadius:
                  BorderRadius.circular(9),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFB25CFF),
                  size: 17,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12.7,
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style:
                        GoogleFonts.poppins(
                          color: Colors.white38,
                          fontSize: 9.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(
                    color: unset
                        ? Colors.white38
                        : Colors.white70,
                    fontSize: 11.5,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white30,
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
