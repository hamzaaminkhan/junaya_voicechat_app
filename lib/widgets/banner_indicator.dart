import 'package:flutter/material.dart';

class BannerIndicator extends StatelessWidget {
  final int total;
  final int current;

  const BannerIndicator({
    super.key,
    required this.total,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        total,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: index == current ? 16 : 5,
          height: 5,
          decoration: BoxDecoration(
            color: index == current
                ? const Color(0xFFFFC857)
                : Colors.white.withOpacity(.25),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
