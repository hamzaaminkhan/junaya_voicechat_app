import 'package:flutter/material.dart';

class EventBanner extends StatelessWidget {
  final String image;

  const EventBanner({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: AspectRatio(
        aspectRatio: 2.6,
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}