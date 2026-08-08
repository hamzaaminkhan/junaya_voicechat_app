import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CountryChip extends StatelessWidget {
  final String name;
  final String flag;
  final bool active;

  const CountryChip({
    super.key,
    required this.name,
    required this.flag,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active
            ? Colors.white.withOpacity(.10)
            : Colors.black.withOpacity(.10),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: active
              ? const Color(0xFFB86BE8).withOpacity(.70)
              : Colors.white.withOpacity(.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            flag,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 5),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 10.5,
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              color: active ? Colors.white : Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
}
