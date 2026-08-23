import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JunayaFonts {
  // Brand / logo / premium titles
  static TextStyle brand({
    double size = 28,
    Color color = Colors.white,
  }) {
    return GoogleFonts.cinzel(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
    );
  }

  // Normal app text
  static TextStyle body({
    double size = 14,
    Color color = Colors.white,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.w400,
    );
  }

  // Section titles
  static TextStyle heading({
    double size = 20,
    Color color = Colors.white,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.w700,
    );
  }

  // VIP / diamonds / coins
  static TextStyle vip({
    double size = 18,
    Color color = const Color(0xFFFFC857),
  }) {
    return GoogleFonts.montserrat(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.w800,
    );
  }

  // Gift names / legendary effects
  static TextStyle gift({
    double size = 18,
    Color color = Colors.white,
  }) {
    return GoogleFonts.orbitron(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
    );
  }
}