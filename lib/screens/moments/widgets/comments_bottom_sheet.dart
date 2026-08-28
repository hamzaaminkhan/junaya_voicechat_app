import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:junaya_voicechat_app/screens/moments/data/comment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/comments_provider.dart';



class CommentsBottomSheet extends ConsumerStatefulWidget {

  final String momentId;


  const CommentsBottomSheet({

    super.key,

    required this.momentId,

  });



  @override
  ConsumerState<CommentsBottomSheet> createState() =>
      _CommentsBottomSheetState();

}



class _CommentsBottomSheetState
    extends ConsumerState<CommentsBottomSheet> {


  final TextEditingController controller =
  TextEditingController();



  @override
  void dispose(){

    controller.dispose();

    super.dispose();

  }



  @override
  Widget build(BuildContext context){

    final state =
    ref.watch(
      commentsProvider(
        widget.momentId,
      ),
    );


    return Container(

      height:
      MediaQuery.of(context).size.height * .78,


      decoration:

      const BoxDecoration(

        color:
        Color(0xff101010),

        borderRadius:

        BorderRadius.vertical(

          top:
          Radius.circular(28),

        ),

      ),


      child:

      Column(

        children:[


          Container(

            margin:
            const EdgeInsets.only(
              top:12,
            ),


            width:
            45,


            height:
            5,


            decoration:

            BoxDecoration(

              color:
              Colors.white30,

              borderRadius:
              BorderRadius.circular(20),

            ),

          ),



          const SizedBox(

            height:16,

          ),



          const Text(

            "Comments",

            style:

            TextStyle(

              color:
              Colors.white,

              fontSize:
              18,

              fontWeight:
              FontWeight.bold,

            ),

          ),



          const SizedBox(

            height:12,

          ),



          Expanded(

            child:

            state.when(

              loading:(){

                return const Center(

                  child:
                  CircularProgressIndicator(),

                );

              },


              error:(error,stack){

                return const Center(

                  child:
                  Text(

                    "Failed loading comments",

                    style:
                    TextStyle(

                      color:
                      Colors.white54,

                    ),

                  ),

                );

              },


              data:(comments){


                if(comments.isEmpty){

                  return const Center(

                    child:

                    Text(

                      "No comments yet",

                      style:

                      TextStyle(

                        color:
                        Colors.white54,

                      ),

                    ),

                  );

                }


                return ListView.builder(

                  padding:

                  const EdgeInsets.symmetric(

                    horizontal:16,

                  ),


                  itemCount:

                  comments.length,


                  itemBuilder:(context,index){

                    return _CommentTile(

                      comment:
                      comments[index],

                    );

                  },

                );


              },

            ),

          ),



          _CommentInput(

            controller:
            controller,


            onSend:(){

              _sendComment();

            },

          ),

        ],

      ),

    );

  }



  Future<void> _sendComment() async {

    final text =
    controller.text.trim();


    if(text.isEmpty){

      return;

    }


    final comment =
    Comment(

      id:

      DateTime.now()
          .microsecondsSinceEpoch
          .toString(),


      momentId:
      widget.momentId,


      author:

      const CommentUser(

        id:
        "local_user",

        username:
        "junaya",

        displayName:
        "Junaya",

        avatar:
        "",

      ),


      text:
      text,


      createdAt:
      DateTime.now(),


      likesCount:
      0,


      isLiked:
      false,

    );


    await ref
        .read(
      commentsProvider(
        widget.momentId,
      ).notifier,
    )
        .addComment(
      comment: comment,
    );


    controller.clear();

  }

}

class _CommentTile extends StatelessWidget {

  final Comment comment;


  const _CommentTile({

    required this.comment,

  });



  @override
  Widget build(BuildContext context){

    return Padding(

      padding:

      const EdgeInsets.only(

        bottom:18,

      ),


      child:

      Row(

        crossAxisAlignment:

        CrossAxisAlignment.start,


        children:[


          CircleAvatar(

            radius:20,


            backgroundImage:

            _avatar(),


            child:

            comment.author.avatar.isEmpty

                ? const Icon(

              Icons.person,

              color:

              Colors.white54,

            )

                : null,

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



                Row(

                  children:[


                    Text(

                      comment.author.displayName,


                      style:

                      const TextStyle(

                        color:
                        Colors.white,

                        fontSize:
                        14,

                        fontWeight:
                        FontWeight.w700,

                      ),

                    ),



                    if(comment.author.verified)

                      const Padding(

                        padding:

                        EdgeInsets.only(

                          left:5,

                        ),


                        child:

                        Icon(

                          Icons.verified,

                          color:
                          Colors.blue,

                          size:
                          15,

                        ),

                      ),


                  ],

                ),




                const SizedBox(

                  height:3,

                ),




                Text(

                  "@${comment.author.username}",


                  style:

                  const TextStyle(

                    color:
                    Colors.white38,

                    fontSize:
                    12,

                  ),

                ),




                const SizedBox(

                  height:6,

                ),




                Text(

                  comment.text,


                  style:

                  const TextStyle(

                    color:
                    Colors.white,

                    fontSize:
                    15,

                    height:
                    1.35,

                  ),

                ),




                const SizedBox(

                  height:8,

                ),




                Row(

                  children:[



                    Text(

                      _timeAgo(

                        comment.createdAt,

                      ),


                      style:

                      const TextStyle(

                        color:
                        Colors.white38,

                        fontSize:
                        12,

                      ),

                    ),




                    const SizedBox(

                      width:18,

                    ),




                    Row(

                      children:[


                        Icon(

                          comment.isLiked

                              ? Icons.favorite

                              : Icons.favorite_border,


                          size:
                          16,


                          color:

                          comment.isLiked

                              ? Colors.red

                              : Colors.white54,

                        ),



                        const SizedBox(

                          width:5,

                        ),



                        Text(

                          comment.likesCount.toString(),


                          style:

                          const TextStyle(

                            color:
                            Colors.white54,

                            fontSize:
                            12,

                          ),

                        ),


                      ],

                    ),




                    const SizedBox(

                      width:18,

                    ),




                    const Text(

                      "Reply",

                      style:

                      TextStyle(

                        color:
                        Colors.white54,

                        fontSize:
                        12,

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





  ImageProvider? _avatar(){

    if(comment.author.avatar.isEmpty){

      return null;

    }


    if(comment.author.avatar.startsWith(
      "http",
    )){

      return NetworkImage(
        comment.author.avatar,
      );

    }


    return FileImage(
      File(
        comment.author.avatar,
      ),
    );

  }





  String _timeAgo(DateTime date){

    final diff =
    DateTime.now().difference(date);


    if(diff.inMinutes < 1){

      return "now";

    }


    if(diff.inHours < 1){

      return "${diff.inMinutes}m";

    }


    if(diff.inDays < 1){

      return "${diff.inHours}h";

    }


    return "${diff.inDays}d";

  }

}

class _CommentInput extends StatelessWidget {

  final TextEditingController controller;

  final VoidCallback onSend;


  const _CommentInput({

    required this.controller,

    required this.onSend,

  });



  @override
  Widget build(BuildContext context){

    return SafeArea(

      child:

      Container(

        padding:

        const EdgeInsets.fromLTRB(

          14,

          8,

          14,

          12,

        ),


        decoration:

        const BoxDecoration(

          color:
          Color(0xff151515),


          border:

          Border(

            top:

            BorderSide(

              color:
              Colors.white10,

            ),

          ),

        ),


        child:

        Row(

          children:[


            Expanded(

              child:

              Container(

                padding:

                const EdgeInsets.symmetric(

                  horizontal:
                  16,

                ),


                decoration:

                BoxDecoration(

                  color:
                  Color(0xff202020),


                  borderRadius:

                  BorderRadius.circular(

                    24,

                  ),

                ),


                child:

                TextField(

                  controller:

                  controller,


                  minLines:

                  1,


                  maxLines:

                  4,


                  style:

                  const TextStyle(

                    color:
                    Colors.white,

                    fontSize:
                    15,

                  ),


                  decoration:

                  const InputDecoration(

                    hintText:

                    "Add a comment...",


                    hintStyle:

                    TextStyle(

                      color:
                      Colors.white38,

                    ),


                    border:

                    InputBorder.none,


                  ),

                ),

              ),

            ),




            const SizedBox(

              width:
              10,

            ),




            GestureDetector(

              onTap:

              onSend,


              child:

              Container(

                width:
                42,


                height:
                42,


                decoration:

                const BoxDecoration(

                  shape:
                  BoxShape.circle,


                  color:
                  Colors.purpleAccent,

                ),


                child:

                const Icon(

                  Icons.send_rounded,

                  color:
                  Colors.white,

                  size:
                  20,

                ),

              ),

            ),


          ],

        ),

      ),

    );

  }

}