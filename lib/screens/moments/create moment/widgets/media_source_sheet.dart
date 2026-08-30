import 'package:flutter/material.dart';

enum MomentMediaSource {
  gallery,
  video,
  camera,
}

class MediaSourceSheet extends StatelessWidget {
  const MediaSourceSheet({
    super.key,
    this.onSelected,
  });

  final ValueChanged<MomentMediaSource>? onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        28,
      ),
      decoration: const BoxDecoration(
        color: Color(0xff11111A),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _handle(),

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

            const SizedBox(height: 5),

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

            _SourceTile(
              icon: Icons.photo_library_outlined,
              title: 'Photo library',
              subtitle:
              'Choose photos from your device',
              onTap: () => _select(
                context,
                MomentMediaSource.gallery,
              ),
            ),

            const SizedBox(height: 8),

            _SourceTile(
              icon: Icons.video_library_outlined,
              title: 'Video',
              subtitle:
              'Choose a video from your device',
              onTap: () => _select(
                context,
                MomentMediaSource.video,
              ),
            ),

            const SizedBox(height: 8),

            _SourceTile(
              icon: Icons.camera_alt_outlined,
              title: 'Camera',
              subtitle:
              'Take a new photo',
              onTap: () => _select(
                context,
                MomentMediaSource.camera,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _select(
      BuildContext context,
      MomentMediaSource source,
      ) {
    onSelected?.call(source);
    Navigator.of(context).pop(source);
  }

  Widget _handle() {
    return Container(
      width: 38,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SourceTile({
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
                child: Icon(
                  icon,
                  color: const Color(0xffA855F7),
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
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }
}