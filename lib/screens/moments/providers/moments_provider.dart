import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_repository.dart';
import 'package:junaya_voicechat_app/services/moment_storage.dart';


final momentStorageProvider =
Provider<MomentStorage>((ref) {
  return MomentStorage();
});

final momentRepositoryProvider =
Provider<MomentRepository>((ref) {

  return MomentRepository(
    storage: ref.read(
      momentStorageProvider,
    ),
  );

});

final momentsProvider =
AsyncNotifierProvider<MomentsNotifier, List<Moment>>(
  MomentsNotifier.new,
);

class MomentsNotifier
    extends AsyncNotifier<List<Moment>> {


  late final MomentRepository _repository;



  @override
  Future<List<Moment>> build() async {

    _repository =
        ref.read(
          momentRepositoryProvider,
        );


    return _repository.getMoments();

  }


  Future<void> refresh() async {

    state =
    const AsyncLoading();



    state = await AsyncValue.guard(
            () async {
          return _repository.getMoments();
        },

    );
  }

  Future<void> createMoment({

    required Moment moment,

    required List<String> imagePaths,


  }) async {


    await _repository.createMoment(

      moment: moment,

      imagePaths: imagePaths,

    );


    await refresh();

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
                (moment) =>
            moment.id != id,
          )
              .toList(),
        );


    try {


      await _repository.deleteMoment(
        id,
      );


    } catch (error, stackTrace) {


      state =
          AsyncError(
            error,
            stackTrace,
          );


      await refresh();


    }

  }

  Future<void> toggleLike(
      Moment moment,
      ) async {


    final updated =
    await _repository.toggleLike(
      moment,
    );

    final current =
        state.value ?? [];

    state = AsyncData<List<Moment>>(
      current.map<Moment>(
            (item) {
          return item.id == updated.id
              ? updated
              : item;
        },
      ).toList(),
    );

  }

  Future<void> addReaction({

    required Moment moment,

    required String userId,

    required String emoji,

  }) async {

    final updated =
    await _repository.addReaction(

      moment: moment,

      userId: userId,

      emoji: emoji,

    );

    final current =
        state.value ?? [];

    state =
        AsyncData(
          current
              .map(
                (item) =>
            updated.id == item.id
                ? updated
                : item,
          )
              .toList(),
        );

  }

  Future<List<Moment>> search(
      String query,
      ) async {

    return _repository.searchMoments(
      query,
    );

  }

  Future<List<Moment>> getUserMoments(
      String userId,
      ) async {

    return _repository.getUserMoments(
      userId,
    );
  }

  Future<void> incrementComments(
      String momentId,
      ) async {

    final moments =
        state.value ?? [];


    final updatedMoments =
    moments.map(

          (moment) {

        if(moment.id != momentId) {
          return moment;
        }


        return moment.copyWith(

          commentsCount:
          moment.commentsCount + 1,

        );

      },

    ).toList();



    state =
        AsyncData(
          updatedMoments,
        );



    final updated =
    updatedMoments.firstWhere(
          (moment) =>
      moment.id == momentId,
    );



    await _repository.updateMoment(
      updated,
    );

  }

  Future<void> decrementComments(
      String momentId,
      ) async {

    final moments =
        state.value ?? [];


    final updatedMoments =
    moments.map(

          (moment) {

        if(moment.id != momentId) {
          return moment;
        }


        return moment.copyWith(

          commentsCount:
          moment.commentsCount > 0
              ? moment.commentsCount - 1
              : 0,

        );

      },

    ).toList();



    state =
        AsyncData(
          updatedMoments,
        );



    final updated =
    updatedMoments.firstWhere(
          (moment) =>
      moment.id == momentId,
    );



    await _repository.updateMoment(
      updated,
    );

  }

}