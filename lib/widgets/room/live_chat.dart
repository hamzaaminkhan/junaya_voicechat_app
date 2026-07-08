import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/theme/app_colors.dart';

class LiveChat extends StatelessWidget {
  const LiveChat({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = [
      ChatModel("Hamza", "Welcome everyone 👋"),
      ChatModel("Ali", "Let's start the PK Battle 🔥"),
      ChatModel("Ahmed", "Hello everyone ❤️"),
      ChatModel("Sara", "Nice room 😍"),
      ChatModel("John", "Greetings from UK 🇬🇧"),
    ];

    return Positioned(
      left: 15,
      right: 15,
      bottom: 105,
      child: IgnorePointer(
        child: Container(
          height: 170,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        chat.name[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.12),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [

                              TextSpan(
                                text: "${chat.name}: ",
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              TextSpan(
                                text: chat.message,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ChatModel {
  final String name;
  final String message;

  ChatModel(this.name, this.message);
}