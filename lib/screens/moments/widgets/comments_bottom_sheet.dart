// ignore_for_file: deprecated_member_use

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

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      commentsProvider(widget.momentId),
    );

    return Container(
      height: MediaQuery.of(context).size.height * .78,
      decoration: const BoxDecoration(
        color: Color(0xff0D0D14),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(),
          Expanded(
            child: state.when(
              loading: _loading,
              error: _error,
              data: _comments,
            ),
          ),
          _CommentInput(
            controller: _controller,
            focusNode: _focusNode,
            onSend: _sendComment,
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 38,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        14,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Comments',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.close,
              size: 22,
              color: Color(0xff8F8F9F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loading() {
    return const Center(
      child: SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xffA855F7),
        ),
      ),
    );
  }

  Widget _error(Object error, StackTrace stackTrace) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Unable to load comments',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white54,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _comments(List<Comment> comments) {
    if (comments.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 40,
              color: Colors.white24,
            ),
            SizedBox(height: 12),
            Text(
              'No comments yet',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Be the first to comment',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        20,
      ),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return _CommentTile(
          comment: comments[index],
        );
      },
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
      commentsProvider(widget.momentId).notifier,
    )
        .addComment(
      comment: comment,
    );

    _controller.clear();
    _focusNode.unfocus();
  }
}

class _CommentTile extends StatelessWidget {
  final Comment comment;

  const _CommentTile({
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    final author = comment.author;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 22,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(
            path: author.avatar,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        author.displayName.isNotEmpty
                            ? author.displayName
                            : author.username,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (author.verified)
                      const Padding(
                        padding:
                        EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.verified,
                          size: 14,
                          color: Color(0xff8B5CF6),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '@${author.username}',
                  style: const TextStyle(
                    color: Color(0xff777787),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  comment.text,
                  style: const TextStyle(
                    color: Color(0xffE8E8EF),
                    fontSize: 14.5,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      _timeAgo(comment.createdAt),
                      style: const TextStyle(
                        color: Color(0xff686877),
                        fontSize: 11.5,
                      ),
                    ),
                    if (comment.likesCount > 0) ...[
                      const SizedBox(width: 14),
                      const Icon(
                        Icons.favorite,
                        size: 12,
                        color: Color(0xffFF3B7A),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        comment.likesCount.toString(),
                        style: const TextStyle(
                          color: Color(0xff686877),
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
  final String path;

  const _Avatar({
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xff20202A),
      ),
      child: ClipOval(
        child: path.isEmpty
            ? const Icon(
          Icons.person,
          color: Colors.white38,
          size: 21,
        )
            : path.startsWith('http')
            ? Image.network(
          path,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) {
            return const Icon(
              Icons.person,
              color: Colors.white38,
              size: 21,
            );
          },
        )
            : Image.file(
          File(path),
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) {
            return const Icon(
              Icons.person,
              color: Colors.white38,
              size: 21,
            );
          },
        ),
      ),
    );
  }
}

class _CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;

  const _CommentInput({
    required this.controller,
    required this.focusNode,
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
          color: const Color(0xff151522),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(.06),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                minLines: 1,
                maxLines: 4,
                textCapitalization:
                TextCapitalization.sentences,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: const TextStyle(
                    color: Color(0xff6F6F7F),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor:
                  const Color(0xff20202A),
                  contentPadding:
                  const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 11,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(22),
                    borderSide: const BorderSide(
                      color: Color(0xff8B5CF6),
                      width: .7,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 9),
            Material(
              color: const Color(0xffA855F7),
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onSend,
                customBorder:
                const CircleBorder(),
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(
                    Icons.arrow_upward_rounded,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}