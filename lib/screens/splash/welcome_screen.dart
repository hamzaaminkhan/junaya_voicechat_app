import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../widgets/space_background.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, .035),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SpaceBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          _logoSection(),
                          const SizedBox(height: 26),
                          _heroText(),
                          const SizedBox(height: 28),
                          _featureRow(),
                          const SizedBox(height: 28),
                          _descriptionCard(),
                          const SizedBox(height: 28),
                          _primaryButton(),
                          const SizedBox(height: 14),
                          _signInRow(),
                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _logoSection() {
    return Column(
      children: [
        Hero(
          tag: 'logo',
          child: Container(
            width: 92,
            height: 92,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.black.withValues(alpha: .16),
              border: Border.all(color: Colors.white.withValues(alpha: .12)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset('assets/logo.png', fit: BoxFit.contain),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'JUNAYA',
          style: GoogleFonts.poppins(
            color: const Color(0xFFFFC94D),
            fontSize: 25,
            fontWeight: FontWeight.w800,
            letterSpacing: 3.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'VOICE CHAT',
          style: GoogleFonts.poppins(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.6,
          ),
        ),
      ],
    );
  }

  Widget _heroText() {
    return Column(
      children: [
        Text(
          'Meet. Talk. Connect.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Text(
            'Join live voice rooms, meet new people and enjoy meaningful conversations from anywhere.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white60,
              fontSize: 13,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }

  Widget _featureRow() {
    return Row(
      children: [
        Expanded(
          child: _featureChip(
            icon: Icons.mic_none_rounded,
            label: 'Voice Rooms',
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _featureChip(
            icon: Icons.card_giftcard_rounded,
            label: 'Gifts',
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _featureChip(
            icon: Icons.workspace_premium_outlined,
            label: 'VIP',
          ),
        ),
      ],
    );
  }

  Widget _featureChip({required IconData icon, required String label}) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: .10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFFFFC94D), size: 23),
          const SizedBox(height: 5),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: .88),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _descriptionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: .09)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFFC94D).withValues(alpha: .10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.public_rounded,
              color: Color(0xFFFFC94D),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A global voice community',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Discover rooms, connect with communities and enjoy live conversations in one place.',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 11.5,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _primaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _goToLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFC83D),
          foregroundColor: const Color(0xFF120915),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          'Get Started',
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _signInRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12.5),
        ),
        GestureDetector(
          onTap: _goToLogin,
          child: Text(
            'Sign In',
            style: GoogleFonts.poppins(
              color: const Color(0xFFFFC94D),
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
