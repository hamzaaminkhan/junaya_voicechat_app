import 'package:flutter/material.dart';

class EventBanner extends StatelessWidget {
  final List<EventBannerItem> banners;

  const EventBanner({
    super.key,
    required this.banners,
  });

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) return const SizedBox();

    final item = banners.first;

    return Container(
      height: 170,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(item.image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withValues(alpha: .7),
              Colors.transparent,
            ],
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            item.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class EventBannerItem {
  final String image;
  final String title;
  final String subtitle;

  EventBannerItem({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}
