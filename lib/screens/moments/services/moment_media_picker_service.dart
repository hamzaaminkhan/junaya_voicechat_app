import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_thumbnail_gdx_plus/video_thumbnail_gdx_plus.dart';

class MomentMediaPicker extends StatefulWidget {
  final List<String> mediaPaths;
  final int maxMedia;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  const MomentMediaPicker({
    super.key,
    required this.mediaPaths,
    required this.maxMedia,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<MomentMediaPicker> createState() =>
      _MomentMediaPickerState();
}

class _MomentMediaPickerState
    extends State<MomentMediaPicker> {
  @override
  Widget build(BuildContext context) {
    final paths = widget.mediaPaths;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        14,
        15,
        14,
        14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff11111A),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(.05),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Photos & videos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${paths.length}/${widget.maxMedia}',
                style: const TextStyle(
                  color: Color(0xff777787),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          SizedBox(
            height: 84,
            child: ListView.separated(
              scrollDirection:
              Axis.horizontal,
              physics:
              const BouncingScrollPhysics(),
              itemCount:
              paths.length +
                  (paths.length <
                      widget.maxMedia
                      ? 1
                      : 0),
              separatorBuilder:
                  (_, __) =>
              const SizedBox(
                width: 9,
              ),
              itemBuilder:
                  (context, index) {
                if (index == paths.length) {
                  return _AddMediaButton(
                    onTap: widget.onAdd,
                  );
                }

                return _MediaItem(
                  path: paths[index],
                  onRemove: () {
                    widget.onRemove(
                      index,
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 11),

          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: Color(0xff666675),
              ),
              const SizedBox(width: 5),
              Text(
                'Up to ${widget.maxMedia} photos or videos',
                style: const TextStyle(
                  color: Color(0xff666675),
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MediaItem extends StatelessWidget {
  final String path;
  final VoidCallback onRemove;

  const _MediaItem({
    required this.path,
    required this.onRemove,
  });

  bool get isVideo {
    final value =
    path.toLowerCase();

    return value.endsWith('.mp4') ||
        value.endsWith('.mov') ||
        value.endsWith('.m4v') ||
        value.endsWith('.webm') ||
        value.endsWith('.avi') ||
        value.endsWith('.mkv');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84,
      height: 84,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius:
            BorderRadius.circular(14),
            child: isVideo
                ? _VideoThumbnail(
              path: path,
            )
                : Image.file(
              File(path),
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) {
                return _placeholder();
              },
            ),
          ),

          if (isVideo)
            const Center(
              child: _PlayBadge(),
            ),

          Positioned(
            top: 5,
            right: 5,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onRemove,
                borderRadius:
                BorderRadius.circular(20),
                child: Container(
                  width: 23,
                  height: 23,
                  decoration:
                  BoxDecoration(
                    color: Colors.black
                        .withOpacity(.72),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xff20202A),
      child: const Icon(
        Icons.image_outlined,
        color: Colors.white30,
        size: 26,
      ),
    );
  }
}

class _VideoThumbnail
    extends StatefulWidget {
  final String path;

  const _VideoThumbnail({
    required this.path,
  });

  @override
  State<_VideoThumbnail> createState() =>
      _VideoThumbnailState();
}

class _VideoThumbnailState
    extends State<_VideoThumbnail> {
  Future<String?>? _thumbnailFuture;

  @override
  void initState() {
    super.initState();

    _thumbnailFuture =
        _generateThumbnail();
  }

  Future<String?> _generateThumbnail() async {
    try {
      return await VideoThumbnail.thumbnailFile(
        video: widget.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 400,
        quality: 75,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _thumbnailFuture,
      builder:
          (context, snapshot) {
        final thumbnail =
            snapshot.data;

        if (thumbnail == null) {
          return Container(
            color: const Color(0xff20202A),
            child: const Icon(
              Icons.videocam_outlined,
              color: Colors.white38,
              size: 26,
            ),
          );
        }

        return Image.file(
          File(thumbnail),
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) {
            return Container(
              color:
              const Color(0xff20202A),
              child: const Icon(
                Icons.videocam_outlined,
                color: Colors.white38,
                size: 26,
              ),
            );
          },
        );
      },
    );
  }
}

class _PlayBadge
    extends StatelessWidget {
  const _PlayBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.black
            .withOpacity(.58),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.play_arrow_rounded,
        color: Colors.white,
        size: 18,
      ),
    );
  }
}

class _AddMediaButton
    extends StatelessWidget {
  final VoidCallback onTap;

  const _AddMediaButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius:
      BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(14),
        child: Ink(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: const Color(0xff0D0D14),
            borderRadius:
            BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xff8B5CF6)
                  .withOpacity(.55),
            ),
          ),
          child: const Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_rounded,
                color: Color(0xffA855F7),
                size: 27,
              ),
              SizedBox(height: 3),
              Text(
                'Add',
                style: TextStyle(
                  color: Color(0xffC084FC),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}