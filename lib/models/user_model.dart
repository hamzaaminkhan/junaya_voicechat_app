import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String username;
  final String email;
  final String profileImage;

  final int coins;
  final int diamonds;

  final bool isVip;
  final bool isOnline;
  final bool isEmailVerified;

  final Timestamp createdAt;
  final Timestamp updatedAt;

  const UserModel({
    required this.uid,
    required this.fullName,
    required this.username,
    required this.email,
    this.profileImage = '',
    this.coins = 0,
    this.diamonds = 0,
    this.isVip = false,
    this.isOnline = false,
    this.isEmailVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert object to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName.trim(),
      'username': username.trim().toLowerCase(),
      'email': email.trim().toLowerCase(),
      'profileImage': profileImage,
      'coins': coins,
      'diamonds': diamonds,
      'isVip': isVip,
      'isOnline': isOnline,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Create object from Firestore Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      profileImage: map['profileImage'] ?? '',
      coins: (map['coins'] ?? 0) as int,
      diamonds: (map['diamonds'] ?? 0) as int,
      isVip: map['isVip'] ?? false,
      isOnline: map['isOnline'] ?? false,
      isEmailVerified: map['isEmailVerified'] ?? false,
      createdAt: map['createdAt'] ?? Timestamp.now(),
      updatedAt: map['updatedAt'] ?? Timestamp.now(),
    );
  }

  /// Copy object with updated values
  UserModel copyWith({
    String? uid,
    String? fullName,
    String? username,
    String? email,
    String? profileImage,
    int? coins,
    int? diamonds,
    bool? isVip,
    bool? isOnline,
    bool? isEmailVerified,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      coins: coins ?? this.coins,
      diamonds: diamonds ?? this.diamonds,
      isVip: isVip ?? this.isVip,
      isOnline: isOnline ?? this.isOnline,
      isEmailVerified:
      isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}