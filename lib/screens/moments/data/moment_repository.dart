import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';



abstract class MomentRepository {



  // ==================================================
  // READ
  // ==================================================


  Future<List<Moment>> getMoments();



  Future<Moment?> getMoment(

      String id,

      );




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
  // UPDATE
  // ==================================================


  Future<Moment> updateMoment(

      Moment moment,

      );





  // ==================================================
  // MEDIA
  // ==================================================


  Future<Moment> addMedia({

    required Moment moment,

    required List<String> mediaPaths,

  });



  Future<Moment> removeMedia({

    required Moment moment,

    required String mediaId,

  });





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
  // REACTIONS
  // ==================================================


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





  // ==================================================
  // ENGAGEMENT
  // ==================================================


  Future<Moment> incrementViews(

      String id,

      );



  Future<Moment> toggleSave(

      Moment moment,

      );



  Future<Moment> incrementShares(

      String id,

      );





  // ==================================================
  // SEARCH
  // ==================================================


  Future<List<Moment>> searchMoments(

      String query,

      );





  // ==================================================
  // USER
  // ==================================================


  Future<List<Moment>> getUserMoments(

      String userId,

      );





  // ==================================================
  // PAGINATION READY
  // ==================================================
  //
  // For future API/Firebase migration.
  //


  Future<List<Moment>> getMomentsPage({

    required int limit,

    String? cursor,

  });





  // ==================================================
  // CLEAR LOCAL DATA
  // ==================================================


  Future<void> clearAll();


}