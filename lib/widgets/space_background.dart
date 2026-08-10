import 'package:flutter/material.dart';

class SpaceBackground extends StatelessWidget {
  final Widget child;

  const SpaceBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,

        children: [
          // SPACE IMAGE BACKGROUND
          Image.asset(
            "assets/backgrounds/space_bg.jpeg",

            fit: BoxFit.cover,

            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.black,

                child: const Center(
                  child: Text(
                    "Background image not found",

                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ),
              );
            },
          ),

          // DARK TRANSPARENT OVERLAY
          Container(color: Colors.black.withValues(alpha: 0.20)),

          // SCREEN CONTENT
          child,
        ],
      ),
    );
  }
}
