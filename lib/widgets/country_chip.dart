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

    this.active=false,

  });



  @override
  Widget build(BuildContext context){


    return Container(



      margin:
      const EdgeInsets.only(right:8),



      padding:
      const EdgeInsets.symmetric(

        horizontal:7,

        vertical:5,

      ),



      decoration:
      BoxDecoration(



        color:

        active

            ?

        Colors.amber

            :

        Colors.white.withOpacity(.08),




        borderRadius:
        BorderRadius.circular(22),



        border:
        Border.all(

          color:
          Colors.purpleAccent,

        ),



      ),




      child:
      Text(


        "$flag $name",


        style:
        GoogleFonts.poppins(


          fontSize:12,


          fontWeight:
          FontWeight.w600,


          color:

          active

              ?

          Colors.black

              :

          Colors.white,


        ),



      ),



    );



  }



}