import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../room_screen.dart';

class JunayaRoomCard extends StatelessWidget {
  final String flag;
  final String roomName;
  final String description;
  final String vip;
  final String level;
  final String role;
  final int likes;
  final String coverImage;

  const JunayaRoomCard({
    super.key,
    required this.flag,
    required this.roomName,
    required this.description,
    required this.vip,
    required this.level,
    required this.role,
    required this.likes,
    required this.coverImage,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const RoomScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withValues(alpha: .06),
          border: Border.all(
            color: Colors.white.withValues(alpha: .10),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [

                  Image.asset(
                    coverImage,
                    fit: BoxFit.cover,
                  ),


                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: .75),
                        ],
                      ),
                    ),
                  ),


                  Positioned(
                    top: 10,
                    left: 10,
                    child: _badge(
                      '🔥 HOT',
                    ),
                  ),


                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: _badge(
                      '👥 $likes',
                    ),
                  ),


                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: .35),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mic_rounded,
                        color: Color(0xff00D9B5),
                        size: 18,
                      ),
                    ),
                  ),

                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    '$flag $roomName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),


                  const SizedBox(height: 3),


                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                  ),


                  const SizedBox(height: 8),


                  Row(
                    children: [

                      _tag(vip),

                      const SizedBox(width: 5),

                      _tag(level),

                      const SizedBox(width: 5),

                      _tag(role),

                    ],
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }


  Widget _badge(String text) {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

  }


  Widget _tag(String text) {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 9,
        ),
      ),
    );

  }
}