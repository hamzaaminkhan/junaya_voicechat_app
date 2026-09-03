// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';

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
  final AudioPlayer _player = AudioPlayer();

  StreamSubscription<PlayerState>?
  _stateSubscription;

  StreamSubscription<Duration>?
  _positionSubscription;

  StreamSubscription<void>?
  _completeSubscription;

  PlayerState _playerState =
      PlayerState.stopped;

  Duration _position =
      Duration.zero;

  @override
  void initState() {
    super.initState();

    _stateSubscription =
        _player.onPlayerStateChanged.listen(
              (state) {
            if (!mounted) {
              return;
            }

            debugPrint(
              'Voice player state: $state',
            );

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

            final total =
                widget.duration;

            final clamped =
            total > Duration.zero &&
                position > total
                ? total
                : position;

            setState(() {
              _position = clamped;
            });
          },
        );

    _completeSubscription =
        _player.onPlayerComplete.listen(
              (_) {
            if (!mounted) {
              return;
            }

            debugPrint(
              'Voice playback completed',
            );

            setState(() {
              _playerState =
                  PlayerState.completed;

              _position =
                  widget.duration;
            });
          },
        );

    _configurePlayer();
  }

  Future<void> _configurePlayer() async {
    try {
      await _player.setVolume(1.0);

      await _player.setReleaseMode(
        ReleaseMode.stop,
      );
    } catch (error) {
      debugPrint(
        'Voice player configuration error: $error',
      );
    }
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
    final source =
    widget.path.trim();

    if (source.isEmpty) {
      debugPrint(
        'Voice player: empty source',
      );
      return;
    }

    // --------------------------------------------------
    // PAUSE
    // --------------------------------------------------

    if (_playerState ==
        PlayerState.playing) {
      try {
        await _player.pause();
      } catch (error) {
        debugPrint(
          'Voice pause error: $error',
        );
      }

      return;
    }

    // --------------------------------------------------
    // RESUME
    // --------------------------------------------------

    if (_playerState ==
        PlayerState.paused) {
      try {
        await _player.resume();
      } catch (error) {
        debugPrint(
          'Voice resume error: $error',
        );
      }

      return;
    }

    // --------------------------------------------------
    // PLAY
    // --------------------------------------------------

    try {
      debugPrint(
        'Voice player source: $source',
      );

      await _player.stop();

      if (source.startsWith('http://') ||
          source.startsWith('https://')) {
        debugPrint(
          'Voice player: using network source',
        );

        await _player.play(
          UrlSource(source),
          volume: 1.0,
        );
      } else {
        final file =
        File(source);

        final exists =
        await file.exists();

        debugPrint(
          'Voice player local file exists: $exists',
        );

        if (!exists) {
          debugPrint(
            'Voice player: file not found: $source',
          );
          return;
        }

        final size =
        await file.length();

        debugPrint(
          'Voice player file size: $size bytes',
        );

        if (size <= 0) {
          debugPrint(
            'Voice player: file is empty',
          );
          return;
        }

        debugPrint(
          'Voice player: using local source',
        );

        await _player.play(
          DeviceFileSource(source),
          volume: 1.0,
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _position =
            Duration.zero;
      });
    } catch (error, stackTrace) {
      debugPrint(
        'Voice playback error: $error',
      );

      debugPrint(
        '$stackTrace',
      );

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
  }

  Future<void> _stop() async {
    try {
      await _player.stop();
    } catch (error) {
      debugPrint(
        'Voice stop error: $error',
      );
    }

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

    final progress =
    totalMs <= 0
        ? 0.0
        : (positionMs / totalMs)
        .clamp(0.0, 1.0);

    final playing =
        _playerState ==
            PlayerState.playing;

    return Container(
      padding:
      const EdgeInsets.all(14),
      decoration:
      BoxDecoration(
        color:
        const Color(0xff191923),
        borderRadius:
        BorderRadius.circular(18),
        border:
        Border.all(
          color:
          Colors.white.withOpacity(.05),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap:
            _togglePlayback,
            child: Container(
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
                shape:
                BoxShape.circle,
              ),
              child:
              Icon(
                playing
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color:
                Colors.white,
                size: 22,
              ),
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .center,
                    children: [
                      for (
                      int i = 0;
                      i < 26;
                      i++
                      )
                        Expanded(
                          child:
                          Padding(
                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal:
                              1.5,
                            ),
                            child:
                            AnimatedContainer(
                              duration:
                              const Duration(
                                milliseconds:
                                160,
                              ),
                              height:
                              7 +
                                  ((i %
                                      5) *
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

                const SizedBox(
                  height: 4,
                ),

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
                        fontSize:
                        10.5,
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
                        fontSize:
                        10.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 8,
          ),

          IconButton(
            onPressed:
            _stop,
            icon:
            const Icon(
              Icons.stop_rounded,
              color:
              Color(0xff666675),
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
}