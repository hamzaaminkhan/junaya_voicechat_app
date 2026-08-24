import 'package:flutter/material.dart';


class ReactionPicker extends StatelessWidget {

  final Function(String emoji) onSelected;


  const ReactionPicker({

    super.key,

    required this.onSelected,

  });



  static const List<String> reactions = [

    "❤️",
    "😂",
    "😍",
    "😮",
    "😢",
    "🔥",

  ];



  @override
  Widget build(BuildContext context) {


    return Container(

      padding:
      const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),


      decoration:
      BoxDecoration(

        color:
        const Color(0xff222222),

        borderRadius:
        BorderRadius.circular(30),

      ),



      child:
      Row(

        mainAxisSize:
        MainAxisSize.min,


        children:

        reactions.map(

              (emoji) {


            return GestureDetector(

              onTap: () {

                onSelected(
                  emoji,
                );

              },


              child:

              Padding(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 8,
                ),


                child:
                Text(

                  emoji,

                  style:
                  const TextStyle(
                    fontSize: 26,
                  ),

                ),

              ),

            );


          },

        )
            .toList(),


      ),

    );

  }

}