import 'package:flutter/material.dart';

import '../models/voice_room_model.dart';

class RoomController extends ChangeNotifier {
  final String currentUserId;
  final String currentUserName;
  final String? currentUserAvatar;

  RoomController({
    required this.currentUserId,
    required this.currentUserName,
    this.currentUserAvatar,
  }) {
    _createTemporaryRoom();
  }

  VoiceRoom? _room;

  VoiceRoom? get room => _room;

  bool _loading = false;

  bool get loading => _loading;

  String? _error;

  String? get error => _error;

  bool _speakerEnabled = true;

  bool get speakerEnabled => _speakerEnabled;

  bool _microphoneEnabled = true;

  bool get microphoneEnabled => _microphoneEnabled;

  int? get mySeatIndex {
    if (_room == null) return null;

    for (int i = 0; i < _room!.seats.length; i++) {
      if (_room!.seats[i].user?.id == currentUserId) {
        return i;
      }
    }

    return null;
  }

  bool get isOnMic => mySeatIndex != null;

  bool get isRoomOwner =>
      _room?.ownerId == currentUserId;

  void _createTemporaryRoom() {
    final seats = List.generate(
      15,
          (index) => RoomSeat(
        number: index + 1,
      ),
    );

    //
    // Temporary demo HOST
    //
    seats[0] = RoomSeat(
      number: 1,
      status: RoomSeatStatus.occupied,
      user: const RoomUser(
        id: 'owner_001',
        name: 'Owner',
        avatar: 'assets/users/profile.png',
        isHost: true,
        isSpeaking: true,
      ),
    );

    //
    // Temporary demo member
    //
    seats[1] = const RoomSeat(
      number: 2,
      status: RoomSeatStatus.occupied,
      user: RoomUser(
        id: 'user_ayesha',
        name: 'Ayesha',
      ),
    );

    //
    // Locked seat
    //
    seats[14] = const RoomSeat(
      number: 15,
      status: RoomSeatStatus.locked,
    );

    _room = VoiceRoom(
      id: '87012534',
      name: 'Junaya Official Room',
      ownerId: 'owner_001',
      announcement:
      'Welcome! Be respectful and enjoy the room.',
      onlineUsers: 128,
      roomRank: 8,
      seats: seats,
    );
  }

  // ============================================================
  // JOIN MIC
  // ============================================================

  bool joinMic(int seatIndex) {
    if (_room == null) return false;

    if (seatIndex < 0 ||
        seatIndex >= _room!.seats.length) {
      return false;
    }

    final targetSeat = _room!.seats[seatIndex];

    if (targetSeat.status ==
        RoomSeatStatus.locked) {
      _error = 'This seat is locked.';
      notifyListeners();
      return false;
    }

    if (targetSeat.status ==
        RoomSeatStatus.occupied) {
      _error = 'This seat is already occupied.';
      notifyListeners();
      return false;
    }

    if (isOnMic) {
      _error = 'You are already on a mic.';
      notifyListeners();
      return false;
    }

    final seats =
    List<RoomSeat>.from(_room!.seats);

    final currentUser = RoomUser(
      id: currentUserId,
      name: currentUserName,
      avatar: currentUserAvatar,
      isMuted: !_microphoneEnabled,
    );

    seats[seatIndex] = RoomSeat(
      number: targetSeat.number,
      status: RoomSeatStatus.occupied,
      user: currentUser,
    );

    _room = _room!.copyWith(
      seats: seats,
    );

    _error = null;

    notifyListeners();

    return true;
  }

  // ============================================================
  // LEAVE MIC
  // ============================================================

  bool leaveMic() {
    final index = mySeatIndex;

    if (_room == null || index == null) {
      return false;
    }

    final seats =
    List<RoomSeat>.from(_room!.seats);

    seats[index] = RoomSeat(
      number: seats[index].number,
    );

    _room = _room!.copyWith(
      seats: seats,
    );

    notifyListeners();

    return true;
  }

  // ============================================================
  // MICROPHONE
  // ============================================================

  void toggleMicrophone() {
    _microphoneEnabled =
    !_microphoneEnabled;

    final index = mySeatIndex;

    if (_room != null && index != null) {
      final seats =
      List<RoomSeat>.from(_room!.seats);

      final seat = seats[index];

      if (seat.user != null) {
        seats[index] = seat.copyWith(
          user: seat.user!.copyWith(
            isMuted: !_microphoneEnabled,
          ),
        );

        _room = _room!.copyWith(
          seats: seats,
        );
      }
    }

    notifyListeners();
  }

  // ============================================================
  // SPEAKER
  // ============================================================

  void toggleSpeaker() {
    _speakerEnabled =
    !_speakerEnabled;

    notifyListeners();
  }

  // ============================================================
  // HOST CONTROLS
  // ============================================================

  void lockSeat(int seatIndex) {
    if (_room == null) return;

    if (seatIndex < 0 ||
        seatIndex >= _room!.seats.length) {
      return;
    }

    final seats =
    List<RoomSeat>.from(_room!.seats);

    final seat = seats[seatIndex];

    if (seat.status ==
        RoomSeatStatus.occupied) {
      return;
    }

    seats[seatIndex] = RoomSeat(
      number: seat.number,
      status: RoomSeatStatus.locked,
    );

    _room = _room!.copyWith(
      seats: seats,
    );

    notifyListeners();
  }

  void unlockSeat(int seatIndex) {
    if (_room == null) return;

    if (seatIndex < 0 ||
        seatIndex >= _room!.seats.length) {
      return;
    }

    final seats =
    List<RoomSeat>.from(_room!.seats);

    final seat = seats[seatIndex];

    if (seat.status !=
        RoomSeatStatus.locked) {
      return;
    }

    seats[seatIndex] = RoomSeat(
      number: seat.number,
    );

    _room = _room!.copyWith(
      seats: seats,
    );

    notifyListeners();
  }

  // ============================================================
  // REALTIME UPDATE
  //
  // Socket.IO will later call this when server sends room:update.
  // ============================================================

  void updateRoomFromServer(
      Map<String, dynamic> json,
      ) {
    _room = VoiceRoom.fromJson(json);

    notifyListeners();
  }

  // ============================================================
  // LOADING
  // ============================================================

  void setLoading(bool value) {
    _loading = value;

    notifyListeners();
  }

  void clearError() {
    _error = null;

    notifyListeners();
  }
}