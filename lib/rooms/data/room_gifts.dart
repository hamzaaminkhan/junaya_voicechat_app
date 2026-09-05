import 'package:junaya_voicechat_app/rooms/models/room_gift_model.dart';

/// Static room gift collection.
///
/// Phase 1B:
/// These are local UI/demo gifts.
/// Later, the backend can provide the real gift catalog,
/// prices, availability, and animation assets.
const List<RoomGift> roomGifts = [
  RoomGift(
    id: 'gift_heart',
    name: 'Heart',
    assetPath: 'assets/rooms/gifts/heart.png',
    price: 10,
    order: 1,
  ),

  RoomGift(
    id: 'gift_rose',
    name: 'Rose',
    assetPath: 'assets/rooms/gifts/rose.png',
    price: 20,
    order: 2,
  ),

  RoomGift(
    id: 'gift_love',
    name: 'Love',
    assetPath: 'assets/rooms/gifts/love.png',
    price: 50,
    order: 3,
  ),

  RoomGift(
    id: 'gift_star',
    name: 'Star',
    assetPath: 'assets/rooms/gifts/star.png',
    price: 100,
    order: 4,
  ),

  RoomGift(
    id: 'gift_crown',
    name: 'Crown',
    assetPath: 'assets/rooms/gifts/crown.png',
    price: 500,
    order: 5,
  ),

  RoomGift(
    id: 'gift_diamond',
    name: 'Diamond',
    assetPath: 'assets/rooms/gifts/diamond.png',
    price: 1000,
    order: 6,
  ),

  RoomGift(
    id: 'gift_car',
    name: 'Luxury Car',
    assetPath: 'assets/rooms/gifts/car.png',
    price: 5000,
    animationPath: 'assets/rooms/gifts/animations/car.json',
    order: 7,
  ),

  RoomGift(
    id: 'gift_rocket',
    name: 'Rocket',
    assetPath: 'assets/rooms/gifts/rocket.png',
    price: 10000,
    animationPath: 'assets/rooms/gifts/animations/rocket.json',
    order: 8,
  ),

  RoomGift(
    id: 'gift_castle',
    name: 'Castle',
    assetPath: 'assets/rooms/gifts/castle.png',
    price: 50000,
    animationPath: 'assets/rooms/gifts/animations/castle.json',
    order: 9,
  ),

  RoomGift(
    id: 'gift_universe',
    name: 'Universe',
    assetPath: 'assets/rooms/gifts/universe.png',
    price: 100000,
    animationPath: 'assets/rooms/gifts/animations/universe.json',
    order: 10,
  ),
];


/// Returns only gifts that are currently active.
List<RoomGift> get activeRoomGifts {
  return roomGifts
      .where(
        (gift) => gift.isActive,
  )
      .toList();
}


/// Returns gifts sorted by their configured order.
List<RoomGift> get orderedRoomGifts {
  final gifts = List<RoomGift>.from(
    roomGifts,
  );

  gifts.sort(
        (a, b) => a.order.compareTo(
      b.order,
    ),
  );

  return gifts;
}


/// Finds a gift by its ID.
RoomGift? findRoomGift(
    String giftId,
    ) {
  for (final gift in roomGifts) {
    if (gift.id == giftId) {
      return gift;
    }
  }

  return null;
}