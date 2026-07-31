import 'package:flutter/material.dart';
import '../models/moment_model.dart';


class MomentCard extends StatelessWidget {


  final MomentModel moment;


  const MomentCard({

    super.key,

    required this.moment,

  });



  @override
  Widget build(BuildContext context) {


    return Container(

      margin: const EdgeInsets.symmetric(

        horizontal: 10,

        vertical: 8,

      ),


      padding: const EdgeInsets.all(12),


      decoration: BoxDecoration(


        color: Colors.black.withOpacity(0.35),


        borderRadius:
        BorderRadius.circular(16),


        border:

        Border.all(

          color: Colors.white24,

          width: 1,

        ),


      ),



      child: Column(


        crossAxisAlignment:
        CrossAxisAlignment.start,


        children: [



          // USER HEADER

          Row(

            children: [


              CircleAvatar(

                radius: 24,


                backgroundImage:

                AssetImage(

                  moment.avatar,

                ),

              ),



              const SizedBox(width: 12),



              Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children: [


                  Text(

                    moment.username,


                    style:

                    const TextStyle(

                      color: Colors.white,

                      fontSize: 16,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),



                  const SizedBox(height:3),



                  Text(

                    moment.time,


                    style:

                    const TextStyle(

                      color: Colors.white60,

                      fontSize: 12,

                    ),

                  ),


                ],

              ),


            ],

          ),



          const SizedBox(height:12),



          // TEXT CONTENT


          Text(

            moment.content,


            style:

            const TextStyle(

              color: Colors.white,

              fontSize: 15,

              height:1.4,

            ),

          ),




          // IMAGES


          if(moment.images.isNotEmpty)

            Padding(

              padding:

              const EdgeInsets.only(top:12),


              child:

              _imageGrid(),


            ),




          const SizedBox(height:12),



          // ACTIONS


          Row(

            children: [


              Icon(

                Icons.favorite_border,

                color: Colors.white70,

                size:22,

              ),



              const SizedBox(width:5),



              Text(

                "${moment.likes}",


                style:

                const TextStyle(

                  color: Colors.white70,

                ),

              ),



              const SizedBox(width:25),



              Icon(

                Icons.chat_bubble_outline,

                color: Colors.white70,

                size:21,

              ),



              const SizedBox(width:5),



              Text(

                "${moment.comments}",


                style:

                const TextStyle(

                  color: Colors.white70,

                ),

              ),



              const Spacer(),



              Icon(

                Icons.share_outlined,

                color: Colors.white70,

                size:21,

              ),



            ],

          ),



        ],

      ),

    );

  }





  Widget _imageGrid(){



    if(moment.images.length == 1){


      return ClipRRect(

        borderRadius:
        BorderRadius.circular(12),


        child:

        Image.asset(

          moment.images.first,


          height:220,


          width:double.infinity,


          fit:BoxFit.cover,


        ),

      );


    }



    return GridView.builder(

      shrinkWrap:true,


      physics:

      const NeverScrollableScrollPhysics(),


      itemCount:

      moment.images.length > 6

          ? 6

          : moment.images.length,



      gridDelegate:

      const SliverGridDelegateWithFixedCrossAxisCount(

        crossAxisCount:3,


        crossAxisSpacing:5,


        mainAxisSpacing:5,


      ),



      itemBuilder:(context,index){



        return ClipRRect(

          borderRadius:

          BorderRadius.circular(10),


          child:

          Image.asset(

            moment.images[index],


            fit:BoxFit.cover,

          ),

        );


      },


    );


  }


}