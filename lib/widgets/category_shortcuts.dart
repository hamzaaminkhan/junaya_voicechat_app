import 'package:flutter/material.dart';

class CategoryShortcuts extends StatelessWidget {
  final ValueChanged<CategoryItem>? onTap;

  const CategoryShortcuts({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      CategoryItem("🏆", "Rank", const Color(0xffffc857)),
      CategoryItem("💑", "Couple", const Color(0xffff6b9d)),
      CategoryItem("📍", "Nearby", const Color(0xff00d9b5)),
    ];

    return SizedBox(
      height: 125,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => onTap?.call(item),
            child: Container(
              width: 145,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  colors: [
                    item.color,
                    item.color.withValues(alpha: .55),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.icon, style: const TextStyle(fontSize: 38)),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryItem {
  final String icon;
  final String title;
  final Color color;

  CategoryItem(this.icon, this.title, this.color);
}
