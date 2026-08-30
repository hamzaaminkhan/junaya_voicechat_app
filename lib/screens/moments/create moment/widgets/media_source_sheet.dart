import 'package:flutter/material.dart';

enum MomentMediaSource {
  camera,
  photos,
  video,
  cameraVideo,
}

class MediaSourceSheet
    extends StatelessWidget {
  const MediaSourceSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        24,
      ),
      decoration:
      const BoxDecoration(
        color: Color(0xff11111A),
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 4,
              decoration:
              BoxDecoration(
                color: Colors.white24,
                borderRadius:
                BorderRadius.circular(
                  20,
                ),
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Add to your moment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pop();
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color:
                    Color(0xff777787),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            const Align(
              alignment:
              Alignment.centerLeft,
              child: Text(
                'Choose how you want to add media.',
                style: TextStyle(
                  color: Color(0xff666675),
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 18),

            _SourceTile(
              icon:
              Icons.camera_alt_outlined,
              color:
              const Color(0xffA855F7),
              title: 'Camera',
              subtitle:
              'Take a photo',
              onTap: () {
                Navigator.of(context).pop(
                  MomentMediaSource.camera,
                );
              },
            ),

            const SizedBox(height: 8),

            _SourceTile(
              icon:
              Icons.photo_library_outlined,
              color:
              const Color(0xff22C55E),
              title: 'Photos',
              subtitle:
              'Choose photos from your gallery',
              onTap: () {
                Navigator.of(context).pop(
                  MomentMediaSource.photos,
                );
              },
            ),

            const SizedBox(height: 8),

            _SourceTile(
              icon:
              Icons.video_library_outlined,
              color:
              const Color(0xffF59E0B),
              title: 'Video',
              subtitle:
              'Choose a video from your gallery',
              onTap: () {
                Navigator.of(context).pop(
                  MomentMediaSource.video,
                );
              },
            ),

            const SizedBox(height: 8),

            _SourceTile(
              icon:
              Icons.videocam_outlined,
              color:
              const Color(0xffEC4899),
              title: 'Record video',
              subtitle:
              'Record a video with your camera',
              onTap: () {
                Navigator.of(context).pop(
                  MomentMediaSource.cameraVideo,
                );
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _SourceTile
    extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SourceTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
      const Color(0xff191923),
      borderRadius:
      BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(17),
        child: Padding(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 12,
          ),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration:
                BoxDecoration(
                  color: color
                      .withOpacity(.11),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
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
                      style:
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      subtitle,
                      style:
                      const TextStyle(
                        color:
                        Color(0xff777787),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color:
                Color(0xff555563),
              ),
            ],
          ),
        ),
      ),
    );
  }
}