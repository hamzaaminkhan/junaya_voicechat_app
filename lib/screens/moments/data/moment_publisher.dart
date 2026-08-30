import 'dart:io';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';

class MomentPublisher {
  const MomentPublisher();

  Moment build({
    required String caption,
    required String visibility,
    required String? location,
    required List<String> mediaPaths,
    required String? voicePath,
    required Duration? voiceDuration,
  }) {
    final now = DateTime.now();

    final media = <MomentMedia>[];

    for (var index = 0;
    index < mediaPaths.length;
    index++) {
      final path = mediaPaths[index];

      media.add(
        _buildMedia(
          path: path,
          order: index,
        ),
      );
    }

    final voice = _buildVoice(
      path: voicePath,
      duration: voiceDuration,
    );

    return Moment(
      id: generateId(),

      author: const MomentUser(
        id: 'local-user',
        username: 'junaya',
        displayName: 'Junaya',
        avatar: '',
      ),

      caption: caption.trim(),

      media: media,

      createdAt: now,

      updatedAt: now,

      visibility:
      _visibilityFromString(
        visibility,
      ),

      location:
      _buildLocation(location),

      hashtags:
      _extractHashtags(caption),

      stats:
      MomentStats.empty(),

      isLiked: false,

      isSaved: false,

      isPinned: false,

      reactions: const [],

      voice: voice,

      music: null,
    );
  }

  MomentMedia _buildMedia({
    required String path,
    required int order,
  }) {
    final extension =
    path.toLowerCase();

    final isVideo =
        extension.endsWith('.mp4') ||
            extension.endsWith('.mov') ||
            extension.endsWith('.m4v') ||
            extension.endsWith('.webm') ||
            extension.endsWith('.avi');

    if (isVideo) {
      return MomentMedia.video(
        path: path,
        order: order,
      );
    }

    return MomentMedia.image(
      path: path,
      order: order,
    );
  }

  VoiceAttachment? _buildVoice({
    required String? path,
    required Duration? duration,
  }) {
    if (path == null ||
        path.trim().isEmpty) {
      return null;
    }

    return VoiceAttachment(
      id: generateId(),
      url: path,
      duration:
      duration?.inSeconds ?? 0,
      uploaded: false,
    );
  }

  MomentLocation? _buildLocation(
      String? value,
      ) {
    if (value == null ||
        value.trim().isEmpty) {
      return null;
    }

    return MomentLocation(
      name: value.trim(),
    );
  }

  MomentVisibility _visibilityFromString(
      String value,
      ) {
    switch (value) {
      case 'friends':
      case 'followers':
        return MomentVisibility.friends;

      case 'private':
        return MomentVisibility.private;

      case 'public':
      default:
        return MomentVisibility.public;
    }
  }

  List<String> _extractHashtags(
      String caption,
      ) {
    final matches =
    RegExp(r'#[A-Za-z0-9_]+')
        .allMatches(caption);

    return matches
        .map((match) =>
    match.group(0)!)
        .toList();
  }
}