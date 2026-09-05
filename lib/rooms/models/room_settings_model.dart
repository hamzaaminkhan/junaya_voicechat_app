class RoomSettings {
  /// Number of microphone seats available in the room.
  ///
  /// Allowed range:
  /// 1 - 25.
  final int seatCount;

  /// Currently selected wallpaper.
  ///
  /// This matches the ID from the room wallpaper catalog.
  final String? wallpaperId;

  /// Whether users can send messages in the room.
  final bool chatEnabled;

  /// Whether users can send gifts in the room.
  final bool giftsEnabled;

  /// Whether users can join the room as guests.
  final bool guestsAllowed;

  const RoomSettings({
    this.seatCount = 15,
    this.wallpaperId,
    this.chatEnabled = true,
    this.giftsEnabled = true,
    this.guestsAllowed = true,
  });


  // ============================================================
  // COPY
  // ============================================================

  RoomSettings copyWith({
    int? seatCount,
    String? wallpaperId,
    bool clearWallpaper = false,
    bool? chatEnabled,
    bool? giftsEnabled,
    bool? guestsAllowed,
  }) {
    return RoomSettings(
      seatCount: _normalizeSeatCount(
        seatCount ?? this.seatCount,
      ),

      wallpaperId: clearWallpaper
          ? null
          : wallpaperId ?? this.wallpaperId,

      chatEnabled:
      chatEnabled ?? this.chatEnabled,

      giftsEnabled:
      giftsEnabled ?? this.giftsEnabled,

      guestsAllowed:
      guestsAllowed ?? this.guestsAllowed,
    );
  }


  // ============================================================
  // JSON
  // ============================================================

  factory RoomSettings.fromJson(
      Map<String, dynamic> json,
      ) {
    return RoomSettings(
      seatCount: _normalizeSeatCount(
        _parseInt(
          json['seatCount'],
          fallback: 15,
        ),
      ),

      wallpaperId:
      json['wallpaperId']?.toString(),

      chatEnabled:
      json['chatEnabled'] != false,

      giftsEnabled:
      json['giftsEnabled'] != false,

      guestsAllowed:
      json['guestsAllowed'] != false,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'seatCount': seatCount,
      'wallpaperId': wallpaperId,
      'chatEnabled': chatEnabled,
      'giftsEnabled': giftsEnabled,
      'guestsAllowed': guestsAllowed,
    };
  }


  // ============================================================
  // HELPERS
  // ============================================================

  bool get isMinimumSeatCount {
    return seatCount <= 1;
  }


  bool get isMaximumSeatCount {
    return seatCount >= 25;
  }


  @override
  String toString() {
    return 'RoomSettings('
        'seatCount: $seatCount, '
        'wallpaperId: $wallpaperId, '
        'chatEnabled: $chatEnabled, '
        'giftsEnabled: $giftsEnabled, '
        'guestsAllowed: $guestsAllowed'
        ')';
  }
}


// ============================================================
// HELPERS
// ============================================================

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