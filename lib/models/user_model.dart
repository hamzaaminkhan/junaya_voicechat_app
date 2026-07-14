class UserModel {
  final String uid;
  final String fullName;
  final String username;
  final String email;
  final String profileImage;
  final int coins;
  final int diamonds;
  final bool isVip;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.username,
    required this.email,
    this.profileImage = '',
    this.coins = 0,
    this.diamonds = 0,
    this.isVip = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'username': username,
      'email': email,
      'profileImage': profileImage,
      'coins': coins,
      'diamonds': diamonds,
      'isVip': isVip,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      fullName: map['fullName'],
      username: map['username'],
      email: map['email'],
      profileImage: map['profileImage'] ?? '',
      coins: map['coins'] ?? 0,
      diamonds: map['diamonds'] ?? 0,
      isVip: map['isVip'] ?? false,
    );
  }
}