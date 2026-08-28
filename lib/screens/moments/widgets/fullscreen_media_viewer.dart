import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';



class FullscreenMediaViewer extends StatefulWidget {

  final List<MomentMedia> media;

  final int initialIndex;


  const FullscreenMediaViewer({

    super.key,

    required this.media,

    this.initialIndex = 0,

  });



  @override
  State<FullscreenMediaViewer> createState() =>
      _FullscreenMediaViewerState();

}



class _FullscreenMediaViewerState
    extends State<FullscreenMediaViewer> {


  late PageController controller;


  late int index;



  @override
  void initState(){

    super.initState();


    index =
        widget.initialIndex;


    controller =
        PageController(
          initialPage:index,
        );

  }



  @override
  void dispose(){

    controller.dispose();

    super.dispose();

  }



  @override
  Widget build(BuildContext context){


    return Scaffold(

      backgroundColor:
      Colors.black,


      body:

      Stack(

        children:[


          PhotoViewGallery.builder(

            pageController:
            controller,


            itemCount:
            widget.media.length,


            onPageChanged:(value){

              setState((){

                index=value;

              });

            },


            builder:(context,i){


              final item =
              widget.media[i];



              return PhotoViewGalleryPageOptions(

                imageProvider:
                _provider(item),


                minScale:
                PhotoViewComputedScale.contained,


                maxScale:
                PhotoViewComputedScale.covered * 3,


                heroAttributes:

                PhotoViewHeroAttributes(

                  tag:
                  item.id,

                ),

              );

            },


            backgroundDecoration:

            const BoxDecoration(

              color:
              Colors.black,

            ),

          ),



          Positioned(

            top:
            MediaQuery.of(context)
                .padding
                .top + 10,


            left:
            12,


            child:

            IconButton(

              onPressed:(){

                Navigator.pop(context);

              },


              icon:

              const Icon(

                Icons.close,

                color:
                Colors.white,

                size:
                32,

              ),

            ),

          ),



          if(widget.media.length > 1)

            Positioned(

              bottom:
              30,


              left:
              0,


              right:
              0,


              child:

              Center(

                child:

                Container(

                  padding:

                  const EdgeInsets.symmetric(

                    horizontal:14,

                    vertical:6,

                  ),


                  decoration:

                  BoxDecoration(

                    color:
                    Colors.black54,


                    borderRadius:

                    BorderRadius.circular(20),

                  ),


                  child:

                  Text(

                    "${index + 1}/${widget.media.length}",


                    style:

                    const TextStyle(

                      color:
                      Colors.white,

                      fontSize:
                      14,

                    ),

                  ),

                ),

              ),

            ),


        ],

      ),

    );

  }



  ImageProvider _provider(
      MomentMedia media,
      ){


    final path =
        media.remoteUrl ??
            media.localPath;



    if(path.startsWith("http")){

      return NetworkImage(
        path,
      );

    }


    return FileImage(
      File(
        path,
      ),
    );

  }

}