import 'package:flutter/material.dart';

class MomentReactionSheet extends StatelessWidget {
  final String? selectedReaction;
  final Map<String, int> reactionCounts;
  final ValueChanged<String>? onSelected;
  final VoidCallback? onRemove;

  const MomentReactionSheet({
    super.key,
    this.selectedReaction,
    this.reactionCounts = const {},
    this.onSelected,
    this.onRemove,
  });

  static const List<String> reactions = [
    '❤️',
    '🔥',
    '😂',
    '😍',
    '👏',
    '😮',
    '😢',
    '✨',
  ];

  @override
  Widget build(BuildContext context) {
    final sortedReactions =
    reactionCounts.entries.toList()
      ..sort(
            (a, b) => b.value.compareTo(a.value),
      );

    return Container(
      padding: const EdgeInsets.fromLTRB(
        18,
        10,
        18,
        24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xff11111A),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _handle(),

            const SizedBox(height: 18),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Reactions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                if (selectedReaction != null)
                  GestureDetector(
                    onTap: onRemove,
                    child: const Text(
                      'Remove',
                      style: TextStyle(
                        color: Color(0xffFF4D6D),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            if (sortedReactions.isNotEmpty)
              _summary(sortedReactions),

            if (sortedReactions.isNotEmpty)
              const SizedBox(height: 18),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose a reaction',
                style: TextStyle(
                  color: Color(0xff888896),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 9,
              runSpacing: 9,
              children: reactions.map(
                    (emoji) {
                  return _ReactionButton(
                    emoji: emoji,
                    selected:
                    selectedReaction == emoji,
                    count:
                    reactionCounts[emoji] ?? 0,
                    onTap: () {
                      onSelected?.call(emoji);
                    },
                  );
                },
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summary(
      List<MapEntry<String, int>> reactions,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff191923),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 27,
            width: 105,
            child: Stack(
              children: List.generate(
                reactions.length > 4
                    ? 4
                    : reactions.length,
                    (index) {
                  return Positioned(
                    left: index * 20,
                    child: Container(
                      width: 27,
                      height: 27,
                      decoration: BoxDecoration(
                        color:
                        const Color(0xff20202A),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                          const Color(0xff191923),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          reactions[index].key,
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              _totalText(reactions),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xffB8B8C8),
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _totalText(
      List<MapEntry<String, int>> reactions,
      ) {
    final total = reactions.fold<int>(
      0,
          (sum, item) => sum + item.value,
    );

    if (total == 1) {
      return '1 reaction';
    }

    return '$total reactions';
  }

  Widget _handle() {
    return Container(
      width: 38,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _ReactionButton extends StatelessWidget {
  final String emoji;
  final bool selected;
  final int count;
  final VoidCallback onTap;

  const _ReactionButton({
    required this.emoji,
    required this.selected,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 160),
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xffA855F7)
              .withOpacity(.15)
              : const Color(0xff20202A),
          borderRadius:
          BorderRadius.circular(17),
          border: Border.all(
            color: selected
                ? const Color(0xffA855F7)
                : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: AnimatedScale(
                scale: selected ? 1.1 : 1,
                duration:
                const Duration(milliseconds: 160),
                child: Text(
                  emoji,
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            ),

            if (count > 0)
              Positioned(
                right: 5,
                bottom: 4,
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: selected
                        ? const Color(0xffC084FC)
                        : const Color(0xff777787),
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}