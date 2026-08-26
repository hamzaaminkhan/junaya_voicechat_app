import 'dart:collection';

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
  final bool verified;
  final int followers;
  final bool isOnline;
  final String bio;

  const MomentUser({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatar,
    this.verified = false,
    this.followers = 0,
    this.isOnline = false,
    this.bio = '',
  });

  factory MomentUser.empty() {
    return const MomentUser(
      id: '',
      username: '',
      displayName: '',
      avatar: '',
    );
  }

  factory MomentUser.fromJson(Map<String,dynamic> json) {
    return MomentUser(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '',
      verified: json['verified'] ?? false,
      followers: json['followers'] ?? 0,
      isOnline: json['isOnline'] ?? false,
      bio: json['bio']?.toString() ?? '',
    );
  }

  Map<String,dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'avatar': avatar,
      'verified': verified,
      'followers': followers,
      'isOnline': isOnline,
      'bio': bio,
    };
  }

  MomentUser copyWith({
    String? id,
    String? username,
    String? displayName,
    String? avatar,
    bool? verified,
    int? followers,
    bool? isOnline,
    String? bio,
  }) {
    return MomentUser(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatar: avatar ?? this.avatar,
      verified: verified ?? this.verified,
      followers: followers ?? this.followers,
      isOnline: isOnline ?? this.isOnline,
      bio: bio ?? this.bio,
    );
  }
}

class MomentLocation {
  final String name;
  final double? latitude;
  final double? longitude;

  const MomentLocation({
    required this.name,
    this.latitude,
    this.longitude,
  });

  factory MomentLocation.empty() {
    return const MomentLocation(
      name: '',
    );
  }

  factory MomentLocation.fromJson(Map<String,dynamic> json) {
    return MomentLocation(
      name: json['name']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String,dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  MomentLocation copyWith({
    String? name,
    double? latitude,
    double? longitude,
  }) {
    return MomentLocation(
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

class MomentMedia {
  final String id;
  final String localPath;
  final String? remoteUrl;
  final String? thumbnail;
  final MomentMediaType type;
  final int order;
  final int size;
  final String mimeType;
  final int? durationSeconds;
  final bool uploaded;
  final bool processing;
  final bool failed;
  final double uploadProgress;
  final double aspectRatio;

  const MomentMedia({
    required this.id,
    required this.localPath,
    required this.type,
    required this.order,
    this.remoteUrl,
    this.thumbnail,
    this.size = 0,
    this.mimeType = '',
    this.durationSeconds,
    this.uploaded = false,
    this.processing = false,
    this.failed = false,
    this.uploadProgress = 0,
    this.aspectRatio = 1,
  });

  String get displayUrl {
    if(uploaded && remoteUrl != null){
      return remoteUrl!;
    }
    return localPath;
  }

  factory MomentMedia.image({
    required String path,
    int order = 0,
  }) {
    return MomentMedia(
      id: generateId(),
      localPath: path,
      type: MomentMediaType.image,
      order: order,
      mimeType: 'image/jpeg',
    );
  }

  factory MomentMedia.video({
    required String path,
    int order = 0,
    int? durationSeconds,
  }) {
    return MomentMedia(
      id: generateId(),
      localPath: path,
      type: MomentMediaType.video,
      order: order,
      mimeType: 'video/mp4',
      durationSeconds: durationSeconds,
    );
  }

  factory MomentMedia.fromJson(
      Map<String,dynamic> json,
      ) {
    return MomentMedia(
      id:
      json['id']?.toString() ?? generateId(),

      localPath:
      json['localPath']?.toString() ?? '',

      remoteUrl:
      json['remoteUrl']?.toString(),

      thumbnail:
      json['thumbnail']?.toString(),

      type:
      MomentMediaType.values.firstWhere(
            (item)=>
        item.name == json['type'],
        orElse:
            ()=>MomentMediaType.image,
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

      processing:
      json['processing'] ?? false,

      failed:
      json['failed'] ?? false,

      uploadProgress:
      (json['uploadProgress'] ?? 0).toDouble(),

      aspectRatio:
      (json['aspectRatio'] ?? 1).toDouble(),
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id': id,
      'localPath': localPath,
      'remoteUrl': remoteUrl,
      'thumbnail': thumbnail,
      'type': type.name,
      'order': order,
      'size': size,
      'mimeType': mimeType,
      'durationSeconds': durationSeconds,
      'uploaded': uploaded,
      'processing': processing,
      'failed': failed,
      'uploadProgress': uploadProgress,
      'aspectRatio': aspectRatio,
    };
  }

  MomentMedia copyWith({
    String? localPath,
    String? remoteUrl,
    String? thumbnail,
    bool? uploaded,
    bool? processing,
    bool? failed,
    double? uploadProgress,
  }) {
    return MomentMedia(
      id: id,
      localPath: localPath ?? this.localPath,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      thumbnail: thumbnail ?? this.thumbnail,
      type: type,
      order: order,
      size: size,
      mimeType: mimeType,
      durationSeconds: durationSeconds,
      uploaded: uploaded ?? this.uploaded,
      processing: processing ?? this.processing,
      failed: failed ?? this.failed,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      aspectRatio: aspectRatio,
    );
  }
}

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
      ) {
    return MomentReaction(
      userId:
      json['userId']?.toString() ?? '',

      emoji:
      json['emoji']?.toString() ?? '',

      createdAt:
      DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ) ??
          DateTime.now(),
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'userId': userId,
      'emoji': emoji,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

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

  factory MomentStats.empty(){
    return const MomentStats();
  }

  factory MomentStats.fromJson(
      Map<String,dynamic> json,
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
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'views': views,
      'saves': saves,
    };
  }

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
}

class VoiceAttachment {
  final String id;
  final String url;
  final String? waveform;
  final int duration;
  final bool uploaded;

  const VoiceAttachment({
    required this.id,
    required this.url,
    this.waveform,
    this.duration = 0,
    this.uploaded = false,
  });

  factory VoiceAttachment.fromJson(
      Map<String,dynamic> json,
      ){
    return VoiceAttachment(
      id:
      json['id']?.toString() ?? '',

      url:
      json['url']?.toString() ?? '',

      waveform:
      json['waveform']?.toString(),

      duration:
      json['duration'] ?? 0,

      uploaded:
      json['uploaded'] ?? false,
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id': id,
      'url': url,
      'waveform': waveform,
      'duration': duration,
      'uploaded': uploaded,
    };
  }

  VoiceAttachment copyWith({
    String? url,
    String? waveform,
    int? duration,
    bool? uploaded,
  }){
    return VoiceAttachment(
      id: id,
      url:
      url ?? this.url,

      waveform:
      waveform ?? this.waveform,

      duration:
      duration ?? this.duration,

      uploaded:
      uploaded ?? this.uploaded,
    );
  }
}

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
  final bool isSaved;
  final bool isPinned;
  final UnmodifiableListView<MomentReaction> reactions;
  final VoiceAttachment? voice;
  final String? music;

  Moment({
    required this.id,
    required this.author,
    required this.caption,
    required List<MomentMedia> media,
    required this.createdAt,
    this.updatedAt,
    this.visibility = MomentVisibility.public,
    this.location,
    required List<String> hashtags,
    this.stats = const MomentStats(),
    this.isLiked = false,
    this.isSaved = false,
    this.isPinned = false,
    required List<MomentReaction> reactions,
    this.voice,
    this.music,
  }) :
        media = UnmodifiableListView(media),
        hashtags = UnmodifiableListView(hashtags),
        reactions = UnmodifiableListView(reactions);

  factory Moment.empty(){
    return Moment(
      id: generateId(),
      author: MomentUser.empty(),
      caption: '',
      media: const [],
      createdAt: DateTime.now(),
      hashtags: const [],
      reactions: const [],
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
        Map<String,dynamic>.from(
          json['author'] ?? {},
        ),
      ),

      caption:
      json['caption']?.toString() ?? '',

      media:
      (json['media'] as List? ?? [])
          .map(
            (item)=>
            MomentMedia.fromJson(
              Map<String,dynamic>.from(item),
            ),
      )
          .toList(),

      createdAt:
      DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ) ??
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
            ()=>MomentVisibility.public,
      ),

      location:
      json['location'] == null
          ? null
          : MomentLocation.fromJson(
        Map<String,dynamic>.from(
          json['location'],
        ),
      ),

      hashtags:
      List<String>.from(
        json['hashtags'] ?? [],
      ),

      stats:
      MomentStats.fromJson(
        Map<String,dynamic>.from(
          json['stats'] ?? {},
        ),
      ),

      isLiked:
      json['isLiked'] ?? false,

      isSaved:
      json['isSaved'] ?? false,

      isPinned:
      json['isPinned'] ?? false,

      reactions:
      (json['reactions'] as List? ?? [])
          .map(
            (item)=>
            MomentReaction.fromJson(
              Map<String,dynamic>.from(item),
            ),
      )
          .toList(),

      voice:
      json['voice'] == null
          ? null
          : VoiceAttachment.fromJson(
        Map<String,dynamic>.from(
          json['voice'],
        ),
      ),

      music:
      json['music']?.toString(),
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id': id,
      'author': author.toJson(),
      'caption': caption,
      'media':
      media
          .map(
            (item)=>item.toJson(),
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
      'isSaved':
      isSaved,
      'isPinned':
      isPinned,
      'reactions':
      reactions
          .map(
            (item)=>item.toJson(),
      )
          .toList(),
      'voice':
      voice?.toJson(),
      'music':
      music,
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
    bool? isSaved,
    bool? isPinned,
    List<MomentReaction>? reactions,
    VoiceAttachment? voice,
    String? music,
  }){
    return Moment(
      id: id,
      author: author,
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
      isSaved:
      isSaved ?? this.isSaved,
      isPinned:
      isPinned ?? this.isPinned,
      reactions:
      reactions ?? this.reactions,
      voice:
      voice ?? this.voice,
      music:
      music ?? this.music,
    );
  }

  bool get hasMedia =>
      media.isNotEmpty;

  bool get hasVideo =>
      media.any(
            (item)=>
        item.type == MomentMediaType.video,
      );

  bool get hasVoice =>
      voice != null;

  int get reactionCount =>
      reactions.length;

  bool get isPublic =>
      visibility == MomentVisibility.public;

  String get timeAgo {
    final diff =
    DateTime.now()
        .difference(createdAt);

    if(diff.inMinutes < 1){
      return "now";
    }

    if(diff.inHours < 1){
      return "${diff.inMinutes}m";
    }

    if(diff.inDays < 1){
      return "${diff.inHours}h";
    }

    return "${diff.inDays}d";
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

String generateId(){
  return DateTime.now()
      .microsecondsSinceEpoch
      .toString();
}