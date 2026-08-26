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


  final bool verified;


  final int followers;





  const MomentUser({


    required this.id,


    required this.username,


    required this.displayName,


    required this.avatar,


    this.verified = false,


    this.followers = 0,


  });









  factory MomentUser.empty(){


    return const MomentUser(


      id: '',


      username: '',


      displayName: '',


      avatar: '',


    );


  }









  factory MomentUser.fromJson(

      Map<String,dynamic> json,

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



      verified:

      json['verified'] ?? false,



      followers:

      json['followers'] ?? 0,



    );


  }









  Map<String,dynamic> toJson(){


    return {


      'id':

      id,



      'username':

      username,



      'displayName':

      displayName,



      'avatar':

      avatar,



      'verified':

      verified,



      'followers':

      followers,



    };


  }









  MomentUser copyWith({


    String? id,


    String? username,


    String? displayName,


    String? avatar,


    bool? verified,


    int? followers,



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



      verified:

      verified ?? this.verified,



      followers:

      followers ?? this.followers,



    );


  }



}









// =====================================================
// LOCATION
// =====================================================


class MomentLocation {


  final String name;


  final double? latitude;


  final double? longitude;





  const MomentLocation({


    required this.name,


    this.latitude,


    this.longitude,



  });









  factory MomentLocation.empty(){


    return const MomentLocation(

      name: '',

    );


  }









  factory MomentLocation.fromJson(

      Map<String,dynamic> json,

      ){



    return MomentLocation(


      name:

      json['name']?.toString() ?? '',



      latitude:

      (json['latitude'] as num?)

          ?.toDouble(),



      longitude:

      (json['longitude'] as num?)

          ?.toDouble(),



    );


  }









  Map<String,dynamic> toJson(){


    return {


      'name':

      name,



      'latitude':

      latitude,



      'longitude':

      longitude,



    };


  }









  MomentLocation copyWith({


    String? name,


    double? latitude,


    double? longitude,



  }){


    return MomentLocation(


      name:

      name ?? this.name,



      latitude:

      latitude ?? this.latitude,



      longitude:

      longitude ?? this.longitude,



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


  final bool uploaded;


  final double aspectRatio;





  const MomentMedia({


    required this.id,


    required this.url,


    required this.type,


    required this.order,


    this.thumbnail,


    this.size = 0,


    this.mimeType = '',


    this.durationSeconds,


    this.uploaded = false,


    this.aspectRatio = 1.0,



  });









  factory MomentMedia.image({


    required String url,


    int order = 0,


    String mimeType = 'image/jpeg',



    bool uploaded = false,



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



      uploaded:

      uploaded,



    );


  }









  factory MomentMedia.video({


    required String url,


    int order = 0,


    String mimeType = 'video/mp4',



    int? durationSeconds,



    bool uploaded = false,



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



      durationSeconds:

      durationSeconds,



      uploaded:

      uploaded,



    );


  }









  factory MomentMedia.fromJson(

      Map<String,dynamic> json,

      ){



    return MomentMedia(


      id:

      json['id']?.toString() ?? '',



      url:

      json['url']?.toString() ?? '',



      thumbnail:

      json['thumbnail']?.toString(),



      type:

      MomentMediaType.values.firstWhere(


            (item) =>

        item.name == json['type'],



        orElse:

            () => MomentMediaType.image,



      ),



      order:

      json['order'] ?? 0,



      size:

      json['size'] ?? 0,



      mimeType:

      json['mimeType']?.toString() ?? '',



      durationSeconds:

      json['durationSeconds'],



      uploaded:

      json['uploaded'] ?? false,



      aspectRatio:

      (json['aspectRatio'] as num?)

          ?.toDouble()

          ??

          1.0,



    );


  }









  Map<String,dynamic> toJson(){


    return {


      'id':

      id,



      'url':

      url,



      'thumbnail':

      thumbnail,



      'type':

      type.name,



      'order':

      order,



      'size':

      size,



      'mimeType':

      mimeType,



      'durationSeconds':

      durationSeconds,



      'uploaded':

      uploaded,



      'aspectRatio':

      aspectRatio,



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


    bool? uploaded,


    double? aspectRatio,



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



      uploaded:

      uploaded ?? this.uploaded,



      aspectRatio:

      aspectRatio ?? this.aspectRatio,



    );


  }


}

// =====================================================
// REACTION
// =====================================================


class MomentReaction {


  final String userId;


  final String emoji;


  final DateTime createdAt;





  const MomentReaction({


    required this.userId,


    required this.emoji,


    required this.createdAt,



  });









  factory MomentReaction.fromJson(

      Map<String,dynamic> json,

      ){


    return MomentReaction(


      userId:

      json['userId']?.toString() ?? '',



      emoji:

      json['emoji']?.toString() ?? '❤️',



      createdAt:

      DateTime.tryParse(

        json['createdAt']

            ?.toString()

            ??

            '',

      )

          ??

          DateTime.now(),



    );


  }









  Map<String,dynamic> toJson(){


    return {


      'userId':

      userId,



      'emoji':

      emoji,



      'createdAt':

      createdAt.toIso8601String(),



    };


  }









  MomentReaction copyWith({


    String? userId,


    String? emoji,


    DateTime? createdAt,



  }){


    return MomentReaction(


      userId:

      userId ?? this.userId,



      emoji:

      emoji ?? this.emoji,



      createdAt:

      createdAt ?? this.createdAt,

    );
  }
}

// =====================================================
// STATS
// =====================================================

class MomentStats {


  final int likes;

  final int comments;

  final int views;

  final int shares;



  const MomentStats({

    this.likes = 0,

    this.comments = 0,

    this.views = 0,

    this.shares = 0,

  });





  factory MomentStats.fromJson(
      Map<String,dynamic> json,
      ){

    return MomentStats(

      likes:
      json['likes'] ?? 0,


      comments:
      json['comments'] ?? 0,


      views:
      json['views'] ?? 0,


      shares:
      json['shares'] ?? 0,

    );

  }






  Map<String,dynamic> toJson(){

    return {

      'likes':
      likes,


      'comments':
      comments,


      'views':
      views,


      'shares':
      shares,

    };

  }






  MomentStats copyWith({

    int? likes,

    int? comments,

    int? views,

    int? shares,

  }){

    return MomentStats(

      likes:
      likes ?? this.likes,


      comments:
      comments ?? this.comments,


      views:
      views ?? this.views,


      shares:
      shares ?? this.shares,


    );

  }


}

// =====================================================
// VOICE ATTACHMENT
// =====================================================

class VoiceAttachment {


  final String id;


  final String url;


  final int durationSeconds;





  const VoiceAttachment({

    required this.id,

    required this.url,

    required this.durationSeconds,

  });






  factory VoiceAttachment.fromJson(
      Map<String,dynamic> json,
      ){

    return VoiceAttachment(

      id:
      json['id']?.toString() ?? '',


      url:
      json['url']?.toString() ?? '',


      durationSeconds:
      json['durationSeconds'] ?? 0,

    );

  }







  Map<String,dynamic> toJson(){

    return {

      'id':
      id,


      'url':
      url,


      'durationSeconds':
      durationSeconds,

    };

  }





  VoiceAttachment copyWith({

    String? id,

    String? url,

    int? durationSeconds,

  }){

    return VoiceAttachment(

      id:
      id ?? this.id,


      url:
      url ?? this.url,


      durationSeconds:
      durationSeconds ?? this.durationSeconds,

    );

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


  final MomentLocation? location;


  final UnmodifiableListView<String> hashtags;


  final MomentStats stats;


  final bool isLiked;


  final UnmodifiableListView<MomentReaction> reactions;


  final bool isPinned;

  final bool isSaved;


  final VoiceAttachment? voice;

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

    this.isSaved = false,

    this.voice,

  })  :
        media = UnmodifiableListView(media),

        hashtags = UnmodifiableListView(hashtags),

        reactions = UnmodifiableListView(reactions);




  factory Moment.empty(){


    return Moment(

      id:'',

      author:
      MomentUser.empty(),

      caption:'',

      media:
      const [],

      createdAt:
      DateTime.now(),

      visibility:
      MomentVisibility.public,

      hashtags:
      const [],

      stats:
      const MomentStats(),

      isLiked:
      false,

      reactions:
      const [],

      isPinned:
      false,

      isSaved:false,

    );


  }











  factory Moment.fromJson(

      Map<String,dynamic> json,

      ){



    return Moment(


      id:

      json['id']?.toString() ?? '',



      author:

      MomentUser.fromJson(

        json['author'] ?? {},

      ),



      caption:

      json['caption']?.toString() ?? '',



      media:


      (json['media'] as List? ?? [])


          .map(

              (item)=>

              MomentMedia.fromJson(

                Map<String,dynamic>.from(item),

              )

      )


          .toList(),



      createdAt:


      DateTime.tryParse(

        json['createdAt']?.toString() ?? '',

      )

          ??

          DateTime.now(),



      updatedAt:


      DateTime.tryParse(

        json['updatedAt']?.toString() ?? '',

      ),



      visibility:


      MomentVisibility.values.firstWhere(


            (item)=>

        item.name == json['visibility'],



        orElse:

            ()=> MomentVisibility.public,



      ),



      location:


      _parseLocation(

        json['location'],

      ),



      hashtags:


      List<String>.from(

        json['hashtags'] ?? [],

      ),



      stats:


      MomentStats.fromJson(

        json['stats'] ?? {},

      ),



      isLiked:

      json['isLiked'] ?? false,



      reactions:


      (json['reactions'] as List? ?? [])


          .map(

              (item)=>

              MomentReaction.fromJson(

                Map<String,dynamic>.from(item),

              )

      )


          .toList(),



      isPinned:

      json['isPinned'] ?? false,


      isSaved:

      json['isSaved'] ?? false,



      voice:


      json['voice'] != null

          ?

      VoiceAttachment.fromJson(

        json['voice'],

      )

          :

      null,



    );


  }









  Map<String,dynamic> toJson(){


    return {


      'id':

      id,



      'author':

      author.toJson(),



      'caption':

      caption,



      'media':


      media

          .map(

              (item)=>item.toJson()

      )

          .toList(),



      'createdAt':

      createdAt.toIso8601String(),



      'updatedAt':

      updatedAt?.toIso8601String(),



      'visibility':

      visibility.name,



      'location':

      location?.toJson(),



      'hashtags':

      hashtags,



      'stats':

      stats.toJson(),



      'isLiked':

      isLiked,



      'reactions':


      reactions

          .map(

              (item)=>item.toJson()

      )

          .toList(),



      'isPinned':

      isPinned,

      'isSaved':

      isSaved,



      'voice':

      voice?.toJson(),



    };


  }









  Moment copyWith({


    String? caption,


    List<MomentMedia>? media,


    DateTime? updatedAt,


    MomentVisibility? visibility,


    MomentLocation? location,


    List<String>? hashtags,


    MomentStats? stats,


    bool? isLiked,


    List<MomentReaction>? reactions,


    bool? isPinned,

    bool? isSaved,

    VoiceAttachment? voice,


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

      updatedAt ?? this.updatedAt,



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

      isSaved:

      isSaved ?? this.isSaved,



      voice:

      voice ?? this.voice,



    );


  }









  bool get hasMedia =>

      media.isNotEmpty;







  bool get hasVideo =>


      media.any(

              (item)=>

          item.type == MomentMediaType.video

      );







  bool get hasVoice =>

      voice != null;







  int get reactionCount =>

      reactions.length;







  String get timeAgo {


    final difference =

    DateTime.now()

        .difference(createdAt);



    if(difference.inMinutes < 60){

      return '${difference.inMinutes}m';

    }



    if(difference.inHours < 24){

      return '${difference.inHours}h';

    }



    return '${difference.inDays}d';


  }









  @override
  bool operator ==(Object other){


    return identical(this, other)

        ||

        other is Moment &&

            other.id == id;


  }







  @override
  int get hashCode =>

      id.hashCode;



}









// =====================================================
// HELPERS
// =====================================================


MomentLocation? _parseLocation(

    dynamic value,

    ){



  if(value == null){

    return null;

  }



  // Backward compatibility
  // old version stored String location


  if(value is String){


    return MomentLocation(

      name:value,

    );


  }



  if(value is Map){


    return MomentLocation.fromJson(

      Map<String,dynamic>.from(value),

    );


  }



  return null;


}









String generateId(){


  return DateTime.now()

      .microsecondsSinceEpoch

      .toString();


}