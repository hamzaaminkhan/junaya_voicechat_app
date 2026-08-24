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


  final TextEditingController _controller =
  TextEditingController();



  @override
  void dispose() {

    _controller.dispose();

    super.dispose();

  }








  Future<void> _sendComment() async {

    final text =
    _controller.text.trim();


    if(text.isEmpty) {

      return;

    }



    final comment =
    Comment(

      id:
      DateTime
          .now()
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
        "Junaya User",

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
      )
          .notifier,
    )
        .addComment(
      comment:
      comment,
    );



    _controller.clear();

  }









  @override
  Widget build(BuildContext context) {


    final commentsState =
    ref.watch(
      commentsProvider(
        widget.momentId,
      ),
    );



    return SafeArea(

      child:
      Container(

        height:
        MediaQuery.of(context)
            .size
            .height *
            .75,


        padding:
        const EdgeInsets.all(16),


        decoration:
        const BoxDecoration(

          color:
          Color(0xff151515),


          borderRadius:
          BorderRadius.vertical(

            top:
            Radius.circular(28),

          ),

        ),



        child:
        Column(

          children: [

            _title(),


            const SizedBox(
              height: 16,
            ),


            Expanded(

              child:

              commentsState.when(

                loading:

                    () =>
                const Center(

                  child:
                  CircularProgressIndicator(),

                ),



                error:

                    (_, __) =>
                const Center(

                  child:
                  Text(

                    "Unable to load comments",

                    style:
                    TextStyle(
                      color:
                      Colors.white,
                    ),

                  ),

                ),




                data:

                    (comments) {

                  if(comments.isEmpty) {

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

                    itemCount:
                    comments.length,


                    itemBuilder:
                        (_, index) {


                      return _CommentTile(

                        comment:
                        comments[index],


                        onLike:

                            () =>
                            ref
                                .read(
                              commentsProvider(
                                widget.momentId,
                              )
                                  .notifier,
                            )
                                .toggleLike(
                              comments[index],
                            ),



                        onDelete:

                            () =>
                            ref
                                .read(
                              commentsProvider(
                                widget.momentId,
                              )
                                  .notifier,
                            )
                                .deleteComment(
                              comments[index],
                            )

                      );


                    },

                  );


                },

              ),

            ),




            _input(),


          ],

        ),

      ),

    );

  }








  Widget _title() {

    return Row(

      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,


      children: [

        const Text(

          "Comments",

          style:
          TextStyle(

            color:
            Colors.white,

            fontSize:
            20,

            fontWeight:
            FontWeight.bold,

          ),

        ),



        IconButton(

          onPressed:
              () =>
              Navigator.pop(
                context,
              ),

          icon:
          const Icon(

            Icons.close,

            color:
            Colors.white,

          ),

        ),

      ],

    );

  }








  Widget _input() {

    return Row(

      children: [

        Expanded(

          child:
          TextField(

            controller:
            _controller,


            style:
            const TextStyle(
              color:
              Colors.white,
            ),


            decoration:
            const InputDecoration(

              hintText:
              "Write a comment...",


              hintStyle:
              TextStyle(
                color:
                Colors.white54,
              ),

            ),

          ),

        ),



        IconButton(

          onPressed:
          _sendComment,


          icon:
          const Icon(

            Icons.send,

            color:
            Colors.purpleAccent,

          ),

        ),

      ],

    );

  }

}







class _CommentTile extends StatelessWidget {


  final Comment comment;

  final VoidCallback onLike;

  final VoidCallback onDelete;



  const _CommentTile({

    required this.comment,

    required this.onLike,

    required this.onDelete,

  });





  @override
  Widget build(BuildContext context) {


    return ListTile(

      contentPadding:
      EdgeInsets.zero,


      leading:
      CircleAvatar(

        child:
        const Icon(
          Icons.person,
        ),

      ),


      title:
      Text(

        comment.author.displayName,

        style:
        const TextStyle(
          color:
          Colors.white,
        ),

      ),



      subtitle:
      Text(

        comment.text,

        style:
        const TextStyle(
          color:
          Colors.white70,
        ),

      ),



      trailing:
      Row(

        mainAxisSize:
        MainAxisSize.min,


        children: [

          IconButton(

            onPressed:
            onLike,


            icon:
            Icon(

              comment.isLiked
                  ? Icons.favorite
                  : Icons.favorite_border,


              color:
              Colors.pinkAccent,

            ),

          ),



          IconButton(

            onPressed:
            onDelete,


            icon:
            const Icon(

              Icons.delete_outline,

              color:
              Colors.white54,

            ),

          ),

        ],

      ),

    );

  }

}