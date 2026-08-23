import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/room_card.dart';
import '../../widgets/space_background.dart';
import '../../widgets/home_top_tabs.dart';
import '../../widgets/country_chip.dart';
import '../../widgets/event_banner.dart';
import '../../widgets/category_shortcuts.dart';
import '../../widgets/announcement_bar.dart';

import '../notifications/notification_screen.dart';
import '../vip/vip_screen.dart';


class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}



class _HomeScreenState extends State<HomeScreen> {


int selectedTab = 0;

int selectedCountry = 0;



final List<EventBannerItem> banners = [


EventBannerItem(
image: 'assets/banners/welcome.png',
title: 'Junaya Party 🎉',
subtitle: 'Join thousands of live rooms',
),


EventBannerItem(
image: 'assets/banners/welcome2.png',
title: 'VIP Rooms 🔥',
subtitle: 'Exclusive voice experiences',
),


EventBannerItem(
image: 'assets/banners/welcome3.png',
title: 'Top Hosts 👑',
subtitle: 'Meet popular creators',
),


EventBannerItem(
image: 'assets/banners/welcome4.png',
title: 'Voice Events 🎤',
subtitle: 'Join live conversations',
),


];




final List<Map<String,dynamic>> rooms = [


{
'flag':'🇵🇰',
'name':'Pakistan Star',
'desc':'Music & Fun Chat',
'vip':'VIP 3',
'level':'LV 8',
'role':'Host',
'likes':650,
'cover':'assets/rooms/room1.jpeg'
},


{
'flag':'🇮🇳',
'name':'India Music',
'desc':'Live Singing Room',
'vip':'VIP 2',
'level':'LV 5',
'role':'Manager',
'likes':320,
'cover':'assets/rooms/room2.jpeg'
},


{
'flag':'🇧🇩',
'name':'Bangladesh Live',
'desc':'Friends Voice Room',
'vip':'VIP 1',
'level':'LV 4',
'role':'Host',
'likes':120,
'cover':'assets/rooms/room3.jpeg'
},


{
'flag':'🇹🇷',
'name':'Turkey Party',
'desc':'Music Night',
'vip':'VIP 4',
'level':'LV 9',
'role':'Admin',
'likes':250,
'cover':'assets/rooms/room4.jpeg'
},


{
'flag':'🇦🇪',
'name':'Dubai VIP',
'desc':'Luxury Voice Room',
'vip':'VIP 5',
'level':'LV 10',
'role':'Owner',
'likes':500,
'cover':'assets/rooms/room5.jpeg'
},


{
'flag':'🇰🇷',
'name':'Korea Lounge',
'desc':'Chill Conversation',
'vip':'VIP 2',
'level':'LV 6',
'role':'Host',
'likes':210,
'cover':'assets/rooms/room6.jpeg'
},


{
'flag':'🇯🇵',
'name':'Tokyo Night',
'desc':'Anime Music Chat',
'vip':'VIP 3',
'level':'LV 7',
'role':'Host',
'likes':390,
'cover':'assets/rooms/room7.jpeg'
},


{
'flag':'🇺🇸',
'name':'USA Talk Zone',
'desc':'International Chat',
'vip':'VIP 4',
'level':'LV 8',
'role':'Admin',
'likes':720,
'cover':'assets/rooms/room8.jpeg'
},


];



final List<Map<String,String>> countries = const [


{
'name':'All',
'flag':'✓'
},


{
'name':'Pakistan',
'flag':'🇵🇰'
},


{
'name':'India',
'flag':'🇮🇳'
},


{
'name':'Bangladesh',
'flag':'🇧🇩'
},


{
'name':'Turkey',
'flag':'🇹🇷'
},


];



@override
Widget build(BuildContext context) {

return Scaffold(

extendBody:true,

backgroundColor:Colors.transparent,


body:SpaceBackground(

child:SafeArea(

bottom:false,

child:CustomScrollView(

physics:
const BouncingScrollPhysics(),


slivers:[


SliverToBoxAdapter(
child:header(),
),


const SliverToBoxAdapter(
child:SizedBox(height:12),
),


SliverToBoxAdapter(

child:HomeTopTabs(

selectedIndex:selectedTab,

onChanged:(index){

setState((){

selectedTab=index;

});

},

),

),


const SliverToBoxAdapter(
child:SizedBox(height:15),
),


SliverToBoxAdapter(

child:EventBanner(

banners:banners,

),

),


const SliverToBoxAdapter(
child:SizedBox(height:15),
),
  SliverToBoxAdapter(

    child:CategoryShortcuts(

      onTap:(item){},

    ),

  ),


  const SliverToBoxAdapter(

    child:SizedBox(height:15),

  ),



  const SliverToBoxAdapter(

    child:AnnouncementBar(messages: [],),

  ),



  const SliverToBoxAdapter(

    child:SizedBox(height:15),

  ),



  SliverToBoxAdapter(

    child:countrySection(),

  ),



  const SliverToBoxAdapter(

    child:SizedBox(height:18),

  ),



  SliverToBoxAdapter(

    child:sectionTitle(),

  ),



  const SliverToBoxAdapter(

    child:SizedBox(height:8),

  ),



  SliverPadding(

    padding:
    const EdgeInsets.symmetric(
      horizontal:15,
    ),


    sliver:SliverGrid(

      delegate:
      SliverChildBuilderDelegate(


            (context,index){


          final room =
          rooms[index];



          return JunayaRoomCard(

            flag:
            room['flag'],

            roomName:
            room['name'],

            description:
            room['desc'],

            vip:
            room['vip'],

            level:
            room['level'],

            role:
            room['role'],

            likes:
            room['likes'],

            coverImage:
            room['cover'],

          );


        },


        childCount:
        rooms.length,


      ),



      gridDelegate:

      const SliverGridDelegateWithFixedCrossAxisCount(

        crossAxisCount:2,

        crossAxisSpacing:12,

        mainAxisSpacing:15,

        childAspectRatio:.85,

      ),


    ),

  ),



  const SliverToBoxAdapter(

    child:SizedBox(height:130),

  ),


],

),

),

),

);

}






Widget header(){


  return Padding(

    padding:
    const EdgeInsets.fromLTRB(
      15,
      8,
      12,
      0,
    ),


    child:Row(

      children:[


        Expanded(

          child:Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,


            children:[


              Text(

                "JUNAYA",

                style:
                GoogleFonts.poppins(

                  color:
                  Colors.white,

                  fontSize:18,

                  fontWeight:
                  FontWeight.w700,

                ),

              ),



              Text(

                "VOICE CHAT",

                style:
                GoogleFonts.poppins(

                  color:
                  Colors.white54,

                  fontSize:9,

                  letterSpacing:2,

                ),

              ),


            ],

          ),

        ),



        _headerButton(

          Icons.workspace_premium_outlined,

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



        const SizedBox(width:8),



        _headerButton(

          Icons.notifications_none_rounded,

              (){

            Navigator.push(

              context,

              MaterialPageRoute(

                builder:(_)=>
                const NotificationScreen(),

              ),

            );

          },

        ),



      ],

    ),

  );

}






Widget _headerButton(
    IconData icon,
    VoidCallback onTap,
    ){


  return InkWell(

    onTap:onTap,

    borderRadius:
    BorderRadius.circular(12),


    child:Container(

      height:38,

      width:38,


      decoration:BoxDecoration(

        color:
        Colors.black.withValues(
          alpha:.18,
        ),


        borderRadius:
        BorderRadius.circular(12),


        border:
        Border.all(

          color:
          Colors.white.withValues(
            alpha:.10,
          ),

        ),

      ),


      child:Icon(

        icon,

        color:
        const Color(0xffffc857),

        size:21,

      ),

    ),

  );

}






Widget countrySection(){


  return SizedBox(

    height:36,


    child:ListView.separated(

      padding:
      const EdgeInsets.symmetric(
        horizontal:15,
      ),


      scrollDirection:
      Axis.horizontal,


      itemCount:
      countries.length,


      separatorBuilder:
          (_,_) =>
      const SizedBox(
        width:8,
      ),



      itemBuilder:(context,index){


        final item =
        countries[index];



        return GestureDetector(

          onTap:(){

            setState((){

              selectedCountry =
                  index;

            });

          },


          child:CountryChip(

            name:
            item['name']!,


            flag:
            item['flag']!,


            active:
            selectedCountry==index,

          ),

        );


      },


    ),

  );

}





Widget sectionTitle(){


  return Padding(

    padding:
    const EdgeInsets.symmetric(
      horizontal:15,
    ),


    child:Row(

      children:[


        Expanded(

          child:Text(

            "Popular Rooms",

            style:
            GoogleFonts.poppins(

              color:
              Colors.white,

              fontSize:20,

              fontWeight:
              FontWeight.w700,

            ),

          ),

        ),



        Container(

          padding:
          const EdgeInsets.symmetric(

            horizontal:10,

            vertical:4,

          ),


          decoration:
          BoxDecoration(

            color:
            Colors.white.withValues(
              alpha:.06,
            ),


            borderRadius:
            BorderRadius.circular(20),

          ),


          child:const Text(

            "LIVE NOW",

            style:TextStyle(

              color:
              Color(0xff00D9B5),

              fontSize:10,

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