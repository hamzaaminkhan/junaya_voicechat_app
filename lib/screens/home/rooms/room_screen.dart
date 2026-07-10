import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/theme/app_colors.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final List<Map<String, dynamic>> allRooms = [
    {
      "title": "PK Battle",
      "host": "Hamza",
      "users": 245,
      "country": "Pakistan",
      "icon": Icons.mic,
      "category": "PK",
    },
    {
      "title": "Music Lounge",
      "host": "Ayesha",
      "users": 189,
      "country": "India",
      "icon": Icons.music_note,
      "category": "Music",
    },
    {
      "title": "Gaming Zone",
      "host": "Alex",
      "users": 321,
      "country": "Bangladesh",
      "icon": Icons.sports_esports,
      "category": "Gaming",
    },
    {
      "title": "Study Room",
      "host": "Ali",
      "users": 97,
      "country": "Pakistan",
      "icon": Icons.menu_book,
      "category": "Study",
    },
    {
      "title": "Dating Club",
      "host": "Emma",
      "users": 152,
      "country": "India",
      "icon": Icons.favorite,
      "category": "Dating",
    },
    {
      "title": "Football Talk",
      "host": "John",
      "users": 201,
      "country": "Pakistan",
      "icon": Icons.sports_soccer,
      "category": "Sports",
    },
  ];

  List<Map<String, dynamic>> filteredRooms = [];
  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    filteredRooms = List.from(allRooms);
  }

  void searchRooms(String value) {
    setState(() {
      filteredRooms = allRooms.where((room) {
        final query = value.toLowerCase();

        final matchesSearch =
            room["title"].toString().toLowerCase().contains(query) ||
                room["host"].toString().toLowerCase().contains(query) ||
                room["country"].toString().toLowerCase().contains(query);

        final matchesCategory = selectedCategory == "All"
            ? true
            : room["category"] == selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void filterCategory(String category) {
    selectedCategory = category;
    searchRooms("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,

        iconTheme: const IconThemeData(
          color: Colors.white, // Bright back arrow
        ),

        title: const Text(
          "Voice Rooms",
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.notifications),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
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
              onChanged: searchRooms,
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
                buildCategory("All"),
                buildCategory("PK"),
                buildCategory("Music"),
                buildCategory("Gaming"),
                buildCategory("Study"),
                buildCategory("Dating"),
                buildCategory("Sports"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: filteredRooms.length,
              itemBuilder: (context, index) {
                final room = filteredRooms[index];

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
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              room["icon"],
                              color: Colors.deepPurple,
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
                              horizontal: 12,
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
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          const Icon(Icons.people,
                              color: Colors.white),
                          const SizedBox(width: 5),
                          Text(
                            "${room["users"]} Users",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.location_on,
                              color: Colors.white),
                          const SizedBox(width: 5),
                          Text(
                            room["country"],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Joining ${room["title"]}",
                                ),
                              ),
                            );
                          },
                          child: const Text("Join Room"),
                        ),
                      ),
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

  Widget buildCategory(String text) {
    final selected = selectedCategory == text;

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ChoiceChip(
        selected: selected,
        label: Text(text),
        onSelected: (_) {
          setState(() {
            filterCategory(text);
          });
        },
        selectedColor: Colors.amber,
        backgroundColor: AppColors.surface,
        labelStyle: TextStyle(
          color: selected ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}