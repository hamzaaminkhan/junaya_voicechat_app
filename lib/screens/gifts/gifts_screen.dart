import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GiftsScreen extends StatelessWidget {
  const GiftsScreen({super.key});

  final List<Map<String, dynamic>> gifts = const [
    {
      "name": "Rose",
      "icon": Icons.local_florist,
      "price": 10,
      "color": Colors.red,
    },
    {
      "name": "Heart",
      "icon": Icons.favorite,
      "price": 25,
      "color": Colors.pink,
    },
    {
      "name": "Cake",
      "icon": Icons.cake,
      "price": 80,
      "color": Colors.orange,
    },
    {
      "name": "Car",
      "icon": Icons.directions_car,
      "price": 500,
      "color": Colors.blue,
    },
    {
      "name": "Castle",
      "icon": Icons.castle,
      "price": 1200,
      "color": Colors.deepPurple,
    },
    {
      "name": "Crown",
      "icon": Icons.workspace_premium,
      "price": 2500,
      "color": Colors.amber,
    },
    {
      "name": "Rocket",
      "icon": Icons.rocket_launch,
      "price": 5000,
      "color": Colors.green,
    },
    {
      "name": "Diamond",
      "icon": Icons.diamond,
      "price": 10000,
      "color": Colors.cyan,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0B0E21),

      appBar: AppBar(
        backgroundColor: const Color(0xff121530),
        elevation: 0,
        title: Text(
          "Gift Store",
          style: GoogleFonts.poppins(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.shopping_cart),
          )
        ],
      ),

      body: Column(
        children: [

          const SizedBox(height: 20),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xff6C3BFF),
                  Color(0xffB43EFF),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [

                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.amber,
                  child: Icon(
                    Icons.monetization_on,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [

                      Text(
                        "Your Coins",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "25,000",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {},
                  child: const Text("Recharge"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: gifts.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: .82,
              ),
              itemBuilder: (context, index) {

                final gift = gifts[index];

                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff121530),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      CircleAvatar(
                        radius: 36,
                        backgroundColor: gift["color"],
                        child: Icon(
                          gift["icon"],
                          size: 36,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        gift["name"],
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "${gift["price"]} Coins",
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text("Send"),
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
}