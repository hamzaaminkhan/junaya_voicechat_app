import 'dart:io';

import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/screens/moments/data/comment_model.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;
  final VoidCallback? onLike;
  final VoidCallback? onReply;

  const CommentTile({
    super.key,
    required this.comment,
    this.onLike,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Avatar(
          avatar: comment.author.avatar,
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              _authorRow(),

              const SizedBox(height: 7),

              Text(
                comment.text,
                style: const TextStyle(
                  color: Color(0xffE5E5EA),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 9),

              _actions(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _authorRow() {
    return Row(
      children: [
        Flexible(
          child: Text(
            comment.author.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        if (comment.author.verified)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(
              Icons.verified_rounded,
              size: 14,
              color: Color(0xffA855F7),
            ),
          ),

        const SizedBox(width: 6),

        Flexible(
          child: Text(
            '@${comment.author.username}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xff666675),
              fontSize: 11.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _actions() {
    return Row(
      children: [
        Text(
          _timeAgo(comment.createdAt),
          style: const TextStyle(
            color: Color(0xff666675),
            fontSize: 11,
          ),
        ),

        const SizedBox(width: 14),

        GestureDetector(
          onTap: onReply,
          child: const Text(
            'Reply',
            style: TextStyle(
              color: Color(0xff888896),
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const Spacer(),

        if (comment.likesCount > 0)
          Text(
            '${comment.likesCount}',
            style: const TextStyle(
              color: Color(0xff777787),
              fontSize: 11,
            ),
          ),

        const SizedBox(width: 5),

        GestureDetector(
          onTap: onLike,
          behavior: HitTestBehavior.opaque,
          child: Icon(
            comment.isLiked
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            size: 17,
            color: comment.isLiked
                ? const Color(0xffFF3B7A)
                : const Color(0xff666675),
          ),
        ),
      ],
    );
  }

  String _timeAgo(DateTime date) {
    final difference =
    DateTime.now().difference(date);

    if (difference.inMinutes < 1) {
      return 'now';
    }

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    }

    if (difference.inDays < 1) {
      return '${difference.inHours}h';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays}d';
    }

    return '${date.day}/${date.month}';
  }
}

class _Avatar extends StatelessWidget {
  final String avatar;

  const _Avatar({
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(1),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Color(0xffA855F7),
            Color(0xffEC4899),
          ],
        ),
      ),
      child: ClipOval(
        child: avatar.isEmpty
            ? _fallback()
            : avatar.startsWith('http')
            ? Image.network(
          avatar,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) => _fallback(),
        )
            : Image.file(
          File(avatar),
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) => _fallback(),
        ),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      color: const Color(0xff20202A),
      child: const Icon(
        Icons.person,
        color: Colors.white38,
        size: 19,
      ),
    );
  }
}