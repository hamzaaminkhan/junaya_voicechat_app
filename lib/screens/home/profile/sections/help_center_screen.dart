import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/profile_section_shell.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  static const List<Map<String, String>> _faqs = [
    {
      'question': 'How do I recharge my wallet?',
      'answer':
          'Open Wallet from your profile and choose Recharge. Payment integration can be connected to the recharge action.',
    },
    {
      'question': 'How do I join an agency?',
      'answer':
          'Open Join Agency, enter the agency ID supplied by the owner, then send your request.',
    },
    {
      'question': 'How do levels work?',
      'answer':
          'Levels can be increased by earning XP through rooms, gifts and community activity once those backend rules are connected.',
    },
    {
      'question': 'Where can I change the app language?',
      'answer':
          'Open Language from Profile or Settings and select your preferred language.',
    },
    {
      'question': 'How do I report a problem?',
      'answer':
          'Use the support options below. A ticket or live-chat API can be connected to these actions later.',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature will be connected to the support backend.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = _query.trim().toLowerCase();
    final visibleFaqs = _faqs.where((faq) {
      if (normalizedQuery.isEmpty) return true;
      return faq['question']!.toLowerCase().contains(normalizedQuery) ||
          faq['answer']!.toLowerCase().contains(normalizedQuery);
    }).toList();

    return ProfileSectionScaffold(
      title: 'Help Center',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
        children: [
          ProfileSectionCard(
            gradient: const LinearGradient(
              colors: [Color(0xFF34125D), Color(0xFF6C2BD9)],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.support_agent_rounded,
                  color: Colors.amber,
                  size: 46,
                ),
                const SizedBox(height: 10),
                Text(
                  'How can we help?',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search help topics',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Colors.amber,
                    ),
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: .22),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const ProfileSectionHeader(
            title: 'Contact support',
            icon: Icons.headset_mic_rounded,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SupportAction(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Live Chat',
                  onTap: () => _showComingSoon('Live chat'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SupportAction(
                  icon: Icons.confirmation_number_outlined,
                  label: 'Create Ticket',
                  onTap: () => _showComingSoon('Support tickets'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const ProfileSectionHeader(
            title: 'Frequently asked questions',
            icon: Icons.quiz_outlined,
          ),
          const SizedBox(height: 12),
          if (visibleFaqs.isEmpty)
            const ProfileSectionCard(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'No matching help topics.',
                    style: TextStyle(color: Colors.white60),
                  ),
                ),
              ),
            )
          else
            ...visibleFaqs.map(
              (faq) => ProfileSectionCard(
                margin: const EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.zero,
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    iconColor: Colors.amber,
                    collapsedIconColor: Colors.white54,
                    title: Text(
                      faq['question']!,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            faq['answer']!,
                            style: GoogleFonts.poppins(
                              color: Colors.white60,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SupportAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SupportAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.amber, size: 30),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
