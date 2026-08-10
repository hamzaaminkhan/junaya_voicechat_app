import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/theme/app_colors.dart';

class SpeakerStage extends StatelessWidget {
  const SpeakerStage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        height: 380,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .25),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            /// Stage Title
            const Positioned(
              top: 18,
              left: 20,
              child: Text(
                "🎤 Speaker Stage",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            /// Host
            const Positioned(top: 130, left: 0, right: 0, child: HostSeat()),

            /// Top Left
            seat(top: 55, left: 45, number: 1),

            /// Top Right
            seat(top: 55, right: 45, number: 2),

            /// Middle Left
            seat(top: 150, left: 15, number: 3),

            /// Middle Right
            seat(top: 150, right: 15, number: 4),

            /// Bottom Left
            seat(bottom: 35, left: 45, number: 5),

            /// Bottom Right
            seat(bottom: 35, right: 45, number: 6),

            /// Bottom Center Left
            seat(bottom: 5, left: 120, number: 7),

            /// Bottom Center Right
            seat(bottom: 5, right: 120, number: 8),
          ],
        ),
      ),
    );
  }

  static Widget seat({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required int number,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: SpeakerSeat(seatNumber: number),
    );
  }
}

class SpeakerSeat extends StatelessWidget {
  final int seatNumber;

  const SpeakerSeat({super.key, required this.seatNumber});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: .15),
              ),
            ),

            const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: Icon(Icons.mic, color: AppColors.primary),
            ),
          ],
        ),

        const SizedBox(height: 6),

        Text(
          "Seat $seatNumber",
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

class HostSeat extends StatelessWidget {
  const HostSeat({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.amber, width: 4),
          ),
          child: const CircleAvatar(
            radius: 38,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 45, color: AppColors.primary),
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          "👑 Host",
          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 4),

        const Text(
          "Hamza",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),

        const SizedBox(height: 4),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "Speaking",
            style: TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
      ],
    );
  }
}
