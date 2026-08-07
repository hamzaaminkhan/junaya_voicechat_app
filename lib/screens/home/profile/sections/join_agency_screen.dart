import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/profile_section_shell.dart';

class JoinAgencyScreen extends StatefulWidget {
  const JoinAgencyScreen({super.key});

  @override
  State<JoinAgencyScreen> createState() => _JoinAgencyScreenState();
}

class _JoinAgencyScreenState extends State<JoinAgencyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _agencyIdController = TextEditingController();
  final _messageController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _agencyIdController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    setState(() => _submitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Agency request submitted successfully.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProfileSectionScaffold(
      title: 'Join Agency',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileSectionCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C3BFF), Color(0xFFB43EFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.handshake_rounded, color: Colors.amber, size: 42),
                  const SizedBox(height: 14),
                  Text(
                    'Grow with an agency',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Join a verified agency to access host support, events, targets and creator growth opportunities.',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(.82),
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const ProfileSectionHeader(
              title: 'Benefits',
              subtitle: 'Agency benefits can be connected to your backend later.',
              icon: Icons.workspace_premium_outlined,
            ),
            const SizedBox(height: 12),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ProfileTag(text: 'Host support', icon: Icons.support_agent),
                ProfileTag(text: 'Special events', icon: Icons.celebration_outlined),
                ProfileTag(text: 'Growth targets', icon: Icons.trending_up),
                ProfileTag(text: 'Creator rewards', icon: Icons.card_giftcard),
              ],
            ),
            const SizedBox(height: 22),
            ProfileSectionCard(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProfileSectionHeader(
                      title: 'Agency application',
                      subtitle: 'Enter the agency ID supplied by the agency owner.',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _agencyIdController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.text,
                      decoration: _inputDecoration(
                        label: 'Agency ID',
                        icon: Icons.badge_outlined,
                        hint: 'e.g. AG-20458',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an agency ID.';
                        }
                        if (value.trim().length < 4) {
                          return 'Agency ID is too short.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      minLines: 3,
                      maxLines: 5,
                      decoration: _inputDecoration(
                        label: 'Message (optional)',
                        icon: Icons.chat_bubble_outline,
                        hint: 'Tell the agency owner a little about yourself.',
                      ),
                    ),
                    const SizedBox(height: 18),
                    ProfilePrimaryButton(
                      label: _submitting ? 'Submitting...' : 'Send Request',
                      icon: Icons.send_rounded,
                      onPressed: _submitting ? null : _submit,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            ProfileSectionCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Colors.amber),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Current status: Not in an agency. Once Firestore/API fields are confirmed, this screen can show real membership and request status.',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white30),
      prefixIcon: Icon(icon, color: Colors.amber),
      filled: true,
      fillColor: Colors.black.withOpacity(.22),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.purpleAccent.withOpacity(.35)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.purpleAccent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}
