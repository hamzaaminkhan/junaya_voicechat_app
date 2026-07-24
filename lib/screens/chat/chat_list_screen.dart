import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:junaya_voicechat_app/models/chat_model.dart';
import 'package:junaya_voicechat_app/screens/chat/chat_screen.dart';
import 'package:junaya_voicechat_app/widgets/chat_tile.dart';
import 'package:junaya_voicechat_app/widgets/search_bar.dart';


class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  int selectedFilter = 0;

  final List<ChatModel> chats = [
    ChatModel(
      name: "Ali",
      lastMessage: "Bro, join my room!",
      time: "2:15 PM",
      online: true,
      unread: 3,
    ),
    ChatModel(
      name: "Sara",
      lastMessage: "Thank you ❤️",
      time: "Yesterday",
      online: false,
      unread: 0,
    ),
    ChatModel(
      name: "Ahmed",
      lastMessage: "Let's play later.",
      time: "10:40 AM",
      online: true,
      unread: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredChats = selectedFilter == 0
        ? chats
        : chats.where((chat) => chat.unread > 0).toList();

    return Scaffold(
        backgroundColor: const Color(0xFF0B0E21),

        appBar: AppBar(
          backgroundColor: const Color(0xFF121530),
          elevation: 0,
          centerTitle: false,
          title: Text(
            "Chats",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF6C3BFF),
          onPressed: () {
// TODO: New Chat
          },
          child: const Icon(
            Icons.chat,
            color: Colors.white,
          ),
        ),

        body: Column(
          children: [
            const SizedBox(height: 16),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ChatSearchBar(),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text("All"),
                    selected: selectedFilter == 0,
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = 0;
                      });
                    },
                  ),

                  const SizedBox(width: 10),

                  ChoiceChip(
                    label: const Text("Unread"),
                    selected: selectedFilter == 1,
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = 1;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const SizedBox(height: 16),

            Expanded(
              child: filteredChats.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      size: 60,
                      color: Colors.white24,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "No chats found",
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.only(
                  bottom: 90,
                ),

                itemCount: filteredChats.length,

                itemBuilder: (context, index) {
                  final chat = filteredChats[index];

                  return ChatTile(
                    chat: chat,

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ChatScreen(
                                currentUserId: "current_user_id",
                                receiverId: chat.name,
                                receiverName: chat.name,
                                receiverImage: "",
                                isOnline: chat.online,
                              ),
                        ),
                      );
                    },
                  );
                },

              ),

            ),
          ],
        )
    );
  }
}