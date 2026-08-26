import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';

import 'package:junaya_voicechat_app/screens/moments/widgets/moment_header.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moment_media.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/reaction_bar.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/reaction_summary.dart';





class MomentCard extends StatelessWidget {



  final Moment moment;



  final VoidCallback onDelete;



  final VoidCallback? onLike;

  final VoidCallback? onComment;

  final VoidCallback? onShare;

  final VoidCallback? onSave;







  const MomentCard({

    super.key,


    required this.moment,


    required this.onDelete,


    this.onLike,


    this.onComment,


    this.onShare,


    this.onSave,


  });









  @override
  Widget build(BuildContext context) {



    return Container(


      margin:

      const EdgeInsets.symmetric(

        horizontal: 12,

        vertical: 8,

      ),





      decoration:

      BoxDecoration(


        color:

        const Color(0xff101010),



        borderRadius:

        BorderRadius.circular(26),



        border:

        Border.all(

          color:

          Colors.white10,

        ),


      ),





      child:

      Column(



        crossAxisAlignment:

        CrossAxisAlignment.start,



        children: [





          MomentHeader(


            moment:

            moment,



            onDelete:

                () => _confirmDelete(

              context,

            ),


          ),







          if(moment.caption.trim().isNotEmpty)

            Padding(


              padding:

              const EdgeInsets.fromLTRB(

                16,

                8,

                16,

                12,

              ),



              child:

              Text(


                moment.caption,



                style:

                const TextStyle(


                  color:

                  Colors.white,



                  fontSize:

                  16,



                  height:

                  1.45,



                ),



              ),



            ),









          if(moment.media.isNotEmpty)

            MomentMediaWidget(


              media:

              moment.media,


            ),







          if(moment.hashtags.isNotEmpty)

            Padding(


              padding:

              const EdgeInsets.symmetric(

                horizontal: 16,

              ),



              child:

              Wrap(


                spacing:

                8,



                children:

                moment.hashtags.map(


                      (tag){


                    return Text(


                      "#$tag",



                      style:

                      const TextStyle(


                        color:

                        Colors.purpleAccent,



                        fontSize:

                        13,


                      ),


                    );


                  },


                ).toList(),



              ),


            ),







          const SizedBox(

            height:

            12,

          ),







          ReactionBar(


            moment:

            moment,



            onLike:

            onLike,



            onComment:

            onComment,



            onShare:

            onShare,



            onSave:

            onSave,


          ),







          if(moment.reactions.isNotEmpty)

            ReactionSummary(


              reactions:

              moment.reactions,


            ),







          const SizedBox(

            height:

            12,

          ),



        ],


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

                  () => Navigator.pop(

                context,

              ),



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