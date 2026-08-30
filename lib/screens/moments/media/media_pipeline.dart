import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';

import '../storage/media_storage.dart';

import 'media_compressor.dart';
import 'thumbnail_generator.dart';
import 'media_duplicate_checker.dart';
import 'upload_queue.dart';

class MediaPipeline {
  final MediaStorage storage;
  final MediaCompressor compressor;
  final ThumbnailGenerator thumbnail;
  final MediaDuplicateChecker duplicateChecker;
  final UploadQueue uploadQueue;

  const MediaPipeline({
    required this.storage,
    required this.compressor,
    required this.thumbnail,
    required this.duplicateChecker,
    required this.uploadQueue,
  });

  Future<List<MomentMedia>> process({
    required String momentId,
    required List<String> files,
  }) async {
    if (files.isEmpty) {
      return const [];
    }

    final result = <MomentMedia>[];

    for (var index = 0;
    index < files.length;
    index++) {
      final original =
      files[index].trim();

      if (original.isEmpty) {
        continue;
      }

      final media =
      await _processSingle(
        momentId: momentId,
        originalPath: original,
        order: index,
      );

      if (media != null) {
        result.add(media);
      }
    }

    return result;
  }

  Future<MomentMedia?> _processSingle({
    required String momentId,
    required String originalPath,
    required int order,
  }) async {
    String compressedPath = '';

    try {
      compressedPath =
      await compressor.compress(
        originalPath,
      );

      if (compressedPath.trim().isEmpty) {
        throw MediaPipelineException(
          'Compression returned an empty path.',
        );
      }

      final duplicate =
      await duplicateChecker.exists(
        compressedPath,
      );

      if (duplicate) {
        return null;
      }

      final saved =
      await storage.saveMedia(
        momentId: momentId,
        paths: [
          compressedPath,
        ],
      );

      if (saved.isEmpty) {
        throw MediaPipelineException(
          'Media storage returned no saved media.',
        );
      }

      var media = saved.first;

      String? thumbnailPath;

      try {
        thumbnailPath =
        await thumbnail.generate(
          media.localPath,
        );
      } catch (_) {
        // Thumbnail failure should not
        // prevent the actual media from
        // being published.
        thumbnailPath = null;
      }

      media = media.copyWith(
        thumbnail: thumbnailPath,
        processing: false,
        uploaded: false,
        failed: false,
        uploadProgress: 0,
      );

      await uploadQueue.add(
        UploadTask.create(
          id: media.id,
          filePath: media.localPath,
          momentId: momentId,
        ),
      );

      return media;
    } catch (error) {
      throw MediaPipelineException(
        'Failed to process media: $originalPath',
        cause: error,
      );
    }
  }
}

class MediaPipelineException
    implements Exception {
  final String message;
  final Object? cause;

  const MediaPipelineException(
      this.message, {
        this.cause,
      });

  @override
  String toString() {
    if (cause == null) {
      return message;
    }

    return '$message Cause: $cause';
  }
}