import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_repository.dart';

class MomentRepositoryImpl implements MomentRepository {
  final List<Moment> _cache = [];

  @override
  Future<List<Moment>> getMoments() async {
    return List.unmodifiable(_cache);
  }

  @override
  Future<Moment?> getMoment(String id) async {
    for (final moment in _cache) {
      if (moment.id == id) {
        return moment;
      }
    }

    return null;
  }

  @override
  Future<Moment> createMoment({
    required Moment moment,
    required List<String> mediaPaths,
  }) async {
    final media = mediaPaths.isEmpty
        ? moment.media.toList()
        : [
      ...moment.media,
      ..._buildMedia(mediaPaths),
    ];

    final created = moment.copyWith(
      media: media,
    );

    _cache.removeWhere(
          (item) => item.id == created.id,
    );

    _cache.insert(0, created);

    return created;
  }

  @override
  Future<Moment> updateMoment(
      Moment moment,
      ) async {
    final index = _cache.indexWhere(
          (item) => item.id == moment.id,
    );

    if (index == -1) {
      throw Exception('Moment not found');
    }

    _cache[index] = moment;

    return moment;
  }

  @override
  Future<Moment> addMedia({
    required Moment moment,
    required List<String> mediaPaths,
  }) async {
    if (mediaPaths.isEmpty) {
      return moment;
    }

    final additionalMedia = _buildMedia(
      mediaPaths,
      startOrder: moment.media.length,
    );

    final updated = moment.copyWith(
      media: [
        ...moment.media,
        ...additionalMedia,
      ],
      updatedAt: DateTime.now(),
    );

    return updateMoment(updated);
  }

  @override
  Future<Moment> removeMedia({
    required Moment moment,
    required String mediaId,
  }) async {
    final updatedMedia = moment.media
        .where((media) => media.id != mediaId)
        .toList();

    if (updatedMedia.length == moment.media.length) {
      return moment;
    }

    final reordered = <MomentMedia>[];

    for (var i = 0; i < updatedMedia.length; i++) {
      final media = updatedMedia[i];

      reordered.add(
        media.copyWith(),
      );
    }

    final updated = moment.copyWith(
      media: reordered,
      updatedAt: DateTime.now(),
    );

    return updateMoment(updated);
  }

  @override
  Future<void> deleteMoment(
      String id,
      ) async {
    _cache.removeWhere(
          (moment) => moment.id == id,
    );
  }

  @override
  Future<Moment> toggleLike(
      Moment moment,
      ) async {
    final liked = !moment.isLiked;

    final likes = liked
        ? moment.stats.likes + 1
        : (moment.stats.likes - 1)
        .clamp(0, double.infinity)
        .toInt();

    final updated = moment.copyWith(
      isLiked: liked,
      stats: moment.stats.copyWith(
        likes: likes,
      ),
      updatedAt: DateTime.now(),
    );

    return updateMoment(updated);
  }

  @override
  Future<Moment> addReaction({
    required Moment moment,
    required String userId,
    required String emoji,
  }) async {
    final now = DateTime.now();

    final reactions = moment.reactions
        .where(
          (reaction) => reaction.userId != userId,
    )
        .toList();

    reactions.add(
      MomentReaction(
        userId: userId,
        emoji: emoji,
        createdAt: now,
      ),
    );

    final updated = moment.copyWith(
      reactions: reactions,
      updatedAt: now,
    );

    return updateMoment(updated);
  }

  @override
  Future<Moment> removeReaction({
    required Moment moment,
    required String userId,
    required String emoji,
  }) async {
    final reactions = moment.reactions
        .where(
          (reaction) =>
      !(reaction.userId == userId &&
          reaction.emoji == emoji),
    )
        .toList();

    final updated = moment.copyWith(
      reactions: reactions,
      updatedAt: DateTime.now(),
    );

    return updateMoment(updated);
  }

  @override
  Future<Moment> incrementViews(
      String id,
      ) async {
    final moment = await getMoment(id);

    if (moment == null) {
      throw Exception('Moment not found');
    }

    final updated = moment.copyWith(
      stats: moment.stats.copyWith(
        views: moment.stats.views + 1,
      ),
    );

    return updateMoment(updated);
  }

  @override
  Future<Moment> toggleSave(
      Moment moment,
      ) async {
    final saved = !moment.isSaved;

    final saves = saved
        ? moment.stats.saves + 1
        : (moment.stats.saves - 1)
        .clamp(0, double.infinity)
        .toInt();

    final updated = moment.copyWith(
      isSaved: saved,
      stats: moment.stats.copyWith(
        saves: saves,
      ),
      updatedAt: DateTime.now(),
    );

    return updateMoment(updated);
  }

  @override
  Future<Moment> incrementShares(
      String id,
      ) async {
    final moment = await getMoment(id);

    if (moment == null) {
      throw Exception('Moment not found');
    }

    final updated = moment.copyWith(
      stats: moment.stats.copyWith(
        shares: moment.stats.shares + 1,
      ),
    );

    return updateMoment(updated);
  }

  @override
  Future<List<Moment>> searchMoments(
      String query,
      ) async {
    final value = query.trim().toLowerCase();

    if (value.isEmpty) {
      return List.unmodifiable(_cache);
    }

    return _cache.where((moment) {
      final captionMatch = moment.caption
          .toLowerCase()
          .contains(value);

      final usernameMatch = moment.author.username
          .toLowerCase()
          .contains(value);

      final displayNameMatch =
      moment.author.displayName
          .toLowerCase()
          .contains(value);

      final hashtagMatch = moment.hashtags.any(
            (tag) => tag.toLowerCase().contains(value),
      );

      return captionMatch ||
          usernameMatch ||
          displayNameMatch ||
          hashtagMatch;
    }).toList();
  }

  @override
  Future<List<Moment>> getUserMoments(
      String userId,
      ) async {
    return _cache
        .where(
          (moment) => moment.author.id == userId,
    )
        .toList();
  }

  @override
  Future<List<Moment>> getMomentsPage({
    required int limit,
    String? cursor,
  }) async {
    if (limit <= 0) {
      return const [];
    }

    var startIndex = 0;

    if (cursor != null && cursor.isNotEmpty) {
      final cursorIndex = _cache.indexWhere(
            (moment) => moment.id == cursor,
      );

      if (cursorIndex != -1) {
        startIndex = cursorIndex + 1;
      }
    }

    if (startIndex >= _cache.length) {
      return const [];
    }

    final endIndex =
    (startIndex + limit).clamp(
      0,
      _cache.length,
    );

    return _cache
        .sublist(startIndex, endIndex)
        .toList();
  }

  @override
  Future<void> clearAll() async {
    _cache.clear();
  }

  List<MomentMedia> _buildMedia(
      List<String> paths, {
        int startOrder = 0,
      }) {
    return paths
        .asMap()
        .entries
        .map(
          (entry) {
        final path = entry.value;
        final order =
            startOrder + entry.key;

        if (_looksLikeVideo(path)) {
          return MomentMedia.video(
            path: path,
            order: order,
          );
        }

        return MomentMedia.image(
          path: path,
          order: order,
        );
      },
    )
        .toList();
  }

  bool _looksLikeVideo(String path) {
    final value = path.toLowerCase();

    return value.endsWith('.mp4') ||
        value.endsWith('.mov') ||
        value.endsWith('.m4v') ||
        value.endsWith('.webm') ||
        value.endsWith('.avi') ||
        value.endsWith('.mkv');
  }
}