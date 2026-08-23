import 'package:flutter/material.dart';

class CategoryShortcuts extends StatelessWidget {
  const CategoryShortcuts({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ['🏆', 'Rank'],
      ['💑', 'Couple'],
      ['📍', 'Nearby'],
      ['🎤', 'Voice'],
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items.map((item) {
        return Column(
          children: [
            Text(item[0], style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 5),
            Text(
              item[1],
              style: const TextStyle(color: Colors.white),
            ),
          ],
        );
      }).toList(),
    );
  }
}