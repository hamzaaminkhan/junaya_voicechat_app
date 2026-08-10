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

  const JunaidRoomCard({
    super.key,
    required this.flag,
    required this.roomName,
    required this.description,
    required this.vip,
    required this.level,
    required this.role,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.white.withValues(alpha: .09)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xFF6D2BC8).withValues(alpha: .24),
                  border: Border.all(
                    color: const Color(0xFF9F6CFF).withValues(alpha: .35),
                  ),
                ),
                child: const Icon(
                  Icons.mic_none_rounded,
                  color: Color(0xFFD9C6FF),
                  size: 25,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(flag, style: const TextStyle(fontSize: 13)),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            roomName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _vipBadge(),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _metaChip(level, const Color(0xFF68E9BF)),
              const SizedBox(width: 6),
              _metaChip(role, const Color(0xFFFFC46B)),
              const Spacer(),
              const Icon(
                Icons.favorite_rounded,
                color: Color(0xFFEA6BDA),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '$likes',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              _joinButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _vipBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFF4D98).withValues(alpha: .08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFFF6AA9).withValues(alpha: .50),
        ),
      ),
      child: Text(
        vip,
        style: GoogleFonts.poppins(
          color: const Color(0xFFFF86B9),
          fontSize: 9.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _metaChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: color.withValues(alpha: .32)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: color.withValues(alpha: .92),
          fontSize: 9.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _joinButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RoomScreen()),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          height: 29,
          padding: const EdgeInsets.symmetric(horizontal: 11),
          decoration: BoxDecoration(
            color: const Color(0xFFFFC857),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'Join',
              style: GoogleFonts.poppins(
                color: const Color(0xFF17100A),
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
