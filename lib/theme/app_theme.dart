import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppTheme {

  static const Color background =
  Color(0xff020D0A);

  static const Color surface =
  Color(0xff071B17);

  static const Color primary =
  Color(0xff00D9B5);

  static const Color secondary =
  Color(0xffFFD166);


  static ThemeData darkTheme = ThemeData(

    brightness: Brightness.dark,


    scaffoldBackgroundColor:
    background,


    primaryColor:
    primary,


    fontFamily:
    GoogleFonts.poppins().fontFamily,


    textTheme:
    GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    ).apply(

      bodyColor:
      Colors.white,

      displayColor:
      Colors.white,

    ).copyWith(

      headlineLarge:
      GoogleFonts.poppins(

        color: Colors.white,

        fontSize: 26,

        fontWeight:
        FontWeight.w700,

      ),


      titleLarge:
      GoogleFonts.poppins(

        color: Colors.white,

        fontSize: 18,

        fontWeight:
        FontWeight.w600,

      ),


      bodyMedium:
      GoogleFonts.poppins(

        color:
        Colors.white70,

        fontSize:14,

      ),

    ),



    colorScheme:
    const ColorScheme.dark(

      primary:
      primary,


      secondary:
      secondary,


      surface:
      surface,


    ),



    appBarTheme:
    const AppBarTheme(

      backgroundColor:
      background,


      elevation:
      0,


      iconTheme:
      IconThemeData(

        color:
        Colors.white,

      ),

    ),



    bottomNavigationBarTheme:
    const BottomNavigationBarThemeData(

      backgroundColor:
      surface,


      selectedItemColor:
      primary,


      unselectedItemColor:
      Colors.white38,


      selectedLabelStyle:
      TextStyle(

        fontWeight:
        FontWeight.w600,

      ),


      type:
      BottomNavigationBarType.fixed,

    ),



    cardTheme:
    CardThemeData(

      color:
      Colors.white.withValues(
        alpha:0.06,
      ),


      elevation:
      0,


      margin:
      EdgeInsets.zero,


      shape:
      RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(20),

      ),

    ),



    elevatedButtonTheme:
    ElevatedButtonThemeData(

      style:
      ElevatedButton.styleFrom(


        backgroundColor:
        primary,


        foregroundColor:
        Colors.black,


        elevation:
        0,


        padding:
        const EdgeInsets.symmetric(

          horizontal:24,

          vertical:12,

        ),



        shape:
        RoundedRectangleBorder(

          borderRadius:
          BorderRadius.circular(22),

        ),


        textStyle:
        GoogleFonts.poppins(

          fontWeight:
          FontWeight.w600,

        ),

      ),

    ),



    inputDecorationTheme:
    InputDecorationTheme(

      filled:true,


      fillColor:
      Colors.white.withValues(
        alpha:.06,
      ),


      border:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(18),

        borderSide:
        BorderSide.none,

      ),

    ),


  );

}