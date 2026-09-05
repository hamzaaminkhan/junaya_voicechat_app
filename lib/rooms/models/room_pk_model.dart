enum RoomPkStatus {
  idle,
  waiting,
  searching,
  active,
  finished,
  cancelled,
}


class RoomPkParticipant {
  final String userId;
  final String name;
  final String? avatar;

  /// PK score / contribution.
  final int score;

  /// Whether this participant is currently connected.
  final bool isOnline;


  const RoomPkParticipant({
    required this.userId,
    required this.name,
    this.avatar,
    this.score = 0,
    this.isOnline = true,
  });


  bool get hasAvatar {
    return avatar != null &&
        avatar!.trim().isNotEmpty;
  }


  RoomPkParticipant copyWith({
    String? userId,
    String? name,
    String? avatar,
    int? score,
    bool? isOnline,
  }) {
    return RoomPkParticipant(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      score: score ?? this.score,
      isOnline: isOnline ?? this.isOnline,
    );
  }


  factory RoomPkParticipant.fromJson(
      Map<String, dynamic> json,
      ) {
    return RoomPkParticipant(
      userId:
      json['_id']?.toString() ??
          json['userId']?.toString() ??
          json['id']?.toString() ??
          '',

      name:
      json['name']?.toString() ??
          'User',

      avatar:
      json['avatar']?.toString(),

      score:
      _parseInt(
        json['score'],
      ),

      isOnline:
      json['isOnline'] != false,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'avatar': avatar,
      'score': score,
      'isOnline': isOnline,
    };
  }
}


class RoomPkModel {
  final String id;

  /// Room that started the PK.
  final String roomId;

  final RoomPkStatus status;

  /// Current room/host.
  final RoomPkParticipant? challenger;

  /// Opposing room/host.
  final RoomPkParticipant? opponent;

  /// PK duration in seconds.
  final int durationSeconds;

  /// Remaining time in seconds.
  final int remainingSeconds;

  /// Total score of the challenger.
  final int challengerScore;

  /// Total score of the opponent.
  final int opponentScore;


  const RoomPkModel({
    this.id = '',
    required this.roomId,
    this.status = RoomPkStatus.idle,
    this.challenger,
    this.opponent,
    this.durationSeconds = 300,
    this.remainingSeconds = 0,
    this.challengerScore = 0,
    this.opponentScore = 0,
  });


  // ============================================================
  // HELPERS
  // ============================================================

  bool get isIdle {
    return status == RoomPkStatus.idle;
  }

  bool get isActive {
    return status == RoomPkStatus.active;
  }

  bool get isFinished {
    return status == RoomPkStatus.finished;
  }

  bool get hasOpponent {
    return opponent != null;
  }

  bool get challengerWinning {
    return challengerScore > opponentScore;
  }

  bool get opponentWinning {
    return opponentScore > challengerScore;
  }

  bool get tied {
    return challengerScore == opponentScore;
  }


  // ============================================================
  // COPY
  // ============================================================

  RoomPkModel copyWith({
    String? id,
    String? roomId,
    RoomPkStatus? status,
    RoomPkParticipant? challenger,
    RoomPkParticipant? opponent,
    int? durationSeconds,
    int? remainingSeconds,
    int? challengerScore,
    int? opponentScore,
  }) {
    return RoomPkModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      status: status ?? this.status,
      challenger: challenger ?? this.challenger,
      opponent: opponent ?? this.opponent,
      durationSeconds:
      durationSeconds ?? this.durationSeconds,
      remainingSeconds:
      remainingSeconds ?? this.remainingSeconds,
      challengerScore:
      challengerScore ?? this.challengerScore,
      opponentScore:
      opponentScore ?? this.opponentScore,
    );
  }


  // ============================================================
  // JSON
  // ============================================================

  factory RoomPkModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawStatus =
        json['status']?.toString().toLowerCase() ??
            'idle';

    final status = _parseStatus(
      rawStatus,
    );

    return RoomPkModel(
      id:
      json['_id']?.toString() ??
          json['id']?.toString() ??
          '',

      roomId:
      json['roomId']?.toString() ??
          '',

      status: status,

      challenger:
      json['challenger'] is Map
          ? RoomPkParticipant.fromJson(
        Map<String, dynamic>.from(
          json['challenger'] as Map,
        ),
      )
          : null,

      opponent:
      json['opponent'] is Map
          ? RoomPkParticipant.fromJson(
        Map<String, dynamic>.from(
          json['opponent'] as Map,
        ),
      )
          : null,

      durationSeconds:
      _parseInt(
        json['durationSeconds'],
        fallback: 300,
      ),

      remainingSeconds:
      _parseInt(
        json['remainingSeconds'],
      ),

      challengerScore:
      _parseInt(
        json['challengerScore'],
      ),

      opponentScore:
      _parseInt(
        json['opponentScore'],
      ),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'status': status.name,
      'challenger': challenger?.toJson(),
      'opponent': opponent?.toJson(),
      'durationSeconds': durationSeconds,
      'remainingSeconds': remainingSeconds,
      'challengerScore': challengerScore,
      'opponentScore': opponentScore,
    };
  }


  @override
  String toString() {
    return 'RoomPkModel('
        'id: $id, '
        'roomId: $roomId, '
        'status: ${status.name}, '
        'challengerScore: $challengerScore, '
        'opponentScore: $opponentScore'
        ')';
  }
}


RoomPkStatus _parseStatus(
    String value,
    ) {
  switch (value) {
    case 'waiting':
      return RoomPkStatus.waiting;

    case 'searching':
      return RoomPkStatus.searching;

    case 'active':
      return RoomPkStatus.active;

    case 'finished':
      return RoomPkStatus.finished;

    case 'cancelled':
      return RoomPkStatus.cancelled;

    case 'idle':
    default:
      return RoomPkStatus.idle;
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