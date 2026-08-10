import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../widgets/profile_section_shell.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  static const _preferenceKey = 'preferred_language';

  final List<Map<String, String>> _languages = const [
    {'name': 'English', 'code': 'en', 'native': 'English'},
    {'name': 'Urdu', 'code': 'ur', 'native': 'اردو'},
    {'name': 'Arabic', 'code': 'ar', 'native': 'العربية'},
    {'name': 'Hindi', 'code': 'hi', 'native': 'हिन्दी'},
    {'name': 'Spanish', 'code': 'es', 'native': 'Español'},
    {'name': 'French', 'code': 'fr', 'native': 'Français'},
  ];

  String _selectedCode = 'en';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;

    setState(() {
      _selectedCode = preferences.getString(_preferenceKey) ?? 'en';
      _loading = false;
    });
  }

  Future<void> _selectLanguage(String code, String name) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_preferenceKey, code);

    if (!mounted) return;
    setState(() => _selectedCode = code);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name preference saved.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProfileSectionScaffold(
      title: 'Language',
      child: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
              children: [
                const ProfileSectionCard(
                  child: ProfileSectionHeader(
                    title: 'Choose your language',
                    subtitle:
                        'This saves the user preference now. App-wide translations can be connected when localization files are added.',
                    icon: Icons.language_rounded,
                  ),
                ),
                const SizedBox(height: 14),
                ..._languages.map((language) {
                  final code = language['code']!;
                  final selected = code == _selectedCode;

                  return ProfileSectionCard(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.zero,
                    child: RadioListTile<String>(
                      value: code,
                      groupValue: _selectedCode,
                      activeColor: Colors.amber,
                      onChanged: (value) {
                        if (value != null) {
                          _selectLanguage(value, language['name']!);
                        }
                      },
                      title: Text(
                        language['name']!,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        language['native']!,
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      secondary: Container(
                        width: 42,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.amber.withValues(alpha: .14)
                              : Colors.white.withValues(alpha: .05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          code.toUpperCase(),
                          style: GoogleFonts.poppins(
                            color: selected ? Colors.amber : Colors.white54,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
