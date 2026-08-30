import 'package:flutter/foundation.dart';

@immutable
class MomentDraft {
  final String id;
  final String caption;
  final List<String> mediaPaths;
  final String? location;
  final String visibility;
  final String? voicePath;
  final Duration? voiceDuration;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MomentDraft({
    required this.id,
    required this.caption,
    required this.mediaPaths,
    required this.location,
    required this.visibility,
    required this.voicePath,
    required this.voiceDuration,
    required this.createdAt,
    required this.updatedAt,
  });

  MomentDraft copyWith({
    String? id,
    String? caption,
    List<String>? mediaPaths,
    String? location,
    String? visibility,
    String? voicePath,
    Duration? voiceDuration,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MomentDraft(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      mediaPaths: List.unmodifiable(
        mediaPaths ?? this.mediaPaths,
      ),
      location: location ?? this.location,
      visibility: visibility ?? this.visibility,
      voicePath: voicePath ?? this.voicePath,
      voiceDuration:
      voiceDuration ?? this.voiceDuration,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}