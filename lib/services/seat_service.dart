import 'package:cloud_firestore/cloud_firestore.dart';


class SeatService {


  final FirebaseFirestore db =
      FirebaseFirestore.instance;



// TAKE SEAT

  Future<void> takeSeat({

    required String roomId,

    required int seatId,

    required String userId,

    required String username,


  }) async {


    await db

        .collection("voice_rooms")

        .doc(roomId)

        .collection("seats")

        .doc(seatId.toString())

        .set({

      "userId": userId,

      "username": username,

      "mic": true,

      "joinedAt":
      FieldValue.serverTimestamp(),


    });


  }





// LEAVE SEAT


  Future<void> leaveSeat({

    required String roomId,

    required int seatId,


  }) async {


    await db

        .collection("voice_rooms")

        .doc(roomId)

        .collection("seats")

        .doc(seatId.toString())

        .delete();


  }



}