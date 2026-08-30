import 'dart:async';

import 'package:flutter/material.dart';

class VoiceRecordingSheet extends StatefulWidget {
  final String? existingDuration;
  final ValueChanged<Duration>? onRecorded;
  final VoidCallback? onCancel;

  const VoiceRecordingSheet({
    super.key,
    this.existingDuration,
    this.onRecorded,
    this.onCancel,
  });

  @override
  State<VoiceRecordingSheet> createState() =>
      _VoiceRecordingSheetState();
}

class _VoiceRecordingSheetState
    extends State<VoiceRecordingSheet> {
  Timer? _timer;

  Duration _duration = Duration.zero;

  bool _recording = false;
  bool _recorded = false;

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
        24,
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

            const SizedBox(height: 18),

            _header(),

            const SizedBox(height: 24),

            _timerDisplay(),

            const SizedBox(height: 24),

            _waveform(),

            const SizedBox(height: 28),

            _recordButton(),

            const SizedBox(height: 18),

            _bottomActions(),
          ],
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
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Voice note',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Record a voice note for your moment.',
                style: TextStyle(
                  color: Color(0xff666675),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            widget.onCancel?.call();
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.close_rounded,
            color: Color(0xff777787),
            size: 21,
          ),
        ),
      ],
    );
  }

  Widget _timerDisplay() {
    return Column(
      children: [
        Text(
          _formatDuration(_duration),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _recording
              ? 'Recording...'
              : _recorded
              ? 'Voice note ready'
              : 'Tap the microphone to start',
          style: TextStyle(
            color: _recording
                ? const Color(0xffFF4D6D)
                : const Color(0xff777787),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _waveform() {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.center,
        crossAxisAlignment:
        CrossAxisAlignment.center,
        children: List.generate(
          32,
              (index) {
            final heights = [
              12.0,
              22.0,
              15.0,
              31.0,
              19.0,
              38.0,
              25.0,
              15.0,
            ];

            final height =
            heights[index % heights.length];

            return AnimatedContainer(
              duration:
              const Duration(milliseconds: 180),
              width: 3,
              height: _recording
                  ? height
                  : _recorded
                  ? height * .8
                  : 8,
              margin:
              const EdgeInsets.symmetric(
                horizontal: 2,
              ),
              decoration: BoxDecoration(
                color: _recording
                    ? const Color(0xffA855F7)
                    : _recorded
                    ? const Color(0xff8B5CF6)
                    : const Color(0xff3A3A48),
                borderRadius:
                BorderRadius.circular(10),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _recordButton() {
    return GestureDetector(
      onTap: _toggleRecording,
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 180),
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _recording
              ? const Color(0xffFF4D6D)
              : const Color(0xffA855F7),
          boxShadow: [
            BoxShadow(
              color: (_recording
                  ? const Color(0xffFF4D6D)
                  : const Color(0xffA855F7))
                  .withOpacity(.22),
              blurRadius: 24,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Icon(
          _recording
              ? Icons.stop_rounded
              : Icons.mic_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _bottomActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              _reset();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor:
              const Color(0xff9999A8),
              side: BorderSide(
                color:
                Colors.white.withOpacity(.08),
              ),
              minimumSize:
              const Size.fromHeight(46),
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Clear',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _recorded
                ? _save
                : null,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor:
              const Color(0xff8B5CF6),
              disabledBackgroundColor:
              const Color(0xff252530),
              foregroundColor: Colors.white,
              minimumSize:
              const Size.fromHeight(46),
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Use voice note',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _toggleRecording() {
    if (_recording) {
      _stopRecording();
      return;
    }

    setState(() {
      _recording = true;
      _recorded = false;
      _duration = Duration.zero;
    });

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (!mounted) {
          return;
        }

        setState(() {
          _duration +=
          const Duration(seconds: 1);
        });
      },
    );
  }

  void _stopRecording() {
    _timer?.cancel();
    _timer = null;

    setState(() {
      _recording = false;
      _recorded = _duration > Duration.zero;
    });
  }

  void _reset() {
    _timer?.cancel();
    _timer = null;

    setState(() {
      _recording = false;
      _recorded = false;
      _duration = Duration.zero;
    });
  }

  void _save() {
    widget.onRecorded?.call(_duration);
    Navigator.of(context).pop(_duration);
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    final seconds = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
  }
}