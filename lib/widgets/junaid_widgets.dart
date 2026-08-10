import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ================= GLASS CARD =================

class GlassCard extends StatelessWidget {
  final Widget child;

  final double radius;

  const GlassCard({super.key, required this.child, this.radius = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .08),

        borderRadius: BorderRadius.circular(radius),

        border: Border.all(
          color: Colors.purpleAccent.withValues(alpha: .45),

          width: 1,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.purpleAccent.withValues(alpha: .25),

            blurRadius: 25,

            spreadRadius: 2,
          ),
        ],
      ),

      child: child,
    );
  }
}

// ================= NEON BORDER =================

class NeonBox extends StatelessWidget {
  final Widget child;

  const NeonBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.blue, Colors.pink],
        ),

        borderRadius: BorderRadius.circular(15),
      ),

      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff090019),

          borderRadius: BorderRadius.circular(25),
        ),

        child: child,
      ),
    );
  }
}

// ================= PREMIUM BUTTON =================

class GoldButton extends StatelessWidget {
  final String text;

  final VoidCallback onTap;

  const GoldButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 20,

        width: double.infinity,

        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xffffd700), Color(0xffff9800)],
          ),

          borderRadius: BorderRadius.circular(10),

          boxShadow: [
            BoxShadow(
              color: Colors.amber.withValues(alpha: .5),
              blurRadius: 20,
            ),
          ],
        ),

        child: Center(
          child: Text(
            text,

            style: GoogleFonts.poppins(
              fontSize: 15,

              fontWeight: FontWeight.bold,

              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

// ================= NEON TAB =================

class NeonTab extends StatelessWidget {
  final String text;

  final bool active;

  final VoidCallback onTap;

  const NeonTab({
    super.key,

    required this.text,

    required this.active,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),

        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

        decoration: BoxDecoration(
          color: active ? Colors.amber : Colors.transparent,

          borderRadius: BorderRadius.circular(30),

          border: Border.all(
            color: active ? Colors.amber : Colors.purpleAccent,
          ),

          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: .5),
                    blurRadius: 10,
                  ),
                ]
              : [],
        ),

        child: Text(
          text,

          style: GoogleFonts.poppins(
            color: active ? Colors.black : Colors.white,

            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ================= ROOM GLOW AVATAR =================

class MicAvatar extends StatelessWidget {
  const MicAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,

      width: 150,

      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.purple, Colors.blue]),

        borderRadius: BorderRadius.circular(5),

        boxShadow: [
          BoxShadow(color: Colors.blue.withValues(alpha: .6), blurRadius: 15),
        ],
      ),

      child: const Icon(Icons.mic, color: Colors.white, size: 20),
    );
  }
}
