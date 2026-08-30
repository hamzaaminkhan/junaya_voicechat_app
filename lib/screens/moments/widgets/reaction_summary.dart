import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';

class ReactionSummary extends StatelessWidget {
  final List<MomentReaction> reactions;

  const ReactionSummary({
    super.key,
    required this.reactions,
  });

  @override
  Widget build(BuildContext context) {
    if (reactions.isEmpty) {
      return const SizedBox.shrink();
    }

    final Map<String, int> counts = {};

    for (final reaction in reactions) {
      counts[reaction.emoji] =
          (counts[reaction.emoji] ?? 0) + 1;
    }

    final sortedReactions = counts.entries.toList()
      ..sort(
            (a, b) => b.value.compareTo(a.value),
      );

    final topEmojis = sortedReactions
        .take(3)
        .map((entry) => entry.key)
        .toList();

    final total = reactions.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        0,
      ),
      child: Row(
        children: [
          _EmojiStack(
            emojis: topEmojis,
          ),

          const SizedBox(width: 8),

          Text(
            _reactionText(total),
            style: const TextStyle(
              color: Color(0xffA7A7B5),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _reactionText(int count) {
    if (count == 1) {
      return '1 reaction';
    }

    return '$count reactions';
  }
}


class _EmojiStack extends StatelessWidget {
  final List<String> emojis;

  const _EmojiStack({
    required this.emojis,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: emojis.length * 18.0,
      height: 24,
      child: Stack(
        children: List.generate(
          emojis.length,
              (index) {
            return Positioned(
              left: index * 15.0,
              top: 0,
              child: Container(
                width: 23,
                height: 23,
                decoration: BoxDecoration(
                  color: const Color(0xff20202B),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xff0D0D14),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  emojis[index],
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}