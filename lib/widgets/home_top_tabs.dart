import 'package:flutter/material.dart';

class HomeTopTabs extends StatelessWidget {
  const HomeTopTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = ['Related', 'Hot', 'Party'];

    return Row(
      children: [
        ...tabs.map((tab) => Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Text(
                tab,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
        const Spacer(),
        const Icon(Icons.search, color: Colors.white),
      ],
    );
  }
}