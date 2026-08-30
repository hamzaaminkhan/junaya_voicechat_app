import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_repository.dart';

import 'package:junaya_voicechat_app/screens/moments/storage/moment_storage.dart';
import 'package:junaya_voicechat_app/screens/moments/storage/media_storage.dart';

import 'package:junaya_voicechat_app/screens/moments/media/media_pipeline.dart';

class LocalMomentRepository
    implements MomentRepository {
  final MomentStorage storage;
  final MediaStorage mediaStorage;
  final MediaPipeline pipeline;

  LocalMomentRepository({
    required this.storage,
    required this.mediaStorage,
    required this.pipeline,
  });

  @override
  Future<List<Moment>> getMoments() {
    return storage.loadMoments();
  }

  @override
  Future<Moment?> getMoment(
      String id,
      ) {
    return storage.getMoment(id);
  }

  @override
  Future<Moment> createMoment({
    required Moment moment,
    required List<String> mediaPaths,
  }) async {
    /*
     * Process images/videos first.
     *
     * The voice attachment is already
     * part of `moment.voice` and is
     * intentionally preserved here.
     */
    final media =
    await pipeline.process(
      momentId: moment.id,
      files: mediaPaths,
    );

    /*
     * If the caller supplied media but
     * none could be processed, don't
     * silently publish an incomplete Moment.
     */
    if (mediaPaths.isNotEmpty &&
        media.isEmpty) {
      throw const MediaPipelineException(
        'Unable to process the selected media.',
      );
    }

    /*
     * Preserve the voice attachment,
     * location, visibility, caption,
     * hashtags, etc.
     *
     * Only replace the processed
     * image/video media collection.
     */
    final updated =
    moment.copyWith(
      media: media,
    );

    return storage.createMoment(
      updated,
    );
  }

  @override
  Future<Moment> updateMoment(
      Moment moment,
      ) async {
    await storage.updateMoment(
      moment,
    );

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

    final media =
    await pipeline.process(
      momentId: moment.id,
      files: mediaPaths,
    );

    if (media.isEmpty) {
      throw const MediaPipelineException(
        'Unable to process the selected media.',
      );
    }

    final updated =
    moment.copyWith(
      media: [
        ...moment.media,
        ...media,
      ],
    );

    await storage.updateMoment(
      updated,
    );

    return updated;
  }

  @override
  Future<Moment> removeMedia({
    required Moment moment,
    required String mediaId,
  }) async {
    MomentMedia? removed;

    for (final item in moment.media) {
      if (item.id == mediaId) {
        removed = item;
        break;
      }
    }

    if (removed == null) {
      return moment;
    }

    final updated =
    moment.copyWith(
      media: moment.media
          .where(
            (item) =>
        item.id != mediaId,
      )
          .toList(),
    );

    await storage.updateMoment(
      updated,
    );

    await mediaStorage.deleteMedia(
      [removed],
    );

    return updated;
  }

  @override
  Future<void> deleteMoment(
      String id,
      ) async {
    final existing =
    await storage.getMoment(id);

    await storage.deleteMoment(id);

    if (existing != null &&
        existing.media.isNotEmpty) {
      await mediaStorage.deleteMedia(
        existing.media,
      );
    }
  }

  @override
  Future<Moment> toggleLike(
      Moment moment,
      ) async {
    final liked =
    !moment.isLiked;

    final updated =
    moment.copyWith(
      isLiked: liked,
      stats:
      moment.stats.copyWith(
        likes: liked
            ? moment.stats.likes + 1
            : moment.stats.likes > 0
            ? moment.stats.likes - 1
            : 0,
      ),
    );

    await storage.updateMoment(
      updated,
    );

    return updated;
  }

  @override
  Future<Moment> addReaction({
    required Moment moment,
    required String userId,
    required String emoji,
  }) async {
    final exists =
    moment.reactions.any(
          (item) =>
      item.userId == userId &&
          item.emoji == emoji,
    );

    if (exists) {
      return removeReaction(
        moment: moment,
        userId: userId,
        emoji: emoji,
      );
    }

    final updated =
    moment.copyWith(
      reactions: [
        ...moment.reactions,
        MomentReaction(
          userId: userId,
          emoji: emoji,
          createdAt:
          DateTime.now(),
        ),
      ],
    );

    await storage.updateMoment(
      updated,
    );

    return updated;
  }

  @override
  Future<Moment> removeReaction({
    required Moment moment,
    required String userId,
    required String emoji,
  }) async {
    final updated =
    moment.copyWith(
      reactions:
      moment.reactions.where(
            (item) =>
        !(item.userId == userId &&
            item.emoji == emoji),
      ).toList(),
    );

    await storage.updateMoment(
      updated,
    );

    return updated;
  }

  @override
  Future<Moment> incrementViews(
      String id,
      ) async {
    final moment =
    await storage.getMoment(id);

    if (moment == null) {
      throw Exception(
        'Moment not found',
      );
    }

    final updated =
    moment.copyWith(
      stats:
      moment.stats.copyWith(
        views:
        moment.stats.views + 1,
      ),
    );

    await storage.updateMoment(
      updated,
    );

    return updated;
  }

  @override
  Future<Moment> incrementShares(
      String id,
      ) async {
    final moment =
    await storage.getMoment(id);

    if (moment == null) {
      throw Exception(
        'Moment not found',
      );
    }

    final updated =
    moment.copyWith(
      stats:
      moment.stats.copyWith(
        shares:
        moment.stats.shares + 1,
      ),
    );

    await storage.updateMoment(
      updated,
    );

    return updated;
  }

  @override
  Future<Moment> toggleSave(
      Moment moment,
      ) async {
    final saved =
    !moment.isSaved;

    final updated =
    moment.copyWith(
      isSaved: saved,
      stats:
      moment.stats.copyWith(
        saves: saved
            ? moment.stats.saves + 1
            : moment.stats.saves > 0
            ? moment.stats.saves - 1
            : 0,
      ),
    );

    await storage.updateMoment(
      updated,
    );

    return updated;
  }

  @override
  Future<List<Moment>> searchMoments(
      String query,
      ) {
    return storage.search(
      query,
    );
  }

  @override
  Future<List<Moment>> getUserMoments(
      String userId,
      ) {
    return storage.getUserMoments(
      userId,
    );
  }

  @override
  Future<List<Moment>> getMomentsPage({
    required int limit,
    String? cursor,
  }) {
    return storage.loadPage(
      limit: limit,
      cursor: cursor,
    );
  }

  @override
  Future<void> clearAll() async {
    await storage.clear();
    await mediaStorage.clear();
  }
}