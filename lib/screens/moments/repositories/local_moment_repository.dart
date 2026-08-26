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








  // ==============================
  // READ
  // ==============================


  @override
  Future<List<Moment>> getMoments() async {

    return await storage.loadMoments();

  }






  @override
  Future<Moment?> getMoment(
      String id,
      ) async {

    return await storage.getMoment(
      id,
    );

  }









  // ==============================
  // CREATE
  // ==============================


  @override
  Future<Moment> createMoment({

    required Moment moment,

    required List<String> mediaPaths,

  }) async {



    final media =

    await pipeline.process(

      momentId: moment.id,

      files: mediaPaths,

    );



    final updated =

    moment.copyWith(

      media: media,

    );



    return await storage.createMoment(
      updated,
    );


  }









  // ==============================
  // UPDATE
  // ==============================


  @override
  Future<Moment> updateMoment(
      Moment moment,
      ) async {


    await storage.updateMoment(
      moment,
    );


    return moment;


  }









  // ==============================
  // MEDIA
  // ==============================


  @override
  Future<Moment> addMedia({

    required Moment moment,

    required List<String> mediaPaths,

  }) async {


    final media =

    await pipeline.process(

      momentId: moment.id,

      files: mediaPaths,

    );



    final updated =

    moment.copyWith(

      media:

      [

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



    final removed =

        moment.media.where(

              (item) =>
          item.id == mediaId,

        ).firstOrNull;




    final updated =

    moment.copyWith(

      media:

      moment.media

          .where(

            (item)=>

        item.id != mediaId,

      )

          .toList(),

    );



    await storage.updateMoment(
      updated,
    );





    if(removed != null){

      await mediaStorage.deleteMedia(
        [
          removed,
        ],
      );

    }




    return updated;


  }









  // ==============================
  // DELETE
  // ==============================


  @override
  Future<void> deleteMoment(
      String id,
      ) async {


    final existing =

    await storage.getMoment(
      id,
    );



    await storage.deleteMoment(
      id,
    );



    if(existing != null &&
        existing.media.isNotEmpty){


      await mediaStorage.deleteMedia(
        existing.media,
      );


    }


  }









  // ==============================
  // LIKE
  // ==============================


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









  // ==============================
  // REACTIONS
  // ==============================


  @override
  Future<Moment> addReaction({

    required Moment moment,

    required String userId,

    required String emoji,

  }) async {



    final exists =

    moment.reactions.any(

          (item)=>

      item.userId == userId &&

          item.emoji == emoji,

    );



    if(exists){

      return await removeReaction(

        moment: moment,

        userId: userId,

        emoji: emoji,

      );

    }




    final reactions =

    [

      ...moment.reactions,

      MomentReaction(

        userId: userId,

        emoji: emoji,

        createdAt: DateTime.now(),

      ),

    ];





    final updated =

    moment.copyWith(

      reactions: reactions,

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

      moment.reactions

          .where(

              (item)=>

          !(

              item.userId == userId &&

                  item.emoji == emoji

          )

      )

          .toList(),

    );



    await storage.updateMoment(
      updated,
    );



    return updated;


  }









  // ==============================
  // ENGAGEMENT
  // ==============================


  @override
  Future<Moment> incrementViews(
      String id,
      ) async {


    final moment =

    await storage.getMoment(
      id,
    );



    if(moment == null){

      throw Exception(
        "Moment not found",
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

    await storage.getMoment(
      id,
    );



    if(moment == null){

      throw Exception(
        "Moment not found",
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


    throw UnimplementedError(
      "Add isSaved field to Moment model first",
    );


  }









  // ==============================
  // SEARCH
  // ==============================


  @override
  Future<List<Moment>> searchMoments(
      String query,
      ) async {


    return await storage.search(
      query,
    );


  }









  // ==============================
  // USER
  // ==============================


  @override
  Future<List<Moment>> getUserMoments(
      String userId,
      ) async {


    return await storage.getUserMoments(
      userId,
    );


  }









  // ==============================
  // PAGINATION
  // ==============================


  @override
  Future<List<Moment>> getMomentsPage({

    required int limit,

    String? cursor,

  }) async {



    final moments =

    await storage.loadMoments();



    var start = 0;



    if(cursor != null){


      final index =

      moments.indexWhere(

            (item)=>

        item.id == cursor,

      );



      if(index != -1){

        start = index + 1;

      }


    }




    return moments

        .skip(start)

        .take(limit)

        .toList();


  }









  // ==============================
  // CLEAR
  // ==============================


  @override
  Future<void> clearAll() async {


    await storage.clear();


    await mediaStorage.clear();


  }


}