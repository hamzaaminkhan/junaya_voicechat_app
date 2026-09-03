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

  VoiceRoom? _room;

  VoiceRoom? get room => _room;

  bool get hasRoom => _room != null;

  bool _loading = false;

  bool get loading => _loading;

  String? _error;

  String? get error => _error;

  bool _speakerEnabled = true;

  bool get speakerEnabled => _speakerEnabled;

  bool _microphoneEnabled = true;

  bool get microphoneEnabled => _microphoneEnabled;

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
  // ROOM / SEAT INFORMATION
  // ------------------------------------------------------------

  int get seatCount {
    return _room?.seatCount ?? 15;
  }

  /// Returns seats that should currently be displayed.
  ///
  /// If the room has 10 configured seats, this returns 1-10.
  /// If the room has 25 configured seats, this returns 1-25.
  List<RoomSeat> get visibleSeats {
    final currentRoom = _room;

    if (currentRoom == null) {
      return const [];
    }

    final seats = <RoomSeat>[];

    for (int number = 1;
    number <= currentRoom.seatCount;
    number++) {
      final existingSeat = findSeatByNumber(number);

      if (existingSeat != null) {
        seats.add(existingSeat);
      } else {
        seats.add(
          RoomSeat(
            number: number,
            status: RoomSeatStatus.empty,
          ),
        );
      }
    }

    return seats;
  }

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

  bool get isRoomOwner {
    return _room?.ownerId == currentUserId;
  }

  // ------------------------------------------------------------
  // FIND SEAT
  // ------------------------------------------------------------

  RoomSeat? findSeatByNumber(int seatNumber) {
    final currentRoom = _room;

    if (currentRoom == null) {
      return null;
    }

    for (final seat in currentRoom.seats) {
      if (seat.number == seatNumber) {
        return seat;
      }
    }

    return null;
  }

  // ------------------------------------------------------------
  // ROOM SETTINGS
  // ------------------------------------------------------------

  /// Change the number of seats in the room.
  ///
  /// Allowed values:
  /// 1 through 25.
  ///
  /// This is UI/local state for Phase 1.
  /// Backend synchronization can be added later.
  void setSeatCount(int count) {
    if (_room == null) {
      return;
    }

    if (count < 1 || count > 25) {
      _setError(
        'Room seats must be between 1 and 25.',
      );
      return;
    }

    final currentSeats = _room!.seats;

    final updatedSeats = <RoomSeat>[];

    for (int number = 1; number <= count; number++) {
      RoomSeat? existingSeat;

      for (final seat in currentSeats) {
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

    _room = _room!.copyWith(
      seatCount: count,
      seats: updatedSeats,
    );

    _error = null;

    notifyListeners();
  }

  /// Convenience method for Room Settings.
  void increaseSeatCount() {
    final currentCount = seatCount;

    if (currentCount >= 25) {
      return;
    }

    setSeatCount(currentCount + 1);
  }

  /// Convenience method for Room Settings.
  void decreaseSeatCount() {
    final currentCount = seatCount;

    if (currentCount <= 1) {
      return;
    }

    final seats = visibleSeats;

    final removedSeatNumber = currentCount;

    final removedSeat = seats.firstWhere(
          (seat) => seat.number == removedSeatNumber,
      orElse: () => RoomSeat(
        number: removedSeatNumber,
        status: RoomSeatStatus.empty,
      ),
    );

    if (removedSeat.isOccupied) {
      _setError(
        'Cannot remove an occupied seat.',
      );

      return;
    }

    setSeatCount(currentCount - 1);
  }

  // ------------------------------------------------------------
  // SEAT PERMISSION
  // ------------------------------------------------------------

  bool canJoinSeat(int seatNumber) {
    if (seatNumber < 1 || seatNumber > seatCount) {
      _setError(
        'This seat is not available.',
      );

      return false;
    }

    final seat = findSeatByNumber(seatNumber);

    if (seat == null) {
      return true;
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

  bool canLockSeat(int seatNumber) {
    if (seatNumber < 1 || seatNumber > seatCount) {
      return false;
    }

    final seat = findSeatByNumber(seatNumber);

    if (seat == null) {
      return true;
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

  void setMicrophoneState(bool enabled) {
    _microphoneEnabled = enabled;

    notifyListeners();
  }

  void toggleMicrophone() {
    _microphoneEnabled = !_microphoneEnabled;

    notifyListeners();
  }

  // ------------------------------------------------------------
  // SPEAKER
  // ------------------------------------------------------------

  void toggleSpeaker() {
    _speakerEnabled = !_speakerEnabled;

    notifyListeners();
  }

  // ------------------------------------------------------------
  // ROOM DATA
  // ------------------------------------------------------------

  void updateRoomFromServer(
      Map<String, dynamic> json,
      ) {
    try {
      final parsed = VoiceRoom.fromJson(json);

      if (parsed.id.isEmpty) {
        _setError(
          'Invalid room data received.',
        );

        return;
      }

      _room = parsed;

      _loading = false;
      _error = null;

      notifyListeners();
    } catch (e) {
      _setError(
        'Unable to update room.',
      );
    }
  }

  void replaceRoom(
      VoiceRoom room,
      ) {
    _room = room;

    _loading = false;
    _error = null;

    notifyListeners();
  }

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
    _setError(message);
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