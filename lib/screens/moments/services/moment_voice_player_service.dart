import 'package:audioplayers/audioplayers.dart';

class MomentVoicePlayerService {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  bool get isPlaying =>
      _player.state == PlayerState.playing;

  Future<void> play(
      String path,
      ) async {
    if (path.isEmpty) {
      return;
    }

    await _player.stop();

    await _player.play(
      DeviceFileSource(path),
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