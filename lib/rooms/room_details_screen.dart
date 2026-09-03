import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/rooms/widgets/bottom_controls.dart';
import 'package:junaya_voicechat_app/rooms/widgets/gift_animation.dart';
import 'package:junaya_voicechat_app/rooms/widgets/gift_overlay.dart';
import 'package:junaya_voicechat_app/rooms/widgets/live_chat.dart';
import 'package:junaya_voicechat_app/rooms/widgets/room_header.dart';
import 'package:junaya_voicechat_app/rooms/widgets/room_statistics.dart';
import 'package:junaya_voicechat_app/rooms/widgets/speaker_stage.dart';


class RoomDetailsScreen extends StatelessWidget {
  const RoomDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Stack(
        children: [
          SingleChildScrollView(
            child: const Column(
              children: [
                RoomHeader(),

                SizedBox(height: 90),

                RoomStatistics(),

                SizedBox(height: 20),

                SpeakerStage(),

                SizedBox(height: 220),
              ],
            ),
          ),

          const GiftAnimationLayer(),

          const GiftOverlay(),

          const LiveChat(),

          const Align(
            alignment: Alignment.bottomCenter,
            child: BottomControls(),
          ),
        ],
      ),
    );
  }
}
