import 'package:flutter/material.dart';

class VoiceNoteTile extends StatefulWidget {
  final ValueChanged<Duration>? onRecorded;
  final VoidCallback? onRemove;

  const VoiceNoteTile({
    super.key,
    this.onRecorded,
    this.onRemove,
  });

  @override
  State<VoiceNoteTile> createState() =>
      _VoiceNoteTileState();
}

class _VoiceNoteTileState extends State<VoiceNoteTile> {
  bool _recording = false;
  Duration _duration = Duration.zero;

  @override
  Widget build(BuildContext context) {
    final hasRecording =
        _duration.inSeconds > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xffA855F7)
                      .withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mic_none_rounded,
                  color: Color(0xffA855F7),
                  size: 19,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
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
                    const SizedBox(height: 3),
                    Text(
                      _recording
                          ? 'Recording...'
                          : hasRecording
                          ? 'Voice note recorded'
                          : 'Add your voice',
                      style: const TextStyle(
                        color: Color(0xff777787),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasRecording && !_recording)
                GestureDetector(
                  onTap: widget.onRemove,
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.close_rounded,
                      color: Color(0xff777787),
                      size: 19,
                    ),
                  ),
                ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: _toggleRecording,
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration:
                  const Duration(milliseconds: 180),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _recording
                        ? const Color(0xffFF3B7A)
                        : const Color(0xffA855F7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _recording
                        ? Icons.stop_rounded
                        : hasRecording
                        ? Icons.replay_rounded
                        : Icons.mic_rounded,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
              ),
            ],
          ),
          if (_recording || hasRecording) ...[
            const SizedBox(height: 13),
            Row(
              children: [
                SizedBox(
                  width: 38,
                  child: Text(
                    _formatDuration(),
                    style: const TextStyle(
                      color: Color(0xff9999A8),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _Waveform(
                    active: _recording,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _toggleRecording() {
    setState(() {
      _recording = !_recording;

      if (_recording) {
        _duration =
        const Duration(seconds: 1);
      }
    });

    if (!_recording && _duration.inSeconds > 0) {
      widget.onRecorded?.call(_duration);
    }

    // Connect the real audio recorder here.
  }

  String _formatDuration() {
    final minutes =
    _duration.inMinutes
        .toString()
        .padLeft(2, '0');

    final seconds =
    (_duration.inSeconds % 60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
  }
}

class _Waveform extends StatelessWidget {
  final bool active;

  const _Waveform({
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    const heights = [
      7.0,
      12.0,
      18.0,
      10.0,
      22.0,
      14.0,
      8.0,
      17.0,
      24.0,
      12.0,
      19.0,
      9.0,
      15.0,
      22.0,
      11.0,
      18.0,
      7.0,
      14.0,
      20.0,
      10.0,
      16.0,
      8.0,
    ];

    return SizedBox(
      height: 24,
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.center,
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: heights.map((height) {
          return AnimatedContainer(
            duration:
            const Duration(milliseconds: 180),
            width: 3,
            height: height,
            decoration: BoxDecoration(
              color: active
                  ? const Color(0xffA855F7)
                  : const Color(0xff6D5A8C),
              borderRadius:
              BorderRadius.circular(10),
            ),
          );
        }).toList(),
      ),
    );
  }
}