import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/comments_bottom_sheet.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moment_header.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moment_media.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moment_reaction_sheet.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/reaction_bar.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/reaction_summary.dart';

class MomentDetailScreen extends StatelessWidget {
  final Moment moment;

  const MomentDetailScreen({
    super.key,
    required this.moment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff07070D),
      appBar: _buildAppBar(context),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(
          top: 4,
          bottom: 40,
        ),
        children: [
          _buildCard(context),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context,
      ) {
    return AppBar(
      backgroundColor: const Color(0xff07070D),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
          size: 23,
        ),
      ),
      title: const Text(
        'Moment',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.more_horiz_rounded,
            color: Color(0xffA7A7B5),
            size: 23,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff0D0D14),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withValues(alpha: .04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .28),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          MomentHeader(
            moment: moment,
            onDelete: () {
              Navigator.of(context).pop();
            },
          ),

          if (moment.caption.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                4,
                16,
                14,
              ),
              child: Text(
                moment.caption,
                style: const TextStyle(
                  color: Color(0xffF2F2F5),
                  fontSize: 16,
                  height: 1.45,
                ),
              ),
            ),

          if (moment.media.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: ClipRRect(
                borderRadius:
                BorderRadius.circular(18),
                child: MomentMediaWidget(
                  media: moment.media.toList(),
                ),
              ),
            ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: ReactionBar(
              moment: moment,
              onLike: () {},
              onComment: () {
                _showComments(context);
              },
              onShare: () {},
              onSave: () {},
            ),
          ),

          if (moment.reactions.isNotEmpty)
            ReactionSummary(
              reactions:
              moment.reactions.toList(),
            ),

          _buildCommentsButton(context),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildCommentsButton(
      BuildContext context,
      ) {
    final count = moment.stats.comments;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        6,
      ),
      child: GestureDetector(
        onTap: () {
          _showComments(context);
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            const Icon(
              Icons.chat_bubble_outline_rounded,
              color: Color(0xff777787),
              size: 17,
            ),
            const SizedBox(width: 8),
            Text(
              count == 0
                  ? 'View comments'
                  : 'View all $count comments',
              style: const TextStyle(
                color: Color(0xff9999A8),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xff555563),
              size: 19,
            ),
          ],
        ),
      ),
    );
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return CommentsBottomSheet(
          momentId: moment.id,
        );
      },
    );
  }

  void _showReactions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return MomentReactionSheet(
          reactionCounts: _reactionCounts(),
        );
      },
    );
  }

  Map<String, int> _reactionCounts() {
    final counts = <String, int>{};

    for (final reaction in moment.reactions) {
      counts[reaction.emoji] =
          (counts[reaction.emoji] ?? 0) + 1;
    }

    return counts;
  }
}