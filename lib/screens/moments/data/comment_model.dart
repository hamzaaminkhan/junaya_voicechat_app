class Comment {

  final String id;

  final String momentId;

  final CommentUser author;

  final String text;

  final DateTime createdAt;

  final DateTime? updatedAt;

  final int likesCount;

  final bool isLiked;

  final String? parentId;



  const Comment({

    required this.id,

    required this.momentId,

    required this.author,

    required this.text,

    required this.createdAt,

    this.updatedAt,

    required this.likesCount,

    required this.isLiked,

    this.parentId,

  });





  factory Comment.empty() {

    return Comment(

      id: '',

      momentId: '',

      author:
      CommentUser.empty(),

      text: '',

      createdAt:
      DateTime.now(),

      likesCount: 0,

      isLiked: false,

    );

  }






  factory Comment.fromJson(
      Map<String, dynamic> json,
      ) {

    return Comment(

      id:
      json['id'] ?? '',


      momentId:
      json['momentId'] ?? '',


      author:
      CommentUser.fromJson(
        json['author'] ?? {},
      ),


      text:
      json['text'] ?? '',


      createdAt:
      DateTime.tryParse(
        json['createdAt'] ?? '',
      )
          ??
          DateTime.now(),



      updatedAt:
      json['updatedAt'] != null
          ? DateTime.tryParse(
        json['updatedAt'],
      )
          : null,



      likesCount:
      json['likesCount'] ?? 0,



      isLiked:
      json['isLiked'] ?? false,



      parentId:
      json['parentId'],

    );

  }







  Map<String, dynamic> toJson() {

    return {

      'id':
      id,


      'momentId':
      momentId,


      'author':
      author.toJson(),


      'text':
      text,


      'createdAt':
      createdAt.toIso8601String(),


      'updatedAt':
      updatedAt
          ?.toIso8601String(),


      'likesCount':
      likesCount,


      'isLiked':
      isLiked,


      'parentId':
      parentId,

    };

  }







  Comment copyWith({

    String? text,

    int? likesCount,

    bool? isLiked,

    DateTime? updatedAt,

  }) {

    return Comment(

      id:
      id,


      momentId:
      momentId,


      author:
      author,


      text:
      text ?? this.text,


      createdAt:
      createdAt,


      updatedAt:
      updatedAt ?? DateTime.now(),


      likesCount:
      likesCount ?? this.likesCount,


      isLiked:
      isLiked ?? this.isLiked,


      parentId:
      parentId,

    );

  }

}







class CommentUser {

  final String id;

  final String username;

  final String displayName;

  final String avatar;



  const CommentUser({

    required this.id,

    required this.username,

    required this.displayName,

    required this.avatar,

  });






  factory CommentUser.empty() {

    return const CommentUser(

      id: '',

      username: '',

      displayName: '',

      avatar: '',

    );

  }







  factory CommentUser.fromJson(
      Map<String, dynamic> json,
      ) {

    return CommentUser(

      id:
      json['id'] ?? '',


      username:
      json['username'] ?? '',


      displayName:
      json['displayName'] ?? '',


      avatar:
      json['avatar'] ?? '',

    );

  }







  Map<String, dynamic> toJson() {

    return {

      'id':
      id,


      'username':
      username,


      'displayName':
      displayName,


      'avatar':
      avatar,

    };

  }

}