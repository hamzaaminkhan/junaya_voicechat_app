import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/profile_section_shell.dart';

class GiftsScreen extends StatelessWidget {
  const GiftsScreen({super.key});

  static const List<Map<String, dynamic>> gifts = [
    {'name': 'Rose', 'icon': Icons.local_florist, 'price': 10, 'color': Colors.redAccent},
    {'name': 'Heart', 'icon': Icons.favorite, 'price': 25, 'color': Colors.pinkAccent},
    {'name': 'Cake', 'icon': Icons.cake, 'price': 80, 'color': Colors.orangeAccent},
    {'name': 'Car', 'icon': Icons.directions_car, 'price': 500, 'color': Colors.lightBlueAccent},
    {'name': 'Castle', 'icon': Icons.castle, 'price': 1200, 'color': Colors.deepPurpleAccent},
    {'name': 'Crown', 'icon': Icons.workspace_premium, 'price': 2500, 'color': Colors.amber},
    {'name': 'Rocket', 'icon': Icons.rocket_launch, 'price': 5000, 'color': Colors.greenAccent},
    {'name': 'Diamond', 'icon': Icons.diamond, 'price': 10000, 'color': Colors.cyanAccent},
  ];

  void _showGiftAction(BuildContext context, String giftName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$giftName selected. Recipient flow can be connected next.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProfileSectionScaffold(
      title: 'Store',
      actions: [
        IconButton(
          tooltip: 'Purchase history',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Purchase history is ready for backend integration.')),
            );
          },
          icon: const Icon(Icons.receipt_long_outlined),
        ),
      ],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
            child: ProfileSectionCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF5A2BE0), Color(0xFFA92EEA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.monetization_on_rounded, color: Colors.black),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your Coins', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11)),
                        Text(
                          '128,540',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Recharge flow can be connected to Wallet.')),
                      );
                    },
                    child: const Text('Recharge'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
              itemCount: gifts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: .86,
              ),
              itemBuilder: (context, index) {
                final gift = gifts[index];
                final color = gift['color'] as Color;

                return ProfileSectionCard(
                  padding: const EdgeInsets.all(13),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withOpacity(.14),
                          border: Border.all(color: color.withOpacity(.45)),
                        ),
                        child: Icon(gift['icon'] as IconData, color: color, size: 31),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        gift['name'] as String,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.monetization_on_rounded, color: Colors.amber, size: 15),
                          const SizedBox(width: 4),
                          Text(
                            '${gift['price']}',
                            style: GoogleFonts.poppins(
                              color: Colors.amber,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            minimumSize: const Size.fromHeight(36),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                          ),
                          onPressed: () => _showGiftAction(context, gift['name'] as String),
                          child: const Text('Send'),
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
}
