import 'package:flutter/material.dart';

class RoomSkeleton extends StatelessWidget {
  final double height;
  final double width;

  const RoomSkeleton({
    super.key,
    this.height = 170,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF21132F),
        borderRadius:
        BorderRadius.circular(18),
      ),
      child: Padding(
        padding:
        const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            _SkeletonBox(
              height: 90,
              width: double.infinity,
              radius: 14,
            ),

            const SizedBox(
              height: 14,
            ),

            _SkeletonBox(
              height: 14,
              width: 120,
              radius: 8,
            ),

            const SizedBox(
              height: 10,
            ),

            _SkeletonBox(
              height: 12,
              width: 80,
              radius: 8,
            ),
          ],
        ),
      ),
    );
  }
}


class _SkeletonBox extends StatelessWidget {
  final double height;
  final double width;
  final double radius;

  const _SkeletonBox({
    required this.height,
    required this.width,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white
            .withOpacity(.08),
        borderRadius:
        BorderRadius.circular(radius),
      ),
    );
  }
}