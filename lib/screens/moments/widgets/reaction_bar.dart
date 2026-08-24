import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/moments_provider.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/comments_bottom_sheet.dart';



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


        GestureDetector(

          onTap: () {

            ref
                .read(
              momentsProvider.notifier,
            )
                .toggleLike(
              moment,
            );

          },


          child: Icon(

            moment.isLiked
                ? Icons.favorite
                : Icons.favorite_border,


            color:
            Colors.pinkAccent,


            size:
            26,

          ),

        ),





        const SizedBox(
          width: 6,
        ),



        Text(

          "${moment.likesCount}",


          style:
          const TextStyle(

            color:
            Colors.white,

          ),

        ),





        const SizedBox(
          width: 22,
        ),





        GestureDetector(

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


          child:

          const Icon(

            Icons.chat_bubble_outline,


            color:
            Colors.white54,


            size:
            24,

          ),

        ),





        const SizedBox(
          width: 6,
        ),



        Text(

          "${moment.commentsCount}",


          style:
          const TextStyle(

            color:
            Colors.white,

          ),

        ),


      ],

    );

  }

}