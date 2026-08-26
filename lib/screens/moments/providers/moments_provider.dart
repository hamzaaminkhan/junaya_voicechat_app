import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_repository.dart';

import 'package:junaya_voicechat_app/screens/moments/providers/media_pipeline_provider.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/media_storage_provider.dart';

import 'package:junaya_voicechat_app/screens/moments/repositories/local_moment_repository.dart';

import 'package:junaya_voicechat_app/screens/moments/storage/moment_storage.dart';


final momentStorageProvider =
Provider<MomentStorage>((ref){
  return MomentStorage();
});


final momentRepositoryProvider =
Provider<MomentRepository>((ref){

  return LocalMomentRepository(

    storage: ref.watch(
      momentStorageProvider,
    ),

    mediaStorage: ref.watch(
      mediaStorageProvider,
    ),

    pipeline: ref.watch(
      mediaPipelineProvider,
    ),

  );

});


final momentsProvider =
AsyncNotifierProvider<MomentsNotifier,List<Moment>>(
  MomentsNotifier.new,
);



class MomentsNotifier extends AsyncNotifier<List<Moment>> {

  late final MomentRepository _repository;


  @override
  Future<List<Moment>> build() async {

    _repository =
        ref.watch(
          momentRepositoryProvider,
        );

    return _repository.getMoments();

  }



  Future<void> refresh() async {

    state =
        AsyncLoading<List<Moment>>()
            .copyWithPrevious(state);


    state =
    await AsyncValue.guard(
          () => _repository.getMoments(),
    );

  }



  Future<List<Moment>> loadPage({

    required int limit,

    String? cursor,

  }){

    return _repository.getMomentsPage(
      limit: limit,
      cursor: cursor,
    );

  }



  Future<void> createMoment({

    required Moment moment,

    required List<String> mediaPaths,

  }) async {


    final previous =
        state.value ?? [];


    state =
        AsyncLoading<List<Moment>>()
            .copyWithPrevious(state);



    state =
    await AsyncValue.guard(() async {

      await _repository.createMoment(
        moment: moment,
        mediaPaths: mediaPaths,
      );


      return _repository.getMoments();

    });



    if(state.hasError){

      state =
          AsyncData(previous);

    }

  }




  Future<void> updateMoment(
      Moment moment,
      ) async {

    try {

      final updated =
      await _repository.updateMoment(
        moment,
      );

      _replace(updated);

    }
    catch(error,stack){

      state =
          AsyncError(
            error,
            stack,
          );

    }

  }




  Future<void> deleteMoment(
      String id,
      ) async {


    final previous =
        state.value ?? [];


    state =
        AsyncData(
          previous
              .where(
                (item)=>item.id != id,
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
          AsyncData(previous);

      state =
          AsyncError(
            error,
            stack,
          );

    }

  }




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

            ? moment.stats.likes + 1

            : moment.stats.likes > 0
            ? moment.stats.likes - 1
            : 0,

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

      _replace(updated);

    }
    catch(error,stack){

      _replace(moment);

      state =
          AsyncError(
            error,
            stack,
          );

    }

  }





  Future<void> addReaction({

    required Moment moment,

    required String userId,

    required String emoji,

  }) async {


    try {


      final updated =
      await _repository.addReaction(
        moment: moment,
        userId: userId,
        emoji: emoji,
      );


      _replace(updated);


    }
    catch(error,stack){

      state =
          AsyncError(
            error,
            stack,
          );

    }

  }




  Future<void> removeReaction({

    required Moment moment,

    required String userId,

    required String emoji,

  }) async {


    try {


      final updated =
      await _repository.removeReaction(
        moment: moment,
        userId: userId,
        emoji: emoji,
      );


      _replace(updated);


    }
    catch(error,stack){

      state =
          AsyncError(
            error,
            stack,
          );

    }

  }




  Future<void> addMedia({

    required Moment moment,

    required List<String> paths,

  }) async {


    try {


      final updated =
      await _repository.addMedia(
        moment: moment,
        mediaPaths: paths,
      );


      _replace(updated);


    }
    catch(error,stack){

      state =
          AsyncError(
            error,
            stack,
          );

    }

  }




  Future<void> removeMedia({

    required Moment moment,

    required String mediaId,

  }) async {


    try {


      final updated =
      await _repository.removeMedia(
        moment: moment,
        mediaId: mediaId,
      );


      _replace(updated);


    }
    catch(error,stack){

      state =
          AsyncError(
            error,
            stack,
          );

    }

  }




  Future<void> incrementViews(
      String id,
      ) async {


    try {


      final updated =
      await _repository.incrementViews(
        id,
      );


      _replace(updated);


    }
    catch(error,stack){

      state =
          AsyncError(
            error,
            stack,
          );

    }

  }




  Future<void> incrementShares(
      String id,
      ) async {


    try {


      final updated =
      await _repository.incrementShares(
        id,
      );


      _replace(updated);


    }
    catch(error,stack){

      state =
          AsyncError(
            error,
            stack,
          );

    }

  }




  Future<void> toggleSave(
      Moment moment,
      ) async {


    try {


      final updated =
      await _repository.toggleSave(
        moment,
      );


      _replace(updated);


    }
    catch(error,stack){

      state =
          AsyncError(
            error,
            stack,
          );

    }

  }





  Future<List<Moment>> search(
      String query,
      ){

    return _repository.searchMoments(
      query,
    );

  }




  Future<List<Moment>> getUserMoments(
      String userId,
      ){

    return _repository.getUserMoments(
      userId,
    );

  }





  Future<void> updateComments({

    required String id,

    required bool increase,

  }) async {


    final moments =
        state.value ?? [];


    final index =
    moments.indexWhere(
          (item)=>item.id == id,
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

            ? old.stats.comments + 1

            : old.stats.comments > 0
            ? old.stats.comments - 1
            : 0,

      ),

    );


    _replace(updated);


    try {

      await _repository.updateMoment(
        updated,
      );

    }
    catch(error,stack){

      _replace(old);

      state =
          AsyncError(
            error,
            stack,
          );

    }

  }




  void _replace(
      Moment updated,
      ){


    final current =
        state.value ?? [];


    state =
        AsyncData(

          current.map(

                (item)=>

            item.id == updated.id

                ? updated

                : item,

          ).toList(),

        );

  }

}