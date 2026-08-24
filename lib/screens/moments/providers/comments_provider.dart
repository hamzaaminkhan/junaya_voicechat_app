import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:junaya_voicechat_app/screens/moments/data/comment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/data/comment_repository.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/moments_provider.dart';
import 'package:junaya_voicechat_app/screens/moments/services/comment_storage.dart';





final commentStorageProvider =
Provider<CommentStorage>((ref) {

  return CommentStorage();

});





final commentRepositoryProvider =
Provider<CommentRepository>((ref) {

  return CommentRepository(

    storage:
    ref.read(
      commentStorageProvider,
    ),

  );

});






final commentsProvider =
AsyncNotifierProvider.family<
    CommentsNotifier,
    List<Comment>,
    String
>(
  CommentsNotifier.new,
);







class CommentsNotifier
    extends FamilyAsyncNotifier<List<Comment>, String> {


  late final CommentRepository _repository;


  late String _momentId;





  @override
  Future<List<Comment>> build(
      String momentId,
      ) async {


    _momentId =
        momentId;


    _repository =
        ref.read(
          commentRepositoryProvider,
        );



    return _repository.getComments(
      momentId,
    );

  }








  Future<void> refresh() async {


    state =
    const AsyncLoading();



    state =
    await AsyncValue.guard(

          () async {

        return _repository.getComments(
          _momentId,
        );

      },

    );

  }









  Future<void> addComment({

    required Comment comment,

  }) async {


    final Comment created =
    await _repository.createComment(
      comment: comment,
    );



    final current =
        state.value ?? [];



    state =
        AsyncData(

          [

            created,

            ...current,

          ],

        );

    await ref
        .read(
      momentsProvider.notifier,
    )
        .incrementComments(
      comment.momentId,
    );


  }









  Future<void> updateComment(
      Comment comment,
      ) async {


    final updated =
    await _repository.updateComment(
      comment,
    );



    final current =
        state.value ?? [];



    state =
        AsyncData(

          current
              .map(

                (item) =>

            item.id == updated.id
                ? updated
                : item,

          )
              .toList(),

        );

  }









  Future<void> deleteComment(
      Comment comment,
      ) async {


    final current =
        state.value ?? [];



    state =
        AsyncData(

          current
              .where(
                (comment) =>
            comment.id != id,
          )
              .toList(),

        );



    try {


      Future<void> deleteComment(
          Comment comment,
          ) async {

        final current =
            state.value ?? [];


        state =
            AsyncData(

              current
                  .where(
                    (item) =>
                item.id != comment.id,
              )
                  .toList(),

            );


        try {

          await _repository.deleteComment(
            comment.id,
          );

          await ref
              .read(
            momentsProvider.notifier,
          )
              .decrementComments(
            comment.momentId,
          );


        } catch(error, stackTrace) {


          state =
              AsyncError(
                error,
                stackTrace,
              );


          await refresh();

        }

      }


    } catch(error, stackTrace) {


      state =
          AsyncError(
            error,
            stackTrace,
          );


      await refresh();

    }

  }









  Future<void> toggleLike(
      Comment comment,
      ) async {


    final updated =
    await _repository.toggleLike(
      comment,
    );



    final current =
        state.value ?? [];



    state =
        AsyncData(

          current
              .map(

                (item) =>

            item.id == updated.id
                ? updated
                : item,

          )
              .toList(),

        );

  }

}