import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/rooms/widgets/room_top_users.dart';
import 'package:junaya_voicechat_app/theme/app_colors.dart';

class RoomHeader extends StatelessWidget {
  const RoomHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [

        // ----------------------------------------------------------
        // HEADER BACKGROUND
        // ----------------------------------------------------------

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

              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  // ------------------------------------------------
                  // BACK BUTTON
                  // ------------------------------------------------

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

                  // ------------------------------------------------
                  // ROOM INFORMATION
                  // ------------------------------------------------

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 1,
                      ),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          // Room name
                          const Text(
                            'PK Battle',

                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,

                            style: TextStyle(
                              color: Colors.white,

                              // Slightly smaller
                              fontSize: 15,

                              fontWeight:
                              FontWeight.w700,

                              height: 1.1,
                            ),
                          ),

                          const SizedBox(height: 3),

                          // Level / ID
                          Text(
                            'Level 25  •  ID 865214',

                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,

                            style: TextStyle(
                              color:
                              Colors.white.withOpacity(.68),

                              // Smaller than room name
                              fontSize: 10.5,

                              fontWeight:
                              FontWeight.w400,

                              height: 1.1,
                            ),
                          ),

                          const SizedBox(height: 9),

                          // ------------------------------------------------
                          // RECTANGULAR GLASS STRIP
                          // ------------------------------------------------

                          Container(
                            height: 30,
                            width: 175,

                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),

                            decoration: BoxDecoration(
                              color:
                              Colors.white.withOpacity(.11),

                              // Less rounded than before
                              borderRadius:
                              BorderRadius.circular(7),

                              border: Border.all(
                                color:
                                Colors.white.withOpacity(.22),

                                width: 1,
                              ),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(.08),

                                  blurRadius: 8,

                                  offset:
                                  const Offset(0, 2),
                                ),
                              ],
                            ),

                            child: Row(
                              children: [

                                Container(
                                  width: 6,
                                  height: 6,

                                  decoration:
                                  const BoxDecoration(
                                    shape:
                                    BoxShape.circle,

                                    color:
                                    Color(0xffE8B4FF),
                                  ),
                                ),

                                const SizedBox(width: 7),

                                const Expanded(
                                  child: Text(
                                    'Voice Room',

                                    maxLines: 1,
                                    overflow:
                                    TextOverflow.ellipsis,

                                    style: TextStyle(
                                      color: Colors.white,

                                      fontSize: 11.5,

                                      fontWeight:
                                      FontWeight.w500,

                                      height: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // ------------------------------------------------
                  // HEADER ACTIONS
                  // ------------------------------------------------

                  const Padding(
                    padding: EdgeInsets.only(
                      top: 4,
                    ),

                    child: Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Padding(
                    padding: EdgeInsets.only(
                      top: 4,
                    ),

                    child: Icon(
                      Icons.settings_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ----------------------------------------------------------
        // HOST PROFILE
        // ----------------------------------------------------------

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
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Hamza',

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

        // ----------------------------------------------------------
        // TOP USERS
        // ----------------------------------------------------------

        Positioned(
          top: 65,
          right: 18,

          child: RoomTopUsers(
            users: const [
              TopRoomUser(
                name: 'User1',
                avatar: '',
                rank: 1,
              ),

              TopRoomUser(
                name: 'User2',
                avatar: '',
                rank: 2,
              ),

              TopRoomUser(
                name: 'User3',
                avatar: '',
                rank: 3,
              ),

              TopRoomUser(
                name: 'User4',
                avatar: '',
                rank: 1,
              ),
            ],

            totalUsers: 128,
          ),
        ),
      ],
    );
  }
}