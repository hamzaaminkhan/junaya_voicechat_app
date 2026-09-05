import 'package:flutter/material.dart';

class RoomActivityFeed extends StatelessWidget {
  final List<String> messages;

  final VoidCallback? onChangeRoomName;

  final VoidCallback? onEditAnnouncement;

  const RoomActivityFeed({
    super.key,
    this.messages = const [],
    this.onChangeRoomName,
    this.onEditAnnouncement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ============================================================
        // TABS
        // ============================================================

        const _RoomActivityTabs(),

        const SizedBox(height: 8),

        // ============================================================
        // PEACE MESSAGE
        // ============================================================

        const Align(
          alignment: Alignment.centerLeft,
          child: _PeaceMessage(),
        ),

        const SizedBox(height: 12),

        // ============================================================
        // ACTIVITY
        // ============================================================

        _BroadcastCard(
          messages: messages,
        ),

        const SizedBox(height: 12),

        // ============================================================
        // CHANGE ROOM NAME
        // ============================================================

        _ChangeRoomNameCard(
          onTap: onChangeRoomName,
        ),

        const SizedBox(height: 12),

        // ============================================================
        // ANNOUNCEMENT
        // ============================================================

        _AnnouncementBar(
          onTap: onEditAnnouncement,
        ),
      ],
    );
  }
}


// ================================================================
// TABS
// ================================================================

class _RoomActivityTabs extends StatelessWidget {
  const _RoomActivityTabs();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        children: [
          Text(
            'All',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(width: 28),

          Text(
            'Chat',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),

          Spacer(),

          SizedBox(
            width: 50,
            child: Divider(
              color: Colors.white24,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}


// ================================================================
// PEACE MESSAGE
// ================================================================

class _PeaceMessage extends StatelessWidget {
  const _PeaceMessage();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 95,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF5D216A).withValues(
          alpha: .82,
        ),
        borderRadius: BorderRadius.circular(
          18,
        ),
      ),
      child: const Text(
        'Peace Come!',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}


// ================================================================
// BROADCAST
// ================================================================

class _BroadcastCard extends StatelessWidget {
  final List<String> messages;

  const _BroadcastCard({
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    final displayMessages = messages.isEmpty
        ? const [
      '🙂',
      '🙂',
      '🙂',
      '🙂',
      '🙂',
      '🙂',
      '🙂',
      '🙂',
    ]
        : messages;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      padding: const EdgeInsets.fromLTRB(
        18,
        14,
        18,
        16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF54215F).withValues(
          alpha: .72,
        ),
        borderRadius: BorderRadius.circular(
          18,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '📣',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),

              const SizedBox(width: 10),

              const Text(
                'Broadcast',
                style: TextStyle(
                  color: Color(0xFFFFE900),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Wrap(
            spacing: 2,
            children: [
              for (final message in displayMessages)
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}


// ================================================================
// CHANGE ROOM NAME
// ================================================================

class _ChangeRoomNameCard extends StatelessWidget {
  final VoidCallback? onTap;

  const _ChangeRoomNameCard({
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF692675).withValues(
          alpha: .72,
        ),
        borderRadius: BorderRadius.circular(
          18,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFF9B4DB0).withValues(
                alpha: .55,
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '🏠',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Change room name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  'once',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 7),

                Row(
                  children: [
                    Text(
                      '🪙',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),

                    SizedBox(width: 5),

                    Text(
                      '+20',
                      style: TextStyle(
                        color: Color(0xFFFFE900),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFFFE900),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              child: const Text(
                'Go',
                style: TextStyle(
                  color: Color(0xFFFFE900),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ================================================================
// ANNOUNCEMENT
// ================================================================

class _AnnouncementBar extends StatelessWidget {
  final VoidCallback? onTap;

  const _AnnouncementBar({
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        height: 58,
        padding: const EdgeInsets.only(
          left: 20,
          right: 8,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF18D4C3),
          borderRadius: BorderRadius.circular(
            30,
          ),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Revise your room announcement !',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: .20,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: Colors.white,
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}