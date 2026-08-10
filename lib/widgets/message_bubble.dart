import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isMe;
  final bool isSeen;

  const MessageBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isMe,
    this.isSeen = false,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe
        ? const Color(0xFF6C3BFF)
        : const Color(0xFF1A1F38);

    final alignment = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    final radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: isMe ? const Radius.circular(18) : const Radius.circular(4),
      bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(18),
    );

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Row(
          mainAxisAlignment: isMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .72,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: radius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: .65),
                            fontSize: 11,
                          ),
                        ),

                        if (isMe) ...[
                          const SizedBox(width: 5),

                          Icon(
                            isSeen ? Icons.done_all : Icons.done,
                            size: 15,
                            color: isSeen
                                ? Colors.lightBlueAccent
                                : Colors.white54,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),
      ],
    );
  }
}
