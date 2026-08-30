import 'package:flutter/material.dart';

enum MomentMediaSource {
  gallery,
  camera,
  video,
}

class MediaSourceSheet extends StatelessWidget {
  final ValueChanged<MomentMediaSource> onSelected;

  const MediaSourceSheet({
    super.key,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        28,
      ),
      decoration: const BoxDecoration(
        color: Color(0xff11111A),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius:
              BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Add media',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Choose how you want to add media.',
              style: TextStyle(
                color: Color(0xff777787),
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 18),
          _SourceItem(
            icon: Icons.photo_library_outlined,
            title: 'Photo library',
            subtitle: 'Choose photos from your device',
            onTap: () {
              onSelected(
                MomentMediaSource.gallery,
              );
            },
          ),
          const SizedBox(height: 8),
          _SourceItem(
            icon: Icons.videocam_outlined,
            title: 'Video',
            subtitle: 'Choose a video from your device',
            onTap: () {
              onSelected(
                MomentMediaSource.video,
              );
            },
          ),
          const SizedBox(height: 8),
          _SourceItem(
            icon: Icons.camera_alt_outlined,
            title: 'Camera',
            subtitle: 'Take a new photo',
            onTap: () {
              onSelected(
                MomentMediaSource.camera,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SourceItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SourceItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xff191923),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xffA855F7)
                      .withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_photo_alternate_outlined,
                  color: Color(0xffA855F7),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xff777787),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xff5F5F6D),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}