import 'package:flutter/material.dart';



class CreateMomentButton extends StatelessWidget {


  final VoidCallback onPressed;



  const CreateMomentButton({

    super.key,

    required this.onPressed,

  });





  @override
  Widget build(BuildContext context) {


    return FloatingActionButton(

      onPressed:

      onPressed,


      backgroundColor:

      Colors.purpleAccent,



      child:

      const Icon(

        Icons.add,

        color:

        Colors.white,

      ),


    );


  }


}