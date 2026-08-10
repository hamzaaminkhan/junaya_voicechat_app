import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:junaya_voicechat_app/models/message_model.dart';

class ChatService {
  ChatService._();

  static final ChatService instance = ChatService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Generates a unique conversation ID
  /// Same ID regardless of sender/receiver order.
  String getConversationId(String user1, String user2) {
    final ids = [user1, user2]..sort();
    return ids.join("_");
  }

  /// Firestore reference
  CollectionReference<Map<String, dynamic>> _messagesRef(
    String conversationId,
  ) {
    return _firestore
        .collection("chats")
        .doc(conversationId)
        .collection("messages");
  }

  /// Send Message
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
    String type = "text",
  }) async {
    final conversationId = getConversationId(senderId, receiverId);

    final doc = _messagesRef(conversationId).doc();

    final newMessage = MessageModel(
      id: doc.id,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      type: type,
      timestamp: Timestamp.now(),
      seen: false,
      deleted: false,
    );

    await doc.set(newMessage.toMap());
  }

  /// Stream Messages
  Stream<List<MessageModel>> getMessages({
    required String senderId,
    required String receiverId,
  }) {
    final conversationId = getConversationId(senderId, receiverId);

    return _messagesRef(conversationId)
        .orderBy("timestamp", descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.data()))
              .toList(),
        );
  }

  /// Mark Message as Seen
  Future<void> markMessageAsSeen({
    required String senderId,
    required String receiverId,
    required String messageId,
  }) async {
    final conversationId = getConversationId(senderId, receiverId);

    await _messagesRef(conversationId).doc(messageId).update({"seen": true});
  }

  /// Delete Message
  Future<void> deleteMessage({
    required String senderId,
    required String receiverId,
    required String messageId,
  }) async {
    final conversationId = getConversationId(senderId, receiverId);

    await _messagesRef(
      conversationId,
    ).doc(messageId).update({"deleted": true, "message": ""});
  }
}
