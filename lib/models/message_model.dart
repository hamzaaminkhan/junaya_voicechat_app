import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final String type;
  final Timestamp timestamp;
  final bool seen;
  final bool deleted;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.seen,
    required this.deleted,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      message: map['message'] ?? '',
      type: map['type'] ?? 'text',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      seen: map['seen'] ?? false,
      deleted: map['deleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'type': type,
      'timestamp': timestamp,
      'seen': seen,
      'deleted': deleted,
    };
  }

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? message,
    String? type,
    Timestamp? timestamp,
    bool? seen,
    bool? deleted,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      seen: seen ?? this.seen,
      deleted: deleted ?? this.deleted,
    );
  }
}
