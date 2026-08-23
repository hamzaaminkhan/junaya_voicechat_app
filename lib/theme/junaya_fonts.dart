
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JunayaFonts {
  static TextStyle brand({double size = 18}) => GoogleFonts.cinzel(
    fontSize: size,
    color: Colors.white,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.8,
  );

  static TextStyle heading({double size = 20}) => GoogleFonts.poppins(
    fontSize: size,
    color: Colors.white,
    fontWeight: FontWeight.w700,
  );

  static TextStyle body({double size = 14}) => GoogleFonts.poppins(
    fontSize: size,
    color: Colors.white70,
    fontWeight: FontWeight.w500,
  );

  static TextStyle vip({double size = 14}) => GoogleFonts.montserrat(
    fontSize: size,
    color: Color(0xFFFFC857),
    fontWeight: FontWeight.w800,
  );
}
