import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class VoiceNotePlayer extends StatefulWidget {
  final String path;
  final Duration duration;

  const VoiceNotePlayer({
    super.key,
    required this.path,
    required this.duration,
  });

  @override
  State<VoiceNotePlayer> createState() =>
      _VoiceNotePlayerState();
}

class _VoiceNotePlayerState
    extends State<VoiceNotePlayer> {
  late final AudioPlayer _player;

  StreamSubscription<PlayerState>? _stateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<void>? _completeSubscription;

  PlayerState _playerState =
      PlayerState.stopped;

  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();

    _setupPlayer();
  }

  Future<void> _setupPlayer() async {
    await _player.setVolume(1.0);

    await _player.setAudioContext(
      AudioContext(
        android: AudioContextAndroid(
          isSpeakerphoneOn: true,
          audioMode: AndroidAudioMode.normal,
          stayAwake: false,
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.media,
          audioFocus: AndroidAudioFocus.gain,
        ),
      ),
    );

    await _player.setReleaseMode(
      ReleaseMode.stop,
    );

    _stateSubscription =
        _player.onPlayerStateChanged.listen(
              (state) {
            if (!mounted) {
              return;
            }

            setState(() {
              _playerState = state;
            });
          },
        );

    _positionSubscription =
        _player.onPositionChanged.listen(
              (position) {
            if (!mounted) {
              return;
            }

            setState(() {
              _position = position;
            });
          },
        );

    _completeSubscription =
        _player.onPlayerComplete.listen(
              (_) {
            if (!mounted) {
              return;
            }

            setState(() {
              _playerState =
                  PlayerState.stopped;

              _position =
                  widget.duration;
            });
          },
        );
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _positionSubscription?.cancel();
    _completeSubscription?.cancel();

    _player.dispose();

    super.dispose();
  }

  Future<void> _togglePlayback() async {
    final path = widget.path.trim();

    if (path.isEmpty) {
      return;
    }

    if (_playerState == PlayerState.playing) {
      await _player.pause();
      return;
    }

    if (_playerState == PlayerState.paused) {
      await _player.resume();
      return;
    }

    try {
      // Always make sure volume is restored.
      await _player.setVolume(1.0);

      // Start from the beginning.
      await _player.seek(Duration.zero);

      await _player.play(
        DeviceFileSource(
          path,
          mimeType: 'audio/mp4',
        ),
        volume: 1.0,
      );

    } catch (error) {
      debugPrint(
        'VoiceNotePlayer playback error: $error',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _playerState =
            PlayerState.stopped;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to play this voice note.',
          ),
        ),
      );
    }
  }

  Future<void> _stop() async {
    await _player.stop();

    if (!mounted) {
      return;
    }

    setState(() {
      _playerState =
          PlayerState.stopped;

      _position =
          Duration.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalMs =
        widget.duration.inMilliseconds;

    final positionMs =
        _position.inMilliseconds;

    final progress = totalMs <= 0
        ? 0.0
        : (positionMs / totalMs)
        .clamp(0.0, 1.0);

    final playing =
        _playerState ==
            PlayerState.playing;

    return Container(
      padding:
      const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xff191923),
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color:
          Colors.white.withValues(alpha: .05),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _togglePlayback,
            behavior:
            HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration:
              const Duration(
                milliseconds: 180,
              ),
              width: 42,
              height: 42,
              decoration:
              BoxDecoration(
                color: playing
                    ? const Color(
                  0xffFF3B7A,
                )
                    : const Color(
                  0xffA855F7,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                playing
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      for (
                      int i = 0;
                      i < 26;
                      i++
                      )
                        Expanded(
                          child: Padding(
                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal: 1.5,
                            ),
                            child:
                            AnimatedContainer(
                              duration:
                              const Duration(
                                milliseconds: 160,
                              ),
                              height:
                              7 +
                                  ((i % 5) *
                                      4),
                              decoration:
                              BoxDecoration(
                                color:
                                i <
                                    (26 *
                                        progress)
                                        .floor()
                                    ? const Color(
                                  0xffA855F7,
                                )
                                    : Colors
                                    .white24,
                                borderRadius:
                                BorderRadius
                                    .circular(
                                  10,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
                  children: [
                    Text(
                      _formatDuration(
                        _position,
                      ),
                      style:
                      const TextStyle(
                        color:
                        Color(0xff777787),
                        fontSize: 10.5,
                      ),
                    ),
                    Text(
                      _formatDuration(
                        widget.duration,
                      ),
                      style:
                      const TextStyle(
                        color:
                        Color(0xff777787),
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          IconButton(
            onPressed: _stop,
            splashRadius: 20,
            icon: const Icon(
              Icons.stop_rounded,
              color: Color(0xff666675),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(
      Duration value,
      ) {
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