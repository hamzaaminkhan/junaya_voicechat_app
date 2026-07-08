import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/theme/app_colors.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> rooms = [
      {
        "title": "PK Battle",
        "host": "Hamza",
        "users": 245,
        "country": "Pakistan",
        "icon": Icons.mic,
      },
      {
        "title": "Music Lounge",
        "host": "Ayesha",
        "users": 189,
        "country": "India",
        "icon": Icons.music_note,
      },
      {
        "title": "Gaming Zone",
        "host": "Alex",
        "users": 321,
        "country": "Bangladesh",
        "icon": Icons.sports_esports,
      },
      {
        "title": "Study Room",
        "host": "Ali",
        "users": 97,
        "country": "Pakistan",
        "icon": Icons.menu_book,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          "Voice Rooms",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.notifications),
          )
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text("Create"),
      ),

      body: Column(
        children: [

          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Rooms...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                category("All"),
                category("PK"),
                category("Music"),
                category("Gaming"),
                category("Study"),
                category("Dating"),
                category("Sports"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              itemCount: rooms.length,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemBuilder: (context, index) {

                final room = rooms[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff6C3BFF),
                        Color(0xffB43EFF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [

                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              room["icon"],
                              color: AppColors.primary,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [

                                Text(
                                  room["title"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),

                                Text(
                                  "Host: ${room["host"]}",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
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

                      const SizedBox(height: 18),

                      Row(
                        children: [

                          const Icon(
                            Icons.people,
                            color: Colors.white,
                          ),

                          const SizedBox(width: 5),

                          Text(
                            "${room["users"]} Users",
                            style: const TextStyle(
                                color: Colors.white),
                          ),

                          const Spacer(),

                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),

                          const SizedBox(width: 5),

                          Text(
                            room["country"],
                            style: const TextStyle(
                                color: Colors.white),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Join Room",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget category(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Chip(
        backgroundColor: AppColors.surface,
        side: BorderSide.none,
        label: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}