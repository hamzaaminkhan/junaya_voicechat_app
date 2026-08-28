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

            (a,b)=> b.value.compareTo(a.value),

      );




    final emojis = sorted

        .take(4)

        .map((e)=>e.key)

        .join(" ");




    final total = reactions.length;




    return Container(

      margin: const EdgeInsets.only(

        top:10,

        left:16,

        right:16,

      ),



      padding: const EdgeInsets.symmetric(

        horizontal:14,

        vertical:9,

      ),



      decoration: BoxDecoration(

        color: const Color(0xff151522),

        borderRadius: BorderRadius.circular(16),

      ),



      child: Row(

        children: [



          Text(

            emojis,


            style: const TextStyle(

              fontSize:18,

              letterSpacing:2,

            ),

          ),




          const SizedBox(width:10),




          Expanded(

            child: Text(

              "You and ${total - 1} others",


              overflow: TextOverflow.ellipsis,


              style: const TextStyle(

                color: Color(0xffB8B8C8),

                fontSize:14,

                fontWeight:FontWeight.w500,

              ),

            ),

          ),



        ],

      ),

    );

  }

}