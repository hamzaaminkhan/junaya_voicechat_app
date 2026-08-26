import 'moment_model.dart';

final List<Moment> sampleMoments = [
  Moment(
    id: "1",
    author: MomentUser(
      id: "user1",
      username: "sarah",
      displayName: "Sarah",
      avatar: "assets/images/avatar1.png",
      verified: true,
      followers: 1200,
      isOnline: true,
    ),
    caption:
    "Had an amazing voice chat tonight ✨\nNew friends, new memories 💜",
    media: [
      MomentMedia.image(
        path: "assets/images/moment1.jpg",
        order: 0,
      ),
      MomentMedia.image(
        path: "assets/images/moment2.jpg",
        order: 1,
      ),
    ],
    createdAt: DateTime.now().subtract(
      const Duration(minutes: 5),
    ),
    visibility: MomentVisibility.public,
    hashtags: const [
      "voicechat",
      "friends",
    ],
    stats: MomentStats(
      likes: 124,
      comments: 18,
      views: 340,
    ),
    isLiked: false,
    isSaved: false,
    reactions: const [],
    isPinned: false,
    location: MomentLocation(
      name: "Hunza Valley, Pakistan",
    ),
  ),
  Moment(
    id: "2",
    author: MomentUser(
      id: "user2",
      username: "alex",
      displayName: "Alex",
      avatar: "assets/images/avatar2.png",
    ),
    caption:
    "Sometimes a simple conversation can make your day better 🌙",
    media: const [],
    createdAt: DateTime.now().subtract(
      const Duration(minutes: 20),
    ),
    visibility: MomentVisibility.public,
    hashtags: const [
      "moments",
    ],
    stats: MomentStats(
      likes: 15,
      comments: 3,
      views: 90,
    ),
    isLiked: false,
    isSaved: false,
    reactions: const [],
    isPinned: false,
  ),
  Moment(
    id: "3",
    author: MomentUser(
      id: "user3",
      username: "emma",
      displayName: "Emma",
      avatar: "assets/images/avatar3.png",
    ),
    caption:
    "Enjoying the beautiful night sky ✨",
    media: [
      MomentMedia.image(
        path: "assets/images/moment3.jpg",
        order: 0,
      ),
    ],
    createdAt: DateTime.now().subtract(
      const Duration(hours: 1),
    ),
    visibility: MomentVisibility.public,
    hashtags: const [
      "nature",
      "sky",
    ],
    stats: MomentStats(
      likes: 42,
      comments: 12,
      views: 200,
    ),
    isLiked: false,
    isSaved: false,
    reactions: const [],
    isPinned: false,
  ),
];