import 'dart:async';
import 'package:flutter/material.dart';


class EventBanner extends StatefulWidget {

  final List<EventBannerItem> banners;


  const EventBanner({

    super.key,

    required this.banners,

  });



  @override
  State<EventBanner> createState() =>
      _EventBannerState();

}




class _EventBannerState extends State<EventBanner> {


  late PageController controller;

  Timer? timer;


  int current = 0;



  @override
  void initState(){

    super.initState();


    controller = PageController();


    timer = Timer.periodic(

      const Duration(seconds:4),

          (_) {

        if(!mounted ||
            widget.banners.length <= 1){

          return;

        }



        current++;


        if(current >= widget.banners.length){

          current = 0;

        }



        controller.animateToPage(

          current,

          duration:
          const Duration(
            milliseconds:500,
          ),

          curve:
          Curves.easeInOut,

        );


      },

    );


  }





  @override
  void dispose(){

    timer?.cancel();

    controller.dispose();

    super.dispose();

  }






  @override
  Widget build(BuildContext context){


    if(widget.banners.isEmpty){

      return const SizedBox();

    }



    return Column(

      children:[


        SizedBox(

          height:170,


          child:PageView.builder(

            controller:
            controller,


            itemCount:
            widget.banners.length,



            onPageChanged:(index){

              setState((){

                current=index;

              });

            },



            itemBuilder:(context,index){


              final item =
              widget.banners[index];



              return Container(

                margin:
                const EdgeInsets.symmetric(
                  horizontal:15,
                ),


                decoration:
                BoxDecoration(

                  borderRadius:
                  BorderRadius.circular(20),


                  image:
                  DecorationImage(

                    image:
                    AssetImage(
                      item.image,
                    ),

                    fit:
                    BoxFit.cover,

                  ),

                ),



                child:Container(

                  padding:
                  const EdgeInsets.all(16),



                  decoration:
                  BoxDecoration(

                    borderRadius:
                    BorderRadius.circular(20),


                    gradient:
                    LinearGradient(

                      begin:
                      Alignment.bottomCenter,


                      end:
                      Alignment.topCenter,


                      colors:[

                        Colors.black
                            .withValues(alpha:.65),

                        Colors.transparent,

                      ],

                    ),

                  ),



                  child:Align(

                    alignment:
                    Alignment.bottomLeft,


                    child:Text(

                      item.title,


                      style:
                      const TextStyle(

                        color:
                        Colors.white,


                        fontSize:20,


                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),

                  ),

                ),

              );

            },


          ),

        ),



        const SizedBox(height:8),



        Row(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children:

          List.generate(

            widget.banners.length,

                (index){


              return AnimatedContainer(

                duration:
                const Duration(
                  milliseconds:200,
                ),


                margin:
                const EdgeInsets.symmetric(
                  horizontal:3,
                ),


                height:6,


                width:

                current == index

                    ?

                18

                    :

                6,


                decoration:
                BoxDecoration(

                  color:

                  current == index

                      ?

                  const Color(
                    0xffC06CFF,
                  )

                      :

                  Colors.white30,


                  borderRadius:
                  BorderRadius.circular(20),

                ),

              );

            },

          ),

        ),


      ],

    );

  }

}





class EventBannerItem {


  final String image;

  final String title;

  final String subtitle;



  EventBannerItem({

    required this.image,

    required this.title,

    required this.subtitle,

  });

}