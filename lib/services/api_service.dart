import 'package:cloud_firestore/cloud_firestore.dart';

class ApiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get hosts =>
      _firestore.collection('hosts');

  CollectionReference get chats =>
      _firestore.collection('chats');

  CollectionReference get users =>
      _firestore.collection('users');


  // Get all live hosts
  Stream<QuerySnapshot> getLiveHosts() {
    return hosts
        .where('isLive', isEqualTo: true)
        .snapshots();
  }


  // Get single host details
  Future<DocumentSnapshot> getHostById(String hostId) async {
    return await hosts.doc(hostId).get();
  }


  // Add new host
  Future<void> addHost({
    required String name,
    required String avatar,
    required String bio,
  }) async {
    await hosts.add({
      'name': name,
      'avatar': avatar,
      'bio': bio,
      'followers': 0,
      'viewers': 0,
      'isLive': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }


  // Update host live status
  Future<void> updateLiveStatus(
      String hostId,
      bool status,
      ) async {
    await hosts.doc(hostId).update({
      'isLive': status,
    });
  }


  // Update viewers count
  Future<void> updateViewerCount(
      String hostId,
      int viewers,
      ) async {
    await hosts.doc(hostId).update({
      'viewers': viewers,
    });
  }


  // Send chat message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String message,
  }) async {
    await chats
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': senderId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }


  // Get chat messages
  Stream<QuerySnapshot> getMessages(
      String chatId,
      ) {
    return chats
        .doc(chatId)
        .collection('messages')
        .orderBy(
      'timestamp',
      descending: true,
    )
        .snapshots();
  }


  // Follow host
  Future<void> followHost(
      String hostId,
      ) async {
    await hosts.doc(hostId).update({
      'followers': FieldValue.increment(1),
    });
  }


  // Remove user/report
  Future<void> reportUser({
    required String userId,
    required String reason,
  }) async {
    await _firestore
        .collection('reports')
        .add({
      'userId': userId,
      'reason': reason,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}