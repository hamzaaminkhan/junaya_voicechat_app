import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _controller.forward();

    Future.delayed(const Duration(seconds: 10), () async {
      if (!mounted) return;

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.intro,
        );
        return;
      }

      await user.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser!;

      if (!refreshedUser.emailVerified) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.emailVerification,
        );
        return;
      }

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.home,
      );
    }
    );
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

      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Hero(
                  tag: "appLogo",
                  child: Image.asset(
                    "assets/logo.png",
                    height: 150,
                  ),
                ),

                 SizedBox(height: 30),

                Text(
                  "JUNAYA",
                  style: GoogleFonts.poppins(
                    color: AppColors.secondary,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Connect. Talk. Enjoy.",
                  style: GoogleFonts.poppins(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                const SizedBox(
                  width: 35,
                  height: 35,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.secondary,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  "Version 1.0.0",
                  style: GoogleFonts.poppins(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}