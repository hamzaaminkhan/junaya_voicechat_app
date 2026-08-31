import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/fullscreen_media_viewer.dart';

class MomentMediaWidget extends StatefulWidget {
  final List<MomentMedia> media;

  const MomentMediaWidget({
    super.key,
    required this.media,
  });

  @override
  State<MomentMediaWidget> createState() =>
      _MomentMediaWidgetState();
}

class _MomentMediaWidgetState
    extends State<MomentMediaWidget> {
  final PageController _controller =
  PageController();

  int _currentIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.media.isEmpty) {
      return const SizedBox.shrink();
    }

    return AspectRatio(
      aspectRatio: 1.15,
      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _controller,
              itemCount:
              widget.media.length,
              physics:
              const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration:
                        const Duration(
                          milliseconds: 250,
                        ),
                        pageBuilder: (_, animation, __) {
                          return FadeTransition(
                            opacity: animation,
                            child:
                            FullscreenMediaViewer(
                              media:
                              widget.media,
                              initialIndex:
                              index,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: _buildMedia(
                    widget.media[index],
                  ),
                );
              },
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 80,
              child: IgnorePointer(
                child: Container(
                  decoration:
                  const BoxDecoration(
                    gradient: LinearGradient(
                      begin:
                      Alignment.topCenter,
                      end:
                      Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            if (widget.media.length > 1)
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                    Colors.black.withOpacity(.55),
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${_currentIndex + 1}/${widget.media.length}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),
              ),

            if (widget.media.length > 1)
              Positioned(
                bottom: 14,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: List.generate(
                    widget.media.length,
                        (index) {
                      final active =
                          index == _currentIndex;

                      return AnimatedContainer(
                        duration:
                        const Duration(
                          milliseconds: 220,
                        ),
                        curve:
                        Curves.easeOut,
                        margin:
                        const EdgeInsets.symmetric(
                          horizontal: 3,
                        ),
                        width:
                        active ? 20 : 6,
                        height: 6,
                        decoration:
                        BoxDecoration(
                          color: active
                              ? const Color(
                            0xffA855F7,
                          )
                              : Colors.white38,
                          borderRadius:
                          BorderRadius.circular(
                            20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedia(MomentMedia item) {
    final source = item.url;

    if (source.isEmpty) {
      return _mediaError();
    }

    final isRemote =
        source.startsWith('http://') ||
            source.startsWith('https://');

    final isBlob =
    source.startsWith('blob:');

    // --------------------------------------------------
    // WEB
    // --------------------------------------------------
    //
    // Image.file() is not supported on Flutter Web.
    //
    if (kIsWeb) {
      if (isRemote || isBlob) {
        return Image.network(
          source,
          fit: BoxFit.cover,
          loadingBuilder: (
              context,
              child,
              progress,
              ) {
            if (progress == null) {
              return child;
            }

            return _mediaLoading();
          },
          errorBuilder: (_, __, ___) {
            return _mediaError();
          },
        );
      }

      return _mediaError();
    }

    // --------------------------------------------------
    // ANDROID / IOS
    // --------------------------------------------------

    if (isRemote) {
      return Image.network(
        source,
        fit: BoxFit.cover,
        loadingBuilder: (
            context,
            child,
            progress,
            ) {
          if (progress == null) {
            return child;
          }

          return _mediaLoading();
        },
        errorBuilder: (_, __, ___) {
          return _mediaError();
        },
      );
    }

    return Image.file(
      File(source),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return _mediaError();
      },
    );
  }

  Widget _mediaLoading() {
    return Container(
      color: const Color(0xff151522),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xffA855F7),
        ),
      ),
    );
  }

  Widget _mediaError() {
    return Container(
      color: const Color(0xff151522),
      child: const Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 42,
          color: Colors.white38,
        ),
      ),
    );
  }
}