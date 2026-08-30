import 'dart:async';

import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/screens/moments/services/moment_voice_recorder_service.dart';

class VoiceRecordingResult {
  final String path;
  final Duration duration;

  const VoiceRecordingResult({
    required this.path,
    required this.duration,
  });
}

class VoiceRecordingSheet extends StatefulWidget {
  final String? existingPath;
  final Duration? existingDuration;

  const VoiceRecordingSheet({
    super.key,
    this.existingPath,
    this.existingDuration,
  });

  @override
  State<VoiceRecordingSheet> createState() =>
      _VoiceRecordingSheetState();
}

class _VoiceRecordingSheetState
    extends State<VoiceRecordingSheet> {
  final MomentVoiceRecorderService
  _recorder = MomentVoiceRecorderService();

  Timer? _timer;

  Duration _duration = Duration.zero;

  String? _recordedPath;

  bool _recording = false;

  bool _busy = false;

  String? _error;

  @override
  void initState() {
    super.initState();

    _recordedPath = widget.existingPath;

    _duration =
        widget.existingDuration ??
            Duration.zero;
  }

  @override
  void dispose() {
    _timer?.cancel();

    _cleanupRecorder();

    super.dispose();
  }

  Future<void> _cleanupRecorder() async {
    try {
      if (await _recorder.isRecording) {
        await _recorder.cancel();
      }

      await _recorder.dispose();
    } catch (_) {}
  }

  Future<void> _toggleRecording() async {
    if (_busy) {
      return;
    }

    if (_recording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final permission =
      await _recorder.hasPermission();

      if (!permission) {
        throw const VoiceRecorderException(
          'Microphone permission is required.',
        );
      }

      if (_recordedPath != null) {
        await _recorder.deleteFile(
          _recordedPath!,
        );

        _recordedPath = null;
      }

      _duration = Duration.zero;

      final path =
      await _recorder.start();

      _timer?.cancel();

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

      if (!mounted) {
        return;
      }

      setState(() {
        _recordedPath = path;
        _recording = true;
        _busy = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _busy = false;
        _error = error.toString();
      });
    }
  }

  Future<void> _stopRecording() async {
    setState(() {
      _busy = true;
    });

    try {
      _timer?.cancel();
      _timer = null;

      final path =
      await _recorder.stop();

      if (!mounted) {
        return;
      }

      setState(() {
        _recordedPath = path;
        _recording = false;
        _busy = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _recording = false;
        _busy = false;
        _error = error.toString();
      });
    }
  }

  Future<void> _deleteRecording() async {
    if (_recording || _busy) {
      return;
    }

    final path = _recordedPath;

    if (path != null) {
      await _recorder.deleteFile(path);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _recordedPath = null;
      _duration = Duration.zero;
      _error = null;
    });
  }

  void _useRecording() {
    final path = _recordedPath;

    if (path == null ||
        path.isEmpty ||
        _duration == Duration.zero ||
        _recording ||
        _busy) {
      return;
    }

    Navigator.of(context).pop(
      VoiceRecordingResult(
        path: path,
        duration: _duration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasRecording =
        _recordedPath != null &&
            _duration > Duration.zero;

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

            _recorderButton(),

            const SizedBox(height: 22),

            _waveform(),

            const SizedBox(height: 10),

            Text(
              _formatDuration(_duration),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xffF87171),
                  fontSize: 12,
                ),
              ),
            ],

            const SizedBox(height: 22),

            _controls(),

            if (hasRecording) ...[
              const SizedBox(height: 14),
              _useButton(),
            ],
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
        borderRadius:
        BorderRadius.circular(20),
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
              SizedBox(height: 4),
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
          onPressed: _recording || _busy
              ? null
              : () {
            Navigator.of(context).pop();
          },
          splashRadius: 20,
          icon: const Icon(
            Icons.close_rounded,
            color: Color(0xff777787),
            size: 21,
          ),
        ),
      ],
    );
  }

  Widget _recorderButton() {
    final active = _recording;

    return AnimatedContainer(
      duration:
      const Duration(milliseconds: 220),
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active
            ? const Color(0xffFF3B7A)
            .withOpacity(.12)
            : const Color(0xffA855F7)
            .withOpacity(.10),
        border: Border.all(
          color: active
              ? const Color(0xffFF3B7A)
              : const Color(0xffA855F7),
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration:
          const Duration(milliseconds: 220),
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? const Color(0xffFF3B7A)
                : const Color(0xffA855F7),
          ),
          child: _busy
              ? const Padding(
            padding: EdgeInsets.all(22),
            child:
            CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : Icon(
            active
                ? Icons.stop_rounded
                : Icons.mic_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget _waveform() {
    const heights = [
      8.0,
      13.0,
      20.0,
      11.0,
      17.0,
      25.0,
      14.0,
      20.0,
      30.0,
      18.0,
      12.0,
      24.0,
      16.0,
      28.0,
      20.0,
      11.0,
      23.0,
      16.0,
      27.0,
      14.0,
      9.0,
      18.0,
      24.0,
      13.0,
    ];

    return SizedBox(
      height: 32,
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          for (final height in heights)
            Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 2,
              ),
              child: AnimatedContainer(
                duration:
                const Duration(milliseconds: 180),
                width: 3,
                height: _duration ==
                    Duration.zero &&
                    !_recording
                    ? 4
                    : height,
                decoration: BoxDecoration(
                  color: _recording
                      ? const Color(0xffFF3B7A)
                      : const Color(0xffA855F7),
                  borderRadius:
                  BorderRadius.circular(10),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _controls() {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: [
        if (_duration > Duration.zero)
          IconButton(
            onPressed:
            _recording || _busy
                ? null
                : _deleteRecording,
            splashRadius: 24,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xff777787),
              size: 23,
            ),
          ),

        if (_duration > Duration.zero)
          const SizedBox(width: 18),

        GestureDetector(
          onTap:
          _busy ? null : _toggleRecording,
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _recording
                  ? const Color(0xffFF3B7A)
                  : const Color(0xffA855F7),
            ),
            child: Icon(
              _recording
                  ? Icons.stop_rounded
                  : Icons.mic_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }

  Widget _useButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed:
        _recording || _busy
            ? null
            : _useRecording,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor:
          const Color(0xff8B5CF6),
          disabledBackgroundColor:
          const Color(0xff302A38),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'Use voice note',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
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