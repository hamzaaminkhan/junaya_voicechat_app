import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';

import 'package:junaya_voicechat_app/screens/moments/widgets/moment_media.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moment_header.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/reaction_bar.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/comments_bottom_sheet.dart';



class MomentDetailScreen extends StatelessWidget {


  final Moment moment;



  const MomentDetailScreen({

    super.key,

    required this.moment,

  });





  @override
  Widget build(
      BuildContext context,
      ) {


    return Scaffold(

      backgroundColor:
      const Color(0xff090909),



      appBar:
      AppBar(

        backgroundColor:
        Colors.transparent,


        elevation:
        0,


        iconTheme:
        const IconThemeData(

          color:
          Colors.white,

        ),



        title:
        const Text(

          "Moment",

          style:
          TextStyle(

            color:
            Colors.white,

            fontWeight:
            FontWeight.bold,

          ),

        ),

      ),





      body:
      ListView(

        padding:
        const EdgeInsets.only(

          bottom:
          40,

        ),



        children: [



          // HEADER

          MomentHeader(

            moment:
            moment,


            onDelete:
                () {


              Navigator.pop(
                context,
              );


            },

          ),





          const SizedBox(
            height:
            16,
          ),





          // MEDIA


          if(moment.media.isNotEmpty)

            SizedBox(

              height:
              300,


              child:
              ListView.builder(

                scrollDirection:
                Axis.horizontal,


                padding:
                const EdgeInsets.symmetric(

                  horizontal:
                  16,

                ),



                itemCount:
                moment.media.length,



                itemBuilder:
                    (context,index) {


                  final media =
                  moment.media[index];



                  return Padding(

                    padding:
                    const EdgeInsets.only(

                      right:
                      12,

                    ),



                    child:
                    SizedBox(

                      width:
                      280,


                      child:
                      MomentMediaWidget(

                        media:

                        [

                          media,

                        ],

                      ),

                    ),

                  );


                },

              ),

            ),





          const SizedBox(
            height:
            20,
          ),






          // CAPTION


          Padding(

            padding:
            const EdgeInsets.symmetric(

              horizontal:
              16,

            ),



            child:
            Text(

              moment.caption,


              style:
              const TextStyle(

                color:
                Colors.white,


                fontSize:
                18,

              ),

            ),

          ),





          const SizedBox(
            height:
            20,
          ),





          // REACTIONS


          Padding(

            padding:
            const EdgeInsets.symmetric(

              horizontal:
              16,

            ),



            child:
            ReactionBar(

              moment:
              moment,

            ),

          ),





          const SizedBox(
            height:
            20,
          ),





          // COMMENTS BUTTON


          Padding(

            padding:
            const EdgeInsets.symmetric(

              horizontal:
              16,

            ),



            child:
            ElevatedButton.icon(



              style:
              ElevatedButton.styleFrom(

                backgroundColor:
                const Color(
                  0xff1c1c1c,
                ),


              ),





              icon:
              const Icon(

                Icons.comment,

                color:
                Colors.white,

              ),





              label:
              Text(

                "${moment.stats.comments} Comments",


                style:
                const TextStyle(

                  color:
                  Colors.white,

                ),

              ),





              onPressed:
                  () {


                showModalBottomSheet(

                  context:
                  context,


                  backgroundColor:
                  Colors.transparent,



                  isScrollControlled:
                  true,



                  builder:
                      (_) {


                    return CommentsBottomSheet(

                      momentId:
                      moment.id,

                    );


                  },

                );


              },


            ),

          ),


        ],


      ),


    );


  }


}