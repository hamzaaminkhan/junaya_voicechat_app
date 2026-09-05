enum RoomRocketStatus {
  idle,
  charging,
  ready,
  blasting,
  completed,
}


enum RoomRocketRewardType {
  frame,
  ride,
  theme,
  other,
}


class RoomRocketReward {
  final String id;
  final String name;
  final RoomRocketRewardType type;
  final String? assetPath;

  const RoomRocketReward({
    required this.id,
    required this.name,
    required this.type,
    this.assetPath,
  });


  bool get hasAsset {
    return assetPath != null &&
        assetPath!.trim().isNotEmpty;
  }


  RoomRocketReward copyWith({
    String? id,
    String? name,
    RoomRocketRewardType? type,
    String? assetPath,
  }) {
    return RoomRocketReward(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      assetPath: assetPath ?? this.assetPath,
    );
  }


  factory RoomRocketReward.fromJson(
      Map<String, dynamic> json,
      ) {
    return RoomRocketReward(
      id: json['_id']?.toString() ??
          json['id']?.toString() ??
          '',

      name: json['name']?.toString() ??
          'Reward',

      type: _parseRewardType(
        json['type'],
      ),

      assetPath:
      json['assetPath']?.toString(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'assetPath': assetPath,
    };
  }
}


class RoomRocketModel {
  final String id;
  final String roomId;

  final RoomRocketStatus status;

  /// Current room sending amount.
  final int currentSending;

  /// Amount required to trigger the rocket.
  ///
  /// Requirement:
  /// 1,000,000.
  final int targetSending;

  /// Reward produced after the rocket blast.
  final RoomRocketReward? reward;

  /// User who triggered/completed the rocket.
  final String? triggeredByUserId;

  /// When the rocket blast started.
  final DateTime? blastedAt;


  const RoomRocketModel({
    this.id = '',
    required this.roomId,

    this.status = RoomRocketStatus.idle,

    this.currentSending = 0,

    this.targetSending = 1000000,

    this.reward,

    this.triggeredByUserId,

    this.blastedAt,
  });


  // ============================================================
  // HELPERS
  // ============================================================

  bool get isIdle {
    return status == RoomRocketStatus.idle;
  }


  bool get isCharging {
    return status == RoomRocketStatus.charging;
  }


  bool get isReady {
    return status == RoomRocketStatus.ready;
  }


  bool get isBlasting {
    return status == RoomRocketStatus.blasting;
  }


  bool get isCompleted {
    return status == RoomRocketStatus.completed;
  }


  bool get targetReached {
    return currentSending >= targetSending;
  }


  /// Progress between 0.0 and 1.0.
  double get progress {
    if (targetSending <= 0) {
      return 0;
    }

    final value =
        currentSending / targetSending;

    if (value < 0) {
      return 0;
    }

    if (value > 1) {
      return 1;
    }

    return value;
  }


  int get remainingSending {
    final remaining =
        targetSending - currentSending;

    return remaining < 0 ? 0 : remaining;
  }


  bool get hasReward {
    return reward != null;
  }


  // ============================================================
  // COPY
  // ============================================================

  RoomRocketModel copyWith({
    String? id,
    String? roomId,
    RoomRocketStatus? status,
    int? currentSending,
    int? targetSending,
    RoomRocketReward? reward,
    String? triggeredByUserId,
    DateTime? blastedAt,
  }) {
    return RoomRocketModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      status: status ?? this.status,
      currentSending:
      currentSending ?? this.currentSending,
      targetSending:
      targetSending ?? this.targetSending,
      reward: reward ?? this.reward,
      triggeredByUserId:
      triggeredByUserId ??
          this.triggeredByUserId,
      blastedAt:
      blastedAt ?? this.blastedAt,
    );
  }


  // ============================================================
  // JSON
  // ============================================================

  factory RoomRocketModel.fromJson(
      Map<String, dynamic> json,
      ) {
    DateTime? blastedAt;

    final rawBlastedAt =
    json['blastedAt'];

    if (rawBlastedAt != null) {
      blastedAt = DateTime.tryParse(
        rawBlastedAt.toString(),
      );
    }


    return RoomRocketModel(
      id:
      json['_id']?.toString() ??
          json['id']?.toString() ??
          '',

      roomId:
      json['roomId']?.toString() ??
          '',

      status:
      _parseStatus(
        json['status'],
      ),

      currentSending:
      _parseInt(
        json['currentSending'] ??
            json['sending'],
      ),

      targetSending:
      _parseInt(
        json['targetSending'],
        fallback: 1000000,
      ),

      reward:
      json['reward'] is Map
          ? RoomRocketReward.fromJson(
        Map<String, dynamic>.from(
          json['reward'] as Map,
        ),
      )
          : null,

      triggeredByUserId:
      json['triggeredByUserId']
          ?.toString(),

      blastedAt: blastedAt,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'status': status.name,
      'currentSending': currentSending,
      'targetSending': targetSending,
      'reward': reward?.toJson(),
      'triggeredByUserId':
      triggeredByUserId,
      'blastedAt':
      blastedAt?.toIso8601String(),
    };
  }


  @override
  String toString() {
    return 'RoomRocketModel('
        'id: $id, '
        'roomId: $roomId, '
        'status: ${status.name}, '
        'currentSending: $currentSending, '
        'targetSending: $targetSending, '
        'reward: $reward'
        ')';
  }
}


// ============================================================
// HELPERS
// ============================================================

RoomRocketStatus _parseStatus(
    dynamic value,
    ) {
  switch (
  value?.toString().toLowerCase()) {
    case 'charging':
      return RoomRocketStatus.charging;

    case 'ready':
      return RoomRocketStatus.ready;

    case 'blasting':
      return RoomRocketStatus.blasting;

    case 'completed':
      return RoomRocketStatus.completed;

    case 'idle':
    default:
      return RoomRocketStatus.idle;
  }
}


RoomRocketRewardType _parseRewardType(
    dynamic value,
    ) {
  switch (
  value?.toString().toLowerCase()) {
    case 'frame':
      return RoomRocketRewardType.frame;

    case 'ride':
      return RoomRocketRewardType.ride;

    case 'theme':
      return RoomRocketRewardType.theme;

    case 'other':
    default:
      return RoomRocketRewardType.other;
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