import 'package:flutter/material.dart';

class ReactionPicker extends StatelessWidget {
  final Function(String emoji) onSelected;

  const ReactionPicker({
    super.key,
    required this.onSelected,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff151522),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: .06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: reactions.map((emoji) {
          return _ReactionItem(
            emoji: emoji,
            onTap: () => onSelected(emoji),
          );
        }).toList(),
      ),
    );
  }
}

class _ReactionItem extends StatefulWidget {
  final String emoji;
  final VoidCallback onTap;

  const _ReactionItem({
    required this.emoji,
    required this.onTap,
  });

  @override
  State<_ReactionItem> createState() =>
      _ReactionItemState();
}

class _ReactionItemState
    extends State<_ReactionItem> {
  bool _pressed = false;

  void _handleTap() {
    setState(() {
      _pressed = true;
    });

    widget.onTap();

    Future.delayed(
      const Duration(milliseconds: 140),
          () {
        if (mounted) {
          setState(() {
            _pressed = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _pressed ? .86 : 1,
        duration: const Duration(
          milliseconds: 100,
        ),
        curve: Curves.easeOut,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xff20202A),
            borderRadius:
            BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.emoji,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}