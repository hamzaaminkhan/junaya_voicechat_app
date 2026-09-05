enum RoomEmojiAnimationType {
  pop,
  bounce,
  float,
  shake,
  zoom,
}


class RoomEmoji {
  final String id;
  final String name;
  final String assetPath;

  /// Animation used when the emoji is sent
  /// to another user's profile.
  final RoomEmojiAnimationType animationType;

  /// How long the animation should run.
  final int animationDurationMs;

  /// Whether this emoji is currently available
  /// in the room.
  final bool enabled;

  /// Optional VIP requirement.
  ///
  /// 0 = everyone can use it.
  /// 1 = VIP1 and above, etc.
  final int requiredVipLevel;


  const RoomEmoji({
    required this.id,
    required this.name,
    required this.assetPath,

    this.animationType =
        RoomEmojiAnimationType.pop,

    this.animationDurationMs = 900,

    this.enabled = true,

    this.requiredVipLevel = 0,
  });


  // ============================================================
  // PERMISSION
  // ============================================================

  bool canUse(int vipLevel) {
    return enabled &&
        vipLevel >= requiredVipLevel;
  }


  // ============================================================
  // COPY
  // ============================================================

  RoomEmoji copyWith({
    String? id,
    String? name,
    String? assetPath,
    RoomEmojiAnimationType? animationType,
    int? animationDurationMs,
    bool? enabled,
    int? requiredVipLevel,
  }) {
    return RoomEmoji(
      id: id ?? this.id,
      name: name ?? this.name,
      assetPath:
      assetPath ?? this.assetPath,

      animationType:
      animationType ?? this.animationType,

      animationDurationMs:
      animationDurationMs ??
          this.animationDurationMs,

      enabled:
      enabled ?? this.enabled,

      requiredVipLevel:
      requiredVipLevel ??
          this.requiredVipLevel,
    );
  }


  // ============================================================
  // JSON
  // ============================================================

  factory RoomEmoji.fromJson(
      Map<String, dynamic> json,
      ) {
    return RoomEmoji(
      id: json['id']?.toString() ?? '',

      name:
      json['name']?.toString() ??
          'Emoji',

      assetPath:
      json['assetPath']?.toString() ??
          '',

      animationType:
      _parseAnimationType(
        json['animationType'],
      ),

      animationDurationMs:
      _parseInt(
        json['animationDurationMs'],
        fallback: 900,
      ),

      enabled:
      json['enabled'] != false,

      requiredVipLevel:
      _parseInt(
        json['requiredVipLevel'],
      ),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'assetPath': assetPath,
      'animationType':
      animationType.name,
      'animationDurationMs':
      animationDurationMs,
      'enabled': enabled,
      'requiredVipLevel':
      requiredVipLevel,
    };
  }


  @override
  String toString() {
    return 'RoomEmoji('
        'id: $id, '
        'name: $name, '
        'assetPath: $assetPath, '
        'animationType: '
        '${animationType.name}, '
        'animationDurationMs: '
        '$animationDurationMs, '
        'enabled: $enabled, '
        'requiredVipLevel: '
        '$requiredVipLevel'
        ')';
  }
}


// ============================================================
// HELPERS
// ============================================================

RoomEmojiAnimationType _parseAnimationType(
    dynamic value,
    ) {
  final raw =
  value?.toString().toLowerCase();

  switch (raw) {
    case 'bounce':
      return RoomEmojiAnimationType.bounce;

    case 'float':
      return RoomEmojiAnimationType.float;

    case 'shake':
      return RoomEmojiAnimationType.shake;

    case 'zoom':
      return RoomEmojiAnimationType.zoom;

    case 'pop':
    default:
      return RoomEmojiAnimationType.pop;
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