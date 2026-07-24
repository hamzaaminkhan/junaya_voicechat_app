import 'package:flutter/material.dart';


class MomentsScreen extends StatelessWidget {

  const MomentsScreen({super.key});


  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:
      const Color(0xff0B0E21),


      appBar:AppBar(

        backgroundColor:
        const Color(0xff121530),

        title:
        const Text(

          "Moments",

          style:TextStyle(

            color:Colors.white,

          ),

        ),

      ),



      body:

      const Center(

        child:

        Text(

          "Moments",

          style:

          TextStyle(

            color:Colors.white,

            fontSize:22,

          ),

        ),

      ),


    );


  }


}