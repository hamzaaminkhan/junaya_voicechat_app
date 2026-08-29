import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';

abstract class MomentRepository {

  Future<List<Moment>> getMoments();

  Future<Moment?> getMoment(
      String id,
      );

  Future<Moment> createMoment({
    required Moment moment,
    required List<String> mediaPaths,
  });

  Future<Moment> updateMoment(
      Moment moment,
      );

  Future<Moment> addMedia({
    required Moment moment,
    required List<String> mediaPaths,
  });

  Future<Moment> removeMedia({
    required Moment moment,
    required String mediaId,
  });

  Future<void> deleteMoment(
      String id,
      );

  Future<Moment> toggleLike(
      Moment moment,
      );

  Future<Moment> addReaction({
    required Moment moment,
    required String userId,
    required String emoji,
  });

  Future<Moment> removeReaction({
    required Moment moment,
    required String userId,
    required String emoji,
  });

  Future<Moment> incrementViews(
      String id,
      );

  Future<Moment> toggleSave(
      Moment moment,
      );

  Future<Moment> incrementShares(
      String id,
      );

  Future<List<Moment>> searchMoments(
      String query,
      );

  Future<List<Moment>> getUserMoments(
      String userId,
      );

  Future<List<Moment>> getMomentsPage({
    required int limit,
    String? cursor,
  });

  Future<void> clearAll();
}