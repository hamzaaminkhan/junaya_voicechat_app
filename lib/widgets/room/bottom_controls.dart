import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/theme/app_colors.dart';

class BottomControls extends StatelessWidget {
  const BottomControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            blurRadius: 15,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          ControlButton(
            icon: Icons.emoji_emotions,
            label: "Emoji",
            color: Colors.orange,
          ),
          ControlButton(
            icon: Icons.card_giftcard,
            label: "Gift",
            color: Colors.pink,
          ),
          ControlButton(
            icon: Icons.mic,
            label: "Mic",
            color: Colors.green,
          ),
          ControlButton(
            icon: Icons.person_add_alt_1,
            label: "Invite",
            color: Colors.blue,
          ),
          ControlButton(
            icon: Icons.logout,
            label: "Leave",
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}

class ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const ControlButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: () {
        switch (label) {
          case "Emoji":
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Emoji panel coming soon")),
            );
            break;

          case "Gift":
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Gift shop coming soon")),
            );
            break;

          case "Mic":
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Mic control coming soon")),
            );
            break;

          case "Invite":
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Invite friends coming soon")),
            );
            break;

          case "Leave":
            Navigator.pop(context);
            break;
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: color.withOpacity(.18),
            child: Icon(
              icon,
              color: color,
              size: 26,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}