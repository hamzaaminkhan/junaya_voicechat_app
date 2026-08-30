import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/comments_bottom_sheet.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moment_header.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moment_media.dart';
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
      backgroundColor: const Color(0xff09090F),
      appBar: AppBar(
        backgroundColor: const Color(0xff09090F),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
          ),
        ),
        title: const Text(
          'Moment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(
          bottom: 40,
        ),
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
                16,
              ),
              child: Text(
                moment.caption,
                style: const TextStyle(
                  color: Colors.white,
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
                borderRadius: BorderRadius.circular(22),
                child: MomentMediaWidget(
                  media: moment.media.toList(),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              4,
            ),
            child: ReactionBar(
              moment: moment,
            ),
          ),
          ReactionSummary(
            reactions: moment.reactions.toList(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              18,
              16,
              0,
            ),
            child: GestureDetector(
              onTap: () {
                _openComments(context);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff151522),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .05),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 19,
                      color: Color(0xffA7A7B8),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        moment.stats.comments == 0
                            ? 'Add a comment...'
                            : '${moment.stats.comments} comments',
                        style: const TextStyle(
                          color: Color(0xffA7A7B8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: Color(0xff666676),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openComments(BuildContext context) {
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
}