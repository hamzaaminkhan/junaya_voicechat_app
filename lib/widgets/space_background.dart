import 'package:flutter/material.dart';



class SpaceBackground extends StatelessWidget {


  final Widget child;



  const SpaceBackground({

    super.key,

    required this.child,

  });




  @override
  Widget build(BuildContext context){



    return Stack(

      children:[


        Positioned.fill(

          child:
          Image.asset(

            "assets/backgrounds/space_bg.jpeg",

            fit:
            BoxFit.cover,

          ),

        ),




        Positioned.fill(


          child:
          Container(


            color:
            Colors.black.withOpacity(.25),


          ),



        ),




        child,



      ],


    );



  }



}