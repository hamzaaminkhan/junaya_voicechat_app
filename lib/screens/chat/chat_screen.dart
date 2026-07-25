import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/models/message_model.dart';
import 'package:junaya_voicechat_app/services/chat_service.dart';
import 'package:junaya_voicechat_app/widgets/message_bubble.dart';
import 'package:junaya_voicechat_app/widgets/message_input.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String receiverId;
  final String receiverName;
  final String receiverImage;
  final bool isOnline;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
    this.isOnline = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService.instance;

  final TextEditingController _messageController =
  TextEditingController();

  final ScrollController _scrollController =
  ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();

    if (text.isEmpty) return;

    try {
      await _chatService.sendMessage(
        senderId: widget.currentUserId,
        receiverId: widget.receiverId,
        message: text,
      );

      _messageController.clear();

      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to send message: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 8,

        title: Row(
          children: [

            Stack(
              children: [

                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey.shade800,
                  backgroundImage: widget.receiverImage.isNotEmpty
                      ? NetworkImage(widget.receiverImage)
                      : null,
                  child: widget.receiverImage.isEmpty
                      ? const Icon(
                    Icons.person,
                    color: Colors.white,
                  )
                      : null,
                ),

                if (widget.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF121530),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 12),

            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                stream: _chatService.getMessages(
                  senderId: widget.currentUserId,
                  receiverId: widget.receiverId,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Something went wrong.\n${snapshot.error}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    );
                  }

                  final messages = snapshot.data ?? [];

                  if (messages.isEmpty) {
                    return const Center(
                      child: Text(
                        "No messages yet.\nStart the conversation 👋",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      );
                    }
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[messages.length - 1 - index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: MessageBubble(
                          message: msg.deleted
                              ? "🚫 Message deleted"
                              : msg.message,

                          time: TimeOfDay.fromDateTime(
                            msg.timestamp.toDate(),
                          ).format(context),

                          isMe:
                          msg.senderId == widget.currentUserId,

                          isSeen: msg.seen,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),

        actions: [

          IconButton(
            onPressed: () {
              // TODO: Voice Call
            },
            icon: const Icon(Icons.call),
          ),

          IconButton(
            onPressed: () {
              // TODO: Video Call
            },
            icon: const Icon(Icons.videocam),
          ),

          PopupMenuButton<String>(
            color: const Color(0xFF1A1F38),
            icon: const Icon(Icons.more_vert),

            onSelected: (value) {
              switch (value) {
                case "profile":
                  break;

                case "clear":
                  break;

                case "block":
                  break;
              }
            },

            itemBuilder: (context) =>
            const [

              PopupMenuItem(
                value: "profile",
                child: Text("View Profile"),
              ),

              PopupMenuItem(
                value: "clear",
                child: Text("Clear Chat"),
              ),

              PopupMenuItem(
                value: "block",
                child: Text("Block User"),
              ),
            ],
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [

            Expanded(
              child: Container(),
            ),

            MessageInput(
              controller: _messageController,
              onSend: _sendMessage,
              onEmojiPressed: () {
                // TODO
              },
              onAttachmentPressed: () {
                // TODO
              },
              onMicPressed: () {
                // TODO
              },
            ),
          ],
        ),
      ),
    );
  }
}