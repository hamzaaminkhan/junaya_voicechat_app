import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/widgets/profile_section_shell.dart';



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
    final unlockedCount = medals
        .where((medal) => medal['unlocked'] == true)
        .length;

    final progress = unlockedCount / medals.length;

    return ProfileSectionScaffold(
      title: 'Medal',
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
        children: [
          _buildProgressCard(unlockedCount: unlockedCount, progress: progress),

          const SizedBox(height: 16),

          _buildSectionHeader(),

          const SizedBox(height: 10),

          LayoutBuilder(
            builder: (context, constraints) {
              final int columns = constraints.maxWidth < 300 ? 1 : 2;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: medals.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,

                  // Fixed card height prevents RenderFlex overflow.
                  mainAxisExtent: 154,
                ),
                itemBuilder: (context, index) {
                  final medal = medals[index];
                  final unlocked = medal['unlocked'] as bool;

                  return _MedalCard(
                    title: medal['title'] as String,
                    description: medal['description'] as String,
                    icon: medal['icon'] as IconData,
                    unlocked: unlocked,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard({
    required int unlockedCount,
    required double progress,
  }) {
    return ProfileSectionCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withValues(alpha: .35)),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: Colors.amber,
              size: 29,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$unlockedCount of ${medals.length} unlocked',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Complete activities to unlock more achievements.',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 10.7,
                    height: 1.35,
                  ),
                ),

                const SizedBox(height: 9),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: Colors.white.withValues(alpha: .07),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          width: 31,
          height: 31,
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(
            Icons.military_tech_rounded,
            color: Colors.amber,
            size: 18,
          ),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your medals',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                'Locked medals show your next goals.',
                style: GoogleFonts.poppins(
                  color: Colors.white38,
                  fontSize: 9.8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MedalCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;

  const _MedalCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    final Color accent = unlocked ? Colors.amber : Colors.white24;

    return ProfileSectionCard(
      padding: const EdgeInsets.fromLTRB(11, 11, 11, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: unlocked
                      ? Colors.amber.withValues(alpha: .10)
                      : Colors.white.withValues(alpha: .035),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: unlocked
                        ? Colors.amber.withValues(alpha: .28)
                        : Colors.white.withValues(alpha: .08),
                  ),
                ),
                child: Icon(icon, color: accent, size: 23),
              ),

              const Spacer(),

              _StatusPill(unlocked: unlocked),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: unlocked ? Colors.white : Colors.white54,
              fontSize: 12.8,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: unlocked ? Colors.white54 : Colors.white30,
              fontSize: 9.6,
              height: 1.32,
            ),
          ),

          const Spacer(),

          Container(
            height: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: unlocked
                  ? Colors.amber.withValues(alpha: .65)
                  : Colors.white.withValues(alpha: .06),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool unlocked;

  const _StatusPill({required this.unlocked});

  @override
  Widget build(BuildContext context) {
    final Color color = unlocked ? const Color(0xFF62E7A5) : Colors.white38;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: .20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            unlocked ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
            color: color,
            size: 11,
          ),
          const SizedBox(width: 3),
          Text(
            unlocked ? 'Unlocked' : 'Locked',
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 8.8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
