import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moment_header.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moment_media.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/reaction_bar.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/reaction_summary.dart';

class MomentCard extends StatefulWidget {
  final Moment moment;
  final VoidCallback onDelete;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSave;

  const MomentCard({
    super.key,
    required this.moment,
    required this.onDelete,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onSave,
  });

  @override
  State<MomentCard> createState() =>
      _MomentCardState();
}

class _MomentCardState
    extends State<MomentCard> {
  bool _showHeart = false;

  void _doubleTapLike() {
    setState(() {
      _showHeart = true;
    });

    widget.onLike?.call();

    Future.delayed(
      const Duration(milliseconds: 700),
          () {
        if (!mounted) {
          return;
        }

        setState(() {
          _showHeart = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final moment = widget.moment;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        10,
        5,
        10,
        6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff0D0D14),
        borderRadius:
        BorderRadius.circular(22),
        border: Border.all(
          color:
          Colors.white.withValues(alpha: .05),
        ),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withValues(alpha: .35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          MomentHeader(
            moment: moment,
            onDelete: widget.onDelete,
          ),

          if (moment.caption.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                14,
                3,
                14,
                9,
              ),
              child: Text(
                moment.caption,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.5,
                  height: 1.45,
                  fontWeight:
                  FontWeight.w400,
                ),
              ),
            ),

          if (moment.media.isNotEmpty)
            GestureDetector(
              onDoubleTap: _doubleTapLike,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.circular(22),
                      child: MomentMediaWidget(
                        media:
                        moment.media.toList(),
                      ),
                    ),
                  ),

                  AnimatedScale(
                    scale:
                    _showHeart ? 1 : 0,
                    duration:
                    const Duration(
                      milliseconds: 180,
                    ),
                    curve:
                    Curves.easeOutBack,
                    child: const Icon(
                      Icons.favorite,
                      size: 90,
                      color:
                      Color(0xffFF3B7A),
                    ),
                  ),
                ],
              ),
            ),

          if (moment.voice != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                14,
                3,
                14,
                3,
              ),
              child: _MomentVoicePlayer(
                voice: moment.voice!,
              ),
            ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              14,
              8,
              14,
              2,
            ),
            child: ReactionBar(
              moment: moment,
              onLike: widget.onLike,
              onComment: widget.onComment,
              onShare: widget.onShare,
              onSave: widget.onSave,
            ),
          ),

          ReactionSummary(
            reactions:
            moment.reactions.toList(),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              14,
              8,
              14,
              12,
            ),
            child: GestureDetector(
              onTap: widget.onComment,
              child: const Text(
                'View comments',
                style: TextStyle(
                  color:
                  Color(0xffA78BFA),
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ============================================================
// MOMENT VOICE PLAYER
// ============================================================

class _MomentVoicePlayer
    extends StatefulWidget {
  final VoiceAttachment voice;

  const _MomentVoicePlayer({
    required this.voice,
  });

  @override
  State<_MomentVoicePlayer> createState() =>
      _MomentVoicePlayerState();
}


class _MomentVoicePlayerState
    extends State<_MomentVoicePlayer> {

  late final AudioPlayer _player;

  final AudioContext _audioContext =  AudioContext(
    android: AudioContextAndroid(
      isSpeakerphoneOn: true,
      stayAwake: true,
      audioMode: AndroidAudioMode.normal,
      contentType: AndroidContentType.music,
      usageType: AndroidUsageType.media,
      audioFocus: AndroidAudioFocus.gain,
    ),
  );

  StreamSubscription<PlayerState>? _stateSubscription;

  bool _isPlaying = false;

  Duration _position =
      Duration.zero;

  Duration _duration =
      Duration.zero;


  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();

    AudioLogger.logLevel =
        AudioLogLevel.info;

    _duration = Duration(
      seconds: widget.voice.duration,
    );

    _stateSubscription =
        _player.onPlayerStateChanged.listen(
              (state) {
            if (!mounted) {
              return;
            }

            setState(() {
              _isPlaying =
                  state == PlayerState.playing;
            });
          },
        );

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

    _player.onDurationChanged.listen(
          (duration) {
        if (!mounted) {
          return;
        }

        if (duration > Duration.zero) {
          setState(() {
            _duration = duration;
          });
        }
      },
    );

    _player.onPlayerComplete.listen(
          (_) {
        if (!mounted) {
          return;
        }

        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      },
    );
  }


  @override
  void dispose() {
    _stateSubscription?.cancel();
    _player.dispose();

    super.dispose();
  }


  Future<void> _togglePlayback() async {
    final path = widget.voice.url.trim();

    if (path.isEmpty) {
      _showError(
        'Voice recording is unavailable.',
      );
      return;
    }

    try {
      debugPrint(
        'VOICE PLAYBACK PATH: $path',
      );

      if (_isPlaying) {
        await _player.pause();
        return;
      }

      // Make sure Android uses the normal
      // media speaker/audio output.
      await _player.setAudioContext(
        AudioContext(
          android: AudioContextAndroid(
            isSpeakerphoneOn: true,
            audioMode: AndroidAudioMode.normal,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.gain,
          ),
        ),
      );

      if (path.startsWith('http://') ||
          path.startsWith('https://')) {
        debugPrint(
          'VOICE PLAYBACK: remote source',
        );

        await _player.play(
          UrlSource(path),
        );
      } else {
        final file = File(path);

        final exists = await file.exists();

        debugPrint(
          'VOICE FILE EXISTS: $exists',
        );

        if (!exists) {
          _showError(
            'Voice recording file was not found.',
          );
          return;
        }

        final length =
        await file.length();

        debugPrint(
          'VOICE FILE SIZE: $length bytes',
        );

        if (length == 0) {
          _showError(
            'Voice recording file is empty.',
          );
          return;
        }

        debugPrint(
          'VOICE PLAYBACK: local file',
        );

        await _player.play(
          DeviceFileSource(path),
        );
      }
    } catch (error, stackTrace) {
      debugPrint(
        'VOICE PLAYBACK ERROR: $error',
      );

      debugPrint(
        'VOICE PLAYBACK STACK: $stackTrace',
      );

      if (!mounted) {
        return;
      }

      _showError(
        'Unable to play voice recording.',
      );
    }
  }


  void _showError(String message) {
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
          duration:
          const Duration(seconds: 2),
        ),
      );
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


  @override
  Widget build(BuildContext context) {
    final maxSeconds =
    _duration.inMilliseconds > 0
        ? _duration.inMilliseconds
        .toDouble()
        : 1.0;

    final currentSeconds =
    _position.inMilliseconds
        .clamp(
      0,
      _duration.inMilliseconds,
    )
        .toDouble();

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff151520),
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color:
          Colors.white.withValues(
            alpha: .06,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _togglePlayback,
            child: Container(
              width: 44,
              height: 44,
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
                size: 24,
              ),
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
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 7),

                SliderTheme(
                  data:
                  SliderTheme.of(context)
                      .copyWith(
                    trackHeight: 3,
                    thumbShape:
                    const RoundSliderThumbShape(
                      enabledThumbRadius: 5,
                    ),
                    overlayShape:
                    const RoundSliderOverlayShape(
                      overlayRadius: 12,
                    ),
                    activeTrackColor:
                    const Color(
                      0xffA855F7,
                    ),
                    inactiveTrackColor:
                    const Color(
                      0xff383844,
                    ),
                    thumbColor:
                    const Color(
                      0xffA855F7,
                    ),
                  ),
                  child: Slider(
                    min: 0,
                    max: maxSeconds,
                    value:
                    currentSeconds
                        .clamp(
                      0.0,
                      maxSeconds,
                    ),
                    onChanged:
                    _duration <=
                        Duration.zero
                        ? null
                        : (value) async {
                      final position =
                      Duration(
                        milliseconds:
                        value
                            .round(),
                      );

                      await _player
                          .seek(
                        position,
                      );
                    },
                  ),
                ),

                Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  child: Text(
                    '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
                    style:
                    const TextStyle(
                      color:
                      Color(0xff777787),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}