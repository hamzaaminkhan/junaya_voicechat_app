import 'dart:io';

import 'package:flutter/material.dart';

import '../data/moment_model.dart';



class MomentCard extends StatelessWidget {


  final Moment moment;


  final VoidCallback onDelete;



  const MomentCard({

    super.key,

    required this.moment,

    required this.onDelete,

  });





  @override
  Widget build(BuildContext context) {


    return Container(

      margin:
      const EdgeInsets.symmetric(
        horizontal:15,
        vertical:8,
      ),


      padding:
      const EdgeInsets.all(16),



      decoration:
      BoxDecoration(

        color:
        const Color(0xff151515),


        borderRadius:
        BorderRadius.circular(22),

      ),





      child:
      Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children:[





          Row(

            children:[


              CircleAvatar(

                radius:22,


                backgroundImage:
                moment.author.avatar.isNotEmpty

                    ?

                AssetImage(
                    moment.author.avatar
                )

                    :

                null,


                child:
                moment.author.avatar.isEmpty

                    ?

                const Icon(
                  Icons.person,
                )

                    :

                null,

              ),



              const SizedBox(
                width:12,
              ),




              Expanded(

                child:
                Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,


                  children:[


                    Text(

                      moment.author.displayName,

                      style:
                      const TextStyle(

                        color:
                        Colors.white,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),



                    Text(

                      moment.createdAt
                          .toString()
                          .substring(
                          0,16
                      ),


                      style:
                      const TextStyle(

                        color:
                        Colors.white54,

                        fontSize:12,

                      ),

                    ),


                  ],

                ),

              ),





              PopupMenuButton(


                icon:
                const Icon(
                  Icons.more_vert,
                  color:Colors.white,
                ),


                itemBuilder:
                    (_) => [

                  PopupMenuItem(

                    onTap:
                    onDelete,


                    child:
                    const Text(
                      "Delete",
                    ),

                  )

                ],

              )


            ],


          ),






          const SizedBox(
            height:15,
          ),





          Text(

            moment.caption,


            style:
            const TextStyle(

              color:
              Colors.white,

              fontSize:16,

            ),

          ),





          const SizedBox(
            height:12,
          ),






          if(moment.media.isNotEmpty)

            SizedBox(

              height:220,


              child:
              ListView.builder(

                scrollDirection:
                Axis.horizontal,


                itemCount:
                moment.media.length,


                itemBuilder:
                    (_,index){


                  final media =
                  moment.media[index];



                  return Container(

                    width:220,


                    margin:
                    const EdgeInsets.only(
                      right:10,
                    ),


                    decoration:
                    BoxDecoration(

                      borderRadius:
                      BorderRadius.circular(18),

                      image:
                      DecorationImage(

                        image:
                        FileImage(
                          File(
                            media.url,
                          ),
                        ),

                        fit:
                        BoxFit.cover,

                      ),

                    ),

                  );


                },

              ),

            ),





          const SizedBox(
            height:15,
          ),





          Row(

            children:[


              Icon(

                moment.isLiked

                    ?

                Icons.favorite

                    :

                Icons.favorite_border,


                color:
                Colors.pinkAccent,

              ),



              const SizedBox(
                width:5,
              ),


              Text(

                "${moment.likesCount}",


                style:
                const TextStyle(
                  color:
                  Colors.white,
                ),

              ),




              const SizedBox(
                width:20,
              ),




              const Icon(

                Icons.comment,

                color:
                Colors.white54,

              ),



              const SizedBox(
                width:5,
              ),



              Text(

                "${moment.commentsCount}",


                style:
                const TextStyle(
                  color:
                  Colors.white,
                ),

              ),


            ],

          )


        ],

      ),

    );


  }



}