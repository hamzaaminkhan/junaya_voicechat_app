import 'package:flutter/material.dart';

/// Reference-sized bottom controls for the 738 x 1600 room canvas.
class RoomBottomControls extends StatelessWidget {
  static const double contentHeight = 94;

  final VoidCallback onChat;
  final VoidCallback onEmoji;
  final VoidCallback onMedia;
  final VoidCallback onTools;
  final VoidCallback onGift;
  final VoidCallback onGame;

  const RoomBottomControls({
    super.key,
    required this.onChat,
    required this.onEmoji,
    required this.onMedia,
    required this.onTools,
    required this.onGift,
    required this.onGame,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: contentHeight,
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 11),
      decoration: const BoxDecoration(
        color: Color(0xFF05030A),
        border: Border(top: BorderSide(color: Color(0x22FFFFFF))),
      ),
      child: Row(
        children: [
          _RoundAction(
            tooltip: 'Chat',
            icon: Icons.chat_bubble_rounded,
            onTap: onChat,
          ),
          const SizedBox(width: 14),
          _RoundAction(
            tooltip: 'Emoji',
            icon: Icons.sentiment_satisfied_alt_rounded,
            onTap: onEmoji,
          ),
          const SizedBox(width: 28),
          SizedBox(
            width: 300,
            child: Semantics(
              button: true,
              label: 'Type a room message',
              child: Container(
                height: 62,
                  padding: const EdgeInsets.fromLTRB(13, 6, 7, 6),
                  decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .25),
                        width: 1,
                      )
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: onMedia,
                        child: const Icon(
                          Icons.photo_library_outlined,
                          color: Colors.white70,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: onChat,
                          child: const Text(
                            'Type…',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 49,
                        height: 49,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF7B27E9), Color(0xFF4A2CB8)],
                          ),
                        ),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 29,
                        ),
                      ),
                    ],
                  ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _SquareAction(
            tooltip: 'Room tools',
            icon: Icons.grid_view_rounded,
            onTap: onTools,
          ),
          const SizedBox(width: 10),
          _SquareAction(
            tooltip: 'Gifts',
            emoji: '🎁',
            onTap: onGift,
            accent: const Color(0xFFFF3DBD),
          ),
          const SizedBox(width: 10),
          _SquareAction(
            tooltip: 'Games',
            emoji: '🎮',
            onTap: onGame,
            accent: const Color(0xFF7F51FF),
          ),
        ],
      ),
    );
  }
}

class RoomSideActionRail extends StatelessWidget {
  final VoidCallback onPk;
  final VoidCallback onVip;
  final VoidCallback onRocket;

  const RoomSideActionRail({
    super.key,
    required this.onPk,
    required this.onVip,
    required this.onRocket,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RailAction(
          onTap: onPk,
          icon: Icons.sports_rounded,
          label: 'PK',
          colors: const [
            Color(0xFF8E2DE2),
            Color(0xFF4A00E0),
          ],
          accent: const Color(0xFFFFD54F),
        ),
        const SizedBox(height: 6),
        _RailAction(
          onTap: onVip,
          icon: Icons.chair_alt_rounded,
          label: 'VIP',
          colors: const [Color(0xFF29489C), Color(0xFF131F57)],
          accent: const Color(0xFFC0DCFF),
        ),
        const SizedBox(height: 6),
        Stack(
          clipBehavior: Clip.none,
          children: [
            _RailAction(
              onTap: onRocket,
              icon: Icons.rocket_launch_rounded,
              label: 'Rocket',
              colors: const [
                Color(0xFFFF512F),
                Color(0xFFF09819),
              ],
              accent: const Color(0xFFFFF1A6),
            ),
          ],
        ),
      ],
    );
  }
}

class _RoundAction extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  const _RoundAction({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 57,
            height: 57,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF17101F),
              border: Border.all(color: const Color(0xFF7F56BC), width: 1.6),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }
}

class _SquareAction extends StatelessWidget {
  final String tooltip;
  final IconData? icon;
  final String? emoji;
  final VoidCallback onTap;
  final Color accent;

  const _SquareAction({
    required this.tooltip,
    this.icon,
    this.emoji,
    required this.onTap,
    this.accent = const Color(0xFFB95CFF),
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 68,
            height: 68,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF180E26),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: accent.withValues(alpha: .75), width: 1.6),
              boxShadow: [
                BoxShadow(color: accent.withValues(alpha: .14), blurRadius: 9),
              ],
            ),
            child: emoji != null
                ? Text(emoji!, style: const TextStyle(fontSize: 34))
                : Icon(icon, color: Colors.white, size: 34),
          ),
        ),
      ),
    );
  }
}

class _RailAction extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final List<Color> colors;
  final Color accent;

  const _RailAction({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.colors,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 96,
          height: 88,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: accent.withValues(alpha: .62), width: 1.4),
            boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 9)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: accent, size: 38),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: accent,
                  fontSize: 15,
                  height: 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
