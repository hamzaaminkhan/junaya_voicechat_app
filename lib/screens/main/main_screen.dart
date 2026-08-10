import 'package:flutter/material.dart';

import '../chat/chat_list_screen.dart';
import '../home/home_screen.dart';
import '../home/profile/profile_screen.dart';
import '../home/rooms/room_screen.dart';
import '../moments/moments_screen.dart';
import '../../widgets/space_background.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const Color _gold = Color(0xFFFFC857);
  static const Color _navBackground = Color(0xFF090713);
  static const Color _inactiveColor = Color(0xFF9A96A5);
  static const Color _micBackground = Color(0xFF21102F);

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

  void _selectPage(int index) {
    if (index == currentIndex) return;

    setState(() {
      currentIndex = index;
    });
  }

  void _openRoom() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const RoomScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: false,
      body: SpaceBackground(
        child: IndexedStack(index: currentIndex, children: pages),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      color: _navBackground,
      child: SafeArea(
        top: false,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: _navBackground,
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.07),
                width: 0.7,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _navButton(
                  index: 0,
                  selectedIcon: Icons.home_rounded,
                  unselectedIcon: Icons.home_outlined,
                  tooltip: 'Home',
                ),
              ),
              Expanded(
                child: _navButton(
                  index: 1,
                  selectedIcon: Icons.auto_awesome_rounded,
                  unselectedIcon: Icons.auto_awesome_outlined,
                  tooltip: 'Moments',
                ),
              ),
              Expanded(child: _micButton()),
              Expanded(
                child: _navButton(
                  index: 2,
                  selectedIcon: Icons.chat_bubble_rounded,
                  unselectedIcon: Icons.chat_bubble_outline_rounded,
                  tooltip: 'Chat',
                  badge: 120,
                ),
              ),
              Expanded(
                child: _navButton(
                  index: 3,
                  selectedIcon: Icons.person_rounded,
                  unselectedIcon: Icons.person_outline_rounded,
                  tooltip: 'Profile',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navButton({
    required int index,
    required IconData selectedIcon,
    required IconData unselectedIcon,
    required String tooltip,
    int? badge,
  }) {
    final bool selected = currentIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectPage(index),
        child: Tooltip(
          message: tooltip,
          child: SizedBox(
            height: 64,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 160),
                      child: Icon(
                        selected ? selectedIcon : unselectedIcon,
                        key: ValueKey(selected),
                        size: 28,
                        color: selected ? _gold : _inactiveColor,
                      ),
                    ),
                  ),
                  if (selected)
                    Positioned(
                      bottom: -1,
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: _gold,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  if (badge != null)
                    Positioned(
                      right: -4,
                      top: -1,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF3B7C),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _navBackground, width: 1.5),
                        ),
                        child: Text(
                          badge > 99 ? '99+' : '$badge',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            height: 1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _micButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _openRoom,
        child: SizedBox(
          height: 64,
          child: Center(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _micBackground,
                border: Border.all(
                  color: _gold.withValues(alpha: 0.9),
                  width: 1.3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _gold.withValues(alpha: 0.12),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Icon(Icons.mic_rounded, size: 26, color: _gold),
            ),
          ),
        ),
      ),
    );
  }
}
