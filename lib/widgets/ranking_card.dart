import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class RankingCard extends StatelessWidget {


  final String title;
  final String icon;
  final Color color;



  const RankingCard({

    super.key,

    required this.title,

    required this.icon,

    required this.color,

  });



  @override
  Widget build(BuildContext context){


    return Container(


      width:110,

      height:3,


      margin:
      const EdgeInsets.symmetric(horizontal:5),



      decoration:
      BoxDecoration(


          gradient:
          LinearGradient(

            colors:[

              color.withOpacity(.6),

              color.withOpacity(.38),

            ],

            begin:
            Alignment.topLeft,

            end:
            Alignment.bottomRight,

          ),



          borderRadius:
          BorderRadius.circular(22),



          boxShadow:[


            BoxShadow(

              color:
              color.withOpacity(.1),

              blurRadius:1,

              spreadRadius:1,

            )

          ]


      ),




      child:
      Column(

        mainAxisAlignment:
        MainAxisAlignment.center,


        children:[



          Text(

            icon,


            style:
            const TextStyle(

              fontSize:6,

            ),


          ),




          const SizedBox(height:3),





          Text(

            title,


            textAlign:
            TextAlign.center,


            style:
            GoogleFonts.poppins(


              color:
              Colors.white,


              fontSize:10,


              fontWeight:
              FontWeight.w700,


            ),


          ),



        ],


      ),


    );


  }


}