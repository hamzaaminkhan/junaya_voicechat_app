import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class MomentVoiceRecorderService {
  final AudioRecorder _recorder = AudioRecorder();

  /// Returns true when recording is currently active.
  Future<bool> get isRecording async {
    return await _recorder.isRecording();
  }

  /// Checks whether microphone permission is available.
  Future<bool> hasPermission() async {
    return await _recorder.hasPermission();
  }

  /// Starts recording and returns the temporary file path.
  Future<String> start() async {
    final permission = await hasPermission();

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
        '${directory.path}/moment_voice_$timestamp.m4a';

    final config = RecordConfig(
      encoder: AudioEncoder.aacLc,

      // Standard high-quality voice recording.
      sampleRate: 44100,
      numChannels: 1,
      bitRate: 128000,

      // Android-specific microphone configuration.
      androidConfig: const AndroidRecordConfig(
        audioSource: AndroidAudioSource.mic,
        audioManagerMode:
        AudioManagerMode.modeNormal,
        manageBluetooth: true,
        speakerphone: false,
        muteAudio: false,
      ),

      // Improve voice capture when supported.
      autoGain: true,
      noiseSuppress: true,
      echoCancel: true,
    );

    try {
      await _recorder.start(
        config,
        path: path,
      );
    } catch (error) {
      throw VoiceRecorderException(
        'Unable to start voice recording: $error',
      );
    }

    return path;
  }

  /// Stops recording and returns the recorded file path.
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

  /// Pauses an active recording.
  Future<void> pause() async {
    final recording = await isRecording;

    if (!recording) {
      return;
    }

    await _recorder.pause();
  }

  /// Resumes a paused recording.
  Future<void> resume() async {
    await _recorder.resume();
  }

  /// Stops and deletes the current recording.
  Future<void> cancel() async {
    final path = await _recorder.stop();

    if (path == null || path.isEmpty) {
      return;
    }

    await deleteFile(path);
  }

  /// Deletes a recording file.
  Future<void> deleteFile(String path) async {
    if (path.isEmpty) {
      return;
    }

    final file = File(path);

    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Releases recorder resources.
  Future<void> dispose() async {
    await _recorder.dispose();
  }
}

class VoiceRecorderException implements Exception {
  final String message;

  const VoiceRecorderException(this.message);

  @override
  String toString() {
    return message;
  }
}