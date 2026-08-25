import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_repository.dart';
import 'package:junaya_voicechat_app/screens/moments/storage/moment_storage.dart';

class LocalMomentRepository
    implements MomentRepository {



  final MomentStorage storage;



  LocalMomentRepository({

    required this.storage,

  });





  // =========================
  // GET ALL
  // =========================


  @override
  Future<List<Moment>> getMoments() async {

    return await storage.loadMoments();

  }







  // =========================
  // CREATE
  // =========================


  @override
  Future<Moment> createMoment({

    required Moment moment,

    required List<String> imagePaths,

  }) async {


    return await storage.createMoment(

      moment: moment,

      mediaPaths: imagePaths,

    );

  }







  // =========================
  // DELETE
  // =========================


  @override
  Future<void> deleteMoment(

      String id,

      ) async {


    await storage.deleteMoment(
      id,
    );


  }







  // =========================
  // UPDATE
  // =========================


  @override
  Future<Moment> updateMoment(

      Moment moment,

      ) async {


    await storage.updateMoment(
      moment,
    );


    return moment;

  }







  // =========================
  // LIKE
  // =========================


  @override
  Future<Moment> toggleLike(

      Moment moment,

      ) async {



    final bool liked =
    !moment.isLiked;



    final updated =

    moment.copyWith(

      isLiked:
      liked,


      stats:

      moment.stats.copyWith(

        likes:

        liked

            ?

        moment.stats.likes + 1


            :

        moment.stats.likes > 0

            ?

        moment.stats.likes - 1


            :

        0,

      ),

    );



    await storage.updateMoment(
      updated,
    );



    return updated;

  }







  // =========================
  // REACTION
  // =========================


  @override
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







  // =========================
  // SEARCH
  // =========================


  @override
  Future<List<Moment>> searchMoments(

      String query,

      ) async {



    final moments =
    await storage.loadMoments();



    final value =
    query.trim().toLowerCase();



    if(value.isEmpty){

      return moments;

    }



    return moments.where(

          (moment){


        final caption =
        moment.caption
            .toLowerCase();



        final username =
        moment.author.username
            .toLowerCase();



        final hashtags =
        moment.hashtags
            .join(' ')
            .toLowerCase();



        return caption.contains(value)

            ||

            username.contains(value)

            ||

            hashtags.contains(value);


      },

    ).toList();


  }







  // =========================
  // USER MOMENTS
  // =========================


  @override
  Future<List<Moment>> getUserMoments(

      String userId,

      ) async {



    final moments =
    await storage.loadMoments();



    return moments.where(

          (moment)=>

      moment.author.id ==
          userId,

    ).toList();


  }







  // =========================
  // CLEAR
  // =========================


  @override
  Future<void> clearAll() async {


    await storage.clear();


  }



}