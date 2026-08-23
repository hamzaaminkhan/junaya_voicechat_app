import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/home/rooms/room_screen.dart';

class JunaidRoomCard extends StatelessWidget {
  final String flag;
  final String roomName;
  final String description;
  final String vip;
  final String level;
  final String role;
  final int likes;

  const JunaidRoomCard({super.key, required this.flag, required this.roomName, required this.description, required this.vip, required this.level, required this.role, required this.likes});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RoomScreen())),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: .88,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.teal.shade900, Colors.black87]),
                    ),
                    child: const Icon(Icons.mic_rounded, size: 55, color: Colors.white24),
                  ),
                  Positioned(top: 10, left: 10, child: _badge('🔥 HOT')),
                  Positioned(bottom: 10, right: 10, child: _badge('👥 $likes')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('$flag $roomName', maxLines: 1, overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          Text(description, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _badge(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
    child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 11)),
  );
}
