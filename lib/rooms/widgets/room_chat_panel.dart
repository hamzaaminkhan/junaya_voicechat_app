import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoomChatDisplayItem {
  final String userId;
  final String name;
  final String? avatar;
  final String message;
  final String? badge;
  final int vipLevel;
  final bool isMe;
  final bool isSystem;

  const RoomChatDisplayItem({
    this.userId = '',
    required this.name,
    this.avatar,
    required this.message,
    this.badge,
    this.vipLevel = 0,
    this.isMe = false,
    this.isSystem = false,
  });
}

/// Chat panel sized for the fixed 738 x 1600 reference canvas.
class RoomChatPanel extends StatelessWidget {
  final List<RoomChatDisplayItem> messages;
  final VoidCallback onTap;
  final double rightActionInset;

  const RoomChatPanel({
    super.key,
    required this.messages,
    required this.onTap,
    this.rightActionInset = 124,
  });

  @override
  Widget build(BuildContext context) {
    final visibleMessages = messages.length > 20
        ? messages.sublist(messages.length - 20)
        : messages;

    return RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xF2050309),
          border: Border(
            top: BorderSide(
              color: const Color(0xFFD6A052).withValues(alpha: .72),
              width: 1.1,
            ),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 18,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 17, rightActionInset, 10),
              child: visibleMessages.isEmpty
                  ? Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Be the first to say something…',
                  style: GoogleFonts.poppins(
                    color: Colors.white38,
                    fontSize: 18,
                  ),
                ),
              )
                  : ListView.separated(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                itemCount: visibleMessages.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _MessageLine(item: visibleMessages[index]);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageLine extends StatelessWidget {
  final RoomChatDisplayItem item;

  const _MessageLine({required this.item});

  @override
  Widget build(BuildContext context) {
    final nameColor = item.isSystem
        ? const Color(0xFFFFCA62)
        : item.isMe
        ? const Color(0xFF66F3C3)
        : const Color(0xFFFFC15A);
    final badgeText = item.badge?.trim().isNotEmpty == true
        ? item.badge!.trim()
        : item.isSystem
        ? 'ROOM'
        : item.vipLevel > 0
        ? '${item.vipLevel}'
        : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (badgeText != null) ...[
          Container(
            constraints: const BoxConstraints(minWidth: 42),
            height: 29,
            padding: const EdgeInsets.symmetric(horizontal: 9),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5932C8), Color(0xFF8B3FE4)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFB777FF).withValues(alpha: .6),
                width: 1,
              ),
            ),
            child: Text(
              badgeText,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: item.isSystem ? 12 : 15,
                height: 1,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ] else ...[
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(color: nameColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      item.isMe ? 'You' : item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: nameColor,
                        fontSize: 18,
                        height: 1.05,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (!item.isSystem) ...[
                    const SizedBox(width: 7),
                    const Text('♛', style: TextStyle(fontSize: 15)),
                  ],
                ],
              ),
              const SizedBox(height: 5),
              Text(
                item.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  height: 1.25,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
