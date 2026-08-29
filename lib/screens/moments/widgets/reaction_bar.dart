import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';


class ReactionBar extends StatefulWidget {

  final Moment moment;

  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSave;


  const ReactionBar({

    super.key,

    required this.moment,

    this.onLike,

    this.onComment,

    this.onShare,

    this.onSave,

  });



  @override
  State<ReactionBar> createState() =>
      _ReactionBarState();

}




class _ReactionBarState
    extends State<ReactionBar> {


  bool _likedAnimation = false;



  void _likePressed(){

    setState(() {

      _likedAnimation = true;

    });


    widget.onLike?.call();


    Future.delayed(
      const Duration(milliseconds:180),
          (){

        if(mounted){

          setState(() {

            _likedAnimation = false;

          });

        }

      },
    );

  }





  @override
  Widget build(BuildContext context) {


    final moment = widget.moment;


    return Row(

      children: [


        // LIKE

        _ActionItem(

          icon:

          moment.isLiked

              ? Icons.favorite

              : Icons.favorite_border,


          count:

          moment.stats.likes,


          color:

          const Color(0xffFF3B7A),


          animate:

          _likedAnimation,


          onTap:

          _likePressed,

        ),




        const SizedBox(width:24),





        // COMMENTS

        _ActionItem(

          icon:

          Icons.chat_bubble_outline,


          count:

          moment.stats.comments,


          color:

          const Color(0xffA7A7BC),


          onTap:

          widget.onComment,

        ),




        const SizedBox(width:24),





        // REACTIONS

        _ActionItem(

          icon:

          Icons.auto_awesome,


          count:

          moment.reactionCount,


          color:

          const Color(0xffA855F7),

        ),





        const Spacer(),





        _IconButton(

          icon:

          Icons.reply_rounded,


          onTap:

          widget.onShare,

        ),




        const SizedBox(width:22),





        _IconButton(

          icon:

          moment.isSaved

              ? Icons.bookmark

              : Icons.bookmark_border,


          onTap:

          widget.onSave,

        ),


      ],

    );

  }

}






class _ActionItem extends StatelessWidget {


  final IconData icon;

  final int count;

  final Color color;

  final VoidCallback? onTap;

  final bool animate;



  const _ActionItem({

    required this.icon,

    required this.count,

    required this.color,

    this.onTap,

    this.animate = false,

  });



  @override
  Widget build(BuildContext context) {


    return GestureDetector(

      onTap:onTap,

      behavior:

      HitTestBehavior.opaque,


      child:Row(

        children:[


          AnimatedScale(

            scale:

            animate ? 1.25 : 1,


            duration:

            const Duration(

              milliseconds:140,

            ),


            child:Icon(

              icon,

              size:25,

              color:color,

            ),

          ),




          if(count > 0)

            Padding(

              padding:

              const EdgeInsets.only(

                left:6,

              ),


              child:Text(

                count.toString(),


                style:TextStyle(

                  color:color,

                  fontSize:15,

                  fontWeight:

                  FontWeight.w600,

                ),

              ),

            ),


        ],

      ),

    );

  }

}







class _IconButton extends StatelessWidget {


  final IconData icon;

  final VoidCallback? onTap;



  const _IconButton({

    required this.icon,

    this.onTap,

  });



  @override
  Widget build(BuildContext context) {


    return GestureDetector(

      onTap:onTap,


      behavior:

      HitTestBehavior.opaque,


      child:Icon(

        icon,

        size:27,

        color:

        const Color(0xffA7A7BC),

      ),

    );

  }

}