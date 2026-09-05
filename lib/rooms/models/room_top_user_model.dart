enum RoomTopUserRank {
  level1,
  level2,
  level3,
}


class RoomTopUser {
  final String userId;
  final String name;
  final String? avatar;

  /// User's position in the room top-user display.
  ///
  /// The UI should normally display only the
  /// first 4 users.
  final int position;

  /// Ranking style:
  ///
  /// Level 1 → Golden
  /// Level 2 → Metal
  /// Level 3 → Silver
  final RoomTopUserRank rank;

  /// Total amount sent by this user.
  final int totalSending;

  final int vipLevel;


  const RoomTopUser({
    required this.userId,
    required this.name,
    this.avatar,
    required this.position,
    this.rank = RoomTopUserRank.level3,
    this.totalSending = 0,
    this.vipLevel = 0,
  });


  // ============================================================
  // RANK HELPERS
  // ============================================================

  bool get isLevel1 {
    return rank == RoomTopUserRank.level1;
  }


  bool get isLevel2 {
    return rank == RoomTopUserRank.level2;
  }


  bool get isLevel3 {
    return rank == RoomTopUserRank.level3;
  }


  String get rankLabel {
    switch (rank) {
      case RoomTopUserRank.level1:
        return 'Level 1';

      case RoomTopUserRank.level2:
        return 'Level 2';

      case RoomTopUserRank.level3:
        return 'Level 3';
    }
  }


  // ============================================================
  // COPY
  // ============================================================

  RoomTopUser copyWith({
    String? userId,
    String? name,
    String? avatar,
    int? position,
    RoomTopUserRank? rank,
    int? totalSending,
    int? vipLevel,
  }) {
    return RoomTopUser(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      position: position ?? this.position,
      rank: rank ?? this.rank,
      totalSending:
      totalSending ?? this.totalSending,
      vipLevel: vipLevel ?? this.vipLevel,
    );
  }


  // ============================================================
  // JSON
  // ============================================================

  factory RoomTopUser.fromJson(
      Map<String, dynamic> json,
      ) {
    return RoomTopUser(
      userId: json['_id']?.toString() ??
          json['userId']?.toString() ??
          json['id']?.toString() ??
          '',

      name: json['name']?.toString() ??
          json['userName']?.toString() ??
          'User',

      avatar: json['avatar']?.toString(),

      position: _parseInt(
        json['position'],
        fallback: 1,
      ),

      rank: _parseRank(
        json['rank'],
      ),

      totalSending: _parseInt(
        json['totalSending'] ??
            json['sending'],
      ),

      vipLevel: _parseInt(
        json['vipLevel'],
      ),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'avatar': avatar,
      'position': position,
      'rank': rank.name,
      'totalSending': totalSending,
      'vipLevel': vipLevel,
    };
  }


  @override
  String toString() {
    return 'RoomTopUser('
        'userId: $userId, '
        'name: $name, '
        'position: $position, '
        'rank: ${rank.name}, '
        'totalSending: $totalSending, '
        'vipLevel: $vipLevel'
        ')';
  }
}


// ============================================================
// HELPERS
// ============================================================

RoomTopUserRank _parseRank(
    dynamic value,
    ) {
  final raw =
  value?.toString().toLowerCase();

  switch (raw) {
    case 'level1':
    case '1':
    case 'gold':
    case 'golden':
      return RoomTopUserRank.level1;

    case 'level2':
    case '2':
    case 'metal':
      return RoomTopUserRank.level2;

    case 'level3':
    case '3':
    case 'silver':
      return RoomTopUserRank.level3;

    default:
      return RoomTopUserRank.level3;
  }
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