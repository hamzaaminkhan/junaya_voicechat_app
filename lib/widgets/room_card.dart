import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/home/rooms/room_screen.dart';



class JunaidRoomCard extends StatelessWidget {


  final String flag;
  final String roomName;
  final String description;
  final String vip;
  final String level;
  final String role;
  final int likes;


  const JunaidRoomCard({

    super.key,

    required this.flag,

    required this.roomName,

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

        horizontal:15,

        vertical:10,

      ),



      padding:
      const EdgeInsets.all(14),




      decoration:
      BoxDecoration(



          gradient:
          LinearGradient(


            colors:[


              const Color(0xff14102F),

              const Color(0xff090018),


            ],


          ),




          borderRadius:
          BorderRadius.circular(28),




          border:
          Border.all(



            color:
            Colors.purpleAccent.withOpacity(.6),



            width:1.2,



          ),




          boxShadow:[



            BoxShadow(


              color:
              Colors.purpleAccent.withOpacity(.25),


              blurRadius:30,


              spreadRadius:2,


            )


          ]


      ),





      child:Column(



        children:[





// TOP ROOM INFO


          Row(


            children:[




// MIC ICON



              Container(


                height:50,


                width:50,



                decoration:
                BoxDecoration(



                    gradient:
                    const LinearGradient(



                      colors:[


                        Color(0xffB721FF),


                        Color(0xff21D4FD),



                      ],



                    ),




                    borderRadius:
                    BorderRadius.circular(22),




                    boxShadow:[


                      BoxShadow(

                        color:
                        Colors.blue.withOpacity(.7),

                        blurRadius:25,

                      )


                    ]



                ),




                child:
                const Icon(


                  Icons.mic,


                  size:40,


                  color:
                  Colors.white,


                ),



              ),







              const SizedBox(width:13),





// ROOM TEXT


              Expanded(



                child:Column(



                  crossAxisAlignment:
                  CrossAxisAlignment.start,



                  children:[




                    Row(

                      children:[



                        Text(


                          "$flag $roomName",



                          style:
                          GoogleFonts.poppins(


                            color:
                            Colors.white,


                            fontSize:10,


                            fontWeight:
                            FontWeight.bold,


                          ),



                        ),



                      ],



                    ),





                    const SizedBox(height:6),




                    Text(


                      description,



                      style:
                      GoogleFonts.poppins(



                        color:
                        Colors.white60,


                        fontSize:14,


                      ),



                    ),





                  ],



                ),



              ),








// VIP BADGE



              Container(


                padding:
                const EdgeInsets.symmetric(

                  horizontal:12,

                  vertical:6,

                ),




                decoration:
                BoxDecoration(



                  borderRadius:
                  BorderRadius.circular(20),




                  border:
                  Border.all(

                    color:
                    Colors.pinkAccent,

                  ),



                  color:
                  Colors.pink.withOpacity(.15),



                ),





                child:
                Text(


                  vip,


                  style:
                  const TextStyle(


                    color:
                    Colors.pinkAccent,


                    fontWeight:
                    FontWeight.bold,


                  ),


                ),




              ),





            ],



          ),







          const SizedBox(height:25),






// LEVEL ROW


          Row(



            children:[




              badge(

                level,

                Colors.greenAccent,

              ),





              const SizedBox(width:10),





              badge(

                role,

                Colors.orangeAccent,

              ),





              const Spacer(),





              Row(


                children:[



                  const Icon(


                    Icons.favorite,


                    color:
                    Colors.purpleAccent,


                    size:22,


                  ),



                  const SizedBox(width:5),




                  Text(


                    "$likes",


                    style:
                    const TextStyle(


                      color:
                      Colors.white,


                      fontSize:16,


                      fontWeight:
                      FontWeight.bold,


                    ),



                  ),



                ],



              ),





            ],



          ),






          const SizedBox(height:18),







// JOIN BUTTON



          GestureDetector(



            onTap:(){



              Navigator.push(


                context,


                MaterialPageRoute(


                  builder:(_)=>

                  const RoomScreen(),


                ),



              );



            },





            child:
            Container(



              height:27,



              width:
              double.infinity,




              decoration:
              BoxDecoration(



                  gradient:
                  const LinearGradient(



                    colors:[


                      Color(0xffffd700),


                      Color(0xffff9800),


                    ],



                  ),



                  borderRadius:
                  BorderRadius.circular(18),



                  boxShadow:[
                    BoxShadow(
                      color:Colors.amber.withOpacity(.6),
                      blurRadius:25,
                    )
                  ]




              ),





              child:
              Center(


                child:
                Text(



                  "Join Room",



                  style:
                  GoogleFonts.poppins(



                    color:
                    Colors.black,


                    fontSize:17,


                    fontWeight:
                    FontWeight.bold,


                  ),



                ),



              ),





            ),




          ),





        ],



      ),




    );



  }






  Widget badge(

      String text,

      Color color,

      ){



    return Container(


      padding:
      const EdgeInsets.symmetric(


        horizontal:14,


        vertical:6,


      ),




      decoration:
      BoxDecoration(



        color:
        color.withOpacity(.15),




        border:
        Border.all(

          color:color,

        ),




        borderRadius:
        BorderRadius.circular(18),



      ),




      child:
      Text(



        text,



        style:
        TextStyle(



          color:
          color,


          fontWeight:
          FontWeight.bold,


          fontSize:12,


        ),



      ),



    );



  }



}