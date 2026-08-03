import 'dart:ui';

import 'package:flutter/material.dart';

class EditProfileDetailsScreen extends StatefulWidget {
  final String? backgroundAsset;

  const EditProfileDetailsScreen({
    super.key,
    this.backgroundAsset,
  });

  @override
  State<EditProfileDetailsScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileDetailsScreen> {
  String username = 'MR.ALEX';
  String gender = 'Male';
  String birthday = '2002-01-20';
  String country = 'Pakistan';
  String province = 'Punjab';
  String height = 'Click to set';
  String weight = '64 kg';
  String job = 'Click to set';
  String signature = 'Click to set';

  static const Color purple = Color(0xff9B5CFF);
  static const Color cardColor = Color(0xff061426);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: _Background(
              assetPath: widget.backgroundAsset,
            ),
          ),

          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.32),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      10,
                      20,
                      35,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPhotoHeader(),

                        const SizedBox(height: 18),

                        _buildAddPhotoButton(),

                        const SizedBox(height: 12),

                        _buildProfileInformationCard(),

                        const SizedBox(height: 16),

                        _buildVoiceCard(),

                        const SizedBox(height: 16),

                        _buildDetailsCard(),
                      ],
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

  Widget _buildTopBar() {
    return SizedBox(
      height: 58,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),

          Positioned(
            left: 6,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile photo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Upload up to 6 photos.\nReview may take 72 hours.',
                style: TextStyle(
                  color: Color(0xffD2CBD8),
                  fontSize: 15,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 20),

        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 112,
              height: 112,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(
                    color: purple.withOpacity(0.65),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff8D898D),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xffEEEEEE),
                  size: 76,
                ),
              ),
            ),

            Positioned(
              right: -3,
              bottom: 5,
              child: GestureDetector(
                onTap: _showPhotoMessage,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xffE6DDF2),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.photo_camera_outlined,
                    color: purple,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddPhotoButton() {
    return InkWell(
      onTap: _showPhotoMessage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.22),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.58),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_camera_outlined,
              color: purple,
              size: 28,
            ),
            SizedBox(width: 12),
            Text(
              'Click to add profile photo',
              style: TextStyle(
                color: Color(0xffE5D6F6),
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInformationCard() {
    return _GlassCard(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle(
              icon: Icons.person_outline_rounded,
              title: 'Profile',
            ),

            const SizedBox(height: 17),

            _buildBullet(
              'VIP 6 to VIP 10 and Emperor can set GIF avatar '
                  '(shall be less than 5MB)',
            ),

            const SizedBox(height: 10),

            _buildBullet(
              'After editing your avatar, you need to wait 48 hours '
                  'before you can edit it again.',
            ),

            const SizedBox(height: 17),

            Divider(
              color: purple.withOpacity(0.85),
              thickness: 1,
            ),

            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: const Color(0xff7740CC),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Notice:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Never upload inappropriate content that violates our '
                  'policies or personal information such as phone number, '
                  'account number, address, or kid pictures. All content '
                  'will be reviewed by AI and the human review team.\n'
                  'Once illegal content is detected, it may result in '
                  'content deletion, profile reset, or account suspension.',
              style: TextStyle(
                color: Color(0xffE6E1EA),
                fontSize: 14.5,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(
            Icons.diamond,
            color: purple,
            size: 10,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xffE3DDE8),
              fontSize: 14.5,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceCard() {
    return _GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const _SectionTitle(
              icon: Icons.graphic_eq_rounded,
              title: 'Voice card',
            ),

            const SizedBox(height: 17),

            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Voice recording will be connected next.',
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xff8DBA62),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_outline_rounded,
                      color: Color(0xffA9E972),
                      size: 28,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Click to add my voice card',
                      style: TextStyle(
                        color: Color(0xffA9E972),
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return _GlassCard(
      child: Column(
        children: [
          _ProfileTile(
            icon: Icons.person_outline_rounded,
            label: 'Username',
            value: username,
            subtitle: 'Username can only be changed once.',
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
            icon: Icons.calendar_month_outlined,
            label: 'Birthday',
            value: birthday,
            onTap: _selectBirthday,
          ),

          _ProfileTile(
            icon: Icons.outlined_flag_rounded,
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
            icon: Icons.account_balance_outlined,
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
      backgroundColor: const Color(0xff0B1628),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Gender',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                ListTile(
                  leading: const Icon(
                    Icons.male_rounded,
                    color: purple,
                  ),
                  title: const Text(
                    'Male',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, 'Male');
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.female_rounded,
                    color: purple,
                  ),
                  title: const Text(
                    'Female',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, 'Female');
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.person_outline_rounded,
                    color: purple,
                  ),
                  title: const Text(
                    'Prefer not to say',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(
                      context,
                      'Prefer not to say',
                    );
                  },
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

  Future<void> _selectBirthday() async {
    final DateTime initialDate =
        DateTime.tryParse(birthday) ?? DateTime(2002, 1, 20);

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: purple,
              surface: Color(0xff101A2D),
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
    final bool isEmptyValue = currentValue == 'Click to set';

    final TextEditingController controller = TextEditingController(
      text: isEmptyValue ? '' : currentValue,
    );

    final String? result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xff0C1728),
          title: Text(
            'Edit $title',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          content: TextField(
            controller: controller,
            maxLines: maxLines,
            autofocus: true,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: hintText ?? 'Enter $title',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.45),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: purple.withOpacity(0.65),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: purple,
                  width: 1.5,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white70,
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
                  color: purple,
                ),
              ),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        onSaved(result.trim());
      });
    }
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            border: showBottomBorder
                ? Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.14),
              ),
            )
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: const Color(0xffB16EFF),
                size: 26,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.5,
                      ),
                    ),

                    if (subtitle != null) ...[
                      const SizedBox(height: 5),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          color: Color(0xffB5ADBB),
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: value == 'Click to set'
                        ? Colors.white.withOpacity(0.52)
                        : const Color(0xffE8E2EB),
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xffD3CED7),
                size: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xff32166A).withOpacity(0.85),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff9958FF).withOpacity(0.35),
                blurRadius: 10,
              ),
            ],
          ),
          child: Icon(
            icon,
            color: const Color(0xffC78CFF),
            size: 21,
          ),
        ),

        const SizedBox(width: 10),

        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 7,
          sigmaY: 7,
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xff061426).withOpacity(0.69),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xff8E72A9).withOpacity(0.52),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  final String? assetPath;

  const _Background({
    this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    if (assetPath != null && assetPath!.trim().isNotEmpty) {
      return Image.asset(
        assetPath!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return const _FallbackBackground();
        },
      );
    }

    return const _FallbackBackground();
  }
}

class _FallbackBackground extends StatelessWidget {
  const _FallbackBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff020817),
            Color(0xff081329),
            Color(0xff061322),
            Color(0xff020611),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -120,
            top: 280,
            child: _GlowCircle(
              size: 300,
              color: Color(0xff00B6D7),
            ),
          ),
          Positioned(
            right: -130,
            top: 120,
            child: _GlowCircle(
              size: 300,
              color: Color(0xff6A19FF),
            ),
          ),
          Positioned(
            right: -90,
            bottom: 160,
            child: _GlowCircle(
              size: 260,
              color: Color(0xff9728FF),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 75,
        sigmaY: 75,
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.45),
        ),
      ),
    );
  }
}