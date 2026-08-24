import 'package:junaya_voicechat_app/services/moment_storage.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';


class MomentRepository {

  final MomentStorage storage;


  MomentRepository({
    required this.storage,
  });







  Future<List<Moment>> getMoments() async {

    return await storage.loadMoments();

  }

  Future<Moment> createMoment({

    required Moment moment,

    required List<String> imagePaths,

  }) async {


    return await storage.createMoment(

      moment: moment,

      sourceImagePaths: imagePaths,

    );


  }








  Future<void> deleteMoment(
      String id,
      ) async {


    await storage.deleteMoment(id);


  }








  Future<Moment> updateMoment(
      Moment moment,
      ) async {


    await storage.updateMoment(moment);


    return moment;


  }








  Future<Moment> toggleLike(
      Moment moment,
      ) async {


    final bool newLiked =
    !moment.isLiked;



    final Moment updated =
    moment.copyWith(

      isLiked:
      newLiked,


      likesCount:

      newLiked

          ?

      moment.likesCount + 1

          :

      (moment.likesCount > 0
          ? moment.likesCount - 1
          : 0),

    );



    await storage.updateMoment(
      updated,
    );



    return updated;

  }








  Future<Moment> addReaction({

    required Moment moment,

    required String userId,

    required String emoji,

  }) async {



    final reactions =
    List<MomentReaction>.from(
      moment.reactions,
    );



    reactions.add(

      MomentReaction(

        userId:
        userId,


        emoji:
        emoji,

      ),

    );





    final updated =
    moment.copyWith(
      reactions:
      reactions,
    );



    await storage.updateMoment(
      updated,
    );



    return updated;


  }








  Future<List<Moment>> searchMoments(
      String query,
      ) async {


    final moments =
    await getMoments();



    final search =
    query.toLowerCase();



    if(search.isEmpty){

      return moments;

    }



    return moments.where(

          (moment){

        return moment.caption
            .toLowerCase()
            .contains(search)

            ||

            moment.author.username
                .toLowerCase()
                .contains(search);

      },

    ).toList();


  }








  Future<List<Moment>> getUserMoments(
      String userId,
      ) async {


    final moments =
    await getMoments();



    return moments.where(

          (moment)=>
      moment.author.id == userId,

    ).toList();


  }








  Future<void> clearAll() async {

    await storage.clear();

  }


}