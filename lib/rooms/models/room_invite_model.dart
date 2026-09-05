enum RoomInviteStatus {
  pending,
  accepted,
  declined,
  expired,
  cancelled,
}


class RoomInvite {
  final String id;

  /// Room where the invitation was created.
  final String roomId;

  /// User sending the invitation.
  final String senderId;
  final String senderName;
  final String? senderAvatar;

  /// Friend/user receiving the invitation.
  final String receiverId;
  final String receiverName;
  final String? receiverAvatar;

  /// Seat the receiver is being invited to.
  final int seatNumber;

  final RoomInviteStatus status;

  /// When the invitation was created.
  final DateTime createdAt;

  /// Optional expiration time.
  final DateTime? expiresAt;


  const RoomInvite({
    this.id = '',

    required this.roomId,

    required this.senderId,
    required this.senderName,
    this.senderAvatar,

    required this.receiverId,
    required this.receiverName,
    this.receiverAvatar,

    required this.seatNumber,

    this.status = RoomInviteStatus.pending,

    required this.createdAt,

    this.expiresAt,
  });


  // ============================================================
  // HELPERS
  // ============================================================

  bool get isPending {
    return status == RoomInviteStatus.pending;
  }


  bool get isAccepted {
    return status == RoomInviteStatus.accepted;
  }


  bool get isDeclined {
    return status == RoomInviteStatus.declined;
  }


  bool get isExpired {
    if (status == RoomInviteStatus.expired) {
      return true;
    }

    final expiry = expiresAt;

    if (expiry == null) {
      return false;
    }

    return DateTime.now().isAfter(expiry);
  }


  bool get isCancelled {
    return status == RoomInviteStatus.cancelled;
  }


  bool get isActive {
    return isPending && !isExpired;
  }


  // ============================================================
  // COPY
  // ============================================================

  RoomInvite copyWith({
    String? id,
    String? roomId,

    String? senderId,
    String? senderName,
    String? senderAvatar,

    String? receiverId,
    String? receiverName,
    String? receiverAvatar,

    int? seatNumber,

    RoomInviteStatus? status,

    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    return RoomInvite(
      id: id ?? this.id,

      roomId: roomId ?? this.roomId,

      senderId:
      senderId ?? this.senderId,

      senderName:
      senderName ?? this.senderName,

      senderAvatar:
      senderAvatar ?? this.senderAvatar,

      receiverId:
      receiverId ?? this.receiverId,

      receiverName:
      receiverName ?? this.receiverName,

      receiverAvatar:
      receiverAvatar ?? this.receiverAvatar,

      seatNumber:
      seatNumber ?? this.seatNumber,

      status:
      status ?? this.status,

      createdAt:
      createdAt ?? this.createdAt,

      expiresAt:
      expiresAt ?? this.expiresAt,
    );
  }


  // ============================================================
  // JSON
  // ============================================================

  factory RoomInvite.fromJson(
      Map<String, dynamic> json,
      ) {
    return RoomInvite(
      id:
      json['_id']?.toString() ??
          json['id']?.toString() ??
          '',

      roomId:
      json['roomId']?.toString() ??
          '',

      senderId:
      json['senderId']?.toString() ??
          '',

      senderName:
      json['senderName']?.toString() ??
          'User',

      senderAvatar:
      json['senderAvatar']?.toString(),

      receiverId:
      json['receiverId']?.toString() ??
          '',

      receiverName:
      json['receiverName']?.toString() ??
          'User',

      receiverAvatar:
      json['receiverAvatar']?.toString(),

      seatNumber:
      _parseInt(
        json['seatNumber'],
        fallback: 1,
      ),

      status:
      _parseStatus(
        json['status'],
      ),

      createdAt:
      _parseDateTime(
        json['createdAt'],
      ),

      expiresAt:
      _parseNullableDateTime(
        json['expiresAt'],
      ),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'roomId': roomId,

      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,

      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverAvatar': receiverAvatar,

      'seatNumber': seatNumber,

      'status': status.name,

      'createdAt':
      createdAt.toIso8601String(),

      'expiresAt':
      expiresAt?.toIso8601String(),
    };
  }


  @override
  String toString() {
    return 'RoomInvite('
        'id: $id, '
        'roomId: $roomId, '
        'senderId: $senderId, '
        'receiverId: $receiverId, '
        'seatNumber: $seatNumber, '
        'status: ${status.name}'
        ')';
  }
}


// ============================================================
// HELPERS
// ============================================================

RoomInviteStatus _parseStatus(
    dynamic value,
    ) {
  switch (
  value?.toString().toLowerCase()) {
    case 'accepted':
      return RoomInviteStatus.accepted;

    case 'declined':
      return RoomInviteStatus.declined;

    case 'expired':
      return RoomInviteStatus.expired;

    case 'cancelled':
      return RoomInviteStatus.cancelled;

    case 'pending':
    default:
      return RoomInviteStatus.pending;
  }
}


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


DateTime? _parseNullableDateTime(
    dynamic value,
    ) {
  if (value == null) {
    return null;
  }

  if (value is DateTime) {
    return value;
  }

  return DateTime.tryParse(
    value.toString(),
  );
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