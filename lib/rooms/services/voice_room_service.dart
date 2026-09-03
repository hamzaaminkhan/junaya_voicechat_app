import 'package:cloud_firestore/cloud_firestore.dart';

class VoiceRoomService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // CREATE ROOM

  Future createRoom({required String roomName, required String hostId}) async {
    await db.collection("voice_rooms").add({
      "roomName": roomName,

      "hostId": hostId,

      "onlineUsers": 1,

      "status": "active",

      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // JOIN ROOM

  Future joinRoom(String roomId, String userId) async {
    await db.collection("voice_rooms").doc(roomId).update({
      "onlineUsers": FieldValue.increment(1),
    });
  }

  // LEAVE ROOM

  Future leaveRoom(String roomId) async {
    await db.collection("voice_rooms").doc(roomId).update({
      "onlineUsers": FieldValue.increment(-1),
    });
  }
}
