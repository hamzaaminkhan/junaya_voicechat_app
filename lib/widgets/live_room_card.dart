import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class LiveRoomCard extends StatelessWidget {


  final String image;
  final String avatar;
  final String flag;
  final String name;
  final String description;
  final String vip;
  final String level;
  final String role;
  final int likes;



  const LiveRoomCard({

    super.key,

    required this.image,
    required this.avatar,
    required this.flag,
    required this.name,
    required this.description,
    required this.vip,
    required this.level,
    required this.role,
    required this.likes,

  });




  @override
  Widget build(BuildContext context){


    return Container(


        margin:
        const EdgeInsets.symmetric(

          horizontal:16,

          vertical:10,

        ),



        height:220,



        decoration:
        BoxDecoration(



            borderRadius:
            BorderRadius.circular(25),



            image:
            DecorationImage(


              image:
              AssetImage(image),


              fit:
              BoxFit.cover,


            ),




            border:
            Border.all(

              color:
              Colors.purpleAccent,

              width:1,

            ),



            boxShadow:[


              BoxShadow(

                color:
                Colors.purpleAccent.withOpacity(.4),

                blurRadius:20,

              )


            ]



        ),





        child:
        Container(


          padding:
          const EdgeInsets.all(15),




          decoration:
          BoxDecoration(



            borderRadius:
            BorderRadius.circular(25),




            gradient:
            LinearGradient(

              colors:[

                Colors.black.withOpacity(.65),

                Colors.transparent,

              ],

              begin:
              Alignment.bottomCenter,

              end:
              Alignment.topCenter,


            ),


          ),





          child:
          Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children:[



              Row(

                children:[



                  CircleAvatar(

                    radius:25,

                    backgroundImage:
                    AssetImage(avatar),

                  ),



                  const SizedBox(width:10),




                  Expanded(

                    child:
                    Text(

                      "$flag $name",

                      style:
                      GoogleFonts.poppins(

                        color:
                        Colors.white,

                        fontSize:16,

                        fontWeight:
                        FontWeight.w600,

                      ),

                    ),

                  ),



                  Container(

                    padding:
                    const EdgeInsets.symmetric(

                      horizontal:10,

                      vertical:5,

                    ),


                    decoration:
                    BoxDecoration(

                      borderRadius:
                      BorderRadius.circular(15),

                      color:
                      Colors.pinkAccent,

                    ),



                    child:
                    Text(

                      vip,

                      style:
                      const TextStyle(

                        color:
                        Colors.white,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),

                  )



                ],

              ),




              const Spacer(),





              Text(

                description,


                style:
                GoogleFonts.poppins(

                  color:
                  Colors.white70,

                  fontSize:14,

                ),

              ),




              const SizedBox(height:10),





              Row(

                children:[


                  badge(level,Colors.greenAccent),


                  const SizedBox(width:8),


                  badge(role,Colors.orangeAccent),



                  const Spacer(),



                  const Icon(

                    Icons.favorite,

                    color:
                    Colors.pinkAccent,

                    size:20,

                  ),



                  Text(

                    "$likes",

                    style:
                    const TextStyle(

                      color:
                      Colors.white,

                    ),

                  )


                ],

              ),




              const SizedBox(height:12),




              Container(

                height:45,

                width:
                double.infinity,

                decoration:
                BoxDecoration(

                  gradient:
                  const LinearGradient(

                    colors:[

                      Colors.amber,

                      Colors.orange,

                    ],

                  ),

                  borderRadius:
                  BorderRadius.circular(20),

                ),


                child:
                Center(

                  child:
                  Text(

                    "JOIN ROOM",

                    style:
                    GoogleFonts.poppins(

                      color:
                      Colors.black,

                      fontWeight:
                      FontWeight.w700,

                    ),

                  ),

                ),


              )



            ],


          ),


        )
        );



    }




  Widget badge(
      String text,
      Color color
      ){

    return Container(

      padding:
      const EdgeInsets.symmetric(

        horizontal:12,

        vertical:4,

      ),


      decoration:
      BoxDecoration(

        border:
        Border.all(

          color:color,

        ),

        borderRadius:
        BorderRadius.circular(15),

      ),


      child:
      Text(

        text,

        style:
        TextStyle(

          color:color,

          fontSize:11,

          fontWeight:
          FontWeight.bold,

        ),

      ),


    );


  }



}