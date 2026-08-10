import 'package:junaya_voicechat_app/models/moment_model.dart';

final List<MomentModel> moments = [
  MomentModel(
    username: "Sarah",

    avatar: "assets/images/avatar1.png",

    time: "5 minutes ago",

    content:
        "Had an amazing voice chat tonight ✨\nNew friends, new memories 💜",

    images: ["assets/images/moment1.jpg", "assets/images/moment2.jpg"],

    likes: 24,

    comments: 8,
  ),

  MomentModel(
    username: "Alex",

    avatar: "assets/images/avatar2.png",

    time: "20 minutes ago",

    content: "Sometimes a simple conversation can make your day better 🌙",

    images: [],

    likes: 15,

    comments: 3,
  ),

  MomentModel(
    username: "Emma",

    avatar: "assets/images/avatar3.png",

    time: "1 hour ago",

    content: "Enjoying the beautiful night sky ✨",

    images: ["assets/images/moment3.jpg"],

    likes: 42,

    comments: 12,
  ),
];
