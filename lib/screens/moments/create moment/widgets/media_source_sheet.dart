import 'package:flutter/material.dart';

enum MediaSource {
  camera,
  gallery,
  video,
}

class MediaSourceSheet extends StatelessWidget {
  final ValueChanged<MediaSource>? onSelected;

  const MediaSourceSheet({
    super.key,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xff11111A),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _handle(),

            const SizedBox(height: 18),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Add media',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xff777787),
                    size: 21,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose how you want to add to your moment.',
                style: TextStyle(
                  color: Color(0xff666675),
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 18),

            _SourceTile(
              icon: Icons.camera_alt_outlined,
              title: 'Camera',
              subtitle: 'Take a photo',
              onTap: () {
                _select(
                  context,
                  MediaSource.camera,
                );
              },
            ),

            const SizedBox(height: 9),

            _SourceTile(
              icon: Icons.photo_library_outlined,
              title: 'Photo library',
              subtitle: 'Choose photos from your device',
              onTap: () {
                _select(
                  context,
                  MediaSource.gallery,
                );
              },
            ),

            const SizedBox(height: 9),

            _SourceTile(
              icon: Icons.videocam_outlined,
              title: 'Video',
              subtitle: 'Record or choose a video',
              onTap: () {
                _select(
                  context,
                  MediaSource.video,
                );
              },
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _select(
      BuildContext context,
      MediaSource source,
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
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xffA855F7)
                      .withOpacity(.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: const Color(0xffA855F7),
                  size: 21,
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
                color: Color(0xff555563),
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }
}