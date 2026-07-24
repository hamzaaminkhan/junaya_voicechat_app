import 'package:cloud_firestore/cloud_firestore.dart';

class VoiceRoomModel {

  final String id;

  final String roomName;

  final String hostId;

  final int onlineUsers;



  VoiceRoomModel({

    required this.id,

    required this.roomName,

    required this.hostId,

    required this.onlineUsers,

  });



  factory VoiceRoomModel.fromMap(
      String id,
      Map<String,dynamic> data
      ){

    return VoiceRoomModel(

      id:id,

      roomName:
      data['roomName'] ?? "",


      hostId:
      data['hostId'] ?? "",


      onlineUsers:
      data['onlineUsers'] ?? 0,

    );


  }



}