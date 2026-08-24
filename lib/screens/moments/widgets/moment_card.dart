import 'dart:io';

import 'package:junaya_voicechat_app/screens/moments/widgets/moment_header.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moment_media.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/moments_provider.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/reaction_bar.dart';



class MomentCard extends ConsumerWidget {

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
      WidgetRef ref,
      ) {

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xff151515),
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _header(context),

          const SizedBox(height: 15),

          Text(
            moment.caption,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 12),

          MomentMediaWidget(
            media: moment.media,
          ),

          const SizedBox(height: 15),

          _actions(ref),

        ],
      ),
    );
  }





  Widget _header(BuildContext context) {

    return MomentHeader(

      moment: moment,

      onDelete: onDelete,

    );
  }







  Widget _media() {

    return SizedBox(

      height: 220,

      child: ListView.builder(

        scrollDirection:
        Axis.horizontal,


        itemCount:
        moment.media.length,


        itemBuilder:
            (_, index) {


          final media =
          moment.media[index];



          return Container(

            width: 220,

            margin:
            const EdgeInsets.only(
              right: 10,
            ),


            decoration:
            BoxDecoration(

              borderRadius:
              BorderRadius.circular(
                18,
              ),

            ),


            clipBehavior:
            Clip.antiAlias,


            child:
            _mediaImage(
              media.url,
            ),

          );

        },

      ),

    );

  }







  Widget _mediaImage(
      String path,
      ) {

    if(path.startsWith('http')) {

      return Image.network(
        path,
        fit: BoxFit.cover,

        errorBuilder:
            (_,_,_) {

          return _brokenImage();

        },
      );

    }


    return Image.file(

      File(path),

      fit:
      BoxFit.cover,


      errorBuilder:
          (_,_,_) {

        return _brokenImage();

      },

    );

  }







  Widget _actions(
      WidgetRef ref,
      ) {

    return ReactionBar(
      moment: moment,
    );

  }


  void _confirmDelete(
      BuildContext context,
      ) {

    showDialog(
      context: context,

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
                  () =>
                  Navigator.pop(
                    context,
                  ),

              child:
              const Text(
                "Cancel",
              ),

            ),



            TextButton(

              onPressed: () {

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








  Widget _brokenImage() {

    return Container(

      color:
      Colors.black26,


      child:
      const Icon(
        Icons.broken_image,
        color: Colors.white54,
      ),

    );

  }



}