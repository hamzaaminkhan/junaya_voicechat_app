import 'package:flutter/material.dart';

import 'models/voice_room_model.dart';

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

  bool get microphoneEnabled =>
      _microphoneEnabled;



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



  bool get isOnMic =>
      mySeatNumber != null;



  bool get isRoomOwner =>
      _room?.ownerId == currentUserId;



  RoomSeat? findSeatByNumber(
      int seatNumber,
      ) {
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



  bool canJoinSeat(
      int seatNumber,
      ) {
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



  bool canLockSeat(
      int seatNumber,
      ) {
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



  void setMicrophoneState(
      bool enabled,
      ) {
    _microphoneEnabled = enabled;
    notifyListeners();
  }



  void toggleMicrophone() {
    _microphoneEnabled =
    !_microphoneEnabled;

    notifyListeners();
  }



  void toggleSpeaker() {
    _speakerEnabled =
    !_speakerEnabled;

    notifyListeners();
  }



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



  void setLoading(
      bool value,
      ) {
    if (_loading == value) {
      return;
    }

    _loading = value;

    notifyListeners();
  }



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