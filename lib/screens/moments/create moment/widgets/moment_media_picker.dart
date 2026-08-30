// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MomentMediaPicker extends StatefulWidget {
  final ValueChanged<List<String>>? onChanged;
  final int maxMedia;

  const MomentMediaPicker({
    super.key,
    this.onChanged,
    this.maxMedia = 10,
  });

  @override
  State<MomentMediaPicker> createState() =>
      _MomentMediaPickerState();
}

class _MomentMediaPickerState
    extends State<MomentMediaPicker> {
  final ImagePicker _picker = ImagePicker();
  final List<String> _media = [];

  bool _picking = false;

  Future<void> _addMedia() async {
    if (_picking ||
        _media.length >= widget.maxMedia) {
      return;
    }

    setState(() {
      _picking = true;
    });

    try {
      final remaining =
          widget.maxMedia - _media.length;

      final files = await _picker.pickMultiImage(
        imageQuality: 90,
      );

      if (files.isEmpty) {
        return;
      }

      final selected = files
          .take(remaining)
          .map((file) => file.path)
          .toList();

      setState(() {
        _media.addAll(selected);
      });

      widget.onChanged?.call(
        List.unmodifiable(_media),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to select photos',
            ),
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          _picking = false;
        });
      }
    }
  }

  void _removeMedia(int index) {
    if (index < 0 ||
        index >= _media.length) {
      return;
    }

    setState(() {
      _media.removeAt(index);
    });

    widget.onChanged?.call(
      List.unmodifiable(_media),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canAdd =
        _media.length < widget.maxMedia;

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
                '${_media.length}/${widget.maxMedia}',
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
              itemCount: _media.length +
                  (canAdd ? 1 : 0),
              separatorBuilder: (_, __) =>
              const SizedBox(width: 9),
              itemBuilder: (context, index) {
                if (index == _media.length) {
                  return _AddMediaButton(
                    loading: _picking,
                    onTap: _addMedia,
                  );
                }

                return _MediaItem(
                  path: _media[index],
                  onRemove: () {
                    _removeMedia(index);
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
  final VoidCallback onRemove;

  const _MediaItem({
    required this.path,
    required this.onRemove,
  });

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
              child: _buildImage(),
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: onRemove,
              behavior:
              HitTestBehavior.opaque,
              child: Container(
                width: 23,
                height: 23,
                decoration: BoxDecoration(
                  color:
                  Colors.black.withOpacity(.7),
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
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          color: const Color(0xff20202A),
          child: const Icon(
            Icons.broken_image_outlined,
            color: Colors.white30,
            size: 26,
          ),
        );
      },
    );
  }
}

class _AddMediaButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool loading;

  const _AddMediaButton({
    required this.onTap,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: loading ? null : onTap,
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
          child: loading
              ? const Center(
            child:
            CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xffA855F7),
            ),
          )
              : const Column(
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