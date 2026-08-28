import 'package:flutter/material.dart';


class CreateMomentButton extends StatelessWidget {


  final VoidCallback onPressed;


  const CreateMomentButton({

    super.key,

    required this.onPressed,

  });



  @override
  Widget build(BuildContext context) {


    return GestureDetector(

      onTap:onPressed,


      child: Container(

        width:60,

        height:60,


        decoration:BoxDecoration(


          shape:BoxShape.circle,


          gradient:const LinearGradient(

            begin:Alignment.topLeft,

            end:Alignment.bottomRight,


            colors:[

              Color(0xffA855F7),

              Color(0xff6D28D9),

            ],

          ),



          boxShadow:[


            BoxShadow(

              color:

              const Color(0xff8B5CF6)

                  .withOpacity(.45),


              blurRadius:30,


              spreadRadius:3,

            ),


          ],


        ),



        child:const Icon(

          Icons.add_rounded,


          size:34,


          color:Colors.white,

        ),

      ),

    );

  }

}