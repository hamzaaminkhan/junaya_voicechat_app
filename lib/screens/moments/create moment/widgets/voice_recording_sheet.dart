import 'dart:async';

import 'package:flutter/material.dart';

enum VoiceRecordingState {
  idle,
  recording,
  recorded,
  playing,
}

class VoiceRecordingSheet extends StatefulWidget {
  final String? existingPath;
  final ValueChanged<String?>? onCompleted;

  const VoiceRecordingSheet({
    super.key,
    this.existingPath,
    this.onCompleted,
  });

  @override
  State<VoiceRecordingSheet> createState() =>
      _VoiceRecordingSheetState();
}

class _VoiceRecordingSheetState
    extends State<VoiceRecordingSheet> {
  VoiceRecordingState _state =
      VoiceRecordingState.idle;

  Duration _duration = Duration.zero;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    if (widget.existingPath != null &&
        widget.existingPath!.isNotEmpty) {
      _state = VoiceRecordingState.recorded;
      _duration =
      const Duration(seconds: 12);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        28,
      ),
      decoration: const BoxDecoration(
        color: Color(0xff11111A),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _handle(),

            const SizedBox(height: 20),

            _header(),

            const SizedBox(height: 24),

            _waveform(),

            const SizedBox(height: 14),

            Text(
              _formatDuration(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),

            _controls(),

            if (_state == VoiceRecordingState.recorded ||
                _state == VoiceRecordingState.playing)
              Padding(
                padding: const EdgeInsets.only(
                  top: 18,
                ),
                child: _deleteButton(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    String title;

    String subtitle;

    switch (_state) {
      case VoiceRecordingState.recording:
        title = 'Recording voice note';
        subtitle = 'Tap stop when you’re done';
        break;

      case VoiceRecordingState.recorded:
        title = 'Voice note ready';
        subtitle = 'Preview your recording';
        break;

      case VoiceRecordingState.playing:
        title = 'Playing voice note';
        subtitle = 'Tap pause to stop playback';
        break;

      case VoiceRecordingState.idle:
        title = 'Add voice note';
        subtitle =
        'Record a short voice message';
        break;
    }

    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xff777787),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _waveform() {
    final active =
        _state == VoiceRecordingState.recording ||
            _state == VoiceRecordingState.playing;

    return SizedBox(
      height: 70,
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.center,
        crossAxisAlignment:
        CrossAxisAlignment.center,
        children: List.generate(
          42,
              (index) {
            final height =
                10.0 +
                    ((index * 17) % 42);

            return AnimatedContainer(
              duration:
              const Duration(milliseconds: 180),
              margin:
              const EdgeInsets.symmetric(
                horizontal: 2,
              ),
              width: 3,
              height: height,
              decoration: BoxDecoration(
                color: active
                    ? const Color(0xffA855F7)
                    : Colors.white24,
                borderRadius:
                BorderRadius.circular(10),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _controls() {
    switch (_state) {
      case VoiceRecordingState.idle:
        return _mainButton(
          icon: Icons.mic_rounded,
          label: 'Start recording',
          onTap: _startRecording,
        );

      case VoiceRecordingState.recording:
        return _mainButton(
          icon: Icons.stop_rounded,
          label: 'Stop recording',
          danger: true,
          onTap: _stopRecording,
        );

      case VoiceRecordingState.recorded:
        return Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            _roundButton(
              icon: Icons.delete_outline_rounded,
              onTap: _deleteRecording,
              secondary: true,
            ),
            const SizedBox(width: 18),
            _roundButton(
              icon: Icons.play_arrow_rounded,
              onTap: _playRecording,
            ),
            const SizedBox(width: 18),
            _roundButton(
              icon: Icons.check_rounded,
              onTap: _useRecording,
            ),
          ],
        );

      case VoiceRecordingState.playing:
        return _mainButton(
          icon: Icons.pause_rounded,
          label: 'Pause',
          onTap: _pausePlayback,
        );
    }
  }

  Widget _mainButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool danger = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding:
        const EdgeInsets.symmetric(
          horizontal: 22,
        ),
        decoration: BoxDecoration(
          color: danger
              ? const Color(0xffFF3B7A)
              : const Color(0xffA855F7),
          borderRadius:
          BorderRadius.circular(17),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 21,
            ),
            const SizedBox(width: 9),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundButton({
    required IconData icon,
    required VoidCallback onTap,
    bool secondary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: secondary
              ? const Color(0xff20202A)
              : const Color(0xffA855F7),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: secondary
              ? const Color(0xff9999A8)
              : Colors.white,
          size: 22,
        ),
      ),
    );
  }

  Widget _deleteButton() {
    return GestureDetector(
      onTap: _deleteRecording,
      child: const Text(
        'Delete recording',
        style: TextStyle(
          color: Color(0xffFF4D6D),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _handle() {
    return Container(
      width: 38,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius:
        BorderRadius.circular(20),
      ),
    );
  }

  void _startRecording() {
    _timer?.cancel();

    setState(() {
      _state =
          VoiceRecordingState.recording;
      _duration = Duration.zero;
    });

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (!mounted) return;

        setState(() {
          _duration +=
          const Duration(seconds: 1);
        });
      },
    );
  }

  void _stopRecording() {
    _timer?.cancel();

    setState(() {
      _state =
          VoiceRecordingState.recorded;
    });
  }

  void _playRecording() {
    setState(() {
      _state =
          VoiceRecordingState.playing;
    });

    // Real audio playback will be connected later.
  }

  void _pausePlayback() {
    setState(() {
      _state =
          VoiceRecordingState.recorded;
    });
  }

  void _deleteRecording() {
    _timer?.cancel();

    setState(() {
      _state =
          VoiceRecordingState.idle;
      _duration = Duration.zero;
    });

    widget.onCompleted?.call(null);
  }

  void _useRecording() {
    widget.onCompleted?.call(
      widget.existingPath ?? 'voice_note',
    );

    Navigator.of(context).pop();
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