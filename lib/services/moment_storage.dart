import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalMomentData {
  final String id;
  final String text;
  final List<String> imagePaths;
  final DateTime createdAt;

  const LocalMomentData({
    required this.id,
    required this.text,
    required this.imagePaths,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'imagePaths': imagePaths,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory LocalMomentData.fromJson(
      Map<String, dynamic> json,
      ) {
    final dynamic rawImages = json['imagePaths'];

    return LocalMomentData(
      id: json['id']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      imagePaths: rawImages is List
          ? rawImages
          .whereType<String>()
          .toList()
          : <String>[],
      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ) ??
          DateTime.now(),
    );
  }
}

class MomentStorage {
  static const String _storageKey =
      'junaya_saved_moments_v1';

  final SharedPreferencesAsync _preferences =
  SharedPreferencesAsync();

  Future<LocalMomentData> createMoment({
    required String text,
    required List<String> sourceImagePaths,
  }) async {
    final String id =
    DateTime.now().microsecondsSinceEpoch.toString();

    final List<String> permanentImagePaths =
    await _copyImagesToAppFolder(
      momentId: id,
      sourcePaths: sourceImagePaths,
    );

    final LocalMomentData newMoment =
    LocalMomentData(
      id: id,
      text: text,
      imagePaths: permanentImagePaths,
      createdAt: DateTime.now(),
    );

    final List<LocalMomentData> existingMoments =
    await loadMoments();

    final List<LocalMomentData> updatedMoments = [
      newMoment,
      ...existingMoments.where(
            (moment) => moment.id != id,
      ),
    ];

    await _writeMoments(updatedMoments);

    return newMoment;
  }

  Future<List<LocalMomentData>> loadMoments() async {
    final String? savedJson =
    await _preferences.getString(_storageKey);

    if (savedJson == null ||
        savedJson.trim().isEmpty) {
      return [];
    }

    try {
      final dynamic decoded = jsonDecode(savedJson);

      if (decoded is! List) {
        return [];
      }

      final List<LocalMomentData> moments = [];

      for (final dynamic item in decoded) {
        if (item is Map) {
          final LocalMomentData moment =
          LocalMomentData.fromJson(
            Map<String, dynamic>.from(item),
          );

          moments.add(moment);
        }
      }

      moments.sort(
            (first, second) => second.createdAt
            .compareTo(first.createdAt),
      );

      return moments;
    } catch (_) {
      return [];
    }
  }

  Future<void> deleteMoment(
      LocalMomentData moment,
      ) async {
    final List<LocalMomentData> existing =
    await loadMoments();

    final List<LocalMomentData> updated =
    existing
        .where(
          (item) => item.id != moment.id,
    )
        .toList();

    for (final String imagePath
    in moment.imagePaths) {
      try {
        final File imageFile = File(imagePath);

        if (await imageFile.exists()) {
          await imageFile.delete();
        }
      } catch (_) {
        // Continue deleting the remaining files.
      }
    }

    await _writeMoments(updated);
  }

  Future<LocalMomentData> updateMoment({
    required LocalMomentData moment,
    required String text,
  }) async {
    final LocalMomentData updatedMoment = LocalMomentData(
      id: moment.id,
      text: text.trim(),
      imagePaths: moment.imagePaths,
      createdAt: moment.createdAt,
    );

    final List<LocalMomentData> existingMoments =
    await loadMoments();

    bool momentFound = false;

    final List<LocalMomentData> updatedMoments =
    existingMoments.map((item) {
      if (item.id == moment.id) {
        momentFound = true;
        return updatedMoment;
      }

      return item;
    }).toList();

    if (!momentFound) {
      updatedMoments.insert(0, updatedMoment);
    }

    await _writeMoments(updatedMoments);

    return updatedMoment;
  }

  Future<List<String>> _copyImagesToAppFolder({
    required String momentId,
    required List<String> sourcePaths,
  }) async {
    if (sourcePaths.isEmpty) {
      return [];
    }

    final Directory documentsDirectory =
    await getApplicationDocumentsDirectory();

    final Directory momentsDirectory = Directory(
      p.join(
        documentsDirectory.path,
        'junaya_moments',
      ),
    );

    if (!await momentsDirectory.exists()) {
      await momentsDirectory.create(
        recursive: true,
      );
    }

    final List<String> savedPaths = [];

    for (int index = 0;
    index < sourcePaths.length;
    index++) {
      try {
        final File sourceFile =
        File(sourcePaths[index]);

        if (!await sourceFile.exists()) {
          continue;
        }

        String extension =
        p.extension(sourceFile.path);

        if (extension.isEmpty) {
          extension = '.jpg';
        }

        final String destinationPath = p.join(
          momentsDirectory.path,
          '${momentId}_$index$extension',
        );

        final File copiedFile = await sourceFile.copy(
          destinationPath,
        );

        savedPaths.add(copiedFile.path);
      } catch (_) {
        // Skip an image if it cannot be copied.
      }
    }

    return savedPaths;
  }

  Future<void> _writeMoments(
      List<LocalMomentData> moments,
      ) async {
    final String encoded = jsonEncode(
      moments
          .map((moment) => moment.toJson())
          .toList(),
    );

    await _preferences.setString(
      _storageKey,
      encoded,
    );
  }
}