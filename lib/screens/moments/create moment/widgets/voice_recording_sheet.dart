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
  final String? existingDuration;

  const VoiceRecordingSheet({
    super.key,
    this.existingDuration,
  });

  @override
  State<VoiceRecordingSheet> createState() =>
      _VoiceRecordingSheetState();
}

class _VoiceRecordingSheetState
    extends State<VoiceRecordingSheet> {
  final MomentVoiceRecorderService _recorder =
  MomentVoiceRecorderService();

  Timer? _timer;

  Duration _duration = Duration.zero;

  String? _recordingPath;

  bool _recording = false;

  bool _paused = false;

  bool _saving = false;

  DateTime? _startedAt;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cleanupRecorder();
    super.dispose();
  }

  Future<void> _cleanupRecorder() async {
    try {
      final recording =
      await _recorder.isRecording;

      if (recording) {
        await _recorder.cancel();
      }
    } catch (_) {}

    await _recorder.dispose();
  }

  Future<void> _startRecording() async {
    if (_recording || _saving) {
      return;
    }

    try {
      final permission =
      await _recorder.hasPermission();

      if (!permission) {
        if (mounted) {
          _showMessage(
            'Microphone permission is required.',
          );
        }
        return;
      }

      final path =
      await _recorder.start();

      if (!mounted) {
        await _recorder.cancel();
        return;
      }

      setState(() {
        _recordingPath = path;
        _recording = true;
        _paused = false;
        _duration = Duration.zero;
        _startedAt = DateTime.now();
      });

      _startTimer();
    } catch (error) {
      if (mounted) {
        _showMessage(
          error.toString(),
        );
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(milliseconds: 100),
          (_) {
        if (!mounted ||
            !_recording ||
            _paused ||
            _startedAt == null) {
          return;
        }

        setState(() {
          _duration =
              DateTime.now()
                  .difference(_startedAt!);
        });
      },
    );
  }

  Future<void> _pauseRecording() async {
    if (!_recording || _paused) {
      return;
    }

    try {
      await _recorder.pause();

      if (!mounted) {
        return;
      }

      _timer?.cancel();

      setState(() {
        _paused = true;
      });
    } catch (error) {
      if (mounted) {
        _showMessage(
          error.toString(),
        );
      }
    }
  }

  Future<void> _resumeRecording() async {
    if (!_recording || !_paused) {
      return;
    }

    try {
      await _recorder.resume();

      if (!mounted) {
        return;
      }

      setState(() {
        _paused = false;
        _startedAt =
            DateTime.now()
                .subtract(_duration);
      });

      _startTimer();
    } catch (error) {
      if (mounted) {
        _showMessage(
          error.toString(),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!_recording || _saving) {
      return;
    }

    setState(() {
      _saving = true;
    });

    _timer?.cancel();

    try {
      final path =
      await _recorder.stop();

      if (path == null ||
          path.isEmpty) {
        throw const VoiceRecorderException(
          'No voice recording was created.',
        );
      }

      final duration = _duration;

      if (duration.inMilliseconds < 300) {
        await _recorder.deleteFile(path);

        throw const VoiceRecorderException(
          'Voice note is too short.',
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _recordingPath = path;
        _recording = false;
        _paused = false;
      });

      Navigator.of(context).pop(
        VoiceRecordingResult(
          path: path,
          duration: duration,
        ),
      );
    } catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _recording = false;
          _paused = false;
        });

        _showMessage(
          error.toString(),
        );
      }
    }
  }

  Future<void> _cancelRecording() async {
    _timer?.cancel();

    try {
      await _recorder.cancel();
    } catch (_) {}

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  Future<void> _close() async {
    if (_recording || _paused) {
      await _cancelRecording();
      return;
    }

    Navigator.of(context).pop();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  String _formatDuration(
      Duration value,
      ) {
    final minutes =
    value.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    final seconds =
    value.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
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
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius:
                BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Voice note',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                IconButton(
                  onPressed:
                  _saving ? null : _close,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xff777787),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              _recording
                  ? _paused
                  ? 'Recording paused'
                  : 'Recording…'
                  : 'Tap the microphone to record',
              style: const TextStyle(
                color: Color(0xff858593),
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 26),

            Text(
              _formatDuration(_duration),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 26),

            GestureDetector(
              onTap: _recording
                  ? (_paused
                  ? _resumeRecording
                  : _pauseRecording)
                  : _startRecording,
              child: AnimatedContainer(
                duration:
                const Duration(
                  milliseconds: 180,
                ),
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _recording
                      ? const Color(0xffA855F7)
                      : const Color(0xff8B5CF6),
                  boxShadow: [
                    BoxShadow(
                      color:
                      const Color(0xff8B5CF6)
                          .withValues(
                        alpha: .22,
                      ),
                      blurRadius: 28,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  _recording
                      ? (_paused
                      ? Icons.play_arrow_rounded
                      : Icons.pause_rounded)
                      : Icons.mic_none_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
            ),

            const SizedBox(height: 22),

            if (_recording)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed:
                  _saving
                      ? null
                      : _stopRecording,
                  icon: const Icon(
                    Icons.stop_rounded,
                  ),
                  label: const Text(
                    'Finish recording',
                  ),
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xff191923),
                    foregroundColor:
                    Colors.white,
                    elevation: 0,
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed:
                  _saving
                      ? null
                      : _close,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color:
                      Color(0xff858593),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

            if (_recording &&
                !_paused) ...[
              const SizedBox(height: 10),
              const Text(
                'Tap the microphone to pause',
                style: TextStyle(
                  color: Color(0xff626270),
                  fontSize: 12,
                ),
              ),
            ],

            if (_saving) ...[
              const SizedBox(height: 14),
              const SizedBox(
                width: 20,
                height: 20,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xffA855F7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}