import 'dart:collection';


// =====================================================
// ENUMS
// =====================================================


enum MomentMediaType {
  image,
  video,
}


enum MomentVisibility {
  public,
  friends,
  private,
}



// =====================================================
// USER
// =====================================================


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



  factory MomentUser.empty(){

    return const MomentUser(

      id:'',

      username:'',

      displayName:'',

      avatar:'',

    );

  }




  factory MomentUser.fromJson(
      Map<String,dynamic> json
      ){

    return MomentUser(

      id:
      json['id']?.toString() ?? '',


      username:
      json['username']?.toString() ?? '',


      displayName:
      json['displayName']?.toString() ?? '',


      avatar:
      json['avatar']?.toString() ?? '',

    );

  }




  Map<String,dynamic> toJson(){

    return {

      'id':id,

      'username':username,

      'displayName':displayName,

      'avatar':avatar,

    };

  }





  MomentUser copyWith({

    String? id,

    String? username,

    String? displayName,

    String? avatar,

  }){

    return MomentUser(

      id:
      id ?? this.id,


      username:
      username ?? this.username,


      displayName:
      displayName ?? this.displayName,


      avatar:
      avatar ?? this.avatar,

    );

  }

}





// =====================================================
// MEDIA
// =====================================================


class MomentMedia {


  final String id;


  final String url;


  final String? thumbnail;


  final MomentMediaType type;


  final int order;


  final int size;


  final String mimeType;


  final int? durationSeconds;




  const MomentMedia({

    required this.id,

    required this.url,

    required this.type,

    required this.order,

    this.thumbnail,

    this.size = 0,

    this.mimeType = '',

    this.durationSeconds,

  });





  factory MomentMedia.image({

    required String url,

    int order = 0,

    String mimeType = 'image/jpeg',

  }){


    return MomentMedia(

      id:
      generateId(),


      url:
      url,


      type:
      MomentMediaType.image,


      order:
      order,


      mimeType:
      mimeType,

    );

  }






  factory MomentMedia.video({

    required String url,

    int order = 0,

    String mimeType = 'video/mp4',

  }){


    return MomentMedia(

      id:
      generateId(),


      url:
      url,


      type:
      MomentMediaType.video,


      order:
      order,


      mimeType:
      mimeType,

    );

  }







  factory MomentMedia.fromJson(
      Map<String,dynamic> json
      ){

    return MomentMedia(

      id:
      json['id']?.toString() ?? '',


      url:
      json['url']?.toString() ?? '',


      thumbnail:
      json['thumbnail'],


      type:

      MomentMediaType.values.firstWhere(

            (e)=>

        e.name ==
            json['type'],

        orElse:
            ()=>MomentMediaType.image,

      ),



      order:
      json['order'] ?? 0,



      size:
      json['size'] ?? 0,



      mimeType:
      json['mimeType'] ?? '',



      durationSeconds:
      json['durationSeconds'],

    );

  }






  Map<String,dynamic> toJson(){

    return {

      'id':id,

      'url':url,

      'thumbnail':thumbnail,

      'type':type.name,

      'order':order,

      'size':size,

      'mimeType':mimeType,

      'durationSeconds':
      durationSeconds,

    };

  }







  MomentMedia copyWith({

    String? id,

    String? url,

    String? thumbnail,

    MomentMediaType? type,

    int? order,

    int? size,

    String? mimeType,

    int? durationSeconds,

  }){


    return MomentMedia(

      id:
      id ?? this.id,


      url:
      url ?? this.url,


      thumbnail:
      thumbnail ?? this.thumbnail,


      type:
      type ?? this.type,


      order:
      order ?? this.order,


      size:
      size ?? this.size,


      mimeType:
      mimeType ?? this.mimeType,


      durationSeconds:
      durationSeconds ?? this.durationSeconds,

    );

  }

}






// =====================================================
// REACTION
// =====================================================


class MomentReaction {


  final String userId;


  final String emoji;



  const MomentReaction({

    required this.userId,

    required this.emoji,

  });





  factory MomentReaction.fromJson(
      Map<String,dynamic> json
      ){

    return MomentReaction(

      userId:
      json['userId'] ?? '',


      emoji:
      json['emoji'] ?? '❤️',

    );

  }





  Map<String,dynamic> toJson(){

    return {

      'userId':
      userId,


      'emoji':
      emoji,

    };

  }

}






// =====================================================
// STATS
// =====================================================


class MomentStats {


  final int likes;


  final int comments;


  final int shares;


  final int views;


  final int saves;




  const MomentStats({

    this.likes = 0,

    this.comments = 0,

    this.shares = 0,

    this.views = 0,

    this.saves = 0,

  });






  MomentStats copyWith({

    int? likes,

    int? comments,

    int? shares,

    int? views,

    int? saves,

  }){


    return MomentStats(

      likes:
      likes ?? this.likes,


      comments:
      comments ?? this.comments,


      shares:
      shares ?? this.shares,


      views:
      views ?? this.views,


      saves:
      saves ?? this.saves,

    );

  }






  factory MomentStats.fromJson(
      Map<String,dynamic> json
      ){

    return MomentStats(

      likes:
      json['likes'] ?? 0,


      comments:
      json['comments'] ?? 0,


      shares:
      json['shares'] ?? 0,


      views:
      json['views'] ?? 0,


      saves:
      json['saves'] ?? 0,

    );

  }






  Map<String,dynamic> toJson(){

    return {

      'likes':likes,

      'comments':comments,

      'shares':shares,

      'views':views,

      'saves':saves,

    };

  }

}






// =====================================================
// MOMENT
// =====================================================


class Moment {


  final String id;


  final MomentUser author;


  final String caption;


  final UnmodifiableListView<MomentMedia> media;


  final DateTime createdAt;


  final DateTime? updatedAt;


  final MomentVisibility visibility;


  final String? location;


  final UnmodifiableListView<String> hashtags;


  final MomentStats stats;


  final bool isLiked;


  final UnmodifiableListView<MomentReaction> reactions;


  final bool isPinned;






  Moment({

    required this.id,

    required this.author,

    required this.caption,

    required List<MomentMedia> media,

    required this.createdAt,

    this.updatedAt,

    required this.visibility,

    this.location,

    required List<String> hashtags,

    required this.stats,

    required this.isLiked,

    required List<MomentReaction> reactions,

    required this.isPinned,

  })

      :

        media =
        UnmodifiableListView(media),


        hashtags =
        UnmodifiableListView(hashtags),


        reactions =
        UnmodifiableListView(reactions);








  factory Moment.empty(){

    return Moment(

      id:'',

      author:
      MomentUser.empty(),

      caption:'',

      media:const [],

      createdAt:
      DateTime.now(),

      visibility:
      MomentVisibility.public,

      hashtags:const [],

      stats:
      const MomentStats(),

      isLiked:false,

      reactions:const [],

      isPinned:false,

    );

  }







  factory Moment.fromJson(
      Map<String,dynamic> json
      ){

    return Moment(

      id:
      json['id'] ?? '',



      author:

      MomentUser.fromJson(
          json['author'] ?? {}
      ),



      caption:
      json['caption'] ?? '',



      media:

      (json['media'] as List? ?? [])

          .map(
              (e)=>
              MomentMedia.fromJson(e)
      )

          .toList(),




      createdAt:

      DateTime.tryParse(

        json['createdAt']
            ?.toString() ?? '',

      )

          ??

          DateTime.now(),




      updatedAt:

      DateTime.tryParse(

        json['updatedAt']
            ?.toString() ?? '',

      ),




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

          json['hashtags'] ?? []

      ),




      stats:

      MomentStats.fromJson(

          json['stats'] ?? {}

      ),




      isLiked:

      json['isLiked'] ?? false,




      reactions:

      (json['reactions'] as List? ?? [])

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

      updatedAt?.toIso8601String(),



      'visibility':

      visibility.name,



      'location':

      location,



      'hashtags':

      hashtags,



      'stats':

      stats.toJson(),



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

    DateTime? updatedAt,

    MomentVisibility? visibility,

    String? location,

    List<String>? hashtags,

    MomentStats? stats,

    bool? isLiked,

    List<MomentReaction>? reactions,

    bool? isPinned,

  }){


    return Moment(

      id:
      id,


      author:
      author,


      caption:
      caption ?? this.caption,


      media:
      media ?? this.media,


      createdAt:
      createdAt,


      updatedAt:
      updatedAt ?? DateTime.now(),



      visibility:
      visibility ?? this.visibility,



      location:
      location ?? this.location,



      hashtags:
      hashtags ?? this.hashtags,



      stats:
      stats ?? this.stats,



      isLiked:
      isLiked ?? this.isLiked,



      reactions:
      reactions ?? this.reactions,



      isPinned:
      isPinned ?? this.isPinned,

    );

  }







  bool get hasMedia =>
      media.isNotEmpty;




  bool get hasVideo =>

      media.any(

              (item)=>

          item.type ==
              MomentMediaType.video

      );






  @override
  bool operator ==(Object other){

    return identical(this, other)

        ||

        other is Moment

            && other.id == id;

  }



  @override
  int get hashCode =>
      id.hashCode;

}

String generateId(){

  return DateTime.now()
      .microsecondsSinceEpoch
      .toString();

}