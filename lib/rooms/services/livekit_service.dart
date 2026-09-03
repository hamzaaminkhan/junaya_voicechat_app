import 'package:livekit_client/livekit_client.dart';

class LiveKitService {
  Room? room;

  Future<void> connect({
    required String url,
    required String token,
  }) async {
    room = Room();

    await room!.connect(
      url,
      token,
    );

    await room!.localParticipant?.setMicrophoneEnabled(true);
  }


  Future<void> disconnect() async {
    await room?.disconnect();
    room = null;
  }


  Future<void> muteMicrophone() async {
    await room?.localParticipant
        ?.setMicrophoneEnabled(false);
  }


  Future<void> unmuteMicrophone() async {
    await room?.localParticipant
        ?.setMicrophoneEnabled(true);
  }
}