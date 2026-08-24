import 'package:flutter/foundation.dart';


enum MomentMediaType {
  image,
  video,
}


enum MomentVisibility {
  public,
  friends,
  private,
}


class MomentUser {
  final String id;
  final String username;
  final String displayName;
  final String avatar;

  const MomentUser({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatar,
  });


  factory MomentUser.empty() {
    return const MomentUser(
      id: '',
      username: '',
      displayName: '',
      avatar: '',
    );
  }


  factory MomentUser.fromJson(Map<String, dynamic> json) {
    return MomentUser(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      displayName: json['displayName'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'avatar': avatar,
    };
  }
}



class MomentMedia {

  final String id;

  /// Local path or network URL
  final String url;

  final MomentMediaType type;

  final int order;


  const MomentMedia({
    required this.id,
    required this.url,
    required this.type,
    required this.order,
  });



  factory MomentMedia.image({
    required String url,
    int order = 0,
  }) {
    return MomentMedia(
      id: UniqueKey().toString(),
      url: url,
      type: MomentMediaType.image,
      order: order,
    );
  }



  factory MomentMedia.video({
    required String url,
    int order = 0,
  }) {
    return MomentMedia(
      id: UniqueKey().toString(),
      url: url,
      type: MomentMediaType.video,
      order: order,
    );
  }



  factory MomentMedia.fromJson(
      Map<String, dynamic> json,
      ) {

    return MomentMedia(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      type: MomentMediaType.values.firstWhere(
            (e) =>
        e.name == json['type'],
        orElse: () =>
        MomentMediaType.image,
      ),
      order: json['order'] ?? 0,
    );
  }



  Map<String,dynamic> toJson(){

    return {
      'id': id,
      'url': url,
      'type': type.name,
      'order': order,
    };

  }

}




class MomentReaction {

  final String userId;

  final String emoji;


  const MomentReaction({
    required this.userId,
    required this.emoji,
  });



  factory MomentReaction.fromJson(
      Map<String,dynamic> json){

    return MomentReaction(
      userId: json['userId'] ?? '',
      emoji: json['emoji'] ?? '❤️',
    );
  }



  Map<String,dynamic> toJson(){

    return {
      'userId':userId,
      'emoji':emoji,
    };

  }

}




class Moment {

  final String id;


  final MomentUser author;


  final String caption;


  final List<MomentMedia> media;


  final DateTime createdAt;


  final DateTime? updatedAt;


  final MomentVisibility visibility;


  final String? location;


  final List<String> hashtags;


  final int likesCount;


  final int commentsCount;


  final bool isLiked;


  final List<MomentReaction> reactions;


  final bool isPinned;



  const Moment({

    required this.id,

    required this.author,

    required this.caption,

    required this.media,

    required this.createdAt,

    this.updatedAt,

    required this.visibility,

    this.location,

    required this.hashtags,

    required this.likesCount,

    required this.commentsCount,

    required this.isLiked,

    required this.reactions,

    required this.isPinned,

  });




  factory Moment.empty(){

    return Moment(

      id: '',

      author: MomentUser.empty(),

      caption: '',

      media: const [],

      createdAt: DateTime.now(),

      visibility: MomentVisibility.public,

      hashtags: const [],

      likesCount: 0,

      commentsCount: 0,

      isLiked: false,

      reactions: const [],

      isPinned: false,

    );

  }





  factory Moment.fromJson(
      Map<String,dynamic> json){

    return Moment(

      id: json['id'] ?? '',


      author:
      MomentUser.fromJson(
        json['author'] ?? {},
      ),


      caption:
      json['caption'] ?? '',


      media:
      (json['media'] as List<dynamic>? ?? [])
          .map(
            (e)=>
            MomentMedia.fromJson(e),
      )
          .toList(),


      createdAt:
      DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      )
          ?? DateTime.now(),



      updatedAt:
      json['updatedAt'] != null
          ?
      DateTime.parse(
        json['updatedAt'],
      )
          :
      null,



      visibility:
      MomentVisibility.values.firstWhere(
            (e)=>
        e.name ==
            json['visibility'],
        orElse:
            ()=>MomentVisibility.public,
      ),



      location:
      json['location'],



      hashtags:
      List<String>.from(
        json['hashtags'] ?? [],
      ),



      likesCount:
      json['likesCount'] ?? 0,



      commentsCount:
      json['commentsCount'] ?? 0,



      isLiked:
      json['isLiked'] ?? false,



      reactions:
      (json['reactions'] as List<dynamic>? ?? [])
          .map(
              (e)=>
              MomentReaction.fromJson(e)
      )
          .toList(),



      isPinned:
      json['isPinned'] ?? false,

    );

  }






  Map<String,dynamic> toJson(){

    return {

      'id':id,


      'author':
      author.toJson(),


      'caption':
      caption,


      'media':
      media
          .map(
              (e)=>e.toJson()
      )
          .toList(),



      'createdAt':
      createdAt.toIso8601String(),



      'updatedAt':
      updatedAt
          ?.toIso8601String(),



      'visibility':
      visibility.name,



      'location':
      location,



      'hashtags':
      hashtags,



      'likesCount':
      likesCount,



      'commentsCount':
      commentsCount,



      'isLiked':
      isLiked,



      'reactions':
      reactions
          .map(
              (e)=>e.toJson()
      )
          .toList(),



      'isPinned':
      isPinned,

    };

  }




  Moment copyWith({

    String? caption,

    List<MomentMedia>? media,

    int? likesCount,

    int? commentsCount,

    bool? isLiked,

    List<MomentReaction>? reactions,

    bool? isPinned,

    MomentVisibility? visibility,

    String? location,

    List<String>? hashtags,

  }) {

    return Moment(

      id:id,

      author:author,

      caption:
      caption ?? this.caption,

      media:
      media ?? this.media,

      createdAt:
      createdAt,

      updatedAt:
      DateTime.now(),

      visibility:
      visibility ?? this.visibility,


      location:
      location ?? this.location,


      hashtags:
      hashtags ?? this.hashtags,

      likesCount:
      likesCount ?? this.likesCount,

      commentsCount:
      commentsCount ?? this.commentsCount,

      isLiked:
      isLiked ?? this.isLiked,

      reactions:
      reactions ?? this.reactions,

      isPinned:
      isPinned ?? this.isPinned,

    );

  }


}