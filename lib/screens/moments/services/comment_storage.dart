import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:junaya_voicechat_app/screens/moments/data/comment_model.dart';



class CommentStorage {

  static const String _storageKey =
      'junaya_comments_v1';



  final SharedPreferencesAsync _preferences =
  SharedPreferencesAsync();





  Future<Comment> createComment(
      Comment comment,
      ) async {


    final List<Comment> comments =
    await loadComments();



    await _writeComments(
      [
        comment,
        ...comments,
      ],
    );



    return comment;

  }







  Future<List<Comment>> loadComments() async {


    final String? raw =
    await _preferences.getString(
      _storageKey,
    );



    if(raw == null || raw.isEmpty) {

      return [];

    }



    try {


      final dynamic decoded =
      jsonDecode(raw);



      if(decoded is! List) {

        return [];

      }



      final List<Comment> comments =
      decoded
          .whereType<Map>()
          .map(
            (item) =>
            Comment.fromJson(
              Map<String, dynamic>.from(
                item,
              ),
            ),
      )
          .toList();



      comments.sort(
            (a, b) =>
            b.createdAt.compareTo(
              a.createdAt,
            ),
      );



      return comments;


    } catch (_) {


      return [];


    }

  }









  Future<List<Comment>> getMomentComments(
      String momentId,
      ) async {


    final comments =
    await loadComments();



    return comments
        .where(
          (comment) =>
      comment.momentId == momentId,
    )
        .toList();

  }









  Future<void> updateComment(
      Comment updated,
      ) async {


    final List<Comment> comments =
    await loadComments();



    final int index =
    comments.indexWhere(
          (comment) =>
      comment.id == updated.id,
    );



    if(index == -1) {

      throw Exception(
        "Comment not found",
      );

    }



    comments[index] =
        updated;



    await _writeComments(
      comments,
    );

  }









  Future<void> deleteComment(
      String id,
      ) async {


    final comments =
    await loadComments();



    comments.removeWhere(
          (comment) =>
      comment.id == id,
    );



    await _writeComments(
      comments,
    );

  }









  Future<void> clear() async {

    await _preferences.remove(
      _storageKey,
    );

  }









  Future<void> _writeComments(
      List<Comment> comments,
      ) async {


    final String encoded =
    jsonEncode(

      comments
          .map(
            (comment) =>
            comment.toJson(),
      )
          .toList(),

    );



    await _preferences.setString(
      _storageKey,
      encoded,
    );

  }

}