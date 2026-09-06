import 'package:flutter/material.dart';

class RoomEmojiPicker extends StatelessWidget {
  final ValueChanged<String> onEmojiSelected;

  const RoomEmojiPicker({
    super.key,
    required this.onEmojiSelected,
  });

  static const List<String> _emojis = [
    '😀',
    '😂',
    '🤣',
    '😊',
    '😍',
    '🥰',
    '😘',
    '😎',
    '🤩',
    '🥳',
    '😇',
    '🤗',
    '😋',
    '😜',
    '🤔',
    '😮',
    '😢',
    '😭',
    '😡',
    '🤬',
    '❤️',
    '💕',
    '💖',
    '💯',
    '🔥',
    '✨',
    '🎉',
    '🎊',
    '👏',
    '🙌',
    '👍',
    '👎',
    '🙏',
    '💪',
    '👋',
    '💋',
    '🌹',
    '🎁',
    '🎈',
    '👑',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        12,
        10,
        12,
        14,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF160633),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: _emojis.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final emoji = _emojis[index];

          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              onEmojiSelected(emoji);
            },
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(
                  fontSize: 27,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}