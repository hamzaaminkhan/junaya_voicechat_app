import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateSeparator extends StatelessWidget {
  final String date;

  const DateSeparator({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Colors.white24, thickness: 1)),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xff232741),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                date,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const Expanded(child: Divider(color: Colors.white24, thickness: 1)),
        ],
      ),
    );
  }
}
