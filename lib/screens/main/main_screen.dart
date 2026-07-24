import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../moments/moments_screen.dart';
import '../chat/chat_list_screen.dart';
import '../home/profile_screen.dart';



class MainScreen extends StatefulWidget {


  const MainScreen({super.key});


  @override
  State<MainScreen> createState()=>_MainScreenState();


}



class _MainScreenState extends State<MainScreen>{



  int currentIndex=0;



  final pages=[


    const HomeScreen(),

    const MomentsScreen(),

    const ChatListScreen(),

    const ProfileScreen(),


  ];





  @override
  Widget build(BuildContext context){


    return Scaffold(



        backgroundColor:
        const Color(0xff050018),




        body:
        pages[currentIndex],




        bottomNavigationBar:
        Container(



          decoration:
          BoxDecoration(


              color:
              const Color(0xff090020),



              borderRadius:
              const BorderRadius.vertical(

                top:Radius.circular(25),

              ),




              border:
              Border.all(

                color:
                Colors.purpleAccent.withOpacity(.35),

              ),



              boxShadow:[


                BoxShadow(

                  color:
                  Colors.purpleAccent.withOpacity(.25),

                  blurRadius:20,

                )


              ]



          ),




          child:
          ClipRRect(

            borderRadius:
            const BorderRadius.vertical(

              top:Radius.circular(25),

            ),



            child:
            BottomNavigationBar(



              backgroundColor:
              Colors.transparent,



              type:
              BottomNavigationBarType.fixed,



              currentIndex:
              currentIndex,



              selectedItemColor:
              Colors.amber,



              unselectedItemColor:
              Colors.white54,




              selectedLabelStyle:
              const TextStyle(

                fontWeight:
                FontWeight.bold,

              ),




              items:[



                BottomNavigationBarItem(

                  icon:
                  Icon(

                    Icons.home_rounded,

                  ),

                  label:
                  "Home",

                ),




                BottomNavigationBarItem(

                  icon:
                  Icon(

                    Icons.auto_awesome,

                  ),

                  label:
                  "Moments",

                ),




                BottomNavigationBarItem(

                  icon:
                  Icon(

                    Icons.chat_bubble_outline,

                  ),

                  label:
                  "Chat",

                ),




                BottomNavigationBarItem(

                  icon:
                  Icon(

                    Icons.person_outline,

                  ),

                  label:
                  "Profile",

                ),



              ],




              onTap:(index){


                setState((){


                  currentIndex=index;


                });


              },




            ),



          ),

        )

        );



    }


}