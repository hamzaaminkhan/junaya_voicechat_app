import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class FramedAvatar extends StatelessWidget {
  final String? avatarUrl;

  final String? frameAsset;

  final bool frameIsLottie;

  /// Actual diameter of the user's avatar.
  final double size;

  /// Controls how large the frame is relative to the avatar.
  final double frameScale;

  const FramedAvatar({
    super.key,
    required this.avatarUrl,
    this.frameAsset,
    this.frameIsLottie = false,
    this.size = 64,
    this.frameScale = 1.06,
  });

  @override
  Widget build(BuildContext context) {
    final double frameSize = size * frameScale;

    return SizedBox(
      width: frameSize,
      height: frameSize,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // --------------------------------------------------
          // AVATAR
          // --------------------------------------------------

          SizedBox(
            width: size,
            height: size,
            child: ClipOval(
              child: _buildAvatar(),
            ),
          ),

          // --------------------------------------------------
          // FRAME
          // --------------------------------------------------

          if (frameAsset != null)
            IgnorePointer(
              child: _buildFrame(frameSize),
            ),
        ],
      ),
    );
  }

  // ========================================================
  // AVATAR
  // ========================================================

  Widget _buildAvatar() {
    if (avatarUrl == null || avatarUrl!.isEmpty) {
      return Container(
        color: const Color(0xFF21152E),
        alignment: Alignment.center,
        child: Icon(
          Icons.person,
          color: Colors.white54,
          size: size * 0.45,
        ),
      );
    }

    if (avatarUrl!.startsWith('assets/')) {
      return Image.asset(
        avatarUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      avatarUrl!,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFF21152E),
          alignment: Alignment.center,
          child: Icon(
            Icons.person,
            color: Colors.white54,
            size: size * 0.45,
          ),
        );
      },
    );
  }

  // ========================================================
  // FRAME
  // ========================================================

  Widget _buildFrame(double frameSize) {
    final String path = frameAsset!.toLowerCase();

    if (frameIsLottie || path.endsWith('.json')) {
      return Lottie.asset(
        frameAsset!,
        width: frameSize,
        height: frameSize,
        fit: BoxFit.contain,
        repeat: true,
      );
    }

    if (path.endsWith('.svg')) {
      return SvgPicture.asset(
        frameAsset!,
        width: frameSize,
        height: frameSize,
        fit: BoxFit.contain,
      );
    }

    return Image.asset(
      frameAsset!,
      width: frameSize,
      height: frameSize,
      fit: BoxFit.contain,
    );
  }
}