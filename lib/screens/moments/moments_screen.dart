import 'package:flutter/material.dart';


class MomentsScreen extends StatelessWidget {

  const MomentsScreen({super.key});


  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar:AppBar(

        backgroundColor: Colors.transparent,

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