class HostModel {
  final String id;
  final String name;
  final String avatar;
  final String bio;
  final int followers;
  final bool isLive;
  final int viewers;

  HostModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.bio,
    required this.followers,
    required this.isLive,
    required this.viewers,
  });

  factory HostModel.fromMap(Map<String, dynamic> map, String id) {
    return HostModel(
      id: id,
      name: map['name'] ?? '',
      avatar: map['avatar'] ?? '',
      bio: map['bio'] ?? '',
      followers: map['followers'] ?? 0,
      isLive: map['isLive'] ?? false,
      viewers: map['viewers'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'avatar': avatar,
      'bio': bio,
      'followers': followers,
      'isLive': isLive,
      'viewers': viewers,
    };
  }

  HostModel copyWith({
    String? id,
    String? name,
    String? avatar,
    String? bio,
    int? followers,
    bool? isLive,
    int? viewers,
  }) {
    return HostModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      isLive: isLive ?? this.isLive,
      viewers: viewers ?? this.viewers,
    );
  }
}
