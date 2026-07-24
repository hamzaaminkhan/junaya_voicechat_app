import 'package:flutter/material.dart';



class MicSeat extends StatelessWidget {


  final String? username;

  final bool micOn;



  const MicSeat({

    super.key,

    this.username,

    this.micOn=false,

  });




  @override
  Widget build(BuildContext context){


    return Column(

      children:[


        Container(

          height:70,

          width:70,


          decoration:BoxDecoration(


            shape:
            BoxShape.circle,


            border:Border.all(

              color:

              micOn

                  ?

              Colors.greenAccent

                  :

              Colors.grey,


              width:3,


            ),


          ),



          child:
          const Icon(

            Icons.person,

            color:Colors.white,

            size:35,

          ),



        ),



        const SizedBox(height:5),



        Text(

          username ?? "Empty",

          style:
          const TextStyle(

            color:Colors.white,

            fontSize:12,

          ),


        ),



        Icon(

          micOn

              ?

          Icons.mic

              :

          Icons.mic_off,


          color:

          micOn

              ?

          Colors.green

              :

          Colors.red,


          size:18,


        )


      ],


    );



  }

}