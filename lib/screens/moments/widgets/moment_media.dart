import 'dart:io';

import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';



class MomentMediaWidget extends StatefulWidget {

  final List<MomentMedia> media;


  const MomentMediaWidget({

    super.key,

    required this.media,

  });



  @override
  State<MomentMediaWidget> createState() =>
      _MomentMediaWidgetState();

}



class _MomentMediaWidgetState extends State<MomentMediaWidget> {


  final PageController _controller =
  PageController();



  int _index = 0;



  @override
  Widget build(BuildContext context) {


    if(widget.media.isEmpty){

      return const SizedBox.shrink();

    }



    return Stack(

      children: [



        AspectRatio(

          aspectRatio: 1,

          child: PageView.builder(

            controller: _controller,

            itemCount: widget.media.length,


            onPageChanged: (value){

              setState(() {

                _index = value;

              });

            },


            itemBuilder: (context,index){


              return _MediaItem(

                media:

                widget.media[index],

              );


            },

          ),

        ),





        if(widget.media.length > 1)

          Positioned(

            top: 12,

            right: 12,

            child: Container(

              padding:

              const EdgeInsets.symmetric(

                horizontal: 10,

                vertical: 5,

              ),


              decoration:

              BoxDecoration(

                color:

                Colors.black54,


                borderRadius:

                BorderRadius.circular(20),

              ),


              child: Text(

                "${_index + 1}/${widget.media.length}",


                style:

                const TextStyle(

                  color: Colors.white,

                  fontSize: 12,

                ),

              ),

            ),

          ),





        if(widget.media.length > 1)

          Positioned(

            bottom: 12,

            left: 0,

            right: 0,

            child: Row(

              mainAxisAlignment:

              MainAxisAlignment.center,


              children:

              List.generate(

                widget.media.length,


                    (i){

                  return Container(

                    margin:

                    const EdgeInsets.symmetric(

                      horizontal: 3,

                    ),


                    width:

                    i == _index ? 18 : 6,


                    height: 6,


                    decoration:

                    BoxDecoration(

                      color:

                      i == _index

                          ? Colors.white

                          : Colors.white38,


                      borderRadius:

                      BorderRadius.circular(10),

                    ),

                  );


                },

              ),

            ),

          ),


      ],

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


    return ClipRRect(

      borderRadius:

      BorderRadius.circular(22),


      child:

      _buildMedia(),

    );


  }







  Widget _buildMedia(){


    switch(media.type){


      case MomentMediaType.image:

        return _image();



      case MomentMediaType.video:

        return _video();


    }


  }







  Widget _image(){


    if(media.url.startsWith("http")){


      return Image.network(

        media.url,

        fit:

        BoxFit.cover,


        errorBuilder:

            (_,__,___)=>_error(),

      );


    }



    return Image.file(

      File(media.url),

      fit:

      BoxFit.cover,


      errorBuilder:

          (_,__,___)=>_error(),

    );


  }







  Widget _video(){


    return Stack(

      fit:

      StackFit.expand,


      children:[


        Container(

          color:

          Colors.black87,

        ),



        const Center(

          child:

          Icon(

            Icons.play_circle_fill,

            size:

            70,

            color:

            Colors.white70,

          ),

        ),


      ],


    );


  }







  Widget _error(){


    return Container(

      color:

      Colors.black26,


      child:

      const Center(

        child:

        Icon(

          Icons.broken_image_outlined,

          color:

          Colors.white54,

          size:

          40,

        ),

      ),

    );


  }


}