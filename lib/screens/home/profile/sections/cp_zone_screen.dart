import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/profile_section_shell.dart';

class CpZoneScreen extends StatelessWidget {
  const CpZoneScreen({super.key});

  void _showInviteDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF170823),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Create CP connection',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter user ID',
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.person_search, color: Colors.amber),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.purpleAccent.withValues(alpha: .45),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.purpleAccent),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final userId = controller.text.trim();
                Navigator.pop(dialogContext);
                if (userId.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('CP invitation sent to $userId.')),
                  );
                }
              },
              child: const Text('Send Invite'),
            ),
          ],
        );
      },
    ).whenComplete(controller.dispose);
  }

  @override
  Widget build(BuildContext context) {
    return ProfileSectionScaffold(
      title: 'CP Zone',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
        children: [
          ProfileSectionCard(
            gradient: const LinearGradient(
              colors: [Color(0xFF3B0A45), Color(0xFF751B80), Color(0xFF301043)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.favorite_rounded,
                  color: Colors.pinkAccent,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  'Your CP Zone',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Connect with a partner, build CP points together and unlock shared profile rewards.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _PartnerAvatar(label: 'You', icon: Icons.person),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.pinkAccent,
                        size: 30,
                      ),
                    ),
                    _PartnerAvatar(
                      label: 'Partner',
                      icon: Icons.person_add_alt_1,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ProfilePrimaryButton(
                  label: 'Invite a CP Partner',
                  icon: Icons.favorite_border_rounded,
                  onPressed: () => _showInviteDialog(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const ProfileSectionHeader(
            title: 'CP progress',
            subtitle: 'Sample values for the first UI version.',
            icon: Icons.auto_graph_rounded,
          ),
          const SizedBox(height: 12),
          const ProfileSectionCard(
            child: Row(
              children: [
                Expanded(
                  child: _CpMetric(
                    value: '0',
                    label: 'CP Points',
                    icon: Icons.favorite,
                  ),
                ),
                _Divider(),
                Expanded(
                  child: _CpMetric(
                    value: '--',
                    label: 'CP Rank',
                    icon: Icons.leaderboard,
                  ),
                ),
                _Divider(),
                Expanded(
                  child: _CpMetric(
                    value: '0',
                    label: 'Days',
                    icon: Icons.calendar_month,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const ProfileSectionHeader(
            title: 'Shared milestones',
            icon: Icons.flag_outlined,
          ),
          const SizedBox(height: 12),
          _milestone('Make a CP connection', '0 / 1', Icons.favorite_border, 0),
          _milestone(
            'Earn 1,000 CP points',
            '0 / 1,000',
            Icons.bolt_outlined,
            0,
          ),
          _milestone(
            'Reach a 7-day streak',
            '0 / 7 days',
            Icons.local_fire_department_outlined,
            0,
          ),
        ],
      ),
    );
  }

  Widget _milestone(
    String title,
    String progressText,
    IconData icon,
    double progress,
  ) {
    return ProfileSectionCard(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.pinkAccent.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: Colors.pinkAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.white10,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.pinkAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            progressText,
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _PartnerAvatar extends StatelessWidget {
  final String label;
  final IconData icon;

  const _PartnerAvatar({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withValues(alpha: .22),
            border: Border.all(color: Colors.pinkAccent.withValues(alpha: .6)),
          ),
          child: Icon(icon, color: Colors.white70),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}

class _CpMetric extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _CpMetric({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.amber, size: 22),
        const SizedBox(height: 5),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: Colors.white54, fontSize: 9),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: Colors.white12,
    );
  }
}
