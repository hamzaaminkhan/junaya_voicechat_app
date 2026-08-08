import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Account'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top:100),
        children: const [
          ListTile(title: Text('Facebook', style: TextStyle(color: Colors.white))),
          ListTile(title: Text('Google', style: TextStyle(color: Colors.white))),
          ListTile(title: Text('Phone', style: TextStyle(color: Colors.white))),
          ListTile(title: Text('Email', style: TextStyle(color: Colors.white))),
          ListTile(title: Text('Delete Account', style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
