import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/moments_provider.dart';

import 'package:junaya_voicechat_app/screens/moments/widgets/comments_bottom_sheet.dart';

import 'reaction_picker.dart';



class ReactionBar extends ConsumerWidget {


  final Moment moment;



  const ReactionBar({

    super.key,

    required this.moment,

  });





  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {


    return Row(

      children: [


        // =============================
        // REACTION PICKER
        // =============================


        GestureDetector(

          onLongPress: () {


            _showReactionPicker(
              context,
              ref,
            );


          },


          child: const Icon(

            Icons.add_reaction_outlined,

            color:
            Colors.white54,

            size:
            24,

          ),

        ),





        const SizedBox(
          width: 8,
        ),





        // =============================
        // LIKES
        // =============================


        Text(

          moment.stats.likes.toString(),


          style:
          const TextStyle(

            color:
            Colors.white,

            fontSize:
            15,

          ),

        ),





        const SizedBox(
          width: 24,
        ),





        // =============================
        // COMMENTS BUTTON
        // =============================


        InkWell(

          borderRadius:
          BorderRadius.circular(20),


          onTap: () {


            showModalBottomSheet(

              context:
              context,


              isScrollControlled:
              true,


              backgroundColor:
              Colors.transparent,


              builder:
                  (_) {


                return CommentsBottomSheet(

                  momentId:
                  moment.id,

                );


              },

            );


          },


          child: const Icon(

            Icons.chat_bubble_outline,

            color:
            Colors.white54,

            size:
            24,

          ),

        ),





        const SizedBox(
          width: 8,
        ),





        // =============================
        // COMMENT COUNT
        // =============================


        Text(

          moment.stats.comments.toString(),


          style:
          const TextStyle(

            color:
            Colors.white,

            fontSize:
            15,

          ),

        ),


      ],

    );


  }








  void _showReactionPicker(

      BuildContext context,

      WidgetRef ref,

      ) {



    showDialog(

      context:
      context,


      barrierColor:
      Colors.black54,


      builder:
          (_) {


        return Dialog(

          backgroundColor:
          Colors.transparent,


          child:

          ReactionPicker(

            onSelected:
                (emoji) async {



              Navigator.pop(
                context,
              );



              await ref
                  .read(
                momentsProvider.notifier,
              )
                  .addReaction(

                moment:
                moment,


                userId:
                "local_user",


                emoji:
                emoji,

              );


            },

          ),


        );


      },

    );


  }



}