import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/theme/app_colors.dart';
import 'package:junaya_voicechat_app/widgets/room/bottom_controls.dart';
import 'package:junaya_voicechat_app/widgets/room/live_chat.dart';
import 'package:junaya_voicechat_app/widgets/room/room_header.dart';
import 'package:junaya_voicechat_app/widgets/room/speaker_stage.dart';
import 'package:junaya_voicechat_app/widgets/room/room_statistics.dart';
import 'package:junaya_voicechat_app/widgets/room/gift_overlay.dart';
import 'package:junaya_voicechat_app/widgets/room/gift_animation.dart';

class RoomDetailsScreen extends StatelessWidget {
  const RoomDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

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