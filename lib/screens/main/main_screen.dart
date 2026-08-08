import 'package:flutter/material.dart';

import '../chat/chat_list_screen.dart';
import '../home/home_screen.dart';
import '../home/profile/profile_screen.dart';
import '../moments/moments_screen.dart';
import '../../widgets/space_background.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      const HomeScreen(),
      const MomentsScreen(),
      const ChatListScreen(),
      ProfileScreen(onBack: _showHomeTab),
    ];
  }

  void _showHomeTab() {
    if (currentIndex == 0) return;

    setState(() {
      currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: SpaceBackground(
        child: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xB30A0313),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(19),
          ),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(.08),
            ),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(19),
          ),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            selectedItemColor: const Color(0xFFFFC857),
            unselectedItemColor: Colors.white54,
            selectedIconTheme: const IconThemeData(size: 24),
            unselectedIconTheme: const IconThemeData(size: 23),
            selectedLabelStyle: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.auto_awesome_rounded),
                label: 'Moments',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline_rounded),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
