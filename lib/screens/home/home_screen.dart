import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/screens/home/rooms/room_screen.dart';
import 'package:junaya_voicechat_app/screens/home/profile_screen.dart';
import 'package:junaya_voicechat_app/screens/gifts/gifts_screen.dart';
import 'package:junaya_voicechat_app/screens/home/wallet_screen.dart';
import 'package:junaya_voicechat_app/screens/notifications/notification_screen.dart';
import 'package:junaya_voicechat_app/theme/app_colors.dart';
import 'package:junaya_voicechat_app/screens/vip/vip_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0B0E21),

      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,

        title: Text(
          "JUNAID",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.amber,
          ),
        ),
        actions: [

          // VIP
          IconButton(
            icon: const Icon(
              Icons.workspace_premium,
              color: Colors.amber,
              size: 28,
            ),
            tooltip: "VIP",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const VipScreen(),
                ),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white,),


            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff121530),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          switch (index) {
            case 0:
              break; // Home

            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RoomScreen(),
                ),
              );
              break;

            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChatScreen(),
                ),
              );
              break;

            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationScreen(),
                ),
              );
              break;

            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
              break;
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: "Rooms",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 15),

            // Search

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Rooms...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Banner

            CarouselSlider(
              options: CarouselOptions(
                height: 170,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: [
                banner("VIP Event"),
                banner("Daily Rewards"),
                banner("Voice Battle"),
              ],
            ),

            const SizedBox(height: 20),

            title("Explore"),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.5,
                children: [

                  featureCard(
                    context,
                    Icons.mic,
                    "Create Room",
                    Colors.deepPurple,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RoomScreen(),
                        ),
                      );
                    },
                  ),

                  featureCard(
                    context,
                    Icons.wallet,
                    "Wallet",
                    Colors.green,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WalletScreen(),
                        ),
                      );
                    },
                  ),

                  featureCard(
                    context,
                    Icons.card_giftcard,
                    "Gift Store",
                    Colors.orange,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GiftsScreen(),
                        ),
                      );
                    },
                  ),

                  featureCard(
                    context,
                    Icons.workspace_premium,
                    "VIP",
                    Colors.amber,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VipScreen(),
                          ),
                        );
                      },
                  ),

                ],
              ),
            ),

            const SizedBox(height: 25),

            title("Popular Rooms"),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(15),
              itemCount: 6,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .9,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, index) {

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.amber,
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Room ${index + 1}",
                        style: const TextStyle(color: Colors.white),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        "120 Users",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),

            title("Top Hosts"),

            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder: (_, index) {

                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [

                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.purple,
                          child: Icon(Icons.person),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Host ${index + 1}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget title(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget banner(String title) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff5B2EFF),
            Color(0xffB721FF),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget action(IconData icon, String text) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.amber,
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(color: Colors.white),
        )
      ],
    );
  }
}

Widget featureCard(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
    ) {
  return InkWell(
    borderRadius: BorderRadius.circular(18),
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            CircleAvatar(
              radius: 26,
              backgroundColor: color,
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),

          ],
        ),
      ),
    ),
  );
}