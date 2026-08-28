import 'package:flutter/material.dart';


class VoiceCommentPreview extends StatelessWidget {

  final String username;

  final String? avatar;

  final String duration;

  final VoidCallback? onPlay;


  const VoiceCommentPreview({

    super.key,

    required this.username,

    required this.duration,

    this.avatar,

    this.onPlay,

  });



  @override
  Widget build(BuildContext context) {


    return Container(

      margin: const EdgeInsets.fromLTRB(

        16,

        12,

        16,

        8,

      ),


      padding: const EdgeInsets.symmetric(

        horizontal:14,

        vertical:12,

      ),


      decoration: BoxDecoration(

        color: const Color(0xff151522),

        borderRadius: BorderRadius.circular(18),

      ),


      child: Row(

        children: [



          // Avatar

          CircleAvatar(

            radius:18,


            backgroundImage:

            avatar != null && avatar!.isNotEmpty

                ? NetworkImage(avatar!)

                : null,


            backgroundColor:

            const Color(0xff242435),


            child:

            avatar == null || avatar!.isEmpty

                ? const Icon(

              Icons.person,

              size:18,

              color:Colors.white54,

            )

                : null,

          ),



          const SizedBox(width:10),




          Expanded(

            child: Column(

              crossAxisAlignment:

              CrossAxisAlignment.start,


              children: [



                Text(

                  username,


                  style: const TextStyle(

                    color:Colors.white,

                    fontSize:13,

                    fontWeight:FontWeight.w600,

                  ),

                ),



                const SizedBox(height:8),




                Row(

                  children: [



                    GestureDetector(

                      onTap:onPlay,


                      child:Container(

                        width:28,

                        height:28,


                        decoration:const BoxDecoration(

                          color:Color(0xff8B5CF6),

                          shape:BoxShape.circle,

                        ),


                        child:const Icon(

                          Icons.play_arrow,

                          size:18,

                          color:Colors.white,

                        ),

                      ),

                    ),




                    const SizedBox(width:10),




                    Expanded(

                      child: Stack(

                        alignment:

                        Alignment.centerLeft,


                        children: [



                          Container(

                            height:3,


                            decoration:BoxDecoration(

                              color:

                              Colors.white24,

                              borderRadius:

                              BorderRadius.circular(10),

                            ),

                          ),




                          FractionallySizedBox(

                            widthFactor:.35,


                            child:Container(

                              height:3,


                              decoration:BoxDecoration(

                                color:

                                Color(0xff8B5CF6),

                                borderRadius:

                                BorderRadius.circular(10),

                              ),

                            ),

                          ),


                        ],

                      ),

                    ),




                    const SizedBox(width:10),




                    Text(

                      duration,


                      style:const TextStyle(

                        color:

                        Colors.white70,

                        fontSize:12,

                      ),

                    ),



                  ],

                ),


              ],

            ),

          ),



        ],

      ),

    );

  }

}