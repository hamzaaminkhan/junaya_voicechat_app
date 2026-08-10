import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/profile_section_shell.dart';

class LevelScreen extends StatelessWidget {
  const LevelScreen({super.key});

  static const int currentLevel = 12;
  static const int currentXp = 7350;
  static const int nextLevelXp = 10000;

  @override
  Widget build(BuildContext context) {
    final progress = currentXp / nextLevelXp;

    return ProfileSectionScaffold(
      title: 'Level',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
        children: [
          ProfileSectionCard(
            gradient: const LinearGradient(
              colors: [Color(0xFF5427D9), Color(0xFF8B2BFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            child: Column(
              children: [
                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: .22),
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '$currentLevel',
                      style: GoogleFonts.poppins(
                        color: Colors.amber,
                        fontSize: 31,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Rising Star',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$currentXp / $nextLevelXp XP',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: progress,
                    backgroundColor: Colors.black26,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.amber,
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${nextLevelXp - currentXp} XP to Level ${currentLevel + 1}',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const ProfileSectionHeader(
            title: 'Level rewards',
            subtitle:
                'Unlock profile effects and room perks as your level grows.',
            icon: Icons.auto_graph_rounded,
          ),
          const SizedBox(height: 12),
          _rewardTile(
            level: 10,
            title: 'Purple profile frame',
            subtitle: 'Unlocked',
            icon: Icons.account_circle_outlined,
            unlocked: true,
          ),
          _rewardTile(
            level: 12,
            title: 'Level badge',
            subtitle: 'Current reward',
            icon: Icons.verified_outlined,
            unlocked: true,
          ),
          _rewardTile(
            level: 15,
            title: 'Entrance effect',
            subtitle: 'Unlock at Level 15',
            icon: Icons.auto_awesome,
          ),
          _rewardTile(
            level: 20,
            title: 'Premium name style',
            subtitle: 'Unlock at Level 20',
            icon: Icons.text_fields_rounded,
          ),
          const SizedBox(height: 20),
          const ProfileSectionHeader(
            title: 'How to gain XP',
            icon: Icons.bolt_rounded,
          ),
          const SizedBox(height: 12),
          const ProfileSectionCard(
            child: Column(
              children: [
                _XpRow(
                  icon: Icons.mic_none_rounded,
                  text: 'Spend time in voice rooms',
                  xp: '+ XP',
                ),
                Divider(color: Colors.white12),
                _XpRow(
                  icon: Icons.card_giftcard,
                  text: 'Send and receive gifts',
                  xp: '+ XP',
                ),
                Divider(color: Colors.white12),
                _XpRow(
                  icon: Icons.people_outline,
                  text: 'Join community activities',
                  xp: '+ XP',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rewardTile({
    required int level,
    required String title,
    required String subtitle,
    required IconData icon,
    bool unlocked = false,
  }) {
    return ProfileSectionCard(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (unlocked ? Colors.amber : Colors.white24).withValues(
                alpha: .13,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: unlocked ? Colors.amber : Colors.white38),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: unlocked ? Colors.amber : Colors.white,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          ProfileTag(
            text: 'Lv. $level',
            color: unlocked ? Colors.amber : Colors.white54,
          ),
        ],
      ),
    );
  }
}

class _XpRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final String xp;

  const _XpRow({required this.icon, required this.text, required this.xp});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 21),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
            ),
          ),
          Text(
            xp,
            style: GoogleFonts.poppins(
              color: Colors.purpleAccent,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
