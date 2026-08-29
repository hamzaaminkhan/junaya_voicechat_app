import 'package:flutter/material.dart';

class MomentsTabHeader extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const MomentsTabHeader({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        6,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TabItem(
            title: "Following",
            active: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
          const SizedBox(width: 32),
          _TabItem(
            title: "Moments",
            active: selectedIndex == 1,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool active;
  final VoidCallback onTap;

  const _TabItem({
    required this.title,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(
                milliseconds: 180,
              ),
              curve: Curves.easeOut,
              style: TextStyle(
                color: active
                    ? Colors.white
                    : const Color(0xff858596),
                fontSize: 17,
                fontWeight: active
                    ? FontWeight.w700
                    : FontWeight.w500,
                letterSpacing: -0.2,
              ),
              child: Text(title),
            ),
            const SizedBox(height: 8),
            AnimatedContainer(
              duration: const Duration(
                milliseconds: 220,
              ),
              curve: Curves.easeOutCubic,
              height: 3,
              width: active ? _indicatorWidth(title) : 0,
              decoration: BoxDecoration(
                color: const Color(0xffA855F7),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _indicatorWidth(String title) {
    if (title == "Following") {
      return 62;
    }

    return 50;
  }
}