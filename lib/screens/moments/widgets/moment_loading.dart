import 'package:flutter/material.dart';


class MomentLoading extends StatelessWidget {

  const MomentLoading({
    super.key,
  });


  @override
  Widget build(BuildContext context) {


    return ListView.builder(

      padding: const EdgeInsets.only(
        top:12,
      ),

      itemCount:3,


      itemBuilder:(context,index){


        return Container(

          height:320,

          margin: const EdgeInsets.symmetric(

            horizontal:14,

            vertical:8,

          ),


          decoration:BoxDecoration(

            color:
            const Color(0xff12121A),


            borderRadius:
            BorderRadius.circular(24),

          ),

        );

      },

    );

  }

}