import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';



class MomentHeader extends StatelessWidget {

  final Moment moment;

  final VoidCallback onDelete;



  const MomentHeader({

    super.key,

    required this.moment,

    required this.onDelete,

  });



  @override
  Widget build(BuildContext context) {

    return Row(

      children: [

        CircleAvatar(

          radius: 22,

          backgroundImage:
          moment.author.avatar.isNotEmpty
              ? AssetImage(
            moment.author.avatar,
          )
              : null,


          child:
          moment.author.avatar.isEmpty

              ? const Icon(
            Icons.person,
          )

              : null,

        ),



        const SizedBox(
          width: 12,
        ),



        Expanded(

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,


            children: [

              Text(

                moment.author.displayName,

                style:
                const TextStyle(

                  color:
                  Colors.white,

                  fontWeight:
                  FontWeight.bold,

                  fontSize:
                  15,

                ),

              ),



              const SizedBox(
                height: 3,
              ),



              Text(

                _formatDate(
                  moment.createdAt,
                ),


                style:
                const TextStyle(

                  color:
                  Colors.white54,

                  fontSize:
                  12,

                ),

              ),

            ],

          ),

        ),




        PopupMenuButton<String>(

          icon:

          const Icon(

            Icons.more_vert,

            color:
            Colors.white,

          ),



          onSelected:

              (value) {


            if(value == 'delete') {

              onDelete();

            }


          },



          itemBuilder:

              (_) => [

            const PopupMenuItem(

              value:
              'delete',


              child:
              Text(
                "Delete",
              ),

            ),

          ],

        ),

      ],

    );

  }






  String _formatDate(
      DateTime date,
      ) {

    final now =
    DateTime.now();


    final difference =
    now.difference(date);



    if(difference.inMinutes < 1) {

      return "Just now";

    }



    if(difference.inHours < 1) {

      return "${difference.inMinutes} min ago";

    }



    if(difference.inDays < 1) {

      return "${difference.inHours} hours ago";

    }



    if(difference.inDays < 7) {

      return "${difference.inDays} days ago";

    }



    return "${date.day}/${date.month}/${date.year}";

  }

}