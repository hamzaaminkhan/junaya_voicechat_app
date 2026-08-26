import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/moments_provider.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/comments_bottom_sheet.dart';

import 'reaction_picker.dart';



class ReactionBar extends ConsumerWidget {

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
  Widget build(BuildContext context, WidgetRef ref) {

    return Row(
      children: [

        GestureDetector(
          onLongPress: () => _showReactionPicker(context, ref),
          child: const Icon(
            Icons.add_reaction_outlined,
            color: Colors.white54,
            size: 24,
          ),
        ),

        const SizedBox(width: 10),

        InkWell(
          onTap: onLike,
          child: Row(
            children: [
              Icon(
                moment.isLiked
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: moment.isLiked
                    ? Colors.red
                    : Colors.white54,
                size: 24,
              ),
              const SizedBox(width: 6),
              Text(
                moment.stats.likes.toString(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 20),

        InkWell(
          onTap: () {
            onComment?.call();

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => CommentsBottomSheet(
                momentId: moment.id,
              ),
            );
          },
          child: Row(
            children: [
              const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white54,
                size: 24,
              ),
              const SizedBox(width: 6),
              Text(
                moment.stats.comments.toString(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        InkWell(
          onTap: onShare,
          child: const Icon(
            Icons.share_outlined,
            color: Colors.white54,
            size: 24,
          ),
        ),

        const SizedBox(width: 16),

        InkWell(
          onTap: onSave,
          child: Icon(
            moment.isSaved
                ? Icons.bookmark
                : Icons.bookmark_border,
            color: Colors.white54,
            size: 24,
          ),
        ),
      ],
    );
  }



  void _showReactionPicker(
      BuildContext context,
      WidgetRef ref,
      ) {

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) {

        return Dialog(
          backgroundColor: Colors.transparent,
          child: ReactionPicker(
            onSelected: (emoji) async {

              Navigator.pop(context);

              await ref
                  .read(momentsProvider.notifier)
                  .addReaction(
                moment: moment,
                userId: "local_user",
                emoji: emoji,
              );
            },
          ),
        );
      },
    );
  }
}