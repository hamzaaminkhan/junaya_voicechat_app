import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:junaya_voicechat_app/screens/moments/data/comment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/data/comment_repository.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/moments_provider.dart';
import 'package:junaya_voicechat_app/screens/moments/services/comment_storage.dart';






// ======================================================
// STORAGE
// ======================================================


final commentStorageProvider =

Provider<CommentStorage>((ref){


  return CommentStorage();


});








// ======================================================
// REPOSITORY
// ======================================================

final commentRepositoryProvider =

Provider<CommentRepository>((ref){


  return CommentRepository(

    storage:

    ref.watch(

      commentStorageProvider,

    ),

  );


});








// ======================================================
// STATE
// ======================================================


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



  late CommentRepository _repository;


  late String _momentId;









  @override
  Future<List<Comment>> build(

      String momentId,

      ) async {


    _momentId = momentId;



    _repository =

        ref.watch(

          commentRepositoryProvider,

        );



    return await _repository.getComments(

      momentId,

    );


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


        return await _repository.getComments(

          _momentId,

        );


      },

    );


  }









  // ======================================================
  // CREATE
  // ======================================================


  Future<void> addComment({

    required Comment comment,

  }) async {



    try {



      final created =

      await _repository.createComment(

        comment:

        comment,

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

          .updateComments(
        id: comment.momentId,
        increase: true,
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
  // UPDATE
  // ======================================================


  Future<void> updateComment(

      Comment comment,

      ) async {



    try {



      final updated =

      await _repository.updateComment(

        comment,

      );





      final current =

          state.value ?? [];





      state =

          AsyncData(

            current.map(

                  (item) =>

              item.id == updated.id

                  ?

              updated

                  :

              item,

            ).toList(),

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


  Future<void> deleteComment(

      Comment comment,

      ) async {



    final previous =

        state.value ?? [];





    state =

        AsyncData(

          previous.where(

                (item) =>

            item.id != comment.id,

          ).toList(),

        );





    try {



      await _repository.deleteComment(

        comment.id,

      );





      await ref

          .read(

        momentsProvider.notifier,

      )
          .updateComments(
        id: comment.momentId,
        increase: false,
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

      Comment comment,

      ) async {



    try {



      final updated =

      await _repository.toggleLike(

        comment,

      );





      final current =

          state.value ?? [];





      state =

          AsyncData(

            current.map(

                  (item) =>

              item.id == updated.id

                  ?

              updated

                  :

              item,

            ).toList(),

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



}