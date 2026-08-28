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



  String _timeAgo(DateTime date) {

    final difference = DateTime.now().difference(date);


    if (difference.inMinutes < 1) {
      return "now";
    }

    if (difference.inHours < 1) {
      return "${difference.inMinutes}m";
    }

    if (difference.inDays < 1) {
      return "${difference.inHours}h";
    }

    return "${difference.inDays}d";
  }



  @override
  Widget build(BuildContext context) {


    final user = moment.author;


    return Padding(

      padding: const EdgeInsets.fromLTRB(

        16,

        16,

        10,

        8,

      ),


      child: Row(

        crossAxisAlignment: CrossAxisAlignment.start,


        children: [



          // Avatar

          Container(

            width: 46,

            height: 46,


            padding: const EdgeInsets.all(1.5),


            decoration: const BoxDecoration(

              shape: BoxShape.circle,


              gradient: LinearGradient(

                colors: [

                  Color(0xffffd700),

                  Color(0xff8b5cf6),

                  Color(0xffff4081),

                ],

              ),

            ),


            child: ClipOval(

              child: user.avatar.isNotEmpty

                  ? Image.network(

                user.avatar,

                fit: BoxFit.cover,

                errorBuilder: (_, _, _) {

                  return _fallbackAvatar();

                },

              )

                  : _fallbackAvatar(),

            ),

          ),




          const SizedBox(width: 12),




          // User information

          Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,


              children: [



                Row(

                  children: [


                    Flexible(

                      child: Text(

                        user.displayName.isNotEmpty

                            ? user.displayName

                            : user.username,


                        overflow: TextOverflow.ellipsis,


                        style: const TextStyle(

                          color: Colors.white,

                          fontSize: 15,

                          fontWeight: FontWeight.w700,

                        ),

                      ),

                    ),



                    if(user.verified)

                      const Padding(

                        padding: EdgeInsets.only(left:5),

                        child: Icon(

                          Icons.verified,

                          size:16,

                          color: Color(0xff8b5cf6),

                        ),

                      ),


                  ],

                ),




                const SizedBox(height:4),




                Row(

                  children: [


                    Text(

                      "@${user.username}",


                      style: const TextStyle(

                        color: Color(0xffA0A0B0),

                        fontSize:13,

                      ),

                    ),



                    const Padding(

                      padding: EdgeInsets.symmetric(

                        horizontal:6,

                      ),

                      child: Text(

                        "•",

                        style: TextStyle(

                          color: Color(0xff666675),

                        ),

                      ),

                    ),



                    Text(

                      _timeAgo(moment.createdAt),


                      style: const TextStyle(

                        color: Color(0xffA0A0B0),

                        fontSize:13,

                      ),

                    ),


                  ],

                ),





                if(moment.location != null)

                  Padding(

                    padding: const EdgeInsets.only(

                      top:5,

                    ),


                    child: Row(

                      children: [


                        const Icon(

                          Icons.location_on,

                          size:14,

                          color: Color(0xff8b5cf6),

                        ),



                        const SizedBox(width:3),



                        Flexible(

                          child: Text(

                            moment.location!.name,


                            overflow: TextOverflow.ellipsis,


                            style: const TextStyle(

                              color: Color(0xffB99CFF),

                              fontSize:12.5,

                            ),

                          ),

                        ),

                      ],

                    ),

                  ),



              ],

            ),

          ),





          // Public badge

          if(moment.visibility.toString().contains("public"))

            Container(

              margin: const EdgeInsets.only(

                top:4,

              ),


              padding: const EdgeInsets.symmetric(

                horizontal:10,

                vertical:6,

              ),


              decoration: BoxDecoration(

                color: const Color(0xff06352B),

                borderRadius: BorderRadius.circular(18),

              ),


              child: const Row(

                children: [


                  Icon(

                    Icons.public,

                    size:14,

                    color: Color(0xff00E6A0),

                  ),



                  SizedBox(width:4),



                  Text(

                    "Public",

                    style: TextStyle(

                      color: Color(0xff00E6A0),

                      fontSize:12,

                      fontWeight: FontWeight.w600,

                    ),

                  ),

                ],

              ),

            ),





          IconButton(

            padding: EdgeInsets.zero,


            constraints: const BoxConstraints(),


            icon: const Icon(

              Icons.more_vert,

              color: Color(0xffB8B8C8),

            ),


            onPressed: onDelete,

          ),


        ],

      ),

    );

  }



  Widget _fallbackAvatar() {

    return Container(

      color: const Color(0xff20202A),


      child: const Icon(

        Icons.person,

        color: Colors.white54,

      ),

    );

  }

}