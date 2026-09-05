import 'package:junaya_voicechat_app/rooms/models/voice_room_model.dart';

const int defaultRoomSeatCount = 15;

const int minRoomSeatCount = 1;

const int maxRoomSeatCount = 25;

const String defaultRoomName = 'Junaya Voice Room';

const String defaultRoomAnnouncement =
    'Welcome to Junaya Voice Room.';


RoomUser defaultRoomHost({
  required String id,
  required String name,
  String? avatar,
}) {
  return RoomUser(
    id: id,
    name: name,
    avatar: avatar,
    isHost: true,
  );
}


List<RoomSeat> createEmptyRoomSeats({
  int count = defaultRoomSeatCount,
}) {
  final safeCount = count.clamp(
    minRoomSeatCount,
    maxRoomSeatCount,
  );

  return List.generate(
    safeCount,
        (index) {
      return RoomSeat(
        number: index + 1,
        status: RoomSeatStatus.empty,
      );
    },
  );
}