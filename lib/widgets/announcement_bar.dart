import 'dart:async';
import 'package:flutter/material.dart';

class AnnouncementBar extends StatefulWidget {

  final List<String> messages;

  final VoidCallback? onTap;


  const AnnouncementBar({

    super.key,

    this.messages = const [

      "Welcome to Junaya 🎉",

      "VIP rooms are live now 🔥",

      "Join your favourite voice rooms 🎤",

      "New events and rewards available 🏆",

    ],

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
  void initState() {

    super.initState();


    controller =
        ScrollController();



    timer =
        Timer.periodic(

          const Duration(milliseconds:40),

              (_) {


            if(!mounted ||
                !controller.hasClients){

              return;

            }



            if(controller.position.pixels >=
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
        "     •     "
    );



    return GestureDetector(


      onTap:
      widget.onTap,


      child:Container(


        height:48,


        margin:
        const EdgeInsets.symmetric(
            horizontal:15),



        decoration:BoxDecoration(


          color:
          Colors.white.withValues(
              alpha:.06),



          borderRadius:
          BorderRadius.circular(18),



          border:
          Border.all(

            color:
            Colors.white.withValues(
                alpha:.10),

          ),



          boxShadow:[


            BoxShadow(

              color:
              const Color(0xff00D9B5)
                  .withValues(alpha:.08),

              blurRadius:20,

            )

          ],


        ),



        child:Row(

          children:[



            const SizedBox(width:12),




            Container(


              height:28,

              width:28,


              decoration:
              BoxDecoration(

                shape:
                BoxShape.circle,


                color:
                const Color(0xff00D9B5)
                    .withValues(alpha:.18),

              ),


              child:
              const Icon(

                Icons.volume_up_rounded,

                size:16,

                color:
                Color(0xff00D9B5),

              ),


            ),




            const SizedBox(width:10),




            Expanded(

              child:ClipRect(

                child:SingleChildScrollView(

                  controller:
                  controller,


                  scrollDirection:
                  Axis.horizontal,


                  physics:
                  const NeverScrollableScrollPhysics(),



                  child:Row(

                    children:[


                      Text(

                        text,


                        style:
                        const TextStyle(

                          color:
                          Colors.white70,


                          fontSize:13,


                          fontWeight:
                          FontWeight.w500,

                        ),

                      ),


                      const SizedBox(
                          width:100),


                    ],

                  ),

                ),

              ),

            ),



          ],

        ),

      ),

    );

  }

}