import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junaya_voicechat_app/services/backend_auth_service.dart';
import 'package:junaya_voicechat_app/widgets/space_background.dart';



class EditProfileDetailsScreen extends StatefulWidget {
  final String? backgroundAsset;
  final Map<String, dynamic>? initialProfile;

  const EditProfileDetailsScreen({
    super.key,
    this.backgroundAsset,
    this.initialProfile,
  });

  @override
  State<EditProfileDetailsScreen> createState() =>
      _EditProfileDetailsScreenState();
}

class _EditProfileDetailsScreenState extends State<EditProfileDetailsScreen> {
  static const Color gold = Color(0xFFFFC94D);
  static const Color purple = Color(0xFFB25CFF);

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final _picker = ImagePicker();

  Map<String, dynamic>? _profile;
  XFile? _selectedAvatar;
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialProfile;
    if (initial != null) {
      _applyProfile(initial);
      _loading = false;
    } else {
      _loadProfile();
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _applyProfile(Map<String, dynamic> profile) {
    _profile = profile;
    _usernameController.text = profile['username']?.toString() ?? '';
    _bioController.text = profile['bio']?.toString() ?? '';
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await BackendAuthService.instance.getProfile();
      if (!mounted) return;
      setState(() {
        _applyProfile(profile);
        _loading = false;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = error.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _pickAvatar() async {
    if (_saving) return;

    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
      maxWidth: 1400,
      maxHeight: 1400,
    );

    if (image == null || !mounted) return;
    setState(() => _selectedAvatar = image);
  }

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      var profile = _profile ?? <String, dynamic>{};
      final oldUsername = profile['username']?.toString().trim() ?? '';
      final oldBio = profile['bio']?.toString().trim() ?? '';
      final newUsername = _usernameController.text.trim();
      final newBio = _bioController.text.trim();

      if (newUsername != oldUsername || newBio != oldBio) {
        profile = await BackendAuthService.instance.updateProfile(
          username: newUsername,
          bio: newBio,
        );
      }

      if (_selectedAvatar != null) {
        profile = await BackendAuthService.instance.uploadAvatar(
          _selectedAvatar!.path,
        );
      }

      if (!mounted) return;
      setState(() {
        _applyProfile(profile);
        _selectedAvatar = null;
        _saving = false;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      final message = error.toString().replaceFirst('Exception: ', '');
      setState(() {
        _saving = false;
        _error = message;
      });
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }
  }

  String _value(String key, [String fallback = '']) {
    final value = _profile?[key];
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  ImageProvider? _avatarProvider() {
    if (_selectedAvatar != null) {
      return FileImage(File(_selectedAvatar!.path));
    }

    final avatarUrl = _value('avatarUrl');
    if (avatarUrl.isNotEmpty) {
      return NetworkImage(avatarUrl);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _buildBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground({required Widget child}) {
    final asset = widget.backgroundAsset?.trim();
    if (asset != null && asset.isNotEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(asset, fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: .42)),
          child,
        ],
      );
    }
    return SpaceBackground(child: child);
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            IconButton(
              onPressed: _saving ? null : () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
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
            SizedBox(
              width: 66,
              child: TextButton(
                onPressed: _loading || _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: gold,
                        ),
                      )
                    : Text(
                        'Save',
                        style: GoogleFonts.poppins(
                          color: gold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: purple));
    }

    if (_profile == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, color: gold, size: 42),
              const SizedBox(height: 12),
              Text(
                _error ?? 'Unable to load profile.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _loading = true;
                    _error = null;
                  });
                  _loadProfile();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _avatarSection(),
            const SizedBox(height: 18),
            _accountIdentityCard(),
            const SizedBox(height: 14),
            _editableCard(),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: const Color(0xFFFF7D96),
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: const Color(0xFF24102E),
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                icon: const Icon(Icons.save_outlined),
                label: Text(
                  'Save profile',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarSection() {
    final avatar = _avatarProvider();
    return Column(
      children: [
        GestureDetector(
          onTap: _pickAvatar,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: purple, width: 2.5),
                ),
                child: CircleAvatar(
                  radius: 52,
                  backgroundColor: const Color(0xFF21152E),
                  backgroundImage: avatar,
                  child: avatar == null
                      ? const Icon(Icons.person, size: 54, color: Colors.white70)
                      : null,
                ),
              ),
              Positioned(
                right: -2,
                bottom: 3,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: gold,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF1A082D), width: 2),
                  ),
                  child: const Icon(
                    Icons.photo_camera_outlined,
                    color: Color(0xFF24102E),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: _saving ? null : _pickAvatar,
          child: Text(
            'Change Avatar',
            style: GoogleFonts.poppins(
              color: gold,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          'JPG, PNG or WEBP • maximum 5 MB',
          style: GoogleFonts.poppins(color: Colors.white38, fontSize: 10),
        ),
      ],
    );
  }

  Widget _accountIdentityCard() {
    final id = _value('junayaId', _value('id', '—'));
    final vip = _value('vipLevel', '0');
    final diamonds = _value('diamonds', '0');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _readOnlyRow(Icons.badge_outlined, 'User ID', id),
          const Divider(color: Colors.white10),
          _readOnlyRow(Icons.workspace_premium_outlined, 'VIP', 'VIP $vip'),
          const Divider(color: Colors.white10),
          _readOnlyRow(Icons.diamond_outlined, 'Diamonds', diamonds),
        ],
      ),
    );
  }

  Widget _editableCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account profile',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 13),
          TextFormField(
            controller: _usernameController,
            enabled: !_saving,
            maxLength: 30,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
            decoration: _inputDecoration(
              label: 'Username',
              icon: Icons.person_outline_rounded,
              helper: 'Must be unique. Letters, numbers, dots and underscores.',
            ),
            validator: (value) {
              final username = value?.trim() ?? '';
              if (username.length < 3 || username.length > 30) {
                return 'Username must be between 3 and 30 characters';
              }
              if (!RegExp(r'^[a-zA-Z0-9._]+$').hasMatch(username)) {
                return 'Use only letters, numbers, dots and underscores';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _bioController,
            enabled: !_saving,
            minLines: 2,
            maxLines: 4,
            maxLength: 300,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
            decoration: _inputDecoration(
              label: 'Bio',
              icon: Icons.notes_rounded,
              helper: 'Optional',
            ),
          ),
        ],
      ),
    );
  }

  Widget _readOnlyRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(icon, color: gold, size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white60, fontSize: 12),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    required String helper,
  }) {
    return InputDecoration(
      labelText: label,
      helperText: helper,
      labelStyle: GoogleFonts.poppins(color: Colors.white60, fontSize: 12),
      helperStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 9.5),
      prefixIcon: Icon(icon, color: gold, size: 19),
      counterStyle: GoogleFonts.poppins(color: Colors.white30, fontSize: 9),
      filled: true,
      fillColor: Colors.black.withValues(alpha: .25),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(color: purple.withValues(alpha: .36)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: gold),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFFF6D86)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFFF6D86)),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: const Color(0xFF16082B).withValues(alpha: .86),
      borderRadius: BorderRadius.circular(17),
      border: Border.all(color: purple.withValues(alpha: .42)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .18),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}
