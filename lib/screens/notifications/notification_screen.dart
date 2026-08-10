import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/theme/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        "title": "Welcome to JUNAYA",
        "subtitle": "Thanks for joining our community.",
        "time": "Just now",
        "icon": Icons.celebration,
        "color": Colors.amber,
      },
      {
        "title": "VIP Activated",
        "subtitle": "Your VIP Level 1 has been activated.",
        "time": "15 min ago",
        "icon": Icons.workspace_premium,
        "color": Colors.orange,
      },
      {
        "title": "Gift Received",
        "subtitle": "Alex sent you 50 Diamonds.",
        "time": "1 hour ago",
        "icon": Icons.card_giftcard,
        "color": Colors.pink,
      },
      {
        "title": "Room Invitation",
        "subtitle": "Hamza invited you to PK Battle.",
        "time": "2 hours ago",
        "icon": Icons.mic,
        "color": Colors.purple,
      },
      {
        "title": "Withdrawal Approved",
        "subtitle": "Your withdrawal request is approved.",
        "time": "Yesterday",
        "icon": Icons.account_balance_wallet,
        "color": Colors.green,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];

          return Card(
            color: AppColors.surface,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(15),

              leading: CircleAvatar(
                radius: 25,
                backgroundColor: item["color"] as Color,
                child: Icon(item["icon"] as IconData, color: Colors.white),
              ),

              title: Text(
                item["title"] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  item["subtitle"] as String,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),

              trailing: Text(
                item["time"] as String,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}
