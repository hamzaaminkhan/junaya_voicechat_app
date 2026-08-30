import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/screens/moments/services/moment_voice_recorder_service.dart';

class VoiceNoteResult {
  final String path;
  final Duration duration;

  const VoiceNoteResult({
    required this.path,
    required this.duration,
  });
}

class VoiceNoteSheet extends StatefulWidget {
  final String? existingPath;
  final Duration? existingDuration;

  const VoiceNoteSheet({
    super.key,
    this.existingPath,
    this.existingDuration,
  });

  @override
  State<VoiceNoteSheet> createState() =>
      _VoiceNoteSheetState();
}

class _VoiceNoteSheetState
    extends State<VoiceNoteSheet> {
  late final MomentVoiceRecorderService _recorder;
  late final AudioPlayer _player;

  Timer? _timer;

  String? _recordedPath;

  Duration _recordedDuration =
      Duration.zero;

  Duration _elapsed =
      Duration.zero;

  bool _isRecording = false;
  bool _isPaused = false;
  bool _isPlaying = false;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();

    _recorder =
        MomentVoiceRecorderService();

    _player =
        AudioPlayer();

    _recordedPath =
        widget.existingPath;

    _recordedDuration =
        widget.existingDuration ??
            Duration.zero;

    _player.onPlayerComplete.listen(
          (_) {
        if (!mounted) {
          return;
        }

        setState(() {
          _isPlaying = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();

    _player.dispose();
    _recorder.dispose();

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
            _buildHandle(),

            const SizedBox(height: 18),

            _buildHeader(),

            const SizedBox(height: 24),

            if (_recordedPath != null &&
                !_isRecording)
              _buildPreview()
            else
              _buildRecorder(),

            const SizedBox(height: 22),

            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
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

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Voice note',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        IconButton(
          onPressed:
          _isBusy ? null : _close,
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

  Widget _buildRecorder() {
    return Column(
      children: [
        Container(
          width: 118,
          height: 118,
          decoration: BoxDecoration(
            color: _isRecording
                ? const Color(0xffEC4899)
                .withOpacity(.10)
                : const Color(0xffA855F7)
                .withOpacity(.10),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: AnimatedContainer(
              duration:
              const Duration(
                milliseconds: 180,
              ),
              width:
              _isRecording ? 82 : 72,
              height:
              _isRecording ? 82 : 72,
              decoration: BoxDecoration(
                color: _isRecording
                    ? const Color(0xffEC4899)
                    : const Color(0xff8B5CF6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isRecording
                    ? Icons.graphic_eq_rounded
                    : Icons.mic_rounded,
                color: Colors.white,
                size: 31,
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        Text(
          _formatDuration(
            _isRecording
                ? _elapsed
                : Duration.zero,
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            fontFeatures: [
              FontFeature.tabularFigures(),
            ],
          ),
        ),

        const SizedBox(height: 6),

        Text(
          _isRecording
              ? (_isPaused
              ? 'Recording paused'
              : 'Recording...')
              : 'Tap the microphone to record',
          style: const TextStyle(
            color: Color(0xff777787),
            fontSize: 12.5,
          ),
        ),

        const SizedBox(height: 22),

        if (_isRecording)
          _buildRecordingControls()
        else
          _buildStartButton(),
      ],
    );
  }

  Widget _buildStartButton() {
    return GestureDetector(
      onTap:
      _isBusy ? null : _startRecording,
      child: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          color: Color(0xff8B5CF6),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.mic_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildRecordingControls() {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: [
        _CircleButton(
          icon: _isPaused
              ? Icons.play_arrow_rounded
              : Icons.pause_rounded,
          onTap: _togglePause,
        ),

        const SizedBox(width: 22),

        GestureDetector(
          onTap:
          _isBusy ? null : _stopRecording,
          child: Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              color: Color(0xffEC4899),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.stop_rounded,
              color: Colors.white,
              size: 31,
            ),
          ),
        ),

        const SizedBox(width: 22),

        _CircleButton(
          icon:
          Icons.delete_outline_rounded,
          onTap:
          _isBusy
              ? () {}
              : _cancelRecording,
        ),
      ],
    );
  }

  Widget _buildPreview() {
    return Column(
      children: [
        Container(
          padding:
          const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xff191923),
            borderRadius:
            BorderRadius.circular(20),
            border: Border.all(
              color:
              Colors.white.withOpacity(.05),
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: _togglePlayback,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration:
                  const BoxDecoration(
                    color: Color(0xff8B5CF6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 27,
                  ),
                ),
              ),

              const SizedBox(width: 14),

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
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _formatDuration(
                        _recordedDuration,
                      ),
                      style: const TextStyle(
                        color:
                        Color(0xff777787),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed:
                _isBusy
                    ? null
                    : _deleteRecording,
                splashRadius: 20,
                icon: const Icon(
                  Icons
                      .delete_outline_rounded,
                  color: Color(0xffF87171),
                  size: 21,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        const Text(
          'Your voice note is ready.',
          style: TextStyle(
            color: Color(0xff777787),
            fontSize: 12.5,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    if (_isRecording) {
      return const SizedBox.shrink();
    }

    if (_recordedPath == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed:
        _isBusy ? null : _useRecording,
        style:
        ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor:
          const Color(0xff8B5CF6),
          foregroundColor: Colors.white,
          disabledBackgroundColor:
          const Color(0xff292433),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(15),
          ),
        ),
        child: _isBusy
            ? const SizedBox(
          width: 20,
          height: 20,
          child:
          CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Text(
          'Use voice note',
          style: TextStyle(
            fontSize: 14,
            fontWeight:
            FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Future<void> _startRecording() async {
    if (_isBusy || _isRecording) {
      return;
    }

    setState(() {
      _isBusy = true;
    });

    try {
      /*
       * If there is an old recording from
       * this sheet, remove it before creating
       * a replacement.
       */
      final oldPath = _recordedPath;

      if (oldPath != null &&
          oldPath != widget.existingPath) {
        await _recorder.deleteFile(
          oldPath,
        );
      }

      await _player.stop();

      final path =
      await _recorder.start();

      if (!mounted) {
        await _recorder.cancel();
        return;
      }

      setState(() {
        _recordedPath = path;
        _recordedDuration =
            Duration.zero;
        _elapsed =
            Duration.zero;
        _isRecording = true;
        _isPaused = false;
        _isPlaying = false;
        _isBusy = false;
      });

      _startTimer();
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isBusy = false;
      });

      _showMessage(
        error is VoiceRecorderException
            ? error.message
            : 'Unable to start recording.',
      );
    }
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (!mounted ||
            !_isRecording ||
            _isPaused) {
          return;
        }

        setState(() {
          _elapsed +=
          const Duration(seconds: 1);
        });
      },
    );
  }

  Future<void> _togglePause() async {
    if (!_isRecording || _isBusy) {
      return;
    }

    try {
      if (_isPaused) {
        await _recorder.resume();

        if (!mounted) {
          return;
        }

        setState(() {
          _isPaused = false;
        });
      } else {
        await _recorder.pause();

        if (!mounted) {
          return;
        }

        setState(() {
          _isPaused = true;
        });
      }
    } catch (_) {
      _showMessage(
        'Unable to change recording state.',
      );
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording || _isBusy) {
      return;
    }

    setState(() {
      _isBusy = true;
    });

    _timer?.cancel();

    try {
      final path =
      await _recorder.stop();

      if (path == null ||
          path.isEmpty) {
        throw const VoiceRecorderException(
          'No recording was created.',
        );
      }

      if (_elapsed < const Duration(
        seconds: 1,
      )) {
        await _recorder.deleteFile(
          path,
        );

        throw const VoiceRecorderException(
          'Voice note is too short.',
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _recordedPath = path;
        _recordedDuration =
            _elapsed;
        _isRecording = false;
        _isPaused = false;
        _isBusy = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isRecording = false;
        _isPaused = false;
        _isBusy = false;
      });

      _showMessage(
        error is VoiceRecorderException
            ? error.message
            : 'Unable to finish recording.',
      );
    }
  }

  Future<void> _cancelRecording() async {
    if (_isBusy) {
      return;
    }

    _timer?.cancel();

    try {
      await _recorder.cancel();
    } catch (_) {}

    if (!mounted) {
      return;
    }

    /*
     * Return to the previous preview if
     * there was an existing voice note.
     */
    if (widget.existingPath != null) {
      setState(() {
        _recordedPath =
            widget.existingPath;
        _recordedDuration =
            widget.existingDuration ??
                Duration.zero;
        _elapsed =
            Duration.zero;
        _isRecording = false;
        _isPaused = false;
        _isPlaying = false;
        _isBusy = false;
      });

      return;
    }

    setState(() {
      _recordedPath = null;
      _recordedDuration =
          Duration.zero;
      _elapsed =
          Duration.zero;
      _isRecording = false;
      _isPaused = false;
      _isPlaying = false;
      _isBusy = false;
    });
  }

  Future<void> _deleteRecording() async {
    if (_isBusy) {
      return;
    }

    final path = _recordedPath;

    await _player.stop();

    if (path != null &&
        path != widget.existingPath) {
      try {
        await _recorder.deleteFile(
          path,
        );
      } catch (_) {}
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _recordedPath = null;
      _recordedDuration =
          Duration.zero;
      _elapsed =
          Duration.zero;
      _isPlaying = false;
    });
  }

  Future<void> _togglePlayback() async {
    final path = _recordedPath;

    if (path == null ||
        path.isEmpty ||
        _isBusy) {
      return;
    }

    try {
      if (_isPlaying) {
        await _player.pause();

        if (!mounted) {
          return;
        }

        setState(() {
          _isPlaying = false;
        });

        return;
      }

      await _player.stop();

      await _player.play(
        DeviceFileSource(path),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isPlaying = true;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isPlaying = false;
      });

      _showMessage(
        'Unable to play the voice note.',
      );
    }
  }

  void _useRecording() {
    final path = _recordedPath;

    if (path == null ||
        path.isEmpty ||
        _recordedDuration <=
            Duration.zero) {
      _showMessage(
        'Record a voice note first.',
      );
      return;
    }

    Navigator.of(context).pop(
      VoiceNoteResult(
        path: path,
        duration:
        _recordedDuration,
      ),
    );
  }

  void _close() {
    Navigator.of(context).pop();
  }

  String _formatDuration(
      Duration duration,
      ) {
    final minutes =
    duration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    final seconds =
    duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
  }

  void _showMessage(
      String message,
      ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior:
          SnackBarBehavior.floating,
          margin:
          const EdgeInsets.all(16),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),
        ),
      );
  }
}

class _CircleButton
    extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color:
          const Color(0xff191923),
          shape: BoxShape.circle,
          border: Border.all(
            color:
            Colors.white.withOpacity(.06),
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}