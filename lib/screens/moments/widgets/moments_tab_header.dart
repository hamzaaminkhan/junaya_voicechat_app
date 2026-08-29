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
        12,
        20,
        8,
      ),
      child: Row(
        children: [
          _TabItem(
            title: "Following",
            active: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
          const SizedBox(width: 34),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: active
                  ? Colors.white
                  : const Color(0xff8C8C9B),
              fontSize: 17,
              fontWeight: active
                  ? FontWeight.w700
                  : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(
              milliseconds: 220,
            ),
            curve: Curves.easeOut,
            height: 3,
            width: active ? _textWidth(title) : 0,
            decoration: BoxDecoration(
              color: const Color(0xffA855F7),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }

  double _textWidth(String text) {
    if (text == "Moments") {
      return 50;
    }
    return 58;
  }
}