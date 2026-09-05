class RoomMessage {
  final String id;

  final String roomId;

  final String userId;

  final String userName;

  final String? avatar;

  final String message;

  final String? badge;

  final int vipLevel;

  final bool isSystem;

  final DateTime createdAt;


  const RoomMessage({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.userName,
    this.avatar,
    required this.message,
    this.badge,
    this.vipLevel = 0,
    this.isSystem = false,
    required this.createdAt,
  });


  RoomMessage copyWith({
    String? id,
    String? roomId,
    String? userId,
    String? userName,
    String? avatar,
    String? message,
    String? badge,
    int? vipLevel,
    bool? isSystem,
    DateTime? createdAt,
  }) {
    return RoomMessage(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      avatar: avatar ?? this.avatar,
      message: message ?? this.message,
      badge: badge ?? this.badge,
      vipLevel: vipLevel ?? this.vipLevel,
      isSystem: isSystem ?? this.isSystem,
      createdAt: createdAt ?? this.createdAt,
    );
  }


  factory RoomMessage.fromJson(
      Map<String, dynamic> json,
      ) {
    return RoomMessage(
      id: json['_id']?.toString() ??
          json['id']?.toString() ??
          '',

      roomId: json['roomId']?.toString() ?? '',

      userId: json['userId']?.toString() ?? '',

      userName: json['userName']?.toString() ??
          json['name']?.toString() ??
          'User',

      avatar: json['avatar']?.toString(),

      message: json['message']?.toString() ?? '',

      badge: json['badge']?.toString(),

      vipLevel: _parseInt(
        json['vipLevel'],
      ),

      isSystem: json['isSystem'] == true,

      createdAt: _parseDateTime(
        json['createdAt'],
      ),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'userId': userId,
      'userName': userName,
      'avatar': avatar,
      'message': message,
      'badge': badge,
      'vipLevel': vipLevel,
      'isSystem': isSystem,
      'createdAt': createdAt.toIso8601String(),
    };
  }


  @override
  String toString() {
    return 'RoomMessage('
        'id: $id, '
        'roomId: $roomId, '
        'userId: $userId, '
        'userName: $userName, '
        'message: $message, '
        'createdAt: $createdAt'
        ')';
  }
}


// ============================================================
// HELPERS
// ============================================================

int _parseInt(
    dynamic value,
    ) {
  if (value is int) {
    return value;
  }

  return int.tryParse(
    value?.toString() ?? '',
  ) ??
      0;
}


DateTime _parseDateTime(
    dynamic value,
    ) {
  if (value is DateTime) {
    return value;
  }

  final parsed = DateTime.tryParse(
    value?.toString() ?? '',
  );

  return parsed ?? DateTime.now();
}