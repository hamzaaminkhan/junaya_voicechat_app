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
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
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
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            "Comments",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: state.when(
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              error: (_, __) {
                return const Center(
                  child: Text(
                    "Failed loading comments",
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                );
              },
              data: (comments) {
                if (comments.isEmpty) {
                  return const Center(
                    child: Text(
                      "No comments yet",
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return _CommentTile(
                      comment: comments[index],
                    );
                  },
                );
              },
            ),
          ),
          _CommentInput(
            controller: controller,
            onSend: _sendComment,
          ),
        ],
      ),
    );
  }

  Future<void> _sendComment() async {
    final text = controller.text.trim();

    if (text.isEmpty) {
      return;
    }

    final comment = Comment(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      momentId: widget.momentId,
      author: const CommentUser(
        id: "local_user",
        username: "junaya",
        displayName: "Junaya",
        avatar: "",
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

    controller.clear();
  }
}

class _CommentTile extends StatelessWidget {
  final Comment comment;

  const _CommentTile({
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 18,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: _avatar(),
            backgroundColor:
            const Color(0xff20202A),
            child: comment.author.avatar.isEmpty
                ? const Icon(
              Icons.person,
              color: Colors.white54,
            )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.author.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                    if (comment.author.verified)
                      const Padding(
                        padding:
                        EdgeInsets.only(left: 5),
                        child: Icon(
                          Icons.verified,
                          size: 14,
                          color: Colors.blue,
                        ),
                      ),
                  ],
                ),
                Text(
                  "@${comment.author.username}",
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  comment.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider? _avatar() {
    if (comment.author.avatar.isEmpty) {
      return null;
    }

    if (comment.author.avatar.startsWith("http")) {
      return NetworkImage(
        comment.author.avatar,
      );
    }

    return FileImage(
      File(
        comment.author.avatar,
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
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          14,
          10,
          14,
          12,
        ),
        decoration: const BoxDecoration(
          color: Color(0xff151522),
          border: Border(
            top: BorderSide(
              color: Colors.white10,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: 4,
                minLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText:
                  "Add a comment...",
                  hintStyle: const TextStyle(
                    color: Colors.white38,
                  ),
                  filled: true,
                  fillColor:
                  const Color(0xff20202A),
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(24),
                    borderSide:
                    BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onSend,
              child: Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffA855F7),
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}