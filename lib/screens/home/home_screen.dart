import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:junaya_voicechat_app/widgets/room_card.dart';
import 'package:junaya_voicechat_app/widgets/space_background.dart';

import '../../widgets/banner_indicator.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/country_chip.dart';
import '../../widgets/ranking_card.dart';
import '../notifications/notification_screen.dart';
import '../vip/vip_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<String> _bannerAssets = [
    'assets/banners/welcome.png',
    'assets/banners/welcome2.png',
    'assets/banners/welcome3.png',
    'assets/banners/welcome4.png',
  ];

  final List<Map<String, dynamic>> rooms = [
    {
      'flag': '🇵🇰',
      'name': 'Pakistan Star',
      'desc': 'Music & Fun Chat',
      'vip': 'VIP 3',
      'level': 'LV 8',
      'role': 'Host',
      'likes': 65,
    },
    {
      'flag': '🇮🇳',
      'name': 'India Music',
      'desc': 'Join Voice Room',
      'vip': 'VIP 2',
      'level': 'LV 5',
      'role': 'Manager',
      'likes': 32,
    },
    {
      'flag': '🇧🇩',
      'name': 'Bangladesh Live',
      'desc': 'Friends Voice Room',
      'vip': 'VIP 1',
      'level': 'LV 4',
      'role': 'Host',
      'likes': 120,
    },
    {
      'flag': '🇹🇷',
      'name': 'Turkey Party',
      'desc': 'Music Night',
      'vip': 'VIP 4',
      'level': 'LV 9',
      'role': 'Admin',
      'likes': 250,
    },
    {
      'flag': '🇦🇪',
      'name': 'Dubai VIP',
      'desc': 'Luxury Voice Room',
      'vip': 'VIP 5',
      'level': 'LV 10',
      'role': 'Owner',
      'likes': 500,
    },
  ];

  final PageController bannerController = PageController();
  Timer? bannerTimer;

  int bannerIndex = 0;
  int selectedTab = 0;
  int selectedCountry = 0;

  final List<String> tabs = ['HOT', 'RECENT', 'FOLLOW'];

  final List<Map<String, String>> countries = const [
    {'name': 'All', 'flag': '✓'},
    {'name': 'Pakistan', 'flag': '🇵🇰'},
    {'name': 'Bangladesh', 'flag': '🇧🇩'},
    {'name': 'India', 'flag': '🇮🇳'},
    {'name': 'Turkey', 'flag': '🇹🇷'},
  ];

  @override
  void initState() {
    super.initState();

    bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!bannerController.hasClients) return;

      final int nextPage = (bannerIndex + 1) % _bannerAssets.length;
      bannerController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    bannerTimer?.cancel();
    bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,

      body: SpaceBackground(
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            color: const Color(0xFFFFC857),
            backgroundColor: const Color(0xEE10051B),
            onRefresh: () async {
              await Future<void>.delayed(const Duration(milliseconds: 700));
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(child: header()),
                const SliverToBoxAdapter(child: SizedBox(height: 7)),
                SliverToBoxAdapter(child: rankingSection()),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(child: tabSection()),
                const SliverToBoxAdapter(child: SizedBox(height: 7)),
                SliverToBoxAdapter(child: countrySection()),
                const SliverToBoxAdapter(child: SizedBox(height: 11)),
                SliverToBoxAdapter(child: homeBannerSlider()),
                const SliverToBoxAdapter(child: SizedBox(height: 7)),
                SliverToBoxAdapter(
                  child: BannerIndicator(
                    total: _bannerAssets.length,
                    current: bannerIndex,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 15)),
                SliverToBoxAdapter(
                  child: sectionTitle('Popular Rooms', trailing: 'Live now'),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 6)),
                SliverList.separated(
                  itemCount: rooms.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return JunaidRoomCard(
                      flag: room['flag'] as String,
                      roomName: room['name'] as String,
                      description: room['desc'] as String,
                      vip: room['vip'] as String,
                      level: room['level'] as String,
                      role: room['role'] as String,
                      likes: room['likes'] as int,
                    );
                  },
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 130)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 6, 10, 1),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.workspace_premium_rounded,
                      color: Color(0xFFFFC857),
                      size: 17,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'JUNAYA',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                Text(
                  'VOICE CHAT',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2.2,
                  ),
                ),
              ],
            ),
          ),
          _headerAction(
            icon: Icons.workspace_premium_outlined,
            tooltip: 'VIP',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VipScreen()),
              );
            },
          ),
          const SizedBox(width: 7),
          _headerAction(
            icon: Icons.notifications_none_rounded,
            tooltip: 'Notifications',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _headerAction({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .16),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: .10)),
            ),
            child: Icon(icon, color: const Color(0xFFFFC857), size: 21),
          ),
        ),
      ),
    );
  }

  Widget rankingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Row(
        children: const [
          Expanded(
            child: RankingCard(
              title: 'Shining Star',
              icon: '✦',
              color: Color(0xFF62E6BD),
            ),
          ),
          SizedBox(width: 7),
          Expanded(
            child: RankingCard(
              title: 'CP Ranking',
              icon: '♥',
              color: Color(0xFFFF74B8),
            ),
          ),
          SizedBox(width: 7),
          Expanded(
            child: RankingCard(
              title: 'Ranking',
              icon: '♛',
              color: Color(0xFFFFC857),
            ),
          ),
        ],
      ),
    );
  }

  Widget tabSection() {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 7),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => setState(() => selectedTab = index),
            child: CategoryChip(
              text: tabs[index],
              active: selectedTab == index,
            ),
          );
        },
      ),
    );
  }

  Widget countrySection() {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        scrollDirection: Axis.horizontal,
        itemCount: countries.length,
        separatorBuilder: (_, _) => const SizedBox(width: 7),
        itemBuilder: (context, index) {
          final country = countries[index];
          return GestureDetector(
            onTap: () => setState(() => selectedCountry = index),
            child: CountryChip(
              name: country['name']!,
              flag: country['flag']!,
              active: selectedCountry == index,
            ),
          );
        },
      ),
    );
  }

  Widget sectionTitle(String text, {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (trailing != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .055),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: .08)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Color(0xFF66E7BD),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    trailing,
                    style: GoogleFonts.poppins(
                      color: Colors.white60,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget homeBannerSlider() {
    return SizedBox(
      height: 170,
      child: PageView.builder(
        controller: bannerController,
        itemCount: _bannerAssets.length,
        onPageChanged: (index) {
          if (!mounted) return;
          setState(() => bannerIndex = index);
        },
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: .10)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              _bannerAssets[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          );
        },
      ),
    );
  }
}
