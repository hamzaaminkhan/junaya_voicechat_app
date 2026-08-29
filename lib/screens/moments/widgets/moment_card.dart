import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moment_header.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moment_media.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/reaction_bar.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/reaction_summary.dart';

class MomentCard extends StatefulWidget {
  final Moment moment;
  final VoidCallback onDelete;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSave;

  const MomentCard({
    super.key,
    required this.moment,
    required this.onDelete,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onSave,
  });

  @override
  State<MomentCard> createState() =>
      _MomentCardState();
}

class _MomentCardState extends State<MomentCard> {
  bool _showHeart = false;

  void _doubleTapLike() {
    setState(() {
      _showHeart = true;
    });

    widget.onLike?.call();

    Future.delayed(
      const Duration(milliseconds: 700),
          () {
        if (mounted) {
          setState(() {
            _showHeart = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final moment = widget.moment;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        12,
        8,
        12,
        10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff0D0D14),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withValues(alpha: .05),
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          MomentHeader(
            moment: moment,
            onDelete: widget.onDelete,
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
                  color: Colors.white,
                  fontSize: 15.5,
                  height: 1.45,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

          if (moment.media.isNotEmpty)
            GestureDetector(
              onDoubleTap: _doubleTapLike,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.circular(22),
                      child: MomentMediaWidget(
                        media:
                        moment.media.toList(),
                      ),
                    ),
                  ),

                  AnimatedScale(
                    scale:
                    _showHeart ? 1 : 0,
                    duration:
                    const Duration(
                      milliseconds: 180,
                    ),
                    curve:
                    Curves.easeOutBack,
                    child: const Icon(
                      Icons.favorite,
                      size: 90,
                      color:
                      Color(0xffFF3B7A),
                    ),
                  ),
                ],
              ),
            ),

          Padding(
            padding:
            const EdgeInsets.fromLTRB(
              16,
              14,
              16,
              4,
            ),
            child: ReactionBar(
              moment: moment,
              onLike: widget.onLike,
              onComment: widget.onComment,
              onShare: widget.onShare,
              onSave: widget.onSave,
            ),
          ),

          ReactionSummary(
            reactions:
            moment.reactions.toList(),
          ),

          Padding(
            padding:
            const EdgeInsets.fromLTRB(
              16,
              12,
              16,
              18,
            ),
            child: GestureDetector(
              onTap: widget.onComment,
              child: const Text(
                "View comments",
                style: TextStyle(
                  color:
                  Color(0xffA78BFA),
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}