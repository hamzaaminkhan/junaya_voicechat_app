import 'package:flutter/material.dart';

enum MomentVisibility {
  public,
  followers,
  private,
}

class VisibilitySheet extends StatelessWidget {
  final MomentVisibility selected;

  const VisibilitySheet({
    super.key,
    this.selected = MomentVisibility.public,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xff11111A),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(),

            const SizedBox(height: 18),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Who can see this?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  splashRadius: 20,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xff777787),
                    size: 21,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose who can view your moment.',
                style: TextStyle(
                  color: Color(0xff666675),
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 18),

            _VisibilityOption(
              icon: Icons.public_rounded,
              color: const Color(0xff22C55E),
              title: 'Public',
              subtitle: 'Anyone can see this moment.',
              selected:
              selected == MomentVisibility.public,
              onTap: () {
                Navigator.of(context).pop(
                  MomentVisibility.public,
                );
              },
            ),

            const SizedBox(height: 8),

            _VisibilityOption(
              icon: Icons.people_outline_rounded,
              color: const Color(0xffA855F7),
              title: 'Followers',
              subtitle:
              'Only people who follow you can see it.',
              selected:
              selected ==
                  MomentVisibility.followers,
              onTap: () {
                Navigator.of(context).pop(
                  MomentVisibility.followers,
                );
              },
            ),

            const SizedBox(height: 8),

            _VisibilityOption(
              icon: Icons.lock_outline_rounded,
              color: const Color(0xffF59E0B),
              title: 'Only me',
              subtitle:
              'Keep this moment private.',
              selected:
              selected ==
                  MomentVisibility.private,
              onTap: () {
                Navigator.of(context).pop(
                  MomentVisibility.private,
                );
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 38,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _VisibilityOption extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _VisibilityOption({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      decoration: BoxDecoration(
        color: selected
            ? color.withOpacity(.09)
            : const Color(0xff191923),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: selected
              ? color.withOpacity(.22)
              : Colors.transparent,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 13,
            ),
            child: Row(
              children: [
                Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.11),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xff777787),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                AnimatedContainer(
                  duration:
                  const Duration(milliseconds: 160),
                  width: 21,
                  height: 21,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? color
                          : const Color(0xff555563),
                      width: 1.5,
                    ),
                  ),
                  child: selected
                      ? Container(
                    margin:
                    const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}