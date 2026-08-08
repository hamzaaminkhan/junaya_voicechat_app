import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/routes/app_routes.dart';

import 'account_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Setting'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 100, 12, 24),
        children: [
          _item(context, 'Account', const AccountScreen()),
          _item(context, 'Change Gmail', null),
          _item(context, 'Forgot Password', null),
          _item(context, 'Face Verification', null),
          _item(context, 'Location', null),
          _item(context, 'Blocked List', null),
          _item(context, 'Clear Cache', null),
          _item(context, 'Rate Us', null),
          _item(context, 'About', null),

          const SizedBox(height: 20),

          _logoutButton(context),
        ],
      ),
    );
  }

  Widget _item(
      BuildContext context,
      String text,
      Widget? page,
      ) {
    return Card(
      color: Colors.black.withOpacity(.25),
      child: ListTile(
        title: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 16,
        ),
        onTap: page == null
            ? null
            : () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => page,
            ),
          );
        },
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
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
        icon: const Icon(
          Icons.logout_rounded,
          size: 20,
        ),
        label: const Text(
          'Log Out',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
