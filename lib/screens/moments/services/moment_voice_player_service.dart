import 'dart:io';

import 'package:audioplayers/audioplayers.dart';

class MomentVoicePlayerService {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  bool get isPlaying =>
      _player.state == PlayerState.playing;

  Future<void> play(String path) async {
    final source = path.trim();

    if (source.isEmpty) {
      return;
    }

    await _player.stop();

    if (source.startsWith('http://') ||
        source.startsWith('https://')) {
      await _player.play(
        UrlSource(source),
      );
      return;
    }

    final file = File(source);

    if (!await file.exists()) {
      throw Exception(
        'Voice file does not exist: $source',
      );
    }

    final size = await file.length();

    if (size <= 0) {
      throw Exception(
        'Voice file is empty: $source',
      );
    }

    await _player.play(
      DeviceFileSource(source),
    );
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.resume();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}