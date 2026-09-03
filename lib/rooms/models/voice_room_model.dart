enum RoomSeatStatus {
  empty,
  occupied,
  locked,
}

class RoomUser {
  final String id;
  final String name;
  final String? avatar;
  final String? junayaId;
  final int vipLevel;
  final bool isHost;
  final bool isAdmin;
  final bool isMuted;
  final bool isSpeaking;

  const RoomUser({
    required this.id,
    required this.name,
    this.avatar,
    this.junayaId,
    this.vipLevel = 0,
    this.isHost = false,
    this.isAdmin = false,
    this.isMuted = false,
    this.isSpeaking = false,
  });

  RoomUser copyWith({
    String? id,
    String? name,
    String? avatar,
    String? junayaId,
    int? vipLevel,
    bool? isHost,
    bool? isAdmin,
    bool? isMuted,
    bool? isSpeaking,
  }) {
    return RoomUser(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      junayaId: junayaId ?? this.junayaId,
      vipLevel: vipLevel ?? this.vipLevel,
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
      junayaId: json['junayaId']?.toString(),
      vipLevel: _parseInt(json['vipLevel']),
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
      'junayaId': junayaId,
      'vipLevel': vipLevel,
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

  bool get isEmpty {
    return status == RoomSeatStatus.empty;
  }

  bool get isOccupied {
    return status == RoomSeatStatus.occupied && user != null;
  }

  bool get isLocked {
    return status == RoomSeatStatus.locked;
  }

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
    final rawStatus =
        json['status']?.toString().toLowerCase() ?? 'empty';

    RoomSeatStatus parsedStatus;

    switch (rawStatus) {
      case 'occupied':
        parsedStatus = RoomSeatStatus.occupied;
        break;

      case 'locked':
        parsedStatus = RoomSeatStatus.locked;
        break;

      case 'empty':
      default:
        parsedStatus = RoomSeatStatus.empty;
        break;
    }

    return RoomSeat(
      number: _parseInt(
        json['number'],
        fallback: 1,
      ),
      status: parsedStatus,
      user: json['user'] is Map
          ? RoomUser.fromJson(
        Map<String, dynamic>.from(
          json['user'] as Map,
        ),
      )
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

  /// Number of seats configured for this room.
  ///
  /// Allowed range: 1 - 25.
  final int seatCount;

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
    this.seatCount = 15,
    this.members = const [],
  });

  /// Returns the configured number of seats.
  int get totalSeats {
    return seatCount;
  }

  /// Returns the actual seat objects currently available.
  int get availableSeatObjects {
    return seats.length;
  }

  VoiceRoom copyWith({
    String? id,
    String? name,
    String? ownerId,
    String? announcement,
    int? onlineUsers,
    int? roomRank,
    int? seatCount,
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
      seatCount: seatCount ?? this.seatCount,
      seats: seats ?? this.seats,
      members: members ?? this.members,
    );
  }

  factory VoiceRoom.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawSeats = json['seats'];

    final parsedSeats = rawSeats is List
        ? rawSeats
        .whereType<Map>()
        .map(
          (item) => RoomSeat.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList()
        : <RoomSeat>[];

    final parsedSeatCount = _parseInt(
      json['seatCount'],
      fallback: parsedSeats.isNotEmpty
          ? parsedSeats.length
          : 15,
    );

    return VoiceRoom(
      id: json['_id']?.toString() ??
          json['id']?.toString() ??
          '',

      name: json['name']?.toString() ??
          'Junaya Voice Room',

      ownerId: json['ownerId']?.toString() ?? '',

      announcement:
      json['announcement']?.toString() ??
          'Welcome to Junaya Voice Room.',

      onlineUsers: _parseInt(
        json['onlineUsers'],
      ),

      roomRank: _parseInt(
        json['roomRank'],
      ),

      seatCount: _normalizeSeatCount(
        parsedSeatCount,
      ),

      seats: parsedSeats,

      members: (json['members'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map(
            (item) => RoomUser.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
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
      'seatCount': seatCount,
      'seats': seats
          .map(
            (seat) => seat.toJson(),
      )
          .toList(),
      'members': members
          .map(
            (user) => user.toJson(),
      )
          .toList(),
    };
  }
}

/// Keeps seat count safely between 1 and 25.
int _normalizeSeatCount(int value) {
  if (value < 1) {
    return 1;
  }

  if (value > 25) {
    return 25;
  }

  return value;
}

int _parseInt(
    dynamic value, {
      int fallback = 0,
    }) {
  if (value is int) {
    return value;
  }

  return int.tryParse(
    value?.toString() ?? '',
  ) ??
      fallback;
}