import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  final List<Map<String, dynamic>> friends = const [
    {
      "name": "Ayesha",
      "country": "Pakistan",
      "online": true,
      "followers": "2.5K",
    },
    {
      "name": "Ali",
      "country": "Pakistan",
      "online": false,
      "followers": "1.2K",
    },
    {
      "name": "Alex",
      "country": "Bangladesh",
      "online": true,
      "followers": "8.4K",
    },
    {"name": "John", "country": "USA", "online": true, "followers": "5.9K"},
    {
      "name": "Fatima",
      "country": "Saudi Arabia",
      "online": false,
      "followers": "3.8K",
    },
    {"name": "Ahmed", "country": "Egypt", "online": true, "followers": "7.3K"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        iconTheme: const IconThemeData(
          color: Colors.white, // Bright back arrow
        ),

        title: Text(
          "Friends",
          style: GoogleFonts.poppins(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.person_add),
          ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search friends...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xff121530),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final friend = friends[index];

                return Card(
                  color: const Color(0xff121530),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  margin: const EdgeInsets.only(bottom: 15),

                  child: ListTile(
                    leading: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.amber,
                          child: Icon(Icons.person, color: Colors.black),
                        ),

                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: friend["online"]
                                  ? Colors.green
                                  : Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),

                    title: Text(
                      friend["name"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          friend["country"],
                          style: const TextStyle(color: Colors.white70),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "${friend["followers"]} Followers",
                          style: const TextStyle(color: Colors.amber),
                        ),
                      ],
                    ),

                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Invite Friend"),
                            content: Text(
                              "Invite ${friend["name"]} to your voice room?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "${friend["name"]} has been invited.",
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                child: const Text("Invite"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text("Invite"),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
