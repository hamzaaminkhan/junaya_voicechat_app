import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryChip extends StatelessWidget {
  final String text;
  final bool active;

  const CategoryChip({
    super.key,
    required this.text,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFFFFC857).withOpacity(.14)
            : Colors.black.withOpacity(.12),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: active
              ? const Color(0xFFFFC857).withOpacity(.72)
              : Colors.white.withOpacity(.09),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: active ? const Color(0xFFFFD36A) : Colors.white60,
          fontWeight: FontWeight.w600,
          fontSize: 10.5,
          letterSpacing: .25,
        ),
      ),
    );
  }
}
