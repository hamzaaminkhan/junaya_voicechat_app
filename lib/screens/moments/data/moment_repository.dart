import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';


abstract class MomentRepository {


  Future<List<Moment>> getMoments();



  Future<Moment> createMoment({

    required Moment moment,

    required List<String> imagePaths,

  });



  Future<void> deleteMoment(
      String id,
      );



  Future<Moment> updateMoment(
      Moment moment,
      );



  Future<Moment> toggleLike(
      Moment moment,
      );



  Future<Moment> addReaction({

    required Moment moment,

    required String userId,

    required String emoji,

  });



  Future<List<Moment>> searchMoments(
      String query,
      );



  Future<List<Moment>> getUserMoments(
      String userId,
      );



  Future<void> clearAll();


}