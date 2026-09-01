import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class MomentVoiceRecorderService {
  final AudioRecorder _recorder = AudioRecorder();

  Future<bool> get isRecording async {
    return _recorder.isRecording();
  }

  Future<bool> hasPermission() async {
    return _recorder.hasPermission();
  }

  Future<Amplitude> getAmplitude() async {
    return _recorder.getAmplitude();
  }

  Future<String> start() async {
    final permission =
    await _recorder.hasPermission();

    if (!permission) {
      throw const VoiceRecorderException(
        'Microphone permission was denied.',
      );
    }

    final directory =
    await getTemporaryDirectory();

    final timestamp =
        DateTime.now().microsecondsSinceEpoch;

    final path =
        '${directory.path}/moment_voice_$timestamp.wav';

    final config = RecordConfig(
      encoder: AudioEncoder.wav,
      sampleRate: 44100,
      numChannels: 1,

      androidConfig: const AndroidRecordConfig(
        audioSource: AndroidAudioSource.mic,
        audioManagerMode:
        AudioManagerMode.modeNormal,
        speakerphone: false,
        manageBluetooth: false,
      ),
    );

    final supported =
    await _recorder.isEncoderSupported(
      AudioEncoder.wav,
    );

    if (!supported) {
      throw const VoiceRecorderException(
        'WAV recording is not supported on this device.',
      );
    }

    await _recorder.start(
      config,
      path: path,
    );

    return path;
  }

  Future<String?> stop() async {
    final path = await _recorder.stop();

    if (path == null || path.isEmpty) {
      return null;
    }

    final file = File(path);

    if (!await file.exists()) {
      return null;
    }

    final size = await file.length();

    if (size <= 0) {
      await deleteFile(path);
      return null;
    }

    return file.path;
  }

  Future<void> pause() async {
    if (!await isRecording) {
      return;
    }

    await _recorder.pause();
  }

  Future<void> resume() async {
    await _recorder.resume();
  }

  Future<void> cancel() async {
    final path = await _recorder.stop();

    if (path != null && path.isNotEmpty) {
      await deleteFile(path);
    }
  }

  Future<void> deleteFile(String path) async {
    if (path.isEmpty) {
      return;
    }

    final file = File(path);

    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }
}

class VoiceRecorderException implements Exception {
  final String message;

  const VoiceRecorderException(this.message);

  @override
  String toString() => message;
}