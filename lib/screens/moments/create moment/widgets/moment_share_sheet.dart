import 'package:flutter/material.dart';

enum MomentShareAction {
  friends,
  copyLink,
  systemShare,
}

class MomentShareSheet extends StatelessWidget {
  final String? momentId;
  final ValueChanged<MomentShareAction>? onSelected;

  const MomentShareSheet({
    super.key,
    this.momentId,
    this.onSelected,
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
          top: Radius.circular(26),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _handle(),

            const SizedBox(height: 18),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Share moment',
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
                'Share this moment with others.',
                style: TextStyle(
                  color: Color(0xff777787),
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 18),

            _ShareTile(
              icon: Icons.send_rounded,
              title: 'Share with friends',
              subtitle: 'Send this moment to your friends',
              onTap: () {
                _select(
                  context,
                  MomentShareAction.friends,
                );
              },
            ),

            const SizedBox(height: 8),

            _ShareTile(
              icon: Icons.link_rounded,
              title: 'Copy link',
              subtitle: 'Copy a link to this moment',
              onTap: () {
                _select(
                  context,
                  MomentShareAction.copyLink,
                );
              },
            ),

            const SizedBox(height: 8),

            _ShareTile(
              icon: Icons.ios_share_rounded,
              title: 'More options',
              subtitle: 'Share using another app',
              onTap: () {
                _select(
                  context,
                  MomentShareAction.systemShare,
                );
              },
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              height: 46,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor:
                  const Color(0xff9999A8),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _select(
      BuildContext context,
      MomentShareAction action,
      ) {
    onSelected?.call(action);
    Navigator.of(context).pop(action);
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

class _ShareTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ShareTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xff191923),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xffA855F7)
                      .withOpacity(.11),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: const Color(0xffA855F7),
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

              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xff5F5F6D),
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }
}