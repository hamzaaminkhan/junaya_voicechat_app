import 'package:flutter/material.dart';

enum MomentVisibilityOption {
  public,
  friends,
  private,
}

class VisibilitySheet extends StatelessWidget {
  final MomentVisibilityOption selected;
  final ValueChanged<MomentVisibilityOption>? onSelected;

  const VisibilitySheet({
    super.key,
    this.selected = MomentVisibilityOption.public,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        28,
      ),
      decoration: const BoxDecoration(
        color: Color(0xff11111A),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _handle(),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Who can see this moment?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 5),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose who can view your moment.',
                style: TextStyle(
                  color: Color(0xff777787),
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 18),

            _VisibilityOption(
              value: MomentVisibilityOption.public,
              selected: selected,
              icon: Icons.public_rounded,
              title: 'Public',
              subtitle:
              'Anyone can see this moment',
              onTap: onSelected,
            ),

            const SizedBox(height: 8),

            _VisibilityOption(
              value: MomentVisibilityOption.friends,
              selected: selected,
              icon: Icons.people_outline_rounded,
              title: 'Friends',
              subtitle:
              'Only people you follow and who follow you',
              onTap: onSelected,
            ),

            const SizedBox(height: 8),

            _VisibilityOption(
              value: MomentVisibilityOption.private,
              selected: selected,
              icon: Icons.lock_outline_rounded,
              title: 'Only me',
              subtitle:
              'Only you can see this moment',
              onTap: onSelected,
            ),
          ],
        ),
      ),
    );
  }

  Widget _handle() {
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
  final MomentVisibilityOption value;
  final MomentVisibilityOption selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final ValueChanged<MomentVisibilityOption>?
  onTap;

  const _VisibilityOption({
    required this.value,
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;

    return Material(
      color: isSelected
          ? const Color(0xffA855F7)
          .withOpacity(.08)
          : const Color(0xff191923),
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: () {
          onTap?.call(value);

          if (onTap != null) {
            Navigator.of(context).pop(value);
          }
        },
        borderRadius: BorderRadius.circular(17),
        child: AnimatedContainer(
          duration:
          const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(17),
            border: Border.all(
              color: isSelected
                  ? const Color(0xffA855F7)
                  .withOpacity(.28)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xffA855F7)
                      .withOpacity(.13)
                      : const Color(0xff20202A),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? const Color(0xffA855F7)
                      : const Color(0xff9999A8),
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
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),

              AnimatedSwitcher(
                duration:
                const Duration(milliseconds: 180),
                child: isSelected
                    ? const Icon(
                  Icons.check_circle_rounded,
                  key: ValueKey('selected'),
                  color: Color(0xffA855F7),
                  size: 21,
                )
                    : const Icon(
                  Icons.radio_button_unchecked,
                  key: ValueKey('unselected'),
                  color: Color(0xff4B4B58),
                  size: 21,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}