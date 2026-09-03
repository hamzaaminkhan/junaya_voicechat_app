// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/rooms/widgets/room_top_users.dart';

import 'package:junaya_voicechat_app/theme/app_colors.dart';

class RoomHeader extends StatelessWidget {
  const RoomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [

        Container(
          height: 150,

          width: double.infinity,

          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff5B2EFF),
                Color(0xff7F39FB),
                Color(0xffC135FF),
              ],
            ),

            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),


          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: Column(
                children: [

                  Row(

                    children: [

                      CircleAvatar(
                        radius: 18,

                        backgroundColor:
                        Colors.white.withOpacity(.18),

                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),


                      const SizedBox(width: 12),



                      Expanded(
                        child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            Text(
                              "PK Battle",

                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight:
                                FontWeight.w700,
                              ),
                            ),


                            const SizedBox(height: 2),


                            Text(
                              "Level 25  •  ID 865214",

                              style: TextStyle(
                                color:
                                Colors.white.withOpacity(.7),

                                fontSize: 12,
                              ),
                            ),


                            const SizedBox(height: 8),


                            // Glass rectangle strip
                            Container(

                              height: 28,

                              width: 160,

                              decoration:
                              BoxDecoration(

                                color:
                                Colors.white.withOpacity(.14),

                                borderRadius:
                                BorderRadius.circular(14),


                                border: Border.all(
                                  color:
                                  Colors.white.withOpacity(.25),
                                ),
                              ),

                              child: const Center(

                                child: Text(
                                  "Voice Room",

                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),



                      const Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                      ),

                      const SizedBox(width: 12),

                      const Icon(
                        Icons.settings_outlined,
                        color: Colors.white,
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ),





        // Host profile
        Positioned(

          bottom: -35,

          left: 0,

          right: 0,

          child: Column(

            children: [

              Container(

                padding:
                const EdgeInsets.all(3),

                decoration:
                const BoxDecoration(

                  shape: BoxShape.circle,

                  color: Colors.amber,
                ),

                child: const CircleAvatar(

                  radius: 35,

                  backgroundColor:
                  Colors.white,

                  child: Icon(
                    Icons.person,

                    size: 45,

                    color:
                    AppColors.primary,
                  ),
                ),
              ),


              const SizedBox(height: 8),


              const Text(
                "Hamza",

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 16,

                  fontWeight:
                  FontWeight.w700,
                ),
              ),

            ],
          ),
        ),

        Positioned(
          top: 65,
          right: 18,
          child: RoomTopUsers(
            users: const [

              TopRoomUser(
                name:'User1',
                avatar:'',
                rank:1,
              ),

              TopRoomUser(
                name:'User2',
                avatar:'',
                rank:2,
              ),

              TopRoomUser(
                name:'User3',
                avatar:'',
                rank:3,
              ),

              TopRoomUser(
                name:'User4',
                avatar:'',
                rank:1,
              ),

            ],

            totalUsers: 128,
          ),
        ),

      ],
    );
  }
}