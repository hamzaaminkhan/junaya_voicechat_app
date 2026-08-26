import 'dart:io';

import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';



class MomentHeader extends StatelessWidget {

  final Moment moment;

  final VoidCallback onDelete;



  const MomentHeader({

    super.key,

    required this.moment,

    required this.onDelete,

  });



  @override
  Widget build(BuildContext context) {


    return Padding(

      padding:

      const EdgeInsets.fromLTRB(

        16,

        14,

        8,

        8,

      ),

      child: Row(

        children: [


          CircleAvatar(

            radius: 22,

            backgroundImage:

            _avatar(),


            child:

            moment.author.avatar.isEmpty

                ? const Icon(

              Icons.person,

              color: Colors.white54,

            )

                : null,

          ),



          const SizedBox(

            width: 12,

          ),




          Expanded(

            child: Column(

              crossAxisAlignment:

              CrossAxisAlignment.start,


              children: [


                Row(

                  children: [


                    Text(

                      moment.author.displayName,


                      style:

                      const TextStyle(

                        color: Colors.white,

                        fontWeight:

                        FontWeight.w700,

                        fontSize: 15,

                      ),

                    ),



                    if(moment.author.verified)

                      const Padding(

                        padding:

                        EdgeInsets.only(

                          left: 5,

                        ),

                        child: Icon(

                          Icons.verified,

                          color: Colors.blue,

                          size: 16,

                        ),

                      ),


                  ],

                ),




                const SizedBox(

                  height: 3,

                ),




                Row(

                  children: [


                    Text(

                      "@${moment.author.username}",


                      style:

                      const TextStyle(

                        color: Colors.white54,

                        fontSize: 12,

                      ),

                    ),




                    const SizedBox(

                      width: 8,

                    ),



                    Text(

                      "• ${_formatDate(moment.createdAt)}",


                      style:

                      const TextStyle(

                        color: Colors.white38,

                        fontSize: 12,

                      ),

                    ),


                  ],

                ),


              ],

            ),

          ),




          PopupMenuButton<String>(

            icon:

            const Icon(

              Icons.more_horiz,

              color: Colors.white70,

            ),


            onSelected:

                (value){


              if(value == "delete"){

                onDelete();

              }


            },


            itemBuilder:

                (_) => [


              const PopupMenuItem(

                value: "delete",

                child: Text(

                  "Delete",

                ),

              ),


            ],

          ),


        ],

      ),

    );

  }






  ImageProvider? _avatar(){


    if(moment.author.avatar.isEmpty){

      return null;

    }



    if(moment.author.avatar.startsWith("http")){

      return NetworkImage(

        moment.author.avatar,

      );

    }



    return FileImage(

      File(

        moment.author.avatar,

      ),

    );


  }






  String _formatDate(DateTime date){


    final difference =

    DateTime.now().difference(date);



    if(difference.inMinutes < 1){

      return "Just now";

    }



    if(difference.inHours < 1){

      return "${difference.inMinutes}m";

    }



    if(difference.inDays < 1){

      return "${difference.inHours}h";

    }



    if(difference.inDays < 7){

      return "${difference.inDays}d";

    }



    return "${date.day}/${date.month}/${date.year}";

  }

}