import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_repository.dart';

import 'package:junaya_voicechat_app/screens/moments/providers/media_pipeline_provider.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/media_storage_provider.dart';

import 'package:junaya_voicechat_app/screens/moments/repositories/local_moment_repository.dart';

import 'package:junaya_voicechat_app/screens/moments/storage/moment_storage.dart';





// ======================================================
// STORAGE PROVIDER
// ======================================================


final momentStorageProvider =

Provider<MomentStorage>((ref){


  return MomentStorage();


});







// ======================================================
// REPOSITORY PROVIDER
// ======================================================


final momentRepositoryProvider =

Provider<MomentRepository>((ref){



  return LocalMomentRepository(

    storage:

    ref.watch(

      momentStorageProvider,

    ),



    mediaStorage:

    ref.watch(

      mediaStorageProvider,

    ),



    pipeline:

    ref.watch(

      mediaPipelineProvider,

    ),


  );


});








// ======================================================
// MOMENTS STATE
// ======================================================


final momentsProvider =

AsyncNotifierProvider<

    MomentsNotifier,

    List<Moment>

>(

  MomentsNotifier.new,

);









class MomentsNotifier

    extends AsyncNotifier<List<Moment>> {



  late MomentRepository _repository;







  @override
  Future<List<Moment>> build() async {


    _repository =

        ref.watch(

          momentRepositoryProvider,

        );



    return await _repository.getMoments();


  }









  // ======================================================
  // REFRESH
  // ======================================================


  Future<void> refresh() async {


    state =

    const AsyncLoading();



    state =

    await AsyncValue.guard(

          () async {


        return await _repository.getMoments();


      },

    );


  }









  // ======================================================
  // CREATE
  // ======================================================


  Future<void> createMoment({

    required Moment moment,

    required List<String> mediaPaths,

  }) async {



    final previous =

        state.value ?? [];





    state =

    const AsyncLoading();






    state =

    await AsyncValue.guard(

          () async {



        await _repository.createMoment(


          moment:

          moment,



          mediaPaths:

          mediaPaths,


        );





        return await _repository.getMoments();



      },

    );







    if(state.hasError){


      state =

          AsyncData(

            previous,

          );


    }



  }









  // ======================================================
  // UPDATE
  // ======================================================


  Future<void> updateMoment(

      Moment moment,

      ) async {



    try {



      await _repository.updateMoment(

        moment,

      );



      _replace(

        moment,

      );


    }


    catch(error,stack){


      state =

          AsyncError(

            error,

            stack,

          );


    }



  }









  // ======================================================
  // DELETE
  // ======================================================


  Future<void> deleteMoment(

      String id,

      ) async {



    final previous =

        state.value ?? [];





    state =

        AsyncData(

          previous

              .where(

                (item)=>

            item.id != id,

          )

              .toList(),

        );





    try {


      await _repository.deleteMoment(

        id,

      );


    }


    catch(error,stack){



      state =

          AsyncError(

            error,

            stack,

          );



      state =

          AsyncData(

            previous,

          );


    }


  }









  // ======================================================
  // LIKE
  // ======================================================


  Future<void> toggleLike(

      Moment moment,

      ) async {



    final optimistic =

    moment.copyWith(


      isLiked:

      !moment.isLiked,



      stats:

      moment.stats.copyWith(


        likes:


        !moment.isLiked

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





    _replace(

      optimistic,

    );





    try {


      final updated =

      await _repository.toggleLike(

        optimistic,

      );



      _replace(

        updated,

      );



    }


    catch(error,stack){



      _replace(

        moment,

      );



      state =

          AsyncError(

            error,

            stack,

          );


    }


  }









  // ======================================================
  // REACTION
  // ======================================================


  Future<void> addReaction({

    required Moment moment,

    required String userId,

    required String emoji,

  }) async {



    try {



      final updated =

      await _repository.addReaction(


        moment:

        moment,



        userId:

        userId,



        emoji:

        emoji,


      );





      _replace(

        updated,

      );


    }


    catch(error,stack){


      state =

          AsyncError(

            error,

            stack,

          );


    }



  }









  // ======================================================
  // SEARCH
  // ======================================================


  Future<List<Moment>> search(

      String query,

      ) {


    return _repository.searchMoments(

      query,

    );


  }









  // ======================================================
  // USER MOMENTS
  // ======================================================


  Future<List<Moment>> getUserMoments(

      String userId,

      ) {


    return _repository.getUserMoments(

      userId,

    );


  }









  // ======================================================
  // COMMENTS
  // ======================================================


  Future<void> updateComments({

    required String id,

    required bool increase,

  }) async {



    final moments =

        state.value ?? [];



    final index =

    moments.indexWhere(

          (item)=>

      item.id == id,

    );



    if(index == -1){

      return;

    }





    final old =

    moments[index];





    final updated =

    old.copyWith(

      stats:

      old.stats.copyWith(

        comments:


        increase

            ?

        old.stats.comments + 1


            :

        old.stats.comments > 0

            ?

        old.stats.comments - 1


            :

        0,


      ),

    );





    _replace(

      updated,

    );



    await _repository.updateMoment(

      updated,

    );


  }









  // ======================================================
  // INTERNAL
  // ======================================================


  void _replace(

      Moment updated,

      ){



    final current =

        state.value ?? [];





    state =

        AsyncData(

          current

              .map(

                  (item)=>


              item.id == updated.id

                  ?

              updated

                  :

              item

          )

              .toList(),


        );


  }



}