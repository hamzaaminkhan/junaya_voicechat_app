import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';



abstract class MomentRepository {


  // ==================================================
  // READ ALL
  // ==================================================

  Future<List<Moment>> getMoments();




  // ==================================================
  // CREATE
  // ==================================================
  //
  // mediaPaths are original picked files.
  // Repository sends them through MediaPipeline.
  //

  Future<Moment> createMoment({

    required Moment moment,

    required List<String> mediaPaths,

  });




  // ==================================================
  // READ SINGLE
  // ==================================================

  Future<Moment?> getMoment(

      String id,

      );




  // ==================================================
  // UPDATE
  // ==================================================

  Future<Moment> updateMoment(

      Moment moment,

      );




  // ==================================================
  // DELETE
  // ==================================================

  Future<void> deleteMoment(

      String id,

      );




  // ==================================================
  // LIKE
  // ==================================================

  Future<Moment> toggleLike(

      Moment moment,

      );




  // ==================================================
  // REACTION
  // ==================================================

  Future<Moment> addReaction({

    required Moment moment,

    required String userId,

    required String emoji,

  });




  // ==================================================
  // SEARCH
  // ==================================================

  Future<List<Moment>> searchMoments(

      String query,

      );




  // ==================================================
  // USER MOMENTS
  // ==================================================

  Future<List<Moment>> getUserMoments(

      String userId,

      );




  // ==================================================
  // CLEAR
  // ==================================================

  Future<void> clearAll();


}