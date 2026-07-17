import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:junaya_voicechat_app/routes/app_routes.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      appBar: AppBar(
        backgroundColor: const Color(0xff121530),
        elevation: 0,

        iconTheme: const IconThemeData(
          color: Colors.white, // Bright back arrow
        ),

        title: Text(
          "Settings",
          style: GoogleFonts.poppins(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        children: [

          const SizedBox(height: 15),

          buildSwitchTile(
            icon: Icons.notifications,
            title: "Notifications",
            value: notifications,
            onChanged: (value) {
              setState(() {
                notifications = value;
              });
            },
          ),

          buildSwitchTile(
            icon: Icons.dark_mode,
            title: "Dark Mode",
            value: darkMode,
            onChanged: (value) {
              setState(() {
                darkMode = value;
              });
            },
          ),

          buildSwitchTile(
            icon: Icons.lock,
            title: "Private Account",
            value: privateAccount,
            onChanged: (value) {
              setState(() {
                privateAccount = value;
              });
            },
          ),

          buildSwitchTile(
            icon: Icons.volume_up,
            title: "Sound Effects",
            value: soundEffects,
            onChanged: (value) {
              setState(() {
                soundEffects = value;
              });
            },
          ),

          const Divider(color: Colors.white24),

          buildTile(Icons.language, "Language"),
          buildTile(Icons.security, "Security"),
          buildTile(Icons.help_outline, "Help & Support"),
          buildTile(Icons.description, "Terms & Conditions"),
          buildTile(Icons.privacy_tip, "Privacy Policy"),
          buildTile(Icons.info_outline, "About App"),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                        (route) => false,
                  );
                }
              },

              icon: const Icon(Icons.logout),

              label: const Text(
                "Logout",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(
        icon,
        color: Colors.amber,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      value: value,
      // ignore: deprecated_member_use
      activeColor: Colors.amber,
      onChanged: onChanged,
    );
  }

  Widget buildTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.amber,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white54,
        size: 18,
      ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("$title clicked"),
            ),
          );
        },
    );
  }
}