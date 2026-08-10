class MomentModel {
  final String username;
  final String avatar;
  final String time;
  final String content;

  final List<String> images;

  final int likes;
  final int comments;

  MomentModel({
    required this.username,

    required this.avatar,

    required this.time,

    required this.content,

    this.images = const [],

    this.likes = 0,

    this.comments = 0,
  });
}
