import 'package:junaya_voicechat_app/rooms/models/room_top_user_model.dart';


/// Static top-user data for Phase 1B UI development.
///
/// Later this data will come from the backend/socket
/// based on actual room sending activity.
const List<RoomTopUser> roomTopUsers = [
  RoomTopUser(
    userId: 'top_user_1',
    name: 'User 1',
    position: 1,
    rank: RoomTopUserRank.level1,
    totalSending: 250000,
    vipLevel: 5,
  ),

  RoomTopUser(
    userId: 'top_user_2',
    name: 'User 2',
    position: 2,
    rank: RoomTopUserRank.level2,
    totalSending: 180000,
    vipLevel: 4,
  ),

  RoomTopUser(
    userId: 'top_user_3',
    name: 'User 3',
    position: 3,
    rank: RoomTopUserRank.level3,
    totalSending: 120000,
    vipLevel: 3,
  ),

  RoomTopUser(
    userId: 'top_user_4',
    name: 'User 4',
    position: 4,
    rank: RoomTopUserRank.level3,
    totalSending: 85000,
    vipLevel: 2,
  ),
];


/// Returns the users that should be displayed
/// in the room top-user overlay.
///
/// The room design currently displays
/// a maximum of 4 users.
List<RoomTopUser> get visibleRoomTopUsers {
  final users = List<RoomTopUser>.from(
    roomTopUsers,
  );

  users.sort(
        (a, b) => a.position.compareTo(
      b.position,
    ),
  );

  if (users.length <= 4) {
    return users;
  }

  return users.sublist(0, 4);
}


/// Finds a top user by user ID.
RoomTopUser? findRoomTopUser(
    String userId,
    ) {
  for (final user in roomTopUsers) {
    if (user.userId == userId) {
      return user;
    }
  }

  return null;
}


/// Returns a top user by display position.
RoomTopUser? findRoomTopUserByPosition(
    int position,
    ) {
  for (final user in roomTopUsers) {
    if (user.position == position) {
      return user;
    }
  }

  return null;
}