import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../widgets/profile_section_shell.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;
  bool darkMode = true;
  bool privateAccount = false;
  bool soundEffects = true;

  void _showPlaceholder(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title screen can be connected next.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProfileSectionScaffold(
      title: 'Settings',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
        children: [
          const ProfileSectionHeader(
            title: 'Preferences',
            icon: Icons.tune_rounded,
          ),
          const SizedBox(height: 12),
          ProfileSectionCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _switchTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Room, chat and account alerts',
                  value: notifications,
                  onChanged: (value) => setState(() => notifications = value),
                ),
                const Divider(color: Colors.white12, height: 1),
                _switchTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  subtitle: 'Use the dark space theme',
                  value: darkMode,
                  onChanged: (value) => setState(() => darkMode = value),
                ),
                const Divider(color: Colors.white12, height: 1),
                _switchTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Private Account',
                  subtitle: 'Limit profile visibility',
                  value: privateAccount,
                  onChanged: (value) => setState(() => privateAccount = value),
                ),
                const Divider(color: Colors.white12, height: 1),
                _switchTile(
                  icon: Icons.volume_up_outlined,
                  title: 'Sound Effects',
                  subtitle: 'Play in-app sound effects',
                  value: soundEffects,
                  onChanged: (value) => setState(() => soundEffects = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const ProfileSectionHeader(
            title: 'Account & Support',
            icon: Icons.manage_accounts_outlined,
          ),
          const SizedBox(height: 12),
          ProfileSectionCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _navigationTile(
                  Icons.language_rounded,
                  'Language',
                  'Choose your preferred language',
                      () => Navigator.pushNamed(context, AppRoutes.language),
                ),
                const Divider(color: Colors.white12, height: 1),
                _navigationTile(
                  Icons.security_outlined,
                  'Security',
                  'Password and sign-in options',
                      () => _showPlaceholder('Security'),
                ),
                const Divider(color: Colors.white12, height: 1),
                _navigationTile(
                  Icons.help_outline_rounded,
                  'Help & Support',
                  'FAQ and support options',
                      () => Navigator.pushNamed(context, AppRoutes.helpCenter),
                ),
                const Divider(color: Colors.white12, height: 1),
                _navigationTile(
                  Icons.description_outlined,
                  'Terms & Conditions',
                  'Read app terms',
                      () => _showPlaceholder('Terms & Conditions'),
                ),
                const Divider(color: Colors.white12, height: 1),
                _navigationTile(
                  Icons.privacy_tip_outlined,
                  'Privacy Policy',
                  'Review privacy information',
                      () => _showPlaceholder('Privacy Policy'),
                ),
                const Divider(color: Colors.white12, height: 1),
                _navigationTile(
                  Icons.info_outline_rounded,
                  'About App',
                  'Version and product information',
                      () => _showPlaceholder('About App'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                      (route) => false,
                );
              },
              icon: const Icon(Icons.logout_rounded),
              label: Text(
                'Logout',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.amber),
      title: Text(
        title,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 10),
      ),
      value: value,
      activeColor: Colors.amber,
      onChanged: onChanged,
    );
  }

  Widget _navigationTile(
      IconData icon,
      String title,
      String subtitle,
      VoidCallback onTap,
      ) {
    return ListTile(
      leading: Icon(icon, color: Colors.amber),
      title: Text(
        title,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 10),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white38, size: 15),
      onTap: onTap,
    );
  }
}
