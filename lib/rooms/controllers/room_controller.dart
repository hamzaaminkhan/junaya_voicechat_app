import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/rooms/models/voice_room_model.dart';

class RoomController extends ChangeNotifier {
  String currentUserId;
  String currentUserName;
  String? currentUserAvatar;

  RoomController({
    required this.currentUserId,
    required this.currentUserName,
    this.currentUserAvatar,
  });

  // ------------------------------------------------------------
  // ROOM
  // ------------------------------------------------------------

  VoiceRoom? _room;

  VoiceRoom? get room {
    return _room;
  }

  bool get hasRoom {
    return _room != null;
  }

  // ------------------------------------------------------------
  // LOADING / ERROR
  // ------------------------------------------------------------

  bool _loading = false;

  bool get loading {
    return _loading;
  }

  String? _error;

  String? get error {
    return _error;
  }

  // ------------------------------------------------------------
  // AUDIO
  // ------------------------------------------------------------

  bool _speakerEnabled = true;

  bool get speakerEnabled {
    return _speakerEnabled;
  }

  bool _microphoneEnabled = true;

  bool get microphoneEnabled {
    return _microphoneEnabled;
  }

  // ------------------------------------------------------------
  // AUTHENTICATED USER
  // ------------------------------------------------------------

  void setAuthenticatedUser({
    required String id,
    required String name,
    String? avatar,
  }) {
    currentUserId = id;
    currentUserName = name;
    currentUserAvatar = avatar;

    notifyListeners();
  }

  // ------------------------------------------------------------
  // SEAT COUNT
  // ------------------------------------------------------------

  /// Current configured number of mic seats.
  ///
  /// Always stays between 1 and 25.
  int get seatCount {
    return _room?.seatCount ?? 15;
  }

  /// All seats that should currently be displayed.
  ///
  /// Example:
  ///
  /// seatCount = 5
  /// => seats 1, 2, 3, 4, 5
  ///
  /// seatCount = 25
  /// => seats 1 through 25
  List<RoomSeat> get visibleSeats {
    final currentRoom = _room;

    if (currentRoom == null) {
      return const [];
    }

    final List<RoomSeat> result = [];

    for (
    int number = 1;
    number <= currentRoom.seatCount;
    number++
    ) {
      RoomSeat? existingSeat;

      for (final seat in currentRoom.seats) {
        if (seat.number == number) {
          existingSeat = seat;
          break;
        }
      }

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

  // ------------------------------------------------------------
  // CHANGE NUMBER OF SEATS
  // ------------------------------------------------------------

  /// Changes the number of visible mic seats.
  ///
  /// Allowed range:
  /// 1 - 25
  ///
  /// This is currently local/UI state.
  /// Backend synchronization will be added later.
  void setSeatCount(int count) {
    if (count < 1 || count > 25) {
      _setError(
        'Room seats must be between 1 and 25.',
      );

      return;
    }

    // If room has not loaded yet, remember nothing.
    // The room needs to exist before its seatCount can be changed.
    if (_room == null) {
      _setError(
        'Room is not loaded yet.',
      );

      return;
    }

    final currentRoom = _room!;

    if (currentRoom.seatCount == count) {
      return;
    }

    final List<RoomSeat> updatedSeats = [];

    for (
    int number = 1;
    number <= count;
    number++
    ) {
      RoomSeat? existingSeat;

      for (final seat in currentRoom.seats) {
        if (seat.number == number) {
          existingSeat = seat;
          break;
        }
      }

      updatedSeats.add(
        existingSeat ??
            RoomSeat(
              number: number,
              status: RoomSeatStatus.empty,
            ),
      );
    }

    _room = currentRoom.copyWith(
      seatCount: count,
      seats: updatedSeats,
    );

    _error = null;

    notifyListeners();
  }

  // ------------------------------------------------------------
  // INCREASE / DECREASE SEATS
  // ------------------------------------------------------------

  void increaseSeatCount() {
    final currentCount = seatCount;

    if (currentCount >= 25) {
      return;
    }

    setSeatCount(
      currentCount + 1,
    );
  }

  void decreaseSeatCount() {
    final currentCount = seatCount;

    if (currentCount <= 1) {
      return;
    }

    final seatBeingRemoved =
    findSeatByNumber(currentCount);

    if (seatBeingRemoved?.isOccupied == true) {
      _setError(
        'Cannot remove an occupied seat.',
      );

      return;
    }

    setSeatCount(
      currentCount - 1,
    );
  }

  // ------------------------------------------------------------
  // MY SEAT
  // ------------------------------------------------------------

  int? get mySeatNumber {
    final currentRoom = _room;

    if (currentRoom == null) {
      return null;
    }

    for (final seat in currentRoom.seats) {
      if (seat.user?.id == currentUserId) {
        return seat.number;
      }
    }

    return null;
  }

  RoomSeat? get mySeat {
    final number = mySeatNumber;

    if (number == null) {
      return null;
    }

    return findSeatByNumber(number);
  }

  bool get isOnMic {
    return mySeatNumber != null;
  }

  // ------------------------------------------------------------
  // ROOM OWNER
  // ------------------------------------------------------------

  bool get isRoomOwner {
    return _room?.ownerId == currentUserId;
  }

  // ------------------------------------------------------------
  // FIND SEAT
  // ------------------------------------------------------------

  RoomSeat? findSeatByNumber(
      int seatNumber,
      ) {
    final currentRoom = _room;

    if (currentRoom == null) {
      return null;
    }

    if (
    seatNumber < 1 ||
        seatNumber > currentRoom.seatCount
    ) {
      return null;
    }

    for (final seat in currentRoom.seats) {
      if (seat.number == seatNumber) {
        return seat;
      }
    }

    // The seat is configured but does not yet
    // exist in the server seat list.
    return RoomSeat(
      number: seatNumber,
      status: RoomSeatStatus.empty,
    );
  }

  // ------------------------------------------------------------
  // JOIN SEAT
  // ------------------------------------------------------------

  bool canJoinSeat(
      int seatNumber,
      ) {
    if (
    seatNumber < 1 ||
        seatNumber > seatCount
    ) {
      _setError(
        'This seat is not available.',
      );

      return false;
    }

    final seat =
    findSeatByNumber(seatNumber);

    if (seat == null) {
      _setError(
        'Seat not found.',
      );

      return false;
    }

    if (seat.isLocked) {
      _setError(
        'This seat is locked.',
      );

      return false;
    }

    if (seat.isOccupied) {
      _setError(
        'This seat is occupied.',
      );

      return false;
    }

    if (isOnMic) {
      _setError(
        'You are already on a mic.',
      );

      return false;
    }

    return true;
  }

  // ------------------------------------------------------------
  // LOCK SEAT
  // ------------------------------------------------------------

  bool canLockSeat(
      int seatNumber,
      ) {
    if (
    seatNumber < 1 ||
        seatNumber > seatCount
    ) {
      return false;
    }

    final seat =
    findSeatByNumber(seatNumber);

    if (seat == null) {
      return false;
    }

    if (seat.isOccupied) {
      _setError(
        'Occupied seat cannot be locked.',
      );

      return false;
    }

    return true;
  }

  // ------------------------------------------------------------
  // MICROPHONE
  // ------------------------------------------------------------

  void setMicrophoneState(
      bool enabled,
      ) {
    if (_microphoneEnabled == enabled) {
      return;
    }

    _microphoneEnabled = enabled;

    notifyListeners();
  }

  void toggleMicrophone() {
    _microphoneEnabled =
    !_microphoneEnabled;

    notifyListeners();
  }

  // ------------------------------------------------------------
  // SPEAKER
  // ------------------------------------------------------------

  void toggleSpeaker() {
    _speakerEnabled =
    !_speakerEnabled;

    notifyListeners();
  }

  // ------------------------------------------------------------
  // UPDATE ROOM FROM SERVER
  // ------------------------------------------------------------

  void updateRoomFromServer(
      Map<String, dynamic> json,
      ) {
    try {
      final parsed =
      VoiceRoom.fromJson(json);

      if (parsed.id.isEmpty) {
        _setError(
          'Invalid room data received.',
        );

        return;
      }

      _room = _normalizeRoom(
        parsed,
      );

      _loading = false;
      _error = null;

      notifyListeners();
    } catch (e) {
      _setError(
        'Unable to update room.',
      );
    }
  }

  // ------------------------------------------------------------
  // REPLACE ROOM
  // ------------------------------------------------------------

  void replaceRoom(
      VoiceRoom room,
      ) {
    _room = _normalizeRoom(
      room,
    );

    _loading = false;
    _error = null;

    notifyListeners();
  }

  // ------------------------------------------------------------
  // NORMALIZE ROOM
  // ------------------------------------------------------------

  /// Makes sure the room always contains
  /// seat objects from 1 to seatCount.
  VoiceRoom _normalizeRoom(
      VoiceRoom room,
      ) {
    final count =
    _normalizeSeatCount(
      room.seatCount,
    );

    final List<RoomSeat> normalizedSeats =
    [];

    for (
    int number = 1;
    number <= count;
    number++
    ) {
      RoomSeat? existingSeat;

      for (final seat in room.seats) {
        if (seat.number == number) {
          existingSeat = seat;
          break;
        }
      }

      normalizedSeats.add(
        existingSeat ??
            RoomSeat(
              number: number,
              status: RoomSeatStatus.empty,
            ),
      );
    }

    return room.copyWith(
      seatCount: count,
      seats: normalizedSeats,
    );
  }

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

  // ------------------------------------------------------------
  // CLEAR ROOM
  // ------------------------------------------------------------

  void clearRoom() {
    _room = null;
    _error = null;

    notifyListeners();
  }

  // ------------------------------------------------------------
  // LOADING
  // ------------------------------------------------------------

  void setLoading(
      bool value,
      ) {
    if (_loading == value) {
      return;
    }

    _loading = value;

    notifyListeners();
  }

  // ------------------------------------------------------------
  // ERROR
  // ------------------------------------------------------------

  void setError(
      String message,
      ) {
    _setError(
      message,
    );
  }

  void clearError() {
    if (_error == null) {
      return;
    }

    _error = null;

    notifyListeners();
  }

  void _setError(
      String message,
      ) {
    _error = message;
    _loading = false;

    notifyListeners();
  }
}