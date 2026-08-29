import 'package:flutter/material.dart';

class MomentOptionTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const MomentOptionTile({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(
          bottom:12,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal:16,
          vertical:14,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff11111A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white10,
          ),
        ),
        child: Row(
          children: [

            Container(
              width:40,
              height:40,
              decoration: BoxDecoration(
                color: color.withOpacity(.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size:20,
              ),
            ),

            const SizedBox(width:14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize:15,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height:3),

                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize:13,
                    ),
                  ),

                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: Colors.white38,
              size:22,
            ),

          ],
        ),
      ),
    );
  }
}