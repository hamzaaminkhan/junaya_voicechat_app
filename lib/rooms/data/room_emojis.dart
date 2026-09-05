import 'package:junaya_voicechat_app/rooms/models/room_emoji_model.dart';

/// Static emoji collection for the room.
///
/// Phase 1B:
/// These are local assets.
/// Later, availability and VIP requirements
/// can be controlled by the backend.
final List<RoomEmoji> roomEmojis = [
  const RoomEmoji(
    id: 'heart',
    name: 'Heart',
    assetPath: 'assets/rooms/emojis/heart.png',
    animationType: RoomEmojiAnimationType.pop,
  ),

  const RoomEmoji(
    id: 'love',
    name: 'Love',
    assetPath: 'assets/rooms/emojis/love.png',
    animationType: RoomEmojiAnimationType.bounce,
  ),

  const RoomEmoji(
    id: 'laugh',
    name: 'Laugh',
    assetPath: 'assets/rooms/emojis/laugh.png',
    animationType: RoomEmojiAnimationType.bounce,
  ),

  const RoomEmoji(
    id: 'happy',
    name: 'Happy',
    assetPath: 'assets/rooms/emojis/happy.png',
    animationType: RoomEmojiAnimationType.pop,
  ),

  const RoomEmoji(
    id: 'wow',
    name: 'Wow',
    assetPath: 'assets/rooms/emojis/wow.png',
    animationType: RoomEmojiAnimationType.zoom,
  ),

  const RoomEmoji(
    id: 'fire',
    name: 'Fire',
    assetPath: 'assets/rooms/emojis/fire.png',
    animationType: RoomEmojiAnimationType.float,
  ),

  const RoomEmoji(
    id: 'clap',
    name: 'Clap',
    assetPath: 'assets/rooms/emojis/clap.png',
    animationType: RoomEmojiAnimationType.bounce,
  ),

  const RoomEmoji(
    id: 'perfect',
    name: 'Perfect',
    assetPath: 'assets/rooms/emojis/100.png',
    animationType: RoomEmojiAnimationType.zoom,
  ),

  const RoomEmoji(
    id: 'party',
    name: 'Party',
    assetPath: 'assets/rooms/emojis/party.png',
    animationType: RoomEmojiAnimationType.float,
  ),

  RoomEmoji(
    id: 'star',
    name: 'Star',
    assetPath: 'assets/rooms/emojis/star.png',
    animationType: RoomEmojiAnimationType.zoom,
  ),

  const RoomEmoji(
    id: 'crown',
    name: 'Crown',
    assetPath: 'assets/rooms/emojis/crown.png',
    animationType: RoomEmojiAnimationType.float,
  ),

  const RoomEmoji(
    id: 'like',
    name: 'Like',
    assetPath: 'assets/rooms/emojis/like.png',
    animationType: RoomEmojiAnimationType.pop,
  ),

  const RoomEmoji(
    id: 'dislike',
    name: 'Dislike',
    assetPath: 'assets/rooms/emojis/dislike.png',
    animationType: RoomEmojiAnimationType.shake,
  ),

  const RoomEmoji(
    id: 'cry',
    name: 'Cry',
    assetPath: 'assets/rooms/emojis/cry.png',
    animationType: RoomEmojiAnimationType.float,
  ),

  const RoomEmoji(
    id: 'angry',
    name: 'Angry',
    assetPath: 'assets/rooms/emojis/angry.png',
    animationType: RoomEmojiAnimationType.shake,
  ),

  const RoomEmoji(
    id: 'cool',
    name: 'Cool',
    assetPath: 'assets/rooms/emojis/cool.png',
    animationType: RoomEmojiAnimationType.zoom,
  ),

  const RoomEmoji(
    id: 'kiss',
    name: 'Kiss',
    assetPath: 'assets/rooms/emojis/kiss.png',
    animationType: RoomEmojiAnimationType.bounce,
  ),

  const RoomEmoji(
    id: 'rocket',
    name: 'Rocket',
    assetPath: 'assets/rooms/emojis/rocket.png',
    animationType: RoomEmojiAnimationType.zoom,
  ),

  const RoomEmoji(
    id: 'money',
    name: 'Money',
    assetPath: 'assets/rooms/emojis/money.png',
    animationType: RoomEmojiAnimationType.float,
    requiredVipLevel: 1,
  ),

  const RoomEmoji(
    id: 'gift',
    name: 'Gift',
    assetPath: 'assets/rooms/emojis/gift.png',
    animationType: RoomEmojiAnimationType.bounce,
  ),
];


/// Smaller collection used by the
/// quick reaction bar.
const List<RoomEmoji> roomQuickEmojis = [
  RoomEmoji(
    id: 'heart',
    name: 'Heart',
    assetPath: 'assets/rooms/emojis/heart.png',
  ),

  RoomEmoji(
    id: 'laugh',
    name: 'Laugh',
    assetPath: 'assets/rooms/emojis/laugh.png',
  ),

  RoomEmoji(
    id: 'fire',
    name: 'Fire',
    assetPath: 'assets/rooms/emojis/fire.png',
  ),

  RoomEmoji(
    id: 'clap',
    name: 'Clap',
    assetPath: 'assets/rooms/emojis/clap.png',
  ),

  RoomEmoji(
    id: 'perfect',
    name: 'Perfect',
    assetPath: 'assets/rooms/emojis/100.png',
  ),

  RoomEmoji(
    id: 'party',
    name: 'Party',
    assetPath: 'assets/rooms/emojis/party.png',
  ),
];


/// Returns only emojis that the current user
/// is allowed to use.
List<RoomEmoji> availableRoomEmojis(
    int vipLevel,
    ) {
  return roomEmojis
      .where(
        (emoji) => emoji.canUse(vipLevel),
  )
      .toList();
}