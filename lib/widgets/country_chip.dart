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

      duration:
      const Duration(milliseconds:200),


      height:36,


      padding:
      const EdgeInsets.symmetric(
        horizontal:14,
      ),


      alignment:
      Alignment.center,


      decoration:BoxDecoration(

        color:

        active

            ?

        const Color(0xff00D9B5)
            .withValues(alpha:.18)

            :

        Colors.white.withValues(alpha:.06),


        borderRadius:
        BorderRadius.circular(20),


        border:Border.all(

          color:

          active

              ?

          const Color(0xff00D9B5)
              .withValues(alpha:.70)

              :

          Colors.white.withValues(alpha:.10),

        ),


        boxShadow:

        active

            ?

        [

          BoxShadow(

            color:
            const Color(0xff00D9B5)
                .withValues(alpha:.20),

            blurRadius:10,

          ),

        ]

            :

        [],

      ),



      child:Row(

        mainAxisSize:
        MainAxisSize.min,


        children:[


          Text(

            flag,

            style:
            const TextStyle(
              fontSize:14,
            ),

          ),


          const SizedBox(width:6),


          Text(

            name,


            style:
            GoogleFonts.poppins(

              fontSize:11,


              fontWeight:

              active

                  ?

              FontWeight.w700

                  :

              FontWeight.w500,


              color:

              active

                  ?

              Colors.white

                  :

              Colors.white60,

            ),

          ),

        ],

      ),

    );

  }

}