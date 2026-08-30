import 'package:flutter/material.dart';

class VoiceCommentPreview extends StatelessWidget {
  final String username;
  final String? avatar;
  final String duration;
  final VoidCallback? onPlay;

  const VoiceCommentPreview({
    super.key,
    required this.username,
    required this.duration,
    this.avatar,
    this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff151522),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: .05),
        ),
      ),
      child: Row(
        children: [
          _Avatar(
            avatar: avatar,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    Material(
                      color: const Color(0xff8B5CF6),
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: onPlay,
                        customBorder:
                        const CircleBorder(),
                        child: const SizedBox(
                          width: 30,
                          height: 30,
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _Waveform(),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      duration,
                      style: const TextStyle(
                        color: Color(0xff9999A8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? avatar;

  const _Avatar({
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    final hasAvatar =
        avatar != null && avatar!.isNotEmpty;

    return Container(
      width: 38,
      height: 38,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xff242435),
      ),
      child: ClipOval(
        child: hasAvatar
            ? Image.network(
          avatar!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return _fallback();
          },
        )
            : _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return const Icon(
      Icons.person,
      size: 19,
      color: Colors.white54,
    );
  }
}

class _Waveform extends StatelessWidget {
  const _Waveform();

  @override
  Widget build(BuildContext context) {
    const heights = [
      5.0,
      9.0,
      6.0,
      13.0,
      8.0,
      16.0,
      10.0,
      7.0,
      14.0,
      9.0,
      5.0,
      12.0,
      8.0,
      15.0,
      7.0,
      10.0,
      6.0,
      12.0,
      8.0,
      5.0,
    ];

    return SizedBox(
      height: 20,
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.center,
        children: List.generate(
          heights.length,
              (index) {
            final played = index < 7;

            return Expanded(
              child: Container(
                height: heights[index],
                margin:
                const EdgeInsets.symmetric(
                  horizontal: 1,
                ),
                decoration: BoxDecoration(
                  color: played
                      ? const Color(0xff8B5CF6)
                      : Colors.white24,
                  borderRadius:
                  BorderRadius.circular(4),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}