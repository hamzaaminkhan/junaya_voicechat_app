import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';



class ReactionSummary extends StatelessWidget {

  final List<MomentReaction> reactions;


  const ReactionSummary({

    super.key,

    required this.reactions,

  });



  @override
  Widget build(BuildContext context) {


    if(reactions.isEmpty) {

      return const SizedBox();

    }



    final Map<String,int> counts = {};



    for(final reaction in reactions) {

      counts[reaction.emoji] =
          (counts[reaction.emoji] ?? 0) + 1;

    }



    return Container(

      margin:
      const EdgeInsets.only(
        top: 10,
      ),


      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),


      decoration:
      BoxDecoration(

        color:
        const Color(0xff222222),


        borderRadius:
        BorderRadius.circular(20),

      ),



      child:
      Row(

        mainAxisSize:
        MainAxisSize.min,


        children:

        counts.entries.map(

              (entry) {


            return Padding(

              padding:
              const EdgeInsets.only(
                right: 10,
              ),


              child:
              Text(

                "${entry.key} ${entry.value}",


                style:
                const TextStyle(

                  color:
                  Colors.white,

                  fontSize:
                  13,

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