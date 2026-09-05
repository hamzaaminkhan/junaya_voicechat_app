import 'package:junaya_voicechat_app/rooms/models/room_rocket_model.dart';


/// Static rocket configuration for Phase 1B.
///
/// The actual sending amount, triggering,
/// blast, and reward delivery will later
/// be controlled by the backend.
const int roomRocketTarget = 1000000;


/// Default rocket state for a room.
RoomRocketModel createDefaultRoomRocket({
  required String roomId,
}) {
  return RoomRocketModel(
    roomId: roomId,
    status: RoomRocketStatus.idle,
    currentSending: 0,
    targetSending: roomRocketTarget,
  );
}


/// Static rewards that can be associated
/// with a completed rocket.
const List<RoomRocketReward> roomRocketRewards = [
  RoomRocketReward(
    id: 'rocket_reward_frame',
    name: 'Rocket Frame',
    type: RoomRocketRewardType.frame,
    assetPath: 'assets/rooms/rockets/rewards/rocket_frame.png',
  ),

  RoomRocketReward(
    id: 'rocket_reward_ride',
    name: 'Rocket Ride',
    type: RoomRocketRewardType.ride,
    assetPath: 'assets/rooms/rockets/rewards/rocket_ride.png',
  ),

  RoomRocketReward(
    id: 'rocket_reward_theme',
    name: 'Rocket Theme',
    type: RoomRocketRewardType.theme,
    assetPath: 'assets/rooms/rockets/rewards/rocket_theme.png',
  ),
];


/// Returns a rocket reward by ID.
RoomRocketReward? findRoomRocketReward(
    String rewardId,
    ) {
  for (final reward in roomRocketRewards) {
    if (reward.id == rewardId) {
      return reward;
    }
  }

  return null;
}


/// Creates a rocket state with a specific
/// sending amount.
///
/// Useful for UI testing before backend
/// integration.
RoomRocketModel createRoomRocketState({
  required String roomId,
  int currentSending = 0,
  RoomRocketStatus status = RoomRocketStatus.idle,
  RoomRocketReward? reward,
  String? triggeredByUserId,
}) {
  final safeSending =
  currentSending.clamp(
    0,
    roomRocketTarget,
  );

  return RoomRocketModel(
    roomId: roomId,
    status: status,
    currentSending: safeSending,
    targetSending: roomRocketTarget,
    reward: reward,
    triggeredByUserId: triggeredByUserId,
  );
}