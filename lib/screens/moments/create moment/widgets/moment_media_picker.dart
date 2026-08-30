import 'dart:io';

import 'package:flutter/material.dart';

class MomentMediaPicker extends StatelessWidget {
  final List<String> mediaPaths;
  final VoidCallback? onAdd;
  final ValueChanged<int>? onRemove;
  final int maxMedia;

  const MomentMediaPicker({
    super.key,
    this.mediaPaths = const [],
    this.onAdd,
    this.onRemove,
    this.maxMedia = 10,
  });

  @override
  Widget build(BuildContext context) {
    final canAdd = mediaPaths.length < maxMedia;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        14,
        15,
        14,
        14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff11111A),
        borderRadius: BorderRadius.circular(20),
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
                '${mediaPaths.length}/$maxMedia',
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
              scrollDirection: Axis.horizontal,
              physics:
              const BouncingScrollPhysics(),
              itemCount:
              mediaPaths.length +
                  (canAdd ? 1 : 0),
              separatorBuilder: (_, __) =>
              const SizedBox(width: 9),
              itemBuilder: (context, index) {
                if (index == mediaPaths.length) {
                  return _AddMediaButton(
                    onTap: onAdd,
                  );
                }

                return _MediaItem(
                  path: mediaPaths[index],
                  onRemove: onRemove == null
                      ? null
                      : () {
                    onRemove!(index);
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 11),

          const Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: Color(0xff666675),
              ),
              SizedBox(width: 5),
              Text(
                'Up to 10 photos or videos',
                style: TextStyle(
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
  final VoidCallback? onRemove;

  const _MediaItem({
    required this.path,
    this.onRemove,
  });

  bool get isVideo {
    final value = path.toLowerCase();

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
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius:
              BorderRadius.circular(14),
              child: _buildPreview(),
            ),
          ),

          if (isVideo)
            Positioned(
              left: 6,
              bottom: 6,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color:
                  Colors.black.withOpacity(.68),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),

          if (onRemove != null)
            Positioned(
              top: 5,
              right: 5,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onRemove,
                  customBorder:
                  const CircleBorder(),
                  child: Container(
                    width: 23,
                    height: 23,
                    decoration: BoxDecoration(
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

  Widget _buildPreview() {
    if (path.startsWith('http://') ||
        path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _placeholder();
        },
        loadingBuilder:
            (context, child, progress) {
          if (progress == null) {
            return child;
          }

          return _loading();
        },
      );
    }

    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return _placeholder();
      },
    );
  }

  Widget _loading() {
    return Container(
      color: const Color(0xff20202A),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xffA855F7),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xff20202A),
      alignment: Alignment.center,
      child: Icon(
        isVideo
            ? Icons.video_file_outlined
            : Icons.image_outlined,
        color: Colors.white30,
        size: 26,
      ),
    );
  }
}

class _AddMediaButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _AddMediaButton({
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
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