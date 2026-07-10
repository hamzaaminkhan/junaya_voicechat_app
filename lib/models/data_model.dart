class UserModel {
  final String id;
  final String username;
  final String email;
  final String country;
  final String avatar;
  final bool isVip;
  final int diamonds;
  final int coins;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.country,
    required this.avatar,
    required this.isVip,
    required this.diamonds,
    required this.coins,
  });
}