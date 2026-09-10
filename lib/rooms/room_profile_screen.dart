import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/rooms/models/voice_room_model.dart';



class RoomProfileScreen extends StatefulWidget {
  final VoiceRoom room;

  final int followerCount;

  final VoidCallback? onRefresh;
  final VoidCallback? onTop;
  final VoidCallback? onSetting;
  final VoidCallback? onRules;


  const RoomProfileScreen({
    super.key,
    required this.room,
    this.followerCount = 0,
    this.onRefresh,
    this.onTop,
    this.onSetting,
    this.onRules,
  });


  @override
  State<RoomProfileScreen> createState() =>
      _RoomProfileScreenState();
}



class _RoomProfileScreenState
    extends State<RoomProfileScreen> {


static const Color cyan =
Color(0xFF22D7C5);

static const Color coral =
Color(0xFFFF6567);


int _selectedTab = 0;

@override
Widget build(BuildContext context) {

  return Scaffold(

    backgroundColor:
    Colors.transparent,


    body: SafeArea(

      bottom: false,


      child: Stack(

        children: [


          const Positioned.fill(

            child: _Background(),

          ),



          _buildContent(),


        ],

      ),

    ),

  );

}




Widget _buildContent() {

  return Positioned(

    left: 0,

    right: 0,

    bottom: 0,


    top: 140,


    child: Container(


      decoration: const BoxDecoration(

        color:
        Color(0xFF351C64),


        borderRadius:
        BorderRadius.only(

          topLeft:
          Radius.circular(35),


          topRight:
          Radius.circular(35),

        ),

      ),



      child: Column(

        children: [



          Expanded(

            child:
            SingleChildScrollView(

              physics:
              const BouncingScrollPhysics(),


              child: Column(

                children: [


                  _buildHeaderCard(),



                  const SizedBox(
                    height: 18,
                  ),



                  Padding(

                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 28,
                    ),


                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,


                      children: [


                        _buildTabs(),



                        const SizedBox(
                          height: 20,
                        ),



                        _buildSelectedTab(),


                      ],

                    ),

                  ),


                ],

              ),

            ),

          ),




          _buildBottomButtons(),


        ],

      ),

    ),

  );

}







Widget _buildHeaderCard() {


final room =
widget.room;


final owner =
room.owner;



final roomName =
room.name.trim().isEmpty

? "Room"

: room.name.trim();



final avatar =
owner?.avatar;



return Container(

width: double.infinity,


padding:
const EdgeInsets.fromLTRB(
28,
30,
28,
24,
),



  decoration: BoxDecoration(

    borderRadius:
    BorderRadius.circular(24),

  ),



child: Row(

children: [



ClipRRect(

borderRadius:
BorderRadius.circular(14),



child:
avatar != null &&
avatar.isNotEmpty


? Image.network(

avatar,

width: 62,

height: 62,

fit:
BoxFit.cover,

)


:

Container(

width: 62,

height: 62,


color:
const Color(
0xFF6A397F),



alignment:
Alignment.center,


child:
Text(

roomName[0]
.toUpperCase(),


style:
const TextStyle(

color:
Colors.white,


fontSize:
26,


fontWeight:
FontWeight.bold,

),

),

),

),




const SizedBox(width: 14),




Expanded(

child: Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children: [



Text(

roomName,


maxLines: 1,


overflow:
TextOverflow.ellipsis,


style:
const TextStyle(

color:
Colors.white,


fontSize:
20,


fontWeight:
FontWeight.w700,

),

),




const SizedBox(height: 5),




Text(

"ID: ${owner?.junayaId ?? room.id}",


style:
TextStyle(

color:
Colors.white
.withOpacity(.55),


fontSize:
13,

),

),



],

),

),





InkWell(

onTap:
widget.onRefresh,


child:
const Icon(

Icons.refresh_rounded,


color:
Colors.white,


size:
32,

),

),


],

),

);

}

Widget _buildTabs() {


const tabs = [
"Profile",
"Member",
"Activity",
];


return Row(

children: [

for(int i = 0; i < tabs.length; i++)

GestureDetector(

onTap: () {

setState(() {

_selectedTab = i;

});

},


child: Padding(

padding:
EdgeInsets.only(

right:
i == tabs.length - 1
? 0
: 28,

),


child: Column(

children: [


Text(

tabs[i],


style:
TextStyle(

color:
i == _selectedTab

? Colors.white

: Colors.white54,


fontSize:
17,


fontWeight:
FontWeight.w400,

),

),



const SizedBox(height: 7),



AnimatedContainer(

duration:
const Duration(
milliseconds: 200,
),


width:
i == _selectedTab
? 18
: 0,


height:
3,


decoration:
BoxDecoration(

color:
cyan,


borderRadius:
BorderRadius.circular(10),

),

),

],

),

),

),

],

);

}






Widget _buildSelectedTab() {


switch(_selectedTab){


case 1:

return _buildMemberTab();



case 2:

return _buildActivityTab();



default:

return _buildProfileTab();

}

}







Widget _buildProfileTab(){


final room =
widget.room;


final announcement =
room.announcement.trim().isEmpty

? "Welcome to my room"

: room.announcement.trim();



return Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children: [



_title(
"Announcement",
),



const SizedBox(height: 10),



Text(

announcement,


maxLines: 4,


overflow:
TextOverflow.ellipsis,


style:
TextStyle(

color:
Colors.white.withOpacity(.75),


fontSize:
13,


height:
1.4,

),

),





const SizedBox(height: 28),




_title(
"Country",
),




const SizedBox(height: 12),




Row(

children: [


const Text(

"🇵🇰",

style:
TextStyle(
fontSize: 20,
),

),



const SizedBox(width: 8),



const Text(

"PK",

style:
TextStyle(

color:
Colors.white,


fontSize:
14,

),

),

],

),






const SizedBox(height: 30),






_title(
"Level",
),




const SizedBox(height: 12),




Row(

children: [



const Text(

"LV",

style:
TextStyle(

color:
cyan,


fontSize:
16,


fontWeight:
FontWeight.bold,

),

),




const SizedBox(width: 5),




const Text(

"2",

style:
TextStyle(

color:
cyan,


fontSize:
16,


fontWeight:
FontWeight.bold,

),

),




const Spacer(),




InkWell(

onTap:
widget.onRules,


child: Row(

children: [


Text(

"Rules",

style:
TextStyle(

color:
Colors.white
.withOpacity(.8),


fontSize:
13,

),

),



const Icon(

Icons.chevron_right,

color:
Colors.white,


size:
20,

),

],

),

),



],

),






const SizedBox(height: 8),




ClipRRect(

borderRadius:
BorderRadius.circular(20),


child:
const LinearProgressIndicator(

value:
.35,


minHeight:
8,


backgroundColor:
Colors.white24,


valueColor:
AlwaysStoppedAnimation<Color>(

cyan,

),

),

),




const SizedBox(height: 8),




Text(

"To upgrade：150/500",


style:
TextStyle(

color:
Colors.white
.withOpacity(.35),


fontSize:
12,

),

),


],

);

}







Widget _title(String text){


return Text(

text,


style:
const TextStyle(

color:
Colors.white,


fontSize:
14,


fontWeight:
FontWeight.w700,

),

);

}






Widget _buildMemberTab(){


final members =
widget.room.members;



return Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children: [



Row(

children: [


_title(
"Members",
),



const Spacer(),




Text(

members.length.toString(),


style:
TextStyle(

color:
Colors.white
.withOpacity(.5),


),

),

],

),




const SizedBox(height: 15),





if(members.isEmpty)

_emptyBox(
"No members",
Icons.people_outline,
)

else


Column(

children: [

for(final member in members)

Padding(

padding:
const EdgeInsets.only(
bottom: 10,
),

child:
_memberTile(member),

),

],

),



],

);

}






Widget _memberTile(RoomUser member){


return Container(

padding:
const EdgeInsets.all(12),


decoration:
BoxDecoration(

color:
Colors.white
.withOpacity(.06),


borderRadius:
BorderRadius.circular(14),

),


child: Row(

children: [



CircleAvatar(

radius:
20,


backgroundColor:
const Color(
0xff4E217A,
),


backgroundImage:

member.avatar != null

? NetworkImage(
member.avatar!,
)

: null,


child:
member.avatar == null

? Text(

member.name[0]
.toUpperCase(),

style:
const TextStyle(

color:
Colors.white,

),

)

: null,

),




const SizedBox(width: 12),




Expanded(

child: Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children: [



Text(

member.name,


style:
const TextStyle(

color:
Colors.white,


fontWeight:
FontWeight.w600,

),

),




Text(

member.isHost
? "Room Owner"
: "Member",


style:
TextStyle(

color:
Colors.white
.withOpacity(.45),


fontSize:
11,

),

),

],

),

),



if(member.isHost)

const Icon(

Icons.workspace_premium,

color:
Colors.amber,

),

],

),

);

}

Widget _buildActivityTab(){

  return Column(

    crossAxisAlignment:
    CrossAxisAlignment.start,


    children: [

      _title(
        "Activity",
      ),


      const SizedBox(height: 15),



      _emptyBox(

        "Room activity will appear here.",

        Icons.history_rounded,

      ),

    ],

  );

}







Widget _emptyBox(
    String text,
    IconData icon,
    ){


  return Container(

    width:
    double.infinity,


    padding:
    const EdgeInsets.symmetric(

      vertical:
      35,

    ),


    decoration:
    BoxDecoration(

      color:
      Colors.white
          .withOpacity(.05),


      borderRadius:
      BorderRadius.circular(16),

    ),


    child: Column(

      children: [


        Icon(

          icon,


          color:
          Colors.white
              .withOpacity(.3),


          size:
          32,

        ),




        const SizedBox(height: 10),




        Text(

          text,


          style:
          TextStyle(

            color:
            Colors.white
                .withOpacity(.45),


            fontSize:
            12,

          ),

        ),

      ],

    ),

  );

}








Widget _buildBottomButtons() {

  return Padding(

    padding: const EdgeInsets.fromLTRB(
      18,
      10,
      18,
      22,
    ),


    child: Row(

      children: [


        Expanded(

          child: _bottomButton(
            "Top",
            coral,
            Icons.rocket_launch_outlined,
            widget.onTop,
          ),

        ),



        const SizedBox(width: 15),



        Expanded(

          child: _bottomButton(
            "Setting",
            cyan,
            Icons.settings_outlined,
            widget.onSetting,
          ),

        ),

      ],

    ),

  );

}

Widget _bottomButton(

    String text,

    Color color,

    IconData icon,

    VoidCallback? tap,

    ){



  return InkWell(

    onTap:
    tap,


    borderRadius:
    BorderRadius.circular(30),


    child:
    Container(

      height:
      42,


      decoration:
      BoxDecoration(

        color:
        color,


        borderRadius:
        BorderRadius.circular(30),

      ),



      child:
      Row(

        mainAxisAlignment:
        MainAxisAlignment.center,


        children: [



          Icon(

            icon,


            color:
            Colors.white,


            size:
            20,

          ),



          const SizedBox(width: 8),




          Text(

            text,


            style:
            const TextStyle(

              color:
              Colors.white,


              fontWeight:
              FontWeight.w600,


              fontSize:
              14,

            ),

          ),

        ],

      ),

    ),

  );

}

}









class _Background extends StatelessWidget {


  const _Background();



  @override
  Widget build(BuildContext context){


    return Container(

      decoration:
      const BoxDecoration(

        gradient:
        LinearGradient(



          end:
          Alignment.bottomCenter,


          colors: [



            Color(0xFF351C64),

          ],

        ),

      ),

    );

  }

}









class _PakistanFlagPainter
    extends CustomPainter {


  const _PakistanFlagPainter();



  @override
  void paint(
      Canvas canvas,
      Size size,
      ){


    final rect =
    Offset.zero & size;



    final green =
    Paint()

      ..color =
      const Color(0xff006600);



    final white =
    Paint()

      ..color =
          Colors.white;



    canvas.drawRect(

      rect,

      green,

    );



    canvas.drawRect(

      Rect.fromLTWH(

        0,

        0,

        size.width * .22,

        size.height,

      ),

      white,

    );



    final center =
    Offset(

      size.width*.62,

      size.height*.5,

    );



    canvas.drawCircle(

      center,

      size.height*.30,

      white,

    );



    canvas.drawCircle(

      Offset(

        center.dx + 3,

        center.dy - 2,

      ),

      size.height*.27,

      green,

    );



    final star =
    Path();



    final starCenter =
    Offset(

      size.width*.78,

      size.height*.35,

    );



    const points = 5;



    final outer =
        size.height*.13;



    final inner =
        outer*.45;



    for(int i=0;i<points*2;i++){


      final radius =
      i.isEven

          ? outer

          : inner;



      final angle =
          -math.pi/2 +

              (math.pi*i/points);



      final point =
      Offset(

        starCenter.dx +

            math.cos(angle)*radius,


        starCenter.dy +

            math.sin(angle)*radius,

      );



      if(i==0){

        star.moveTo(
          point.dx,
          point.dy,
        );

      }

      else{

        star.lineTo(
          point.dx,
          point.dy,
        );

      }

    }



    star.close();



    canvas.drawPath(

      star,

      white,

    );


  }



  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ){

    return false;

  }

}