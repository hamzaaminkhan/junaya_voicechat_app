enum RoomSeatStatus {
  empty,
  occupied,
  locked,
}


// ============================================================
// ROOM USER
// ============================================================

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


  factory RoomUser.fromJson(
      Map<String, dynamic> json,
      ) {
    return RoomUser(
      id: json['_id']?.toString() ??
          json['id']?.toString() ??
          '',

      name: json['name']?.toString() ??
          'User',

      avatar: json['avatar']?.toString(),

      junayaId: json['junayaId']?.toString(),

      vipLevel: _parseInt(
        json['vipLevel'],
      ),

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


// ============================================================
// ROOM SEAT
// ============================================================

class RoomSeat {
  /// Human-readable seat number.
  ///
  /// Valid range: 1 - 25.
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
    return status == RoomSeatStatus.occupied &&
        user != null;
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

      user: removeUser
          ? null
          : user ?? this.user,
    );
  }


  factory RoomSeat.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawStatus = json['status']
        ?.toString()
        .toLowerCase() ??
        'empty';


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


    RoomUser? parsedUser;

    final rawUser = json['user'];

    if (rawUser is Map) {
      parsedUser = RoomUser.fromJson(
        Map<String, dynamic>.from(
          rawUser,
        ),
      );
    }


    // If there is no user, the seat cannot
    // actually be considered occupied.
    if (parsedStatus == RoomSeatStatus.occupied &&
        parsedUser == null) {
      parsedStatus = RoomSeatStatus.empty;
    }


    return RoomSeat(
      number: _parseInt(
        json['number'],
        fallback: 1,
      ),

      status: parsedStatus,

      user: parsedUser,
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


// ============================================================
// VOICE ROOM
// ============================================================

class VoiceRoom {
  final String id;

  final String name;

  final String ownerId;

  final String announcement;

  final int onlineUsers;

  final int roomRank;


  /// Number of microphone seats configured
  /// for this room.
  ///
  /// Valid range:
  ///
  /// 1 - 25
  final int seatCount;


  /// Configured room seats.
  ///
  /// The controller/UI should expose seats
  /// through [visibleSeats].
  final List<RoomSeat> seats;


  /// Users currently associated with the room.
  final List<RoomUser> members;


  /// Currently selected room wallpaper.
  ///
  /// This is the asset/file identifier for now.
  /// Backend synchronization can be added later.
  final String? wallpaperId;


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

    this.wallpaperId,
  });


  // ============================================================
  // SEAT HELPERS
  // ============================================================

  int get totalSeats {
    return seatCount;
  }


  int get availableSeatObjects {
    return seats.length;
  }


  /// Returns the seat with the requested number.
  RoomSeat? seatByNumber(
      int number,
      ) {
    for (final seat in seats) {
      if (seat.number == number) {
        return seat;
      }
    }

    return null;
  }


  /// Returns true when this room supports
  /// the requested seat number.
  bool hasSeatNumber(
      int number,
      ) {
    return number >= 1 &&
        number <= seatCount;
  }


  /// Returns all seats from 1 through seatCount.
  ///
  /// Missing seat objects are automatically
  /// represented as empty seats.
  List<RoomSeat> get visibleSeats {
    final result = <RoomSeat>[];

    for (
    int number = 1;
    number <= seatCount;
    number++
    ) {
      final existingSeat = seatByNumber(
        number,
      );

      result.add(
        existingSeat ??
            RoomSeat(
              number: number,
              status: RoomSeatStatus.empty,
            ),
      );
    }

    return result;
  }


  // ============================================================
  // ROOM HELPERS
  // ============================================================

  RoomUser? get owner {
    for (final user in members) {
      if (user.id == ownerId) {
        return user;
      }
    }

    return null;
  }


  int get occupiedSeatCount {
    return visibleSeats
        .where(
          (seat) => seat.isOccupied,
    )
        .length;
  }


  int get emptySeatCount {
    return visibleSeats
        .where(
          (seat) => seat.isEmpty,
    )
        .length;
  }


  int get lockedSeatCount {
    return visibleSeats
        .where(
          (seat) => seat.isLocked,
    )
        .length;
  }


  // ============================================================
  // COPY
  // ============================================================

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
    String? wallpaperId,
  }) {
    return VoiceRoom(
      id: id ?? this.id,

      name: name ?? this.name,

      ownerId: ownerId ?? this.ownerId,

      announcement:
      announcement ?? this.announcement,

      onlineUsers:
      onlineUsers ?? this.onlineUsers,

      roomRank:
      roomRank ?? this.roomRank,

      seatCount:
      seatCount ?? this.seatCount,

      seats:
      seats ?? this.seats,

      members:
      members ?? this.members,

      wallpaperId:
      wallpaperId ?? this.wallpaperId,
    );
  }


  // ============================================================
  // FROM JSON
  // ============================================================

  factory VoiceRoom.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawSeats = json['seats'];


    final parsedSeats = <RoomSeat>[];


    if (rawSeats is List) {
      for (final item in rawSeats) {
        if (item is Map) {
          parsedSeats.add(
            RoomSeat.fromJson(
              Map<String, dynamic>.from(
                item,
              ),
            ),
          );
        }
      }
    }


    // Remove invalid seat numbers.
    final validSeats = parsedSeats
        .where(
          (seat) =>
      seat.number >= 1 &&
          seat.number <= 25,
    )
        .toList();


    // Determine configured seat count.
    final parsedSeatCount = _parseInt(
      json['seatCount'],
      fallback: validSeats.isNotEmpty
          ? validSeats
          .map(
            (seat) => seat.number,
      )
          .reduce(
            (a, b) => a > b ? a : b,
      )
          : 15,
    );


    final normalizedSeatCount =
    _normalizeSeatCount(
      parsedSeatCount,
    );


    // Keep only seats that belong to
    // the configured range.
    final normalizedSeats = validSeats
        .where(
          (seat) =>
      seat.number <=
          normalizedSeatCount,
    )
        .toList();


    return VoiceRoom(
      id: json['_id']?.toString() ??
          json['id']?.toString() ??
          '',

      name: json['name']?.toString() ??
          'Junaya Voice Room',

      ownerId:
      json['ownerId']?.toString() ??
          '',

      announcement:
      json['announcement']?.toString() ??
          'Welcome to Junaya Voice Room.',

      onlineUsers: _parseInt(
        json['onlineUsers'],
      ),

      roomRank: _parseInt(
        json['roomRank'],
      ),

      seatCount: normalizedSeatCount,

      seats: normalizedSeats,

      members:
      _parseUsers(json['members']),

      wallpaperId:
      json['wallpaperId']?.toString(),
    );
  }


  // ============================================================
  // TO JSON
  // ============================================================

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

      'wallpaperId': wallpaperId,
    };
  }
}


// ============================================================
// HELPERS
// ============================================================

List<RoomUser> _parseUsers(
    dynamic value,
    ) {
  if (value is! List) {
    return const [];
  }


  final users = <RoomUser>[];


  for (final item in value) {
    if (item is Map) {
      users.add(
        RoomUser.fromJson(
          Map<String, dynamic>.from(
            item,
          ),
        ),
      );
    }
  }


  return users;
}


// ============================================================
// SEAT COUNT
// ============================================================

/// Keeps the room seat count safely
/// between 1 and 25.
int _normalizeSeatCount(
    int value,
    ) {
  if (value < 1) {
    return 1;
  }


  if (value > 25) {
    return 25;
  }


  return value;
}


// ============================================================
// INTEGER PARSER
// ============================================================

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