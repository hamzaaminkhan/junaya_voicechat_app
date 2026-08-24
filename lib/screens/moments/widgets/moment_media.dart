import 'dart:io';

import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';



class MomentMediaWidget extends StatelessWidget {

  final List<MomentMedia> media;


  const MomentMediaWidget({

    super.key,

    required this.media,

  });



  @override
  Widget build(BuildContext context) {

    if (media.isEmpty) {

      return const SizedBox.shrink();

    }


    return SizedBox(

      height: 220,

      child: ListView.builder(

        scrollDirection:
        Axis.horizontal,


        itemCount:
        media.length,


        itemBuilder:
            (context, index) {


          return _MediaItem(

            media:
            media[index],

          );


        },

      ),

    );

  }

}







class _MediaItem extends StatelessWidget {


  final MomentMedia media;



  const _MediaItem({

    required this.media,

  });





  @override
  Widget build(BuildContext context) {


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

        color:
        Colors.black26,

      ),


      clipBehavior:
      Clip.antiAlias,


      child:
      _buildMedia(),

    );

  }








  Widget _buildMedia() {


    switch(media.type) {


      case MomentMediaType.image:

        return _image();



      case MomentMediaType.video:

        return _video();


    }

  }








  Widget _image() {


    if(media.url.startsWith('http')) {


      return Image.network(

        media.url,

        fit:
        BoxFit.cover,


        errorBuilder:
            (_, error, stackTrace) {

          return _error();

        },

      );

    }



    return Image.file(

      File(
        media.url,
      ),


      fit:
      BoxFit.cover,

      errorBuilder:
          (_, error, stackTrace) {

        return _error();

      },

    );


  }








  Widget _video() {


    return Stack(

      alignment:
      Alignment.center,


      children:[


        Container(

          color:
          Colors.black45,

        ),



        const Icon(

          Icons.play_circle_fill,

          size:
          60,

          color:
          Colors.white70,

        ),



      ],

    );


  }








  Widget _error() {


    return Container(

      color:
      Colors.black26,


      alignment:
      Alignment.center,


      child:
      const Icon(

        Icons.broken_image_outlined,

        color:
        Colors.white54,

        size:
        40,

      ),

    );


  }

}