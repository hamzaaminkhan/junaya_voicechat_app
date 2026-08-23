import 'package:flutter/material.dart';

class JunayaRoomCard extends StatelessWidget {
  final String title;
  final String image;
  final int listeners;
  final bool isLive;
  final bool isVip;
  final bool isNew;

  const JunayaRoomCard({
    super.key,
    required this.title,
    required this.image,
    required this.listeners,
    this.isLive = true,
    this.isVip = false,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: .85,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(image, fit: BoxFit.cover),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Row(
                    children: [
                      if (isLive) _badge('LIVE'),
                      if (isVip) const SizedBox(width: 6),
                      if (isVip) _badge('VIP'),
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: _badge('👥 $listeners'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${isNew ? 'NEW • ' : ''}$title',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
    );
  }
}
