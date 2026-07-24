import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CategoryChip extends StatelessWidget {


  final String text;
  final bool active;


  const CategoryChip({

    super.key,

    required this.text,

    this.active=false,

  });



  @override
  Widget build(BuildContext context){


    return Container(


      padding:
      const EdgeInsets.symmetric(

        horizontal:12,

        vertical:5,

      ),



      margin:
      const EdgeInsets.only(right:10),



      decoration:
      BoxDecoration(


        color:
        active

            ? Colors.amber

            : Colors.transparent,



        borderRadius:
        BorderRadius.circular(25),



        border:
        Border.all(

          color:
          active

              ? Colors.amber

              : Colors.purpleAccent,

          width:1,

        ),



        boxShadow:

        active

            ?

        [

          BoxShadow(

            color:
            Colors.amber.withOpacity(.1),

            blurRadius:15,

          )

        ]

            :

        [],




      ),





      child:
      Text(


        text,


        style:
        GoogleFonts.poppins(

          color:

          active

              ?

          Colors.black

              :

          Colors.white,


          fontWeight:
          FontWeight.w600,


          fontSize:10,

        ),



      ),



    );



  }


}