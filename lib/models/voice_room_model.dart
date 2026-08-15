enum RoomSeatStatus { empty, occupied, locked }

class RoomUser {
  final String id;
  final String name;
  final String? avatar;
  final bool isHost;
  final bool isAdmin;
  final bool isMuted;
  final bool isSpeaking;

  const RoomUser({
    required this.id,
    required this.name,
    this.avatar,
    this.isHost = false,
    this.isAdmin = false,
    this.isMuted = false,
    this.isSpeaking = false,
  });

  RoomUser copyWith({
    String? id,
    String? name,
    String? avatar,
    bool? isHost,
    bool? isAdmin,
    bool? isMuted,
    bool? isSpeaking,
  }) {
    return RoomUser(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      isHost: isHost ?? this.isHost,
      isAdmin: isAdmin ?? this.isAdmin,
      isMuted: isMuted ?? this.isMuted,
      isSpeaking: isSpeaking ?? this.isSpeaking,
    );
  }

  factory RoomUser.fromJson(Map<String, dynamic> json) {
    return RoomUser(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'User',
      avatar: json['avatar']?.toString(),
      isHost: json['isHost'] == true,
      isAdmin: json['isAdmin'] == true,
      isMuted: json['isMuted'] == true,
      isSpeaking: json['isSpeaking'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'isHost': isHost,
      'isAdmin': isAdmin,
      'isMuted': isMuted,
      'isSpeaking': isSpeaking,
    };
  }
}

class RoomSeat {
  final int number;
  final RoomSeatStatus status;
  final RoomUser? user;

  const RoomSeat({
    required this.number,
    this.status = RoomSeatStatus.empty,
    this.user,
  });

  bool get isEmpty => status == RoomSeatStatus.empty;
  bool get isOccupied => status == RoomSeatStatus.occupied && user != null;
  bool get isLocked => status == RoomSeatStatus.locked;

  RoomSeat copyWith({
    int? number,
    RoomSeatStatus? status,
    RoomUser? user,
    bool removeUser = false,
  }) {
    return RoomSeat(
      number: number ?? this.number,
      status: status ?? this.status,
      user: removeUser ? null : user ?? this.user,
    );
  }

  factory RoomSeat.fromJson(Map<String, dynamic> json) {
    final rawStatus = json['status']?.toString() ?? 'empty';

    RoomSeatStatus parsedStatus;
    switch (rawStatus) {
      case 'occupied':
        parsedStatus = RoomSeatStatus.occupied;
        break;
      case 'locked':
        parsedStatus = RoomSeatStatus.locked;
        break;
      default:
        parsedStatus = RoomSeatStatus.empty;
    }

    final rawNumber = json['number'];
    final seatNumber = rawNumber is int
        ? rawNumber
        : int.tryParse(rawNumber?.toString() ?? '') ?? 1;

    return RoomSeat(
      number: seatNumber,
      status: parsedStatus,
      user: json['user'] is Map
          ? RoomUser.fromJson(Map<String, dynamic>.from(json['user'] as Map))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'status': status.name,
      'user': user?.toJson(),
    };
  }
}

class VoiceRoom {
  final String id;
  final String name;
  final String ownerId;
  final String announcement;
  final int onlineUsers;
  final int roomRank;
  final List<RoomSeat> seats;
  final List<RoomUser> members;

  const VoiceRoom({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.announcement,
    required this.onlineUsers,
    required this.roomRank,
    required this.seats,
    this.members = const [],
  });

  VoiceRoom copyWith({
    String? id,
    String? name,
    String? ownerId,
    String? announcement,
    int? onlineUsers,
    int? roomRank,
    List<RoomSeat>? seats,
    List<RoomUser>? members,
  }) {
    return VoiceRoom(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      announcement: announcement ?? this.announcement,
      onlineUsers: onlineUsers ?? this.onlineUsers,
      roomRank: roomRank ?? this.roomRank,
      seats: seats ?? this.seats,
      members: members ?? this.members,
    );
  }

  factory VoiceRoom.fromJson(Map<String, dynamic> json) {
    final rawOnline = json['onlineUsers'];
    final rawRank = json['roomRank'];

    return VoiceRoom(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Junaya Voice Room',
      ownerId: json['ownerId']?.toString() ?? '',
      announcement: json['announcement']?.toString() ?? 'Welcome to Junaya.',
      onlineUsers: rawOnline is int
          ? rawOnline
          : int.tryParse(rawOnline?.toString() ?? '') ?? 0,
      roomRank: rawRank is int
          ? rawRank
          : int.tryParse(rawRank?.toString() ?? '') ?? 0,
      seats: (json['seats'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((item) => RoomSeat.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
      members: (json['members'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((item) => RoomUser.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ownerId': ownerId,
      'announcement': announcement,
      'onlineUsers': onlineUsers,
      'roomRank': roomRank,
      'seats': seats.map((seat) => seat.toJson()).toList(),
      'members': members.map((user) => user.toJson()).toList(),
    };
  }
}
