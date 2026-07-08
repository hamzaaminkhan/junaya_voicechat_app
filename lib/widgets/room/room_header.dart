import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/theme/app_colors.dart';

class RoomHeader extends StatelessWidget {
  const RoomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [

        Container(
          height: 210,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff5B2EFF),
                Color(0xff7F39FB),
                Color(0xffC135FF),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(35),
              bottomRight: Radius.circular(35),
            ),
          ),

          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 10),
              child: Column(
                children: [

                  /// Top Bar
                  Row(
                    children: [

                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
                          backgroundColor: Colors.white24,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            Text(
                              "PK Battle",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 3),

                            Text(
                              "Room ID : 865214",
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),

                      const SizedBox(width: 15),

                      const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),

                      const SizedBox(width: 15),

                      const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                    ],
                  ),

                  const Spacer(),

                  /// Statistics

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                    children: [

                      stat(Icons.people, "245"),

                      stat(Icons.favorite, "12.4K"),

                      stat(Icons.card_giftcard, "540"),
                    ],
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),

        /// Host Avatar

        Positioned(
          bottom: -45,
          left: 0,
          right: 0,
          child: Column(
            children: [

              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.amber,
                    width: 4,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 55,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Hamza",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 5),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: const Text(
                  "LIVE",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget stat(IconData icon, String value) {
    return Row(
      children: [

        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),

        const SizedBox(width: 6),

        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}