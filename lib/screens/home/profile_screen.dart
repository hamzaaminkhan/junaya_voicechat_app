import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/screens/settings/settings_screen.dart';
import 'package:junaya_voicechat_app/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0B0E21),

      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,

        iconTheme: const IconThemeData(
          color: Colors.white, // Bright back arrow
        ),
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 30),

            const CircleAvatar(
              radius: 55,
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              "Hamza",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "ID : 1254789",
              style: TextStyle(
                color: Colors.white.withOpacity(.7),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Text(
                "VIP 3",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  stat("Friends", "320"),
                  stat("Followers", "4.8K"),
                  stat("Following", "512"),

                ],
              ),
            ),

            const SizedBox(height: 30),

            infoCard(
              Icons.account_balance_wallet,
              "Coins",
              "128,540",
              Colors.amber,
            ),

            infoCard(
              Icons.diamond,
              "Diamonds",
              "12,900",
              Colors.cyan,
            ),

            infoCard(
              Icons.public,
              "Country",
              "Pakistan",
              Colors.green,
            ),

            const SizedBox(height: 15),

            menuTile(Icons.settings, "Settings"),
            menuTile(Icons.lock, "Privacy"),
            menuTile(Icons.help, "Help Center"),
            menuTile(Icons.history, "Transaction History"),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget stat(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget infoCard(
      IconData icon,
      String title,
      String value,
      Color color,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 8,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xff121530),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [

            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.black),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),

            Text(
              value,
              style: const TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.amber),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white54,
        size: 18,
      ),
      onTap: () {},
    );
  }
}