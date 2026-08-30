import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';

class FullscreenMediaViewer extends StatefulWidget {
  final List<MomentMedia> media;
  final int initialIndex;

  const FullscreenMediaViewer({
    super.key,
    required this.media,
    this.initialIndex = 0,
  });

  @override
  State<FullscreenMediaViewer> createState() =>
      _FullscreenMediaViewerState();
}

class _FullscreenMediaViewerState
    extends State<FullscreenMediaViewer> {
  late final PageController _controller;

  late int _currentIndex;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex;

    _controller = PageController(
      initialPage: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.media.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            pageController: _controller,
            itemCount: widget.media.length,

            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),

            onPageChanged: (value) {
              if (!mounted) return;

              setState(() {
                _currentIndex = value;
              });
            },

            builder: (context, index) {
              final media = widget.media[index];

              return PhotoViewGalleryPageOptions(
                imageProvider: _imageProvider(media),

                minScale:
                PhotoViewComputedScale.contained,

                maxScale:
                PhotoViewComputedScale.covered * 3,

                heroAttributes:
                PhotoViewHeroAttributes(
                  tag: 'moment-media-${media.id}',
                ),
              );
            },
          ),

          _buildTopBar(context),

          if (widget.media.length > 1)
            _buildPageIndicator(),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
          child: Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              if (widget.media.length > 1)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(
                      alpha: .55,
                    ),
                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                  child: Text(
                    '${_currentIndex + 1}/${widget.media.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.media.length,
              (index) {
            final active =
                index == _currentIndex;

            return AnimatedContainer(
              duration:
              const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              margin:
              const EdgeInsets.symmetric(
                horizontal: 3,
              ),
              width: active ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active
                    ? Colors.white
                    : Colors.white38,
                borderRadius:
                BorderRadius.circular(10),
              ),
            );
          },
        ),
      ),
    );
  }

  ImageProvider _imageProvider(
      MomentMedia media,
      ) {
    final remoteUrl = media.remoteUrl;

    if (remoteUrl != null &&
        remoteUrl.trim().isNotEmpty) {
      return NetworkImage(remoteUrl);
    }

    final localPath = media.localPath;

    if (localPath.trim().isNotEmpty) {
      return FileImage(
        File(localPath),
      );
    }

    return const AssetImage(
      'assets/images/placeholder.png',
    );
  }
}