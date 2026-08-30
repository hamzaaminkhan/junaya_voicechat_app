import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:junaya_voicechat_app/screens/moments/data/comment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/comments_provider.dart';

class CommentsBottomSheet extends ConsumerStatefulWidget {
  final String momentId;

  const CommentsBottomSheet({
    super.key,
    required this.momentId,
  });

  @override
  ConsumerState<CommentsBottomSheet> createState() =>
      _CommentsBottomSheetState();
}

class _CommentsBottomSheetState
    extends ConsumerState<CommentsBottomSheet> {
  final TextEditingController _controller =
  TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state =
    ref.watch(commentsProvider(widget.momentId));

    return Container(
      height:
      MediaQuery.of(context).size.height * .82,
      decoration: const BoxDecoration(
        color: Color(0xff0D0D14),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(),
          const Divider(
            height: 1,
            color: Colors.white10,
          ),
          Expanded(
            child: state.when(
              loading: _loading,
              error: _error,
              data: _comments,
            ),
          ),
          _CommentInput(
            controller: _controller,
            onSend: _sendComment,
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 11),
      width: 38,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        17,
        16,
        16,
      ),
      child: Row(
        children: [
          Text(
            'Comments',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          Spacer(),
          Icon(
            Icons.chat_bubble_outline_rounded,
            color: Color(0xff777787),
            size: 19,
          ),
        ],
      ),
    );
  }

  Widget _loading() {
    return const Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xffA855F7),
        ),
      ),
    );
  }

  Widget _error(Object error, StackTrace stack) {
    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      children: [
        SizedBox(
          height:
          MediaQuery.of(context).size.height * .25,
        ),
        const Icon(
          Icons.chat_bubble_outline_rounded,
          color: Colors.white24,
          size: 42,
        ),
        const SizedBox(height: 14),
        const Text(
          'Unable to load comments',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Pull down to try again.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff666675),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _comments(List<Comment> comments) {
    if (comments.isEmpty) {
      return _emptyState();
    }

    return ListView.separated(
      physics:
      const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        16,
        18,
        16,
        20,
      ),
      itemCount: comments.length,
      separatorBuilder: (_, __) =>
      const SizedBox(height: 22),
      itemBuilder: (context, index) {
        return _CommentTile(
          comment: comments[index],
        );
      },
    );
  }

  Widget _emptyState() {
    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height:
          MediaQuery.of(context).size.height * .24,
        ),
        Container(
          width: 58,
          height: 58,
          margin: const EdgeInsets.symmetric(
            horizontal: 0,
          ),
          decoration: const BoxDecoration(
            color: Color(0xff191923),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.chat_bubble_outline_rounded,
            color: Colors.white30,
            size: 27,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'No comments yet',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Be the first to share your thoughts.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff666675),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Future<void> _sendComment() async {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      return;
    }

    final comment = Comment(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      momentId: widget.momentId,
      author: const CommentUser(
        id: 'local_user',
        username: 'junaya',
        displayName: 'Junaya',
        avatar: '',
      ),
      text: text,
      createdAt: DateTime.now(),
      likesCount: 0,
      isLiked: false,
    );

    await ref
        .read(
      commentsProvider(widget.momentId)
          .notifier,
    )
        .addComment(
      comment: comment,
    );

    if (!mounted) {
      return;
    }

    _controller.clear();
  }
}

class _CommentTile extends StatelessWidget {
  final Comment comment;

  const _CommentTile({
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
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
              Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      comment.author.displayName,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (comment.author.verified)
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 4,
                      ),
                      child: Icon(
                        Icons.verified_rounded,
                        size: 14,
                        color: Color(0xffA855F7),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 2),

              Text(
                '@${comment.author.username}',
                style: const TextStyle(
                  color: Color(0xff666675),
                  fontSize: 11.5,
                ),
              ),

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

              Row(
                children: [
                  Text(
                    _timeAgo(comment.createdAt),
                    style: const TextStyle(
                      color: Color(0xff666675),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Reply',
                    style: TextStyle(
                      color: Color(0xff888896),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
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
                  Icon(
                    comment.isLiked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 16,
                    color: comment.isLiked
                        ? const Color(0xffFF3B7A)
                        : const Color(0xff666675),
                  ),
                ],
              ),
            ],
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
            ? Container(
          color: const Color(0xff20202A),
          child: const Icon(
            Icons.person,
            color: Colors.white38,
            size: 19,
          ),
        )
            : avatar.startsWith('http')
            ? Image.network(
          avatar,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) =>
              _fallback(),
        )
            : Image.file(
          File(avatar),
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) =>
              _fallback(),
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

class _CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _CommentInput({
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          14,
          10,
          14,
          12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff11111A),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: .05),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints:
                const BoxConstraints(
                  maxHeight: 110,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff20202A),
                  borderRadius:
                  BorderRadius.circular(22),
                ),
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 4,
                  textCapitalization:
                  TextCapitalization.sentences,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  decoration:
                  const InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(
                      color: Color(0xff666675),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 9),

            GestureDetector(
              onTap: onSend,
              child: Container(
                width: 42,
                height: 42,
                decoration:
                const BoxDecoration(
                  color: Color(0xffA855F7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_upward_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}