import 'package:flutter/material.dart';

import '../models/voice_room_model.dart';

class RoomController extends ChangeNotifier {
  String currentUserId;
  String currentUserName;
  String? currentUserAvatar;

  RoomController({
    required this.currentUserId,
    required this.currentUserName,
    this.currentUserAvatar,
  });

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

  int? get mySeatIndex {
    final currentRoom = _room;
    if (currentRoom == null) return null;

    for (int i = 0; i < currentRoom.seats.length; i++) {
      if (currentRoom.seats[i].user?.id == currentUserId) {
        return i;
      }
    }

    return null;
  }

  bool get isOnMic => mySeatIndex != null;
  bool get isRoomOwner => _room?.ownerId == currentUserId;

  bool joinMic(int seatIndex) {
    final currentRoom = _room;
    if (currentRoom == null) {
      _setError('Room is not loaded yet.');
      return false;
    }

    if (seatIndex < 0 || seatIndex >= currentRoom.seats.length) {
      _setError('Invalid mic seat.');
      return false;
    }

    final targetSeat = currentRoom.seats[seatIndex];

    if (targetSeat.isLocked) {
      _setError('This mic seat is locked.');
      return false;
    }

    if (targetSeat.isOccupied) {
      _setError('This mic seat is already occupied.');
      return false;
    }

    if (isOnMic) {
      _setError('You are already on a mic.');
      return false;
    }

    final seats = List<RoomSeat>.from(currentRoom.seats);
    seats[seatIndex] = RoomSeat(
      number: targetSeat.number,
      status: RoomSeatStatus.occupied,
      user: RoomUser(
        id: currentUserId,
        name: currentUserName,
        avatar: currentUserAvatar,
        isHost: isRoomOwner,
        isMuted: !_microphoneEnabled,
      ),
    );

    _room = currentRoom.copyWith(seats: seats);
    _error = null;
    notifyListeners();
    return true;
  }

  bool leaveMic() {
    final currentRoom = _room;
    final index = mySeatIndex;

    if (currentRoom == null || index == null) {
      _setError('You are not on a mic seat.');
      return false;
    }

    final seats = List<RoomSeat>.from(currentRoom.seats);
    seats[index] = RoomSeat(number: seats[index].number);

    _room = currentRoom.copyWith(seats: seats);
    _error = null;
    notifyListeners();
    return true;
  }

  void toggleMicrophone() {
    _microphoneEnabled = !_microphoneEnabled;

    final currentRoom = _room;
    final index = mySeatIndex;

    if (currentRoom != null && index != null) {
      final seats = List<RoomSeat>.from(currentRoom.seats);
      final seat = seats[index];

      if (seat.user != null) {
        seats[index] = seat.copyWith(
          user: seat.user!.copyWith(isMuted: !_microphoneEnabled),
        );
        _room = currentRoom.copyWith(seats: seats);
      }
    }

    notifyListeners();
  }

  void toggleSpeaker() {
    _speakerEnabled = !_speakerEnabled;
    notifyListeners();
  }

  bool lockSeat(int seatIndex) {
    final currentRoom = _room;
    if (currentRoom == null) return false;

    if (seatIndex < 0 || seatIndex >= currentRoom.seats.length) {
      return false;
    }

    final seat = currentRoom.seats[seatIndex];
    if (seat.isOccupied) {
      _setError('Occupied mic cannot be locked.');
      return false;
    }

    final seats = List<RoomSeat>.from(currentRoom.seats);
    seats[seatIndex] = RoomSeat(
      number: seat.number,
      status: RoomSeatStatus.locked,
    );

    _room = currentRoom.copyWith(seats: seats);
    _error = null;
    notifyListeners();
    return true;
  }

  bool unlockSeat(int seatIndex) {
    final currentRoom = _room;
    if (currentRoom == null) return false;

    if (seatIndex < 0 || seatIndex >= currentRoom.seats.length) {
      return false;
    }

    final seat = currentRoom.seats[seatIndex];
    if (!seat.isLocked) return false;

    final seats = List<RoomSeat>.from(currentRoom.seats);
    seats[seatIndex] = RoomSeat(number: seat.number);

    _room = currentRoom.copyWith(seats: seats);
    _error = null;
    notifyListeners();
    return true;
  }

  void updateRoomFromServer(Map<String, dynamic> json) {
    final parsed = VoiceRoom.fromJson(json);

    if (parsed.id.isEmpty) {
      _setError('Server returned an invalid room.');
      return;
    }

    _room = parsed;
    _loading = false;
    _error = null;
    notifyListeners();
  }

  void clearRoom() {
    _room = null;
    _error = null;
    notifyListeners();
  }

  void setLoading(bool value) {
    if (_loading == value) return;
    _loading = value;
    notifyListeners();
  }

  void setError(String message) {
    _setError(message);
  }

  void clearError() {
    if (_error == null) return;
    _error = null;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    _loading = false;
    notifyListeners();
  }
}
