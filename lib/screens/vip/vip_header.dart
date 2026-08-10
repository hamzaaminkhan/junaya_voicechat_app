import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VipHeader extends StatelessWidget {
  const VipHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff6C3BFF), Color(0xffB43EFF)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purpleAccent.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Crown
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber,
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withValues(alpha: .45),
                  blurRadius: 25,
                ),
              ],
            ),
            child: const Icon(
              Icons.workspace_premium,
              size: 55,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "VIP MEMBER",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Unlock Premium Features",
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
          ),

          const SizedBox(height: 25),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),

                const SizedBox(width: 8),

                Text(
                  "Current Level : VIP 0",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          LinearProgressIndicator(
            value: .15,
            minHeight: 8,
            borderRadius: BorderRadius.circular(20),
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation(Colors.amber),
          ),

          const SizedBox(height: 10),

          Text(
            "15% Progress to VIP 1",
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
