import '../data/moment_draft_model.dart';

abstract class DraftRepository {
  Future<List<MomentDraft>> getDrafts();

  Future<MomentDraft?> getDraft(
      String id,
      );

  Future<MomentDraft> saveDraft(
      MomentDraft draft,
      );

  Future<void> deleteDraft(
      String id,
      );

  Future<void> clearAll();
}