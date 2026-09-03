import 'dart:math';
import 'package:flutter/material.dart';

class GiftOverlay extends StatelessWidget {
  const GiftOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final gifts = ["🌹", "💎", "🚗", "👑", "🎁", "❤️", "⭐", "🚀"];

    return IgnorePointer(
      child: Stack(
        children: List.generate(
          gifts.length,
          (index) => FloatingGift(emoji: gifts[index], delay: index * 400),
        ),
      ),
    );
  }
}

class FloatingGift extends StatefulWidget {
  final String emoji;
  final int delay;

  const FloatingGift({super.key, required this.emoji, required this.delay});

  @override
  State<FloatingGift> createState() => _FloatingGiftState();
}

class _FloatingGiftState extends State<FloatingGift>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  final random = Random();

  late double left;

  @override
  void initState() {
    super.initState();

    left = 20 + random.nextDouble() * 250;

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Positioned(
          left: left,
          bottom: controller.value * 500,
          child: Opacity(
            opacity: 1 - controller.value,
            child: Transform.scale(
              scale: 0.8 + controller.value * .5,
              child: Text(widget.emoji, style: const TextStyle(fontSize: 28)),
            ),
          ),
        );
      },
    );
  }
}
