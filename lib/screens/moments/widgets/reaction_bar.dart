import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';

class ReactionBar extends StatelessWidget {
  final Moment moment;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSave;

  const ReactionBar({
    super.key,
    required this.moment,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionItem(
          icon: Icons.favorite,
          count: 0,
          color: const Color(0xffFF3B7A),
          onTap: onLike,
        ),
        const SizedBox(width: 26),
        _ActionItem(
          icon: Icons.chat_bubble_outline,
          count: 0,
          color: const Color(0xffA7A7BC),
          onTap: onComment,
        ),
        const SizedBox(width: 26),
        _ActionItem(
          icon: Icons.auto_awesome,
          count: moment.reactions.length,
          color: const Color(0xffA855F7),
        ),
        const Spacer(),
        IconButton(
          onPressed: onShare,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(
            Icons.reply_rounded,
            color: Color(0xffA7A7BC),
            size: 26,
          ),
        ),
        const SizedBox(width: 22),
        IconButton(
          onPressed: onSave,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(
            Icons.bookmark_border,
            color: Color(0xffA7A7BC),
            size: 26,
          ),
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;
  final VoidCallback? onTap;

  const _ActionItem({
    required this.icon,
    required this.count,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(
            icon,
            size: 25,
            color: color,
          ),
          const SizedBox(width: 7),
          Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}