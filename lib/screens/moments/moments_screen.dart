import 'dart:io';

import 'package:flutter/material.dart';

import 'create_moment_screen.dart';
import '../../services/moment_storage.dart';

enum MomentMediaType {
  asset,
  file,
}

class MomentMedia {
  final String path;
  final MomentMediaType type;

  const MomentMedia.asset(this.path) : type = MomentMediaType.asset;
  const MomentMedia.file(this.path) : type = MomentMediaType.file;
}

class MomentItem {
  final String username;
  final String avatarAsset;
  final String message;
  final String time;
  final String badge;
  final int comments;
  final int likes;
  final bool isLive;
  final List<MomentMedia> media;
  final LocalMomentData? localData;

  const MomentItem({
    required this.username,
    required this.avatarAsset,
    required this.message,
    required this.time,
    required this.badge,
    required this.comments,
    required this.likes,
    required this.isLive,
    required this.media,
    this.localData,
  });
}

class MomentsScreen extends StatefulWidget {
  const MomentsScreen({super.key});

  @override
  State<MomentsScreen> createState() => _MomentsScreenState();
}

class _MomentsScreenState extends State<MomentsScreen> {
  final MomentStorage _momentStorage = MomentStorage();

  int _selectedTab = 1;

  final List<MomentItem> _moments = [
    const MomentItem(
      username: '🇨🇦 Ms Pinky 👑',
      avatarAsset: 'assets/images/moments/pinky_avatar.jpg',
      message: 'I’m not interested your coins i need true love 💘❤️\n💋💛',
      time: '3 days ago',
      badge: 'Q 45',
      comments: 19,
      likes: 39,
      isLive: true,
      media: [
        MomentMedia.asset('assets/images/moments/pinky_post_1.jpg'),
        MomentMedia.asset('assets/images/moments/pinky_post_2.jpg'),
      ],
    ),
    const MomentItem(
      username: '➳ MR Ali',
      avatarAsset: 'assets/images/moments/ali_avatar.jpg',
      message: '',
      time: '13 hours ago',
      badge: 'SVIP2',
      comments: 16,
      likes: 14,
      isLive: true,
      media: [
        MomentMedia.asset('assets/images/moments/ali_birthday.jpg'),
      ],
    ),
    const MomentItem(
      username: '♬ Zyni Malik 🌻💔',
      avatarAsset: 'assets/images/moments/zyni_avatar.jpg',
      message: 'Enjoy every beautiful moment ✨',
      time: '1 day ago',
      badge: 'Q',
      comments: 11,
      likes: 28,
      isLive: false,
      media: [],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedMoments();
  }

  Future<void> _loadSavedMoments() async {
    try {
      final List<LocalMomentData> savedMoments =
      await _momentStorage.loadMoments();

      if (!mounted) return;

      setState(() {
        _moments.insertAll(
          0,
          savedMoments.map(_convertSavedMoment),
        );
      });
    } catch (_) {
      if (!mounted) return;

      _showMomentMessage(
        'Saved moments could not be loaded.',
        isError: true,
      );
    }
  }

  MomentItem _convertSavedMoment(LocalMomentData savedMoment) {
    return MomentItem(
      username: 'You',
      avatarAsset: '',
      message: savedMoment.text,
      time: _formatMomentTime(savedMoment.createdAt),
      badge: 'NEW',
      comments: 0,
      likes: 0,
      isLive: false,
      media: savedMoment.imagePaths
          .map((path) => MomentMedia.file(path))
          .toList(),
      localData: savedMoment,
    );
  }

  String _formatMomentTime(DateTime createdAt) {
    final Duration difference = DateTime.now().difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    }

    if (difference.inDays == 1) {
      return '1 day ago';
    }

    return '${difference.inDays} days ago';
  }

  Future<void> _openCreateMomentScreen() async {
    final CreatedMoment? createdMoment =
    await Navigator.push<CreatedMoment>(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateMomentScreen(),
      ),
    );

    if (createdMoment == null || !mounted) {
      return;
    }

    try {
      final LocalMomentData savedMoment =
      await _momentStorage.createMoment(
        text: createdMoment.text,
        sourceImagePaths: createdMoment.imagePaths,
      );

      if (!mounted) return;

      setState(() {
        _selectedTab = 1;
        _moments.insert(0, _convertSavedMoment(savedMoment));
      });

      _showMomentMessage('Moment posted successfully.');
    } catch (_) {
      if (!mounted) return;

      _showMomentMessage(
        'Moment could not be saved.',
        isError: true,
      );
    }
  }

  Future<void> _editMoment(MomentItem moment) async {
    final LocalMomentData? localMoment = moment.localData;

    if (localMoment == null) {
      return;
    }

    final TextEditingController controller =
    TextEditingController(text: moment.message);

    int characterCount = controller.text.length;

    final String? updatedText = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF13001F),
              insetPadding: const EdgeInsets.symmetric(horizontal: 22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(
                  color: const Color(0xFFA440F2).withOpacity(.55),
                ),
              ),
              titlePadding: const EdgeInsets.fromLTRB(18, 17, 18, 0),
              contentPadding: const EdgeInsets.fromLTRB(18, 13, 18, 5),
              actionsPadding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
              title: const Row(
                children: [
                  Icon(
                    Icons.edit_rounded,
                    color: Color(0xFFFFD36A),
                    size: 21,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Edit Moment',
                    style: TextStyle(
                      color: Color(0xFFFFE5B2),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 135,
                    decoration: BoxDecoration(
                      color: const Color(0xFF090010),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: const Color(0xFF9435CD).withOpacity(.7),
                      ),
                    ),
                    child: TextField(
                      controller: controller,
                      maxLength: 1000,
                      maxLines: null,
                      expands: true,
                      cursorColor: const Color(0xFFFFD36A),
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.35,
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          characterCount = value.length;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Say something',
                        hintStyle: TextStyle(color: Colors.white38),
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$characterCount/1000',
                      style: const TextStyle(
                        color: Color(0xFFB45BEE),
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white60),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final String text = controller.text.trim();

                    if (text.isEmpty && localMoment.imagePaths.isEmpty) {
                      return;
                    }

                    Navigator.pop(dialogContext, text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7620A9),
                    foregroundColor: const Color(0xFFFFE5A1),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 17,
                      vertical: 9,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    controller.dispose();

    if (updatedText == null || !mounted) {
      return;
    }

    try {
      final LocalMomentData updatedMoment =
      await _momentStorage.updateMoment(
        moment: localMoment,
        text: updatedText,
      );

      if (!mounted) return;

      setState(() {
        final int momentIndex = _moments.indexWhere(
              (item) => item.localData?.id == localMoment.id,
        );

        if (momentIndex != -1) {
          _moments[momentIndex] = _convertSavedMoment(updatedMoment);
        }
      });

      _showMomentMessage('Moment updated successfully.');
    } catch (_) {
      if (!mounted) return;

      _showMomentMessage(
        'Moment could not be updated.',
        isError: true,
      );
    }
  }

  Future<void> _deleteMoment(MomentItem moment) async {
    final LocalMomentData? localMoment = moment.localData;

    if (localMoment == null) {
      return;
    }

    final bool shouldDelete =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              backgroundColor: const Color(0xFF13001F),
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(
                  color: const Color(0xFFFF4E80).withOpacity(.50),
                ),
              ),
              title: const Row(
                children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFFF5E88),
                    size: 21,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Delete Moment?',
                    style: TextStyle(
                      color: Color(0xFFFFE5B2),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              content: const Text(
                'This moment and its saved images will be permanently deleted.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white60),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB8234E),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
            false;

    if (!shouldDelete || !mounted) {
      return;
    }

    try {
      await _momentStorage.deleteMoment(localMoment);

      if (!mounted) return;

      setState(() {
        _moments.removeWhere(
              (item) => item.localData?.id == localMoment.id,
        );
      });

      _showMomentMessage('Moment deleted successfully.');
    } catch (_) {
      if (!mounted) return;

      _showMomentMessage(
        'Moment could not be deleted.',
        isError: true,
      );
    }
  }

  void _showMomentMessage(
      String message, {
        bool isError = false,
      }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError
              ? const Color(0xFF7A1835)
              : const Color(0xFF361050),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 58),
        child: _CreateMomentButton(
          onTap: _openCreateMomentScreen,
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: _MomentsBackground(),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildTabHeader(),
                const SizedBox(height: 2),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _selectedTab == 1
                        ? _buildMomentsFeed()
                        : _buildFollowFeed(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 2),
      child: SizedBox(
        height: 44,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _TopTab(
              text: 'Follow',
              selected: _selectedTab == 0,
              onTap: () {
                setState(() {
                  _selectedTab = 0;
                });
              },
            ),
            const SizedBox(width: 22),
            _TopTab(
              text: 'Moments',
              selected: _selectedTab == 1,
              onTap: () {
                setState(() {
                  _selectedTab = 1;
                });
              },
            ),
            const Spacer(),
            const Icon(
              Icons.workspace_premium_outlined,
              color: Color(0xFFFFC95C),
              size: 27,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMomentsFeed() {
    return ListView.separated(
      key: const ValueKey('moments-feed'),
      padding: const EdgeInsets.fromLTRB(9, 4, 9, 125),
      itemCount: _moments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 9),
      itemBuilder: (context, index) {
        final MomentItem moment = _moments[index];

        return MomentCard(
          key: ValueKey(
            moment.localData?.id ?? 'moment-sample-$index',
          ),
          moment: moment,
          onEdit: moment.localData == null
              ? null
              : () => _editMoment(moment),
          onDelete: moment.localData == null
              ? null
              : () => _deleteMoment(moment),
        );
      },
    );
  }

  Widget _buildFollowFeed() {
    return ListView.separated(
      key: const ValueKey('follow-feed'),
      padding: const EdgeInsets.fromLTRB(9, 4, 9, 125),
      itemCount: _moments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 9),
      itemBuilder: (context, index) {
        final MomentItem moment = _moments[index];

        return MomentCard(
          key: ValueKey(
            moment.localData?.id ?? 'follow-sample-$index',
          ),
          moment: moment,
          onEdit: moment.localData == null
              ? null
              : () => _editMoment(moment),
          onDelete: moment.localData == null
              ? null
              : () => _deleteMoment(moment),
        );
      },
    );
  }
}

class _TopTab extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _TopTab({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 2,
            vertical: 5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: selected
                      ? const Color(0xFFFFD36A)
                      : Colors.white54,
                  fontSize: 18,
                  fontWeight:
                  selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: selected ? 28 : 0,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD36A),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MomentCard extends StatefulWidget {
  final MomentItem moment;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MomentCard({
    super.key,
    required this.moment,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<MomentCard> createState() => _MomentCardState();
}

class _MomentCardState extends State<MomentCard> {
  bool _liked = false;
  bool _followed = false;

  @override
  Widget build(BuildContext context) {
    final MomentItem moment = widget.moment;

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: const Color(0xD90B0015),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF8D36BD).withOpacity(.38),
          width: .8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(moment),

          if (moment.message.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              moment.message,
              style: const TextStyle(
                color: Color(0xFFF1EDF5),
                fontSize: 14,
                height: 1.32,
              ),
            ),
          ],

          if (moment.media.isNotEmpty) ...[
            const SizedBox(height: 9),
            _buildMedia(moment.media),
          ],

          const SizedBox(height: 8),
          _buildFooter(moment),
        ],
      ),
    );
  }

  Widget _buildHeader(MomentItem moment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _ProfileAvatar(
          assetPath: moment.avatarAsset,
          isLive: moment.isLive,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                moment.username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFFFE5B2),
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _SmallBadge(text: moment.badge),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.military_tech_rounded,
                    color: Color(0xFFD89832),
                    size: 17,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              _followed = !_followed;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 38,
            height: 34,
            decoration: BoxDecoration(
              color: _followed
                  ? const Color(0xFF7420A5)
                  : const Color(0xFF21102D),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: const Color(0xFFFFC95C).withOpacity(.75),
              ),
            ),
            child: Icon(
              _followed
                  ? Icons.check_rounded
                  : Icons.add_rounded,
              color: const Color(0xFFFFD36A),
              size: 23,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMedia(List<MomentMedia> media) {
    if (media.length == 1) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final double mediaHeight =
          (constraints.maxWidth * .60).clamp(170.0, 245.0);

          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: double.infinity,
              height: mediaHeight,
              child: _MomentImage(
                media: media.first,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      );
    }

    if (media.length == 2) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final double mediaHeight =
          (constraints.maxWidth * .52).clamp(155.0, 215.0);

          return SizedBox(
            height: mediaHeight,
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: _MomentImage(
                      media: media[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: _MomentImage(
                      media: media[1],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: media.length.clamp(0, 4),
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: _MomentImage(
            media: media[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  Widget _buildFooter(MomentItem moment) {
    return Row(
      children: [
        Expanded(
          child: Text(
            moment.time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.5,
            ),
          ),
        ),
        const Icon(
          Icons.chat_bubble_outline_rounded,
          color: Color(0xFFFFD36A),
          size: 18,
        ),
        const SizedBox(width: 4),
        Text(
          '${moment.comments}',
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 17),
        GestureDetector(
          onTap: () {
            setState(() {
              _liked = !_liked;
            });
          },
          child: Icon(
            _liked
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            color: _liked
                ? const Color(0xFFFF4E80)
                : const Color(0xFFFFD36A),
            size: 20,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '${moment.likes + (_liked ? 1 : 0)}',
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 13),
        _buildMomentOptions(),
      ],
    );
  }

  Widget _buildMomentOptions() {
    final bool hasOwnerActions =
        widget.onEdit != null || widget.onDelete != null;

    if (!hasOwnerActions) {
      return const Icon(
        Icons.more_horiz_rounded,
        color: Colors.white38,
        size: 21,
      );
    }

    return PopupMenuButton<_MomentMenuAction>(
      tooltip: 'Moment options',
      padding: EdgeInsets.zero,
      color: const Color(0xFF190024),
      elevation: 10,
      offset: const Offset(0, 28),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
        side: BorderSide(
          color: const Color(0xFFA440F2).withOpacity(.45),
        ),
      ),
      onSelected: (action) {
        switch (action) {
          case _MomentMenuAction.edit:
            widget.onEdit?.call();
            break;
          case _MomentMenuAction.delete:
            widget.onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) {
        return [
          if (widget.onEdit != null)
            const PopupMenuItem<_MomentMenuAction>(
              value: _MomentMenuAction.edit,
              height: 42,
              child: Row(
                children: [
                  Icon(
                    Icons.edit_rounded,
                    color: Color(0xFFFFD36A),
                    size: 18,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Edit moment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          if (widget.onDelete != null)
            const PopupMenuItem<_MomentMenuAction>(
              value: _MomentMenuAction.delete,
              height: 42,
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFFF5D87),
                    size: 19,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Delete moment',
                    style: TextStyle(
                      color: Color(0xFFFF8BA8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
        ];
      },
      child: const Icon(
        Icons.more_horiz_rounded,
        color: Colors.white38,
        size: 21,
      ),
    );
  }
}

enum _MomentMenuAction {
  edit,
  delete,
}

class _ProfileAvatar extends StatelessWidget {
  final String assetPath;
  final bool isLive;

  const _ProfileAvatar({
    required this.assetPath,
    required this.isLive,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 53,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 46,
            height: 46,
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFD36A),
                  Color(0xFFB635FF),
                ],
              ),
            ),
            child: ClipOval(
              child: assetPath.isEmpty
                  ? Container(
                color: const Color(0xFF38104E),
                child: const Icon(
                  Icons.person_rounded,
                  color: Color(0xFFFFD36A),
                  size: 27,
                ),
              )
                  : Image.asset(
                assetPath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    color: const Color(0xFF38104E),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Color(0xFFFFD36A),
                      size: 27,
                    ),
                  );
                },
              ),
            ),
          ),
          if (isLive)
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 1.5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: const Color(0xFFE61B9B),
                ),
                child: const Text(
                  'Live',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  final String text;

  const _SmallBadge({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2.5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF02B9B),
            Color(0xFFAF44F2),
          ],
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MomentImage extends StatelessWidget {
  final MomentMedia media;
  final BoxFit fit;

  const _MomentImage({
    required this.media,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (media.type == MomentMediaType.file) {
      return Image.file(
        File(media.path),
        width: double.infinity,
        height: double.infinity,
        fit: fit,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }

    return Image.asset(
      media.path,
      width: double.infinity,
      height: double.infinity,
      fit: fit,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }

  Widget _fallback() {
    return Container(
      color: const Color(0xFF21102C),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          color: Color(0xFFB86AE3),
          size: 34,
        ),
      ),
    );
  }
}

class _CreateMomentButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CreateMomentButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF8D27D0),
                Color(0xFF511278),
              ],
            ),
            border: Border.all(
              color: const Color(0xFFFFD36A).withOpacity(.85),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B24B5).withOpacity(.32),
                blurRadius: 10,
              ),
            ],
          ),
          child: const Icon(
            Icons.add_rounded,
            color: Color(0xFFFFD36A),
            size: 29,
          ),
        ),
      ),
    );
  }
}

class _MomentsBackground extends StatelessWidget {
  const _MomentsBackground();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand();
  }
}