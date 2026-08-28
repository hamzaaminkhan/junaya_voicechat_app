import 'package:flutter/material.dart';


class ReactionPicker extends StatelessWidget {

  final Function(String emoji) onSelected;


  const ReactionPicker({

    super.key,

    required this.onSelected,

  });



  static const List<String> reactions = [

    "❤️",

    "🔥",

    "😂",

    "😍",

    "👏",

    "😮",

    "😢",

    "✨",

  ];



  @override
  Widget build(BuildContext context) {


    return Container(

      padding:

      const EdgeInsets.all(20),


      decoration:

      BoxDecoration(

        color:

        const Color(0xff151515),


        borderRadius:

        BorderRadius.circular(28),


        border:

        Border.all(

          color:
          Colors.white12,

        ),

      ),


      child:

      Wrap(

        alignment:

        WrapAlignment.center,


        spacing:

        18,


        runSpacing:

        18,


        children:

        reactions.map(

              (emoji){


            return GestureDetector(

              onTap:(){

                onSelected(
                  emoji,
                );

              },


              child:

              Container(

                width:
                48,

                height:
                48,


                decoration:

                BoxDecoration(

                  color:
                  Colors.white10,


                  borderRadius:

                  BorderRadius.circular(
                    18,
                  ),

                ),


                child:

                Center(

                  child:

                  Text(

                    emoji,

                    style:

                    const TextStyle(

                      fontSize:
                      25,

                    ),

                  ),

                ),

              ),

            );

          },

        ).toList(),

      ),

    );

  }

}