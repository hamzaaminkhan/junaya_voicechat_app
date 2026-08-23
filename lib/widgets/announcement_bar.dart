import 'dart:async';
import 'package:flutter/material.dart';


class AnnouncementBar extends StatefulWidget {

  final List<String> messages;

  final VoidCallback? onTap;


  const AnnouncementBar({

    super.key,

    required this.messages,

    this.onTap,

  });



  @override
  State<AnnouncementBar> createState() =>
      _AnnouncementBarState();

}





class _AnnouncementBarState
    extends State<AnnouncementBar> {


  late ScrollController controller;

  Timer? timer;



  @override
  void initState(){

    super.initState();


    controller =
        ScrollController();



    timer =
        Timer.periodic(

          const Duration(
              milliseconds:40),


              (_) {


            if(!controller.hasClients){
              return;
            }


            if(controller.offset >=
                controller.position.maxScrollExtent){

              controller.jumpTo(0);

            }

            else{

              controller.animateTo(

                controller.offset + 1,

                duration:
                const Duration(
                    milliseconds:40),

                curve:
                Curves.linear,

              );

            }

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


    final text =
    widget.messages.join(
        "     •     ");



    return GestureDetector(

      onTap:
      widget.onTap,


      child:

      Container(

        height:42,


        padding:
        const EdgeInsets.symmetric(
          horizontal:14,
        ),



        decoration:
        BoxDecoration(


          color:
          Colors.white.withValues(alpha: .06),



          borderRadius:
          BorderRadius.circular(22),



          border:
          Border.all(

            color:
            Colors.white.withValues(alpha: .1),

          ),

        ),




        child:

        Row(

          children:[



            Container(

              height:26,

              width:26,


              decoration:
              BoxDecoration(

                shape:
                BoxShape.circle,


                color:
                const Color(0xff00D9B5)
                    .withValues(alpha: .18),

              ),


              child:
              const Icon(

                Icons.campaign_rounded,

                size:16,

                color:
                Color(0xff00D9B5),

              ),

            ),



            const SizedBox(
                width:10),




            Expanded(

              child:

              ClipRect(

                child:

                SingleChildScrollView(

                  controller:
                  controller,


                  scrollDirection:
                  Axis.horizontal,


                  physics:
                  const NeverScrollableScrollPhysics(),



                  child:

                  Text(

                    text,


                    maxLines:1,


                    style:
                    const TextStyle(

                      color:
                      Colors.white70,


                      fontSize:13,


                      fontWeight:
                      FontWeight.w500,

                    ),

                  ),

                ),

              ),

            )

          ],

        ),

      ),

    );

  }

}