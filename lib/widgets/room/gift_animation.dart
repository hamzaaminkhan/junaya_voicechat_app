import 'package:flutter/material.dart';

class GiftAnimation {
  static final ValueNotifier<String?> currentGift = ValueNotifier<String?>(
    null,
  );

  static void show(BuildContext context, String gift) {
    currentGift.value = gift;

    Future.delayed(const Duration(seconds: 3), () {
      currentGift.value = null;
    });
  }
}

class GiftAnimationLayer extends StatelessWidget {
  const GiftAnimationLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ValueListenableBuilder<String?>(
        valueListenable: GiftAnimation.currentGift,
        builder: (context, gift, child) {
          if (gift == null) {
            return const SizedBox.shrink();
          }

          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 1, end: 0),
            duration: const Duration(seconds: 3),
            builder: (context, value, child) {
              return Stack(
                children: [
                  /// Dark Overlay
                  Opacity(
                    opacity: 0.3 * value,
                    child: Container(color: Colors.black),
                  ),

                  /// Gift
                  Center(
                    child: Transform.scale(
                      scale: 1 + (1 - value),
                      child: Opacity(
                        opacity: value,
                        child: Text(
                          gift,
                          style: const TextStyle(fontSize: 150),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
