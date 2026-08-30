import 'package:flutter/material.dart';

enum MomentMoreAction {
  edit,
  save,
  share,
  copyLink,
  report,
  delete,
}

class MomentMoreSheet extends StatelessWidget {
  final bool isSaved;
  final bool isOwner;
  final ValueChanged<MomentMoreAction>? onSelected;

  const MomentMoreSheet({
    super.key,
    this.isSaved = false,
    this.isOwner = false,
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

            if (isOwner) ...[
              _ActionTile(
                icon: Icons.edit_outlined,
                title: 'Edit moment',
                onTap: () {
                  _select(
                    context,
                    MomentMoreAction.edit,
                  );
                },
              ),
              _divider(),
            ],

            _ActionTile(
              icon: isSaved
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_outline_rounded,
              title: isSaved
                  ? 'Remove from saved'
                  : 'Save moment',
              onTap: () {
                _select(
                  context,
                  MomentMoreAction.save,
                );
              },
            ),

            _divider(),

            _ActionTile(
              icon: Icons.ios_share_rounded,
              title: 'Share moment',
              onTap: () {
                _select(
                  context,
                  MomentMoreAction.share,
                );
              },
            ),

            _divider(),

            _ActionTile(
              icon: Icons.link_rounded,
              title: 'Copy link',
              onTap: () {
                _select(
                  context,
                  MomentMoreAction.copyLink,
                );
              },
            ),

            if (!isOwner) ...[
              _divider(),
              _ActionTile(
                icon: Icons.flag_outlined,
                title: 'Report moment',
                destructive: true,
                onTap: () {
                  _select(
                    context,
                    MomentMoreAction.report,
                  );
                },
              ),
            ],

            if (isOwner) ...[
              const SizedBox(height: 6),
              _divider(),
              const SizedBox(height: 6),
              _ActionTile(
                icon: Icons.delete_outline_rounded,
                title: 'Delete moment',
                destructive: true,
                onTap: () {
                  _select(
                    context,
                    MomentMoreAction.delete,
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _select(
      BuildContext context,
      MomentMoreAction action,
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

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 54,
      ),
      child: Divider(
        height: 1,
        color: Colors.white.withOpacity(.05),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool destructive;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = destructive
        ? const Color(0xffFF4D6D)
        : const Color(0xffD5D5DD);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 13,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: destructive
                      ? const Color(0xffFF4D6D)
                      .withOpacity(.09)
                      : const Color(0xff20202A),
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
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              if (!destructive)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xff555563),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}