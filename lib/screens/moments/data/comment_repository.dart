import 'package:junaya_voicechat_app/screens/moments/data/comment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/services/comment_storage.dart';



class CommentRepository {

  final CommentStorage storage;



  CommentRepository({
    required this.storage,
  });







  Future<List<Comment>> getComments(
      String momentId,
      ) async {

    return storage.getMomentComments(
      momentId,
    );

  }









  Future<Comment> createComment({

    required Comment comment,

  }) async {


    return storage.createComment(
      comment,
    );

  }









  Future<Comment> updateComment(
      Comment comment,
      ) async {


    await storage.updateComment(
      comment,
    );


    return comment;

  }









  Future<void> deleteComment(
      String id,
      ) async {


    await storage.deleteComment(
      id,
    );

  }









  Future<Comment> toggleLike(
      Comment comment,
      ) async {


    final Comment updated =
    comment.copyWith(

      isLiked:
      !comment.isLiked,


      likesCount:

      comment.isLiked

          ?

      comment.likesCount - 1

          :

      comment.likesCount + 1,

    );



    await storage.updateComment(
      updated,
    );



    return updated;

  }









  Future<List<Comment>> searchComments({

    required String momentId,

    required String query,

  }) async {


    final comments =
    await getComments(
      momentId,
    );



    final String search =
    query.trim()
        .toLowerCase();



    if(search.isEmpty) {

      return comments;

    }



    return comments
        .where(
          (comment) {

        return comment.text
            .toLowerCase()
            .contains(
          search,
        );

      },
    )
        .toList();

  }









  Future<void> clearAll() async {

    await storage.clear();

  }


}