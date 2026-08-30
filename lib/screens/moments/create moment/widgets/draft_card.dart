import 'package:flutter/material.dart';

class DraftCard extends StatelessWidget {
  final String? thumbnail;
  final String caption;
  final String date;
  final int mediaCount;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const DraftCard({
    super.key,
    this.thumbnail,
    this.caption = '',
    this.date = '',
    this.mediaCount = 0,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xff11111A),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _thumbnail(),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      caption.trim().isEmpty
                          ? 'Untitled moment'
                          : caption.trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        if (date.isNotEmpty)
                          Text(
                            date,
                            style: const TextStyle(
                              color: Color(0xff777787),
                              fontSize: 12,
                            ),
                          ),

                        if (date.isNotEmpty &&
                            mediaCount > 0)
                          const Padding(
                            padding:
                            EdgeInsets.symmetric(
                              horizontal: 7,
                            ),
                            child: Text(
                              '•',
                              style: TextStyle(
                                color:
                                Color(0xff555563),
                              ),
                            ),
                          ),

                        if (mediaCount > 0)
                          Row(
                            mainAxisSize:
                            MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.photo_outlined,
                                size: 13,
                                color:
                                Color(0xff777787),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$mediaCount',
                                style:
                                const TextStyle(
                                  color:
                                  Color(0xff777787),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              PopupMenuButton<String>(
                color: const Color(0xff20202A),
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Color(0xff777787),
                  size: 21,
                ),
                onSelected: (value) {
                  if (value == 'delete') {
                    onDelete?.call();
                  }
                },
                itemBuilder: (_) {
                  return const [
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            color: Color(0xffFF4D6D),
                            size: 19,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Delete draft',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _thumbnail() {
    if (thumbnail == null ||
        thumbnail!.trim().isEmpty) {
      return Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          color: const Color(0xff20202A),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(
          Icons.edit_note_rounded,
          color: Colors.white24,
          size: 30,
        ),
      );
    }

    final isNetwork =
        thumbnail!.startsWith('http://') ||
            thumbnail!.startsWith('https://');

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: isNetwork
          ? Image.network(
        thumbnail!,
        width: 76,
        height: 76,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            _thumbnailPlaceholder(),
      )
          : Image.asset(
        thumbnail!,
        width: 76,
        height: 76,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            _thumbnailPlaceholder(),
      ),
    );
  }

  Widget _thumbnailPlaceholder() {
    return Container(
      width: 76,
      height: 76,
      color: const Color(0xff20202A),
      child: const Icon(
        Icons.image_outlined,
        color: Colors.white24,
        size: 28,
      ),
    );
  }
}