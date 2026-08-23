import 'package:flutter/material.dart';

class SpaceBackground extends StatelessWidget {
  final Widget child;

  const SpaceBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [

          // SPACE IMAGE
          Image.asset(
            "assets/backgrounds/space_bg.jpeg",
            fit: BoxFit.cover,

            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xff05020B),
                child: const Center(
                  child: Text(
                    "Background image not found",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                ),
              );
            },
          ),


          // DARK READABILITY LAYER
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [

                  Colors.black.withValues(
                    alpha: .35,
                  ),

                  const Color(0xff05020B).withValues(
                    alpha: .80,
                  ),

                ],
              ),
            ),
          ),


          // SUBTLE JUNAYA GLOW
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -.7),
                  radius: 1.2,
                  colors: [

                    const Color(0xff00D9B5)
                        .withValues(alpha: .08),

                    Colors.transparent,

                  ],
                ),
              ),
            ),
          ),


          // CONTENT
          child,
        ],
      ),
    );
  }
}