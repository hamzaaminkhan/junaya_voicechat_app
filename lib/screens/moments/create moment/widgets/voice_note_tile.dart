import 'package:flutter/material.dart';

class VoiceNoteTile extends StatelessWidget {
  final Duration? duration;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const VoiceNoteTile({
    super.key,
    this.duration,
    this.onTap,
    this.onRemove,
  });

  bool get hasVoiceNote =>
      duration != null;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: hasVoiceNote ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          child: Row(
            children: [
              _buildIcon(),

              const SizedBox(width: 12),

              Expanded(
                child: _buildContent(),
              ),

              const SizedBox(width: 10),

              _buildAction(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xffA855F7)
            .withOpacity(.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        hasVoiceNote
            ? Icons.graphic_eq_rounded
            : Icons.mic_none_rounded,
        color: const Color(0xffA855F7),
        size: 20,
      ),
    );
  }

  Widget _buildContent() {
    if (hasVoiceNote) {
      return Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'Voice note',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              const Icon(
                Icons.play_arrow_rounded,
                color: Color(0xffA855F7),
                size: 15,
              ),

              const SizedBox(width: 3),

              Text(
                _formatDuration(duration!),
                style: const TextStyle(
                  color: Color(0xff888896),
                  fontSize: 12,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _Waveform(),
              ),
            ],
          ),
        ],
      );
    }

    return const Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          'Voice note',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: 3),

        Text(
          'Add your voice to this moment',
          style: TextStyle(
            color: Color(0xff777787),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAction() {
    if (hasVoiceNote) {
      return IconButton(
        onPressed: onRemove,
        splashRadius: 20,
        icon: const Icon(
          Icons.delete_outline_rounded,
          color: Color(0xff777787),
          size: 20,
        ),
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xffA855F7),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.mic_rounded,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  String _formatDuration(Duration value) {
    final minutes = value.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    final seconds = value.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
  }
}

class _Waveform extends StatelessWidget {
  const _Waveform();

  @override
  Widget build(BuildContext context) {
    const heights = [
      5.0,
      9.0,
      14.0,
      8.0,
      18.0,
      11.0,
      15.0,
      7.0,
      13.0,
      17.0,
      9.0,
      14.0,
      6.0,
      12.0,
      16.0,
      8.0,
      13.0,
      18.0,
      10.0,
      6.0,
    ];

    return SizedBox(
      height: 20,
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceEvenly,
        children: [
          for (final height in heights)
            Container(
              width: 2.5,
              height: height,
              decoration: BoxDecoration(
                color: const Color(0xffA855F7),
                borderRadius:
                BorderRadius.circular(10),
              ),
            ),
        ],
      ),
    );
  }
}