import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';

import 'package:junaya_voicechat_app/screens/moments/widgets/moment_header.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moment_media.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/reaction_bar.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/reaction_summary.dart';



class MomentCard extends StatelessWidget {


  final Moment moment;


  final VoidCallback onDelete;



  const MomentCard({

    super.key,

    required this.moment,

    required this.onDelete,

  });





  @override
  Widget build(
      BuildContext context,
      ) {


    return Container(

      margin:
      const EdgeInsets.symmetric(

        horizontal:
        15,

        vertical:
        8,

      ),



      padding:
      const EdgeInsets.all(16),



      decoration:
      BoxDecoration(

        color:
        const Color(0xff151515),


        borderRadius:
        BorderRadius.circular(22),

      ),



      child:
      Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children: [



          _header(context),





          if(moment.caption.isNotEmpty)...[

            const SizedBox(
              height:
              15,
            ),



            Text(

              moment.caption,


              style:
              const TextStyle(

                color:
                Colors.white,

                fontSize:
                16,

              ),

            ),

          ],






          if(moment.media.isNotEmpty)...[

            const SizedBox(
              height:
              12,
            ),



            MomentMediaWidget(

              media:
              moment.media,

            ),

          ],





          if(moment.hashtags.isNotEmpty)

            _hashtags(),





          const SizedBox(
            height:
            15,
          ),





          _stats(),





          const SizedBox(
            height:
            12,
          ),





          ReactionBar(

            moment:
            moment,

          ),





          const SizedBox(
            height:
            8,
          ),





          ReactionSummary(

            reactions:
            moment.reactions,

          ),


        ],

      ),

    );


  }








  Widget _header(
      BuildContext context,
      ){


    return MomentHeader(

      moment:
      moment,


      onDelete:
          () => _confirmDelete(
        context,
      ),

    );


  }








  Widget _stats(){


    return Row(

      children: [



        _statItem(

          Icons.favorite,

          moment.stats.likes,

        ),





        const SizedBox(
          width:
          20,
        ),





        _statItem(

          Icons.comment,

          moment.stats.comments,

        ),





        const Spacer(),





        if(moment.isPinned)

          const Icon(

            Icons.push_pin,

            color:
            Colors.amber,

            size:
            18,

          ),


      ],

    );


  }








  Widget _statItem(

      IconData icon,

      int value,

      ){


    return Row(

      children: [



        Icon(

          icon,

          color:
          Colors.white54,

          size:
          18,

        ),





        const SizedBox(
          width:
          5,
        ),





        Text(

          value.toString(),


          style:
          const TextStyle(

            color:
            Colors.white70,

          ),

        ),


      ],

    );


  }








  Widget _hashtags(){


    return Padding(

      padding:
      const EdgeInsets.only(

        top:
        12,

      ),



      child:
      Wrap(

        spacing:
        6,


        children:

        moment.hashtags.map(

              (tag){

            return Text(

              "#$tag",


              style:
              const TextStyle(

                color:
                Colors.purpleAccent,

              ),

            );


          },

        ).toList(),


      ),

    );


  }








  void _confirmDelete(
      BuildContext context,
      ){


    showDialog(

      context:
      context,


      builder:
          (_) {


        return AlertDialog(

          title:
          const Text(
            "Delete moment?",
          ),



          content:
          const Text(
            "This action cannot be undone.",
          ),



          actions: [



            TextButton(

              onPressed:
                  () {

                Navigator.pop(
                  context,
                );

              },


              child:
              const Text(
                "Cancel",
              ),

            ),





            TextButton(

              onPressed:
                  () {


                Navigator.pop(
                  context,
                );


                onDelete();


              },


              child:
              const Text(
                "Delete",
              ),

            ),


          ],

        );


      },

    );


  }



}