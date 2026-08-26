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


    if(reactions.isEmpty){

      return const SizedBox.shrink();

    }



    final Map<String,int> counts = {};



    for(final reaction in reactions){

      counts[reaction.emoji] =

          (counts[reaction.emoji] ?? 0) + 1;

    }



    final sorted = counts.entries.toList()

      ..sort(

            (a,b) =>

            b.value.compareTo(a.value),

      );



    return Container(

      margin:

      const EdgeInsets.only(

        top: 10,

      ),



      padding:

      const EdgeInsets.symmetric(

        horizontal: 12,

        vertical: 8,

      ),



      decoration:

      BoxDecoration(

        color:

        const Color(0xff202020),


        borderRadius:

        BorderRadius.circular(18),

      ),



      child: Wrap(

        spacing: 12,

        runSpacing: 6,


        children:

        sorted.map(

              (entry){


            return Row(

              mainAxisSize:

              MainAxisSize.min,


              children: [


                Text(

                  entry.key,

                  style:

                  const TextStyle(

                    fontSize: 16,

                  ),

                ),



                const SizedBox(

                  width: 4,

                ),



                Text(

                  entry.value.toString(),

                  style:

                  const TextStyle(

                    color:

                    Colors.white70,

                    fontSize:

                    13,

                    fontWeight:

                    FontWeight.w600,

                  ),

                ),

              ],

            );


          },

        ).toList(),

      ),

    );

  }

}