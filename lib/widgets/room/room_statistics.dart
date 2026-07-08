import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/theme/app_colors.dart';

class RoomStatistics extends StatelessWidget {
  const RoomStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            blurRadius: 12,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [

          StatItem(
            icon: Icons.people,
            value: "245",
            label: "Members",
            color: Colors.blue,
          ),

          StatItem(
            icon: Icons.favorite,
            value: "12.4K",
            label: "Likes",
            color: Colors.red,
          ),

          StatItem(
            icon: Icons.card_giftcard,
            value: "540",
            label: "Gifts",
            color: Colors.amber,
          ),

          StatItem(
            icon: Icons.workspace_premium,
            value: "18",
            label: "Level",
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const StatItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        CircleAvatar(
          radius: 22,
          backgroundColor: color.withOpacity(.15),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}