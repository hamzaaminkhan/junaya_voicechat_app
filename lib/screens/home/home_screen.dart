import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/widgets/room_card.dart';
import 'package:junaya_voicechat_app/widgets/space_background.dart';
import '../../widgets/ranking_card.dart';
import '../../widgets/country_chip.dart';
import '../../widgets/category_chip.dart';
import '../vip/vip_screen.dart';

import '../../widgets/banner_indicator.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  final List<Map<String,dynamic>> rooms = [

    {
      "flag":"🇵🇰",
      "name":"Pakistan Star",
      "desc":"Music & Fun Chat",
      "vip":"VIP 3",
      "level":"LV 8",
      "role":"Host",
      "likes":65,
    },

    {
      "flag":"🇮🇳",
      "name":"India Music",
      "desc":"Join Voice Room",
      "vip":"VIP 2",
      "level":"LV 5",
      "role":"Manager",
      "likes":32,
    },

    {
      "flag":"🇧🇩",
      "name":"Bangladesh Live",
      "desc":"Friends Voice Room",
      "vip":"VIP 1",
      "level":"LV 4",
      "role":"Host",
      "likes":120,
    },

    {
      "flag":"🇹🇷",
      "name":"Turkey Party",
      "desc":"Music Night",
      "vip":"VIP 4",
      "level":"LV 9",
      "role":"Admin",
      "likes":250,
    },

    {
      "flag":"🇦🇪",
      "name":"Dubai VIP",
      "desc":"Luxury Voice Room",
      "vip":"VIP 5",
      "level":"LV 10",
      "role":"Owner",
      "likes":500,
    },

  ];

  final PageController bannerController = PageController();

  int bannerIndex = 0;
  int selectedTab = 0;
  int selectedCountry = 0;

  final List<String> tabs = [

    "HOT",
    "RECENT",
    "FOLLOW"

  ];

  final List<String> countries = [

    "All",
    "🇵🇰 Pakistan",
    "🇮🇳 India",
    "🇧🇩 Bangladesh"

  ];



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      extendBody:true,

      floatingActionButton:
      createRoomButton(),

      backgroundColor:
      const Color(0xff050018),


      body: SpaceBackground(

        child: SafeArea(

          child: RefreshIndicator(

            color:
            Colors.amber,


            onRefresh:()async{


              await Future.delayed(

                  const Duration(
                      seconds:1
                  )

              );


            },


            child: SingleChildScrollView(

            child: Column(

              children:[


                header(),


                const SizedBox(height:5),


                rankingSection(),


                const SizedBox(height:12),


                tabSection(),


                const SizedBox(height:8),


                countrySection(),


                const SizedBox(height:12),



                SizedBox(

                  height:170,

                  child:
                  homeBannerSlider(),

                ),


                const SizedBox(height:10),


                BannerIndicator(

                  total:15,

                  current:bannerIndex,

                ),


                const SizedBox(height:15),

                sectionTitle(
                  "Popular Rooms",
                ),

                const SizedBox(height:10),

                ListView.builder(

                  shrinkWrap:true,

                  physics:
                  const NeverScrollableScrollPhysics(),

                  itemCount:rooms.length,

                  itemBuilder:(context,index){

                    final room=rooms[index];


                    return JunaidRoomCard(

                      flag: room["flag"] as String,

                      roomName: room["name"] as String,

                      description: room["desc"] as String,

                      vip: room["vip"] as String,

                      level: room["level"] as String,

                      role: room["role"] as String,

                      likes: room["likes"] as int,


                    );

                  },

                ),


                roomList(),



              ],

            )

          ),

        ),

      ),

    ),

    );


  }

// ================= HEADER =================

  Widget header() {

    return Padding(

      padding: const EdgeInsets.symmetric(
        horizontal:8,
      ),

      child: Row(

        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

        children:[

          // LOGO AREA

          Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children:[

              Row(

                children:[

                  const Text(

                    "♛",

                    style: TextStyle(

                      color: Colors.amber,

                      fontSize:15,

                    ),

                  ),

                  Text(

                    "JUNAYA",

                    style:
                    GoogleFonts.poppins(

                      color:
                      Colors.amber,

                      fontSize:15,

                      fontWeight:
                      FontWeight.w600,

                      letterSpacing:1.5,

                    ),

                  ),

                ],

              ),

              Text(

                "  ─  CHAT  ─",

                style:
                GoogleFonts.poppins(

                  color:
                  Colors.purpleAccent,

                  fontSize:9,

                  letterSpacing:2,

                  fontWeight:
                  FontWeight.w500,

                ),

              ),
            ],

          ),

          // ICONS


          Row(

            children:[


              glowButton(

                Icons.workspace_premium,

                    (){

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder:(_)=>
                      const VipScreen(),

                    ),

                  );

                },

              ),

              const SizedBox(width:5),


              glowButton(

                Icons.notifications_none,

                    (){},

              ),

            ],

          ),

        ],

      ),

    );

  }

// ================= RANKING =================

  Widget rankingSection(){

    return SizedBox(

      height:55,

      child: ListView(

        scrollDirection: Axis.horizontal,

        children:[

          RankingCard(
            title:"Shining\nStar",
            icon:"⭐",
            color:Colors.greenAccent,
          ),


          RankingCard(
            title:"CP\nRanking",
            icon:"❤️",
            color:Colors.pinkAccent,
          ),


          RankingCard(
            title:"Ranking",
            icon:"🏆",
            color:Colors.orangeAccent,
          ),

        ],

      ),

    );

  }

// ================= TABS =================

  Widget tabSection(){


    return SizedBox(


      height:30,


      child:
      ListView(

        scrollDirection:
        Axis.horizontal,


        padding:
        const EdgeInsets.symmetric(
          horizontal:18,
        ),



        children:[



          CategoryChip(

            text:"HOT",

            active:true,

          ),



          CategoryChip(

            text:"RECENTLY",

          ),



          CategoryChip(

            text:"FOLLOW",

          ),



        ],



      ),


    );


  }

// ================= COUNTRY =================



  Widget countrySection(){


    return SizedBox(


      height:32,


      child:
      ListView(

        scrollDirection:
        Axis.horizontal,


        padding:
        const EdgeInsets.symmetric(
          horizontal:18,
        ),



        children:[



          CountryChip(

            name:"All",

            flag:"✓",

            active:true,

          ),



          CountryChip(

            name:"Pakistan",

            flag:"🇵🇰",

          ),



          CountryChip(

            name:"Bangladesh",

            flag:"🇧🇩",

          ),



          CountryChip(

            name:"India",

            flag:"🇮🇳",

          ),



          CountryChip(

            name:"Turkey",

            flag:"🇹🇷",

          ),



          Container(

            padding:
            const EdgeInsets.all(10),

            child:
            const Icon(

              Icons.arrow_forward_ios,

              color:Colors.white,

              size:16,

            ),

          )



        ],



      ),



    );


  }

// ================= BANNER =================


  Widget banner(

      String title,

      String subtitle,

      ){

    return Container(

      margin:
      const EdgeInsets.symmetric(
        horizontal:5,
      ),

      decoration:
      BoxDecoration(

        gradient:
        const LinearGradient(

            colors:[

              Color(0xff4B0082),

              Color(0xff8A2BE2)

            ]

        ),


        borderRadius:
        BorderRadius.circular(12),

      ),

      child:Column(

        mainAxisAlignment:
        MainAxisAlignment.center,

        children:[

          Text(

            title,

            style:
            GoogleFonts.poppins(

              color:
              Colors.white,

              fontSize:25,

              fontWeight:
              FontWeight.bold,

            ),

          ),


          Text(

            subtitle,

            style:
            const TextStyle(

              color:
              Colors.white70,

              fontSize:12,

            ),

          )


        ],


      ),


    );


  }



  Widget glowButton(

      IconData icon,

      VoidCallback press,

      ){


    return Container(


      decoration:
      BoxDecoration(


          shape:
          BoxShape.circle,


          boxShadow:[


            BoxShadow(

              color:
              Colors.purpleAccent.withValues(alpha: .08),

              blurRadius:20,

            )

          ]


      ),



      child:IconButton(


        onPressed:press,


        icon:
        Icon(

          icon,

          color:
          Colors.amber,

          size:30,

        ),


      ),


    );


  }

  Widget sectionTitle(String text) {

    return Padding(

      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      child: Align(

        alignment: Alignment.centerLeft,

        child: Text(

          text,

          style: GoogleFonts.poppins(

            color: Colors.white,

            fontSize: 22,

            fontWeight: FontWeight.w600,

          ),

        ),

      ),

    );

  }

   Widget homeBannerSlider(){

    return Container(

      height:170,

      margin: const EdgeInsets.symmetric(
        horizontal:16,
      ),


      child: PageView.builder(

        onPageChanged:(index){

          setState((){

            bannerIndex=index;

          });

        },



        itemCount:15,


        controller:
        bannerController,


        itemBuilder:(context,index){


          return Container(


            margin:
            const EdgeInsets.symmetric(
              horizontal:6,
            ),



            decoration:
            BoxDecoration(


                borderRadius:
                BorderRadius.circular(18),


                gradient:
                LinearGradient(

                  colors:[

                    Colors.purple.shade900,

                    Colors.blue.shade700,

                  ],

                ),


                boxShadow:[


                  BoxShadow(

                    color:
                    Colors.purple.withOpacity(.5),

                    blurRadius:20,

                  )


                ]

            ),




            child:
            Stack(

              children:[



                Align(

                  alignment:
                  Alignment.center,


                  child: ClipRRect(

                    borderRadius:
                    BorderRadius.circular(18),

                    child: Image.asset(

                      [
                        "assets/banners/welcome.png",
                        "assets/banners/welcome2.png",
                        "assets/banners/welcome3.png",
                        "assets/banners/welcome4.png",

                      ][index % 4],


                      fit: BoxFit.cover,

                      width: double.infinity,

                      height: double.infinity,

                    ),

                  ),





                ),




              ],


            ),


          );



        },


      ),


    );

  }

  Widget createRoomButton(){

    return Container(

      decoration:
      BoxDecoration(

          shape:
          BoxShape.circle,


          boxShadow:[

            BoxShadow(

              color:
              Colors.amber.withOpacity(.6),

              blurRadius:25,

            )

          ]

      ),



      child:
      FloatingActionButton(

        backgroundColor:
        Colors.amber,


        onPressed:(){



        },


        child:
        const Icon(

          Icons.mic,

          color:
          Colors.black,

          size:30,

        ),


      ),

    );


  }

  Widget roomList(){

    final List<Map<String,dynamic>> rooms=[


      {
        "flag":"🇵🇰",
        "name":"Pakistan Star",
        "desc":"Music & Fun Chat",
        "vip":"VIP 3",
        "level":"LV 8",
        "role":"Host",
        "likes":65,
      },


      {
        "flag":"🇮🇳",
        "name":"India Music",
        "desc":"Join Voice Room",
        "vip":"VIP 2",
        "level":"LV 5",
        "role":"Manager",
        "likes":32,
      },


      {
        "flag":"🇧🇩",
        "name":"Bangladesh Live",
        "desc":"Friends Voice Room",
        "vip":"VIP 1",
        "level":"LV 4",
        "role":"Host",
        "likes":120,
      },


      {
        "flag":"🇹🇷",
        "name":"Turkey Night",
        "desc":"Party & Music",
        "vip":"VIP 4",
        "level":"LV 9",
        "role":"Admin",
        "likes":250,
      },


      {
        "flag":"🇦🇪",
        "name":"Dubai VIP",
        "desc":"Luxury Voice Chat",
        "vip":"VIP 5",
        "level":"LV 10",
        "role":"Owner",
        "likes":500,
      },


    ];


    return Column(

      children:

      rooms.map((room){

        return JunaidRoomCard(

          flag: room["flag"] as String,

          roomName: room["name"] as String,

          description: room["desc"] as String,

          vip: room["vip"] as String,

          level: room["level"] as String,

          role: room["role"] as String,

          likes: room["likes"] as int,

        );

      }).toList(),

    );


  }


}