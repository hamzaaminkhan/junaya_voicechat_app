enum RoomModerationAction {
  mute,
  unmute,
  kick,
  ban,
  unban,
  makeAdmin,
  removeAdmin,
}


enum RoomModerationStatus {
  pending,
  completed,
  failed,
  cancelled,
}


class RoomModerationModel {
  final String id;

  /// Room where the moderation action occurred.
  final String roomId;

  /// User performing the action.
  final String moderatorId;
  final String moderatorName;

  /// User being moderated.
  final String targetUserId;
  final String targetUserName;

  final RoomModerationAction action;

  final RoomModerationStatus status;

  /// Optional reason supplied by the moderator.
  final String? reason;

  /// Optional mute/ban duration in seconds.
  ///
  /// null means no duration was specified.
  final int? durationSeconds;

  final DateTime createdAt;

  const RoomModerationModel({
    this.id = '',

    required this.roomId,

    required this.moderatorId,
    required this.moderatorName,

    required this.targetUserId,
    required this.targetUserName,

    required this.action,

    this.status = RoomModerationStatus.pending,

    this.reason,

    this.durationSeconds,

    required this.createdAt,
  });


  // ============================================================
  // HELPERS
  // ============================================================

  bool get isMute {
    return action == RoomModerationAction.mute;
  }


  bool get isUnmute {
    return action == RoomModerationAction.unmute;
  }


  bool get isKick {
    return action == RoomModerationAction.kick;
  }


  bool get isBan {
    return action == RoomModerationAction.ban;
  }


  bool get isUnban {
    return action == RoomModerationAction.unban;
  }


  bool get isMakeAdmin {
    return action == RoomModerationAction.makeAdmin;
  }


  bool get isRemoveAdmin {
    return action == RoomModerationAction.removeAdmin;
  }


  bool get isPending {
    return status == RoomModerationStatus.pending;
  }


  bool get isCompleted {
    return status == RoomModerationStatus.completed;
  }


  bool get isFailed {
    return status == RoomModerationStatus.failed;
  }


  bool get isCancelled {
    return status == RoomModerationStatus.cancelled;
  }


  bool get hasReason {
    return reason != null &&
        reason!.trim().isNotEmpty;
  }


  bool get hasDuration {
    return durationSeconds != null &&
        durationSeconds! > 0;
  }


  // ============================================================
  // COPY
  // ============================================================

  RoomModerationModel copyWith({
    String? id,
    String? roomId,

    String? moderatorId,
    String? moderatorName,

    String? targetUserId,
    String? targetUserName,

    RoomModerationAction? action,

    RoomModerationStatus? status,

    String? reason,
    int? durationSeconds,

    DateTime? createdAt,
  }) {
    return RoomModerationModel(
      id: id ?? this.id,

      roomId: roomId ?? this.roomId,

      moderatorId:
      moderatorId ?? this.moderatorId,

      moderatorName:
      moderatorName ?? this.moderatorName,

      targetUserId:
      targetUserId ?? this.targetUserId,

      targetUserName:
      targetUserName ?? this.targetUserName,

      action:
      action ?? this.action,

      status:
      status ?? this.status,

      reason:
      reason ?? this.reason,

      durationSeconds:
      durationSeconds ??
          this.durationSeconds,

      createdAt:
      createdAt ?? this.createdAt,
    );
  }


  // ============================================================
  // JSON
  // ============================================================

  factory RoomModerationModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return RoomModerationModel(
      id:
      json['_id']?.toString() ??
          json['id']?.toString() ??
          '',

      roomId:
      json['roomId']?.toString() ??
          '',

      moderatorId:
      json['moderatorId']?.toString() ??
          '',

      moderatorName:
      json['moderatorName']?.toString() ??
          'Moderator',

      targetUserId:
      json['targetUserId']?.toString() ??
          '',

      targetUserName:
      json['targetUserName']?.toString() ??
          'User',

      action:
      _parseAction(
        json['action'],
      ),

      status:
      _parseStatus(
        json['status'],
      ),

      reason:
      json['reason']?.toString(),

      durationSeconds:
      json['durationSeconds'] == null
          ? null
          : _parseInt(
        json['durationSeconds'],
      ),

      createdAt:
      _parseDateTime(
        json['createdAt'],
      ),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'roomId': roomId,

      'moderatorId': moderatorId,
      'moderatorName': moderatorName,

      'targetUserId': targetUserId,
      'targetUserName': targetUserName,

      'action': action.name,

      'status': status.name,

      'reason': reason,

      'durationSeconds':
      durationSeconds,

      'createdAt':
      createdAt.toIso8601String(),
    };
  }


  @override
  String toString() {
    return 'RoomModerationModel('
        'id: $id, '
        'roomId: $roomId, '
        'moderatorId: $moderatorId, '
        'targetUserId: $targetUserId, '
        'action: ${action.name}, '
        'status: ${status.name}'
        ')';
  }
}


// ============================================================
// ACTION PARSER
// ============================================================

RoomModerationAction _parseAction(
    dynamic value,
    ) {
  switch (
  value?.toString().toLowerCase()) {
    case 'mute':
      return RoomModerationAction.mute;

    case 'unmute':
      return RoomModerationAction.unmute;

    case 'kick':
      return RoomModerationAction.kick;

    case 'ban':
      return RoomModerationAction.ban;

    case 'unban':
      return RoomModerationAction.unban;

    case 'makeadmin':
    case 'make_admin':
      return RoomModerationAction.makeAdmin;

    case 'removeadmin':
    case 'remove_admin':
      return RoomModerationAction.removeAdmin;

    default:
      return RoomModerationAction.mute;
  }
}


// ============================================================
// STATUS PARSER
// ============================================================

RoomModerationStatus _parseStatus(
    dynamic value,
    ) {
  switch (
  value?.toString().toLowerCase()) {
    case 'completed':
      return RoomModerationStatus.completed;

    case 'failed':
      return RoomModerationStatus.failed;

    case 'cancelled':
      return RoomModerationStatus.cancelled;

    case 'pending':
    default:
      return RoomModerationStatus.pending;
  }
}


// ============================================================
// DATE PARSER
// ============================================================

DateTime _parseDateTime(
    dynamic value,
    ) {
  if (value is DateTime) {
    return value;
  }

  return DateTime.tryParse(
    value?.toString() ?? '',
  ) ??
      DateTime.now();
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