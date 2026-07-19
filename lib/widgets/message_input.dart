import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onEmojiPressed;
  final VoidCallback onAttachmentPressed;
  final VoidCallback onMicPressed;

  const MessageInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onEmojiPressed,
    required this.onAttachmentPressed,
    required this.onMicPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        decoration: const BoxDecoration(
          color: Color(0xFF121530),
          border: Border(
            top: BorderSide(
              color: Color(0xFF23284A),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: onEmojiPressed,
              icon: const Icon(
                Icons.emoji_emotions_outlined,
                color: Colors.white70,
              ),
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F38),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.multiline,
                        textCapitalization:
                        TextCapitalization.sentences,
                        minLines: 1,
                        maxLines: 5,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => onSend(),
                      ),
                    ),

                    IconButton(
                      onPressed: onAttachmentPressed,
                      icon: const Icon(
                        Icons.attach_file,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 8),

            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, child) {
                final hasText = value.text.trim().isNotEmpty;

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: FloatingActionButton(
                    key: ValueKey(hasText),
                    heroTag: null,
                    mini: true,
                    elevation: 0,
                    backgroundColor: const Color(0xFF6C3BFF),
                    onPressed: hasText ? onSend : onMicPressed,
                    child: Icon(
                      hasText ? Icons.send : Icons.mic,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}