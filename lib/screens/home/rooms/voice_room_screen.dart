import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/mic_seat.dart';


class VoiceRoomScreen extends StatefulWidget {


  final String roomId;


  const VoiceRoomScreen({

    super.key,

    required this.roomId,

  });



  @override
  State<VoiceRoomScreen> createState()=>_VoiceRoomScreenState();


}



class _VoiceRoomScreenState extends State<VoiceRoomScreen>{


  bool micOn=false;



  @override
  Widget build(BuildContext context){


    return Scaffold(


      backgroundColor: Colors.transparent,



      body:
      SafeArea(

        child:Column(

          children:[



            roomHeader(),



            const SizedBox(height:20),



            Expanded(

              child:
              seatGrid(),

            ),



            chatBox(),



            bottomControls(),



          ],

        ),

      ),

    );


  }



// ================= HEADER =================


  Widget roomHeader(){


    return Padding(

      padding:
      const EdgeInsets.all(15),


      child:Row(

        children:[


          IconButton(

            icon:
            const Icon(

              Icons.arrow_back,

              color:Colors.white,

            ),

            onPressed:(){

              Navigator.pop(context);

            },

          ),



          Expanded(

            child:
            Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,


              children:[


                Text(

                  "CS Pakistan Room",

                  style:
                  GoogleFonts.poppins(

                    color:Colors.white,

                    fontSize:18,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),



                onlineUsers(),



              ],

            ),

          ),




          IconButton(

            icon:
            const Icon(

              Icons.card_giftcard,

              color:Colors.amber,

            ),

            onPressed:(){},


          ),


        ],


      ),


    );


  }




// ================= ONLINE USERS =================


  Widget onlineUsers(){


    return StreamBuilder<DocumentSnapshot>(


      stream:

      FirebaseFirestore.instance

          .collection("voice_rooms")

          .doc(widget.roomId)

          .snapshots(),



      builder:(context,snapshot){


        if(!snapshot.hasData){

          return const SizedBox();

        }



        var data =
        snapshot.data!.data()
        as Map<String,dynamic>?;



        return Text(

          "${data?['onlineUsers'] ?? 0} Online",

          style:

          const TextStyle(

            color:Colors.greenAccent,

          ),

        );


      },


    );


  }



// ================= SEATS =================



  Widget seatGrid(){


    return StreamBuilder<QuerySnapshot>(


      stream:

      FirebaseFirestore.instance

          .collection("voice_rooms")

          .doc(widget.roomId)

          .collection("seats")

          .snapshots(),



      builder:(context,snapshot){


        if(!snapshot.hasData){

          return const Center(

            child:CircularProgressIndicator(),

          );

        }




        return GridView.builder(


          padding:
          const EdgeInsets.all(20),


          itemCount:9,


          gridDelegate:

          const SliverGridDelegateWithFixedCrossAxisCount(

            crossAxisCount:3,

            mainAxisSpacing:20,

            crossAxisSpacing:20,

          ),



          itemBuilder:(context,index){



            String? username;

            bool mic=false;



            for(var seat in snapshot.data!.docs){


              if(seat.id==index.toString()){


                final data =
                seat.data()
                as Map<String,dynamic>;



                username =
                data['username'];


                mic =
                    data['mic'] ?? false;


              }


            }




            return MicSeat(

              username:username,

              micOn:mic,

            );


          },


        );


      },


    );



  }



// ================= CHAT =================


  Widget chatBox(){


    return Container(

      height:90,


      padding:
      const EdgeInsets.all(12),


      alignment:
      Alignment.centerLeft,


      child:
      const Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children:[


          Text(

            "💬 Welcome to the room",

            style:

            TextStyle(

              color:Colors.white70,

            ),

          ),


          Text(

            "User joined the room",

            style:

            TextStyle(

              color:Colors.white54,

            ),

          ),


        ],


      ),


    );


  }



// ================= CONTROLS =================


  Widget bottomControls(){


    return Padding(

      padding:
      const EdgeInsets.all(15),


      child:Row(

        mainAxisAlignment:
        MainAxisAlignment.spaceAround,


        children:[


          controlButton(

            micOn
                ?
            Icons.mic
                :
            Icons.mic_off,


                (){


              setState((){

                micOn=!micOn;

              });


            },


          ),



          controlButton(

            Icons.card_giftcard,

                (){},


          ),



          controlButton(

            Icons.chat,

                (){},


          ),



        ],


      ),


    );


  }





  Widget controlButton(

      IconData icon,

      VoidCallback tap,

      ){


    return CircleAvatar(

      radius:28,


      backgroundColor:
      Colors.white12,


      child:

      IconButton(

        onPressed:tap,


        icon:

        Icon(

          icon,

          color:Colors.amber,

        ),


      ),


    );


  }


}