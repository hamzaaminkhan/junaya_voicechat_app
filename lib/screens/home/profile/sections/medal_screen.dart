import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/profile_section_shell.dart';

class MedalScreen extends StatelessWidget {
  const MedalScreen({super.key});

  static const List<Map<String, dynamic>> medals = [
    {
      'title': 'First Voice',
      'description': 'Join your first voice room',
      'icon': Icons.mic_rounded,
      'unlocked': true,
    },
    {
      'title': 'Friendly',
      'description': 'Make 10 friends',
      'icon': Icons.people_alt_rounded,
      'unlocked': true,
    },
    {
      'title': 'Gift Giver',
      'description': 'Send 100 gifts',
      'icon': Icons.card_giftcard_rounded,
      'unlocked': false,
    },
    {
      'title': 'Room Star',
      'description': 'Reach 1K room visitors',
      'icon': Icons.star_rounded,
      'unlocked': false,
    },
    {
      'title': 'Social Pro',
      'description': 'Reach 500 followers',
      'icon': Icons.groups_rounded,
      'unlocked': false,
    },
    {
      'title': 'VIP Shine',
      'description': 'Activate a VIP level',
      'icon': Icons.workspace_premium_rounded,
      'unlocked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final unlockedCount = medals.where((medal) => medal['unlocked'] == true).length;

    return ProfileSectionScaffold(
      title: 'Medal',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
        children: [
          ProfileSectionCard(
            gradient: const LinearGradient(
              colors: [Color(0xFF36165D), Color(0xFF7B2CBF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber.withOpacity(.15),
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 38),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$unlockedCount / ${medals.length} medals unlocked',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Complete activities to grow your medal score and display achievements on your profile.',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const ProfileSectionHeader(
            title: 'Your medals',
            subtitle: 'Locked medals show the next achievement to work toward.',
            icon: Icons.military_tech_rounded,
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: medals.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: .88,
            ),
            itemBuilder: (context, index) {
              final medal = medals[index];
              final unlocked = medal['unlocked'] as bool;

              return ProfileSectionCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: unlocked
                            ? Colors.amber.withOpacity(.13)
                            : Colors.white.withOpacity(.05),
                        border: Border.all(
                          color: unlocked ? Colors.amber : Colors.white24,
                        ),
                      ),
                      child: Icon(
                        medal['icon'] as IconData,
                        color: unlocked ? Colors.amber : Colors.white24,
                        size: 31,
                      ),
                    ),
                    const SizedBox(height: 11),
                    Text(
                      medal['title'] as String,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: unlocked ? Colors.white : Colors.white54,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      medal['description'] as String,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ProfileTag(
                      text: unlocked ? 'Unlocked' : 'Locked',
                      icon: unlocked ? Icons.check_circle : Icons.lock_outline,
                      color: unlocked ? Colors.greenAccent : Colors.white54,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
