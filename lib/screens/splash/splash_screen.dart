import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/space_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: .94,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, .025),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    _continueAfterSplash();
  }

  Future<void> _continueAfterSplash() async {
    await Future.delayed(const Duration(milliseconds: 1800));

    if (!mounted) return;

    final auth = FirebaseAuth.instance;
    var user = auth.currentUser;

    if (user == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.intro);
      return;
    }

    // Refresh when possible, but do not throw away a valid cached session
    // just because the device is temporarily offline.
    try {
      await user.reload();
      user = auth.currentUser ?? user;
    } catch (_) {
      // Continue with the cached Firebase user.
    }

    if (!mounted) return;

    if (user?.email != null && !user!.emailVerified) {
      Navigator.pushReplacementNamed(context, AppRoutes.emailVerification);
      return;
    }

    await AuthService.instance.syncCurrentUserState();

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, AppRoutes.main);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SpaceBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildLogo(),
                            const SizedBox(height: 20),
                            _buildBrandName(),
                            const SizedBox(height: 5),
                            _buildTagline(),
                            const SizedBox(height: 28),
                            _buildLoadingIndicator(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 18,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildFooter(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Hero(
      tag: 'logo',
      child: Container(
        width: 112,
        height: 112,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: .14),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: .10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .16),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Image.asset('assets/logo.png', fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildBrandName() {
    return Text(
      'JUNAYA',
      style: GoogleFonts.poppins(
        color: const Color(0xFFFFC94D),
        fontSize: 27,
        fontWeight: FontWeight.w800,
        letterSpacing: 4,
      ),
    );
  }

  Widget _buildTagline() {
    return Text(
      'Connect • Talk • Enjoy',
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        color: Colors.white60,
        fontSize: 12.5,
        fontWeight: FontWeight.w400,
        letterSpacing: .3,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 120,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              minHeight: 3,
              backgroundColor: Color(0x22FFFFFF),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC94D)),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            'Starting Junaya...',
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 10.5),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          'JUNAYA VOICE CHAT',
          style: GoogleFonts.poppins(
            color: Colors.white30,
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Version 1.0.0',
          style: GoogleFonts.poppins(color: Colors.white24, fontSize: 9),
        ),
      ],
    );
  }
}
