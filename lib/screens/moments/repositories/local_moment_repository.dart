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









  // =====================================================
  // GET ALL
  // =====================================================


  @override
  Future<List<Moment>> getMoments() async {


    return await storage.loadMoments();


  }









  // =====================================================
  // GET SINGLE
  // =====================================================


  @override
  Future<Moment?> getMoment(

      String id,

      ) async {


    return await storage.getMoment(

      id,

    );


  }









  // =====================================================
  // CREATE
  // =====================================================


  @override
  Future<Moment> createMoment({

    required Moment moment,

    required List<String> mediaPaths,

  }) async {



    final processedMedia =

    await pipeline.process(

      momentId:

      moment.id,


      files:

      mediaPaths,

    );





    final updated =

    moment.copyWith(

      media:

      processedMedia,

    );





    return await storage.createMoment(

      updated,

    );


  }









  // =====================================================
  // UPDATE
  // =====================================================


  @override
  Future<Moment> updateMoment(

      Moment moment,

      ) async {



    await storage.updateMoment(

      moment,

    );



    return moment;


  }









  // =====================================================
  // DELETE
  // =====================================================


  @override
  Future<void> deleteMoment(

      String id,

      ) async {



    final existing =

    await storage.getMoment(

      id,

    );





    // remove database record first

    await storage.deleteMoment(

      id,

    );






    // remove physical files

    if(existing != null &&

        existing.media.isNotEmpty){



      await mediaStorage.deleteMedia(

        existing.media,

      );


    }



  }









  // =====================================================
  // LIKE
  // =====================================================


  @override
  Future<Moment> toggleLike(

      Moment moment,

      ) async {



    final liked =

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









  // =====================================================
  // REACTION
  // =====================================================


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





    final exists =

    reactions.any(

          (item) =>

      item.userId == userId &&

          item.emoji == emoji,

    );





    if(exists){


      reactions.removeWhere(

            (item) =>

        item.userId == userId &&

            item.emoji == emoji,

      );


    }

    else{


      reactions.add(

        MomentReaction(

          userId:

          userId,


          emoji:

          emoji,

        ),

      );


    }





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









  // =====================================================
  // SEARCH
  // =====================================================


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

        moment.caption.toLowerCase();



        final username =

        moment.author.username.toLowerCase();



        final tags =

        moment.hashtags

            .join(' ')

            .toLowerCase();





        return caption.contains(value)

            ||

            username.contains(value)

            ||

            tags.contains(value);



      },

    ).toList();



  }









  // =====================================================
  // USER MOMENTS
  // =====================================================


  @override
  Future<List<Moment>> getUserMoments(

      String userId,

      ) async {



    final moments =

    await storage.loadMoments();





    return moments.where(

          (moment) =>

      moment.author.id == userId,

    ).toList();


  }









  // =====================================================
  // CLEAR ALL
  // =====================================================


  @override
  Future<void> clearAll() async {



    await storage.clear();



    await mediaStorage.clear();



  }



}