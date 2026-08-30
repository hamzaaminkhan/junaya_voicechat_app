import 'dart:io';

import 'package:image_picker/image_picker.dart';

class MomentMediaService {
  final ImagePicker _picker = ImagePicker();

  Future<List<String>> selectPhotos({
    required int remaining,
  }) async {
    if (remaining <= 0) {
      return const [];
    }

    final files = await _picker.pickMultiImage(
      imageQuality: 90,
    );

    if (files.isEmpty) {
      return const [];
    }

    return files
        .take(remaining)
        .map((file) => file.path)
        .toList();
  }

  Future<List<String>> selectCameraMedia() async {
    final file = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );

    if (file == null) {
      return const [];
    }

    return [file.path];
  }

  Future<List<String>> selectVideo() async {
    final file = await _picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (file == null) {
      return const [];
    }

    return [file.path];
  }

  Future<List<String>> selectCameraVideo() async {
    final file = await _picker.pickVideo(
      source: ImageSource.camera,
    );

    if (file == null) {
      return const [];
    }

    return [file.path];
  }
}