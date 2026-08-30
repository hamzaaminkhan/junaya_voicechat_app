import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_draft_model.dart';



class DraftCard extends StatelessWidget {
  final MomentDraft draft;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const DraftCard({
    super.key,
    required this.draft,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xff11111A),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildThumbnail(),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      draft.caption.trim().isEmpty
                          ? 'Untitled moment'
                          : draft.caption.trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: Color(0xff666675),
                        ),

                        const SizedBox(width: 4),

                        Text(
                          _formatDate(draft.updatedAt),
                          style: const TextStyle(
                            color: Color(0xff666675),
                            fontSize: 11.5,
                          ),
                        ),

                        if (draft.mediaPaths.isNotEmpty) ...[
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.photo_library_outlined,
                            size: 13,
                            color: Color(0xff666675),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${draft.mediaPaths.length}',
                            style: const TextStyle(
                              color: Color(0xff666675),
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: onDelete,
                splashRadius: 20,
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Color(0xff777787),
                  size: 21,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    final hasMedia =
        draft.mediaPaths.isNotEmpty;

    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: const Color(0xff191923),
        borderRadius: BorderRadius.circular(14),
      ),
      child: hasMedia
          ? _buildImage(
        draft.mediaPaths.first,
      )
          : const Icon(
        Icons.auto_awesome_rounded,
        color: Color(0xff8B5CF6),
        size: 25,
      ),
    );
  }

  Widget _buildImage(String path) {
    if (path.startsWith('http://') ||
        path.startsWith('https://')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(
          path,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return const Icon(
              Icons.image_outlined,
              color: Color(0xff777787),
            );
          },
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return const Icon(
            Icons.image_outlined,
            color: Color(0xff777787),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    }

    if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }

    final month = date.month
        .toString()
        .padLeft(2, '0');

    final day = date.day
        .toString()
        .padLeft(2, '0');

    return '$day/$month/${date.year}';
  }
}