import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xff050018),

    primaryColor: Colors.amber,

    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.white,

      displayColor: Colors.white,
    ),

    colorScheme: const ColorScheme.dark(
      primary: Colors.amber,

      secondary: Colors.purpleAccent,

      surface: Color(0xff0B0820),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff080020),

      elevation: 0,

      iconTheme: IconThemeData(color: Colors.white),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xff080020),

      selectedItemColor: Colors.amber,

      unselectedItemColor: Colors.white54,

      type: BottomNavigationBarType.fixed,
    ),

    cardTheme: CardThemeData(
      color: Colors.white.withValues(alpha: 0.08),

      elevation: 0,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,

        foregroundColor: Colors.black,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
  );
}
