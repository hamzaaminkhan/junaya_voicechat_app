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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Saved moments could not be loaded.',
          ),
        ),
      );
    }
  }

  MomentItem _convertSavedMoment(
      LocalMomentData savedMoment,
      ) {
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
          .map(
            (path) => MomentMedia.file(path),
      )
          .toList(),

      localData: savedMoment,
    );
  }

  String _formatMomentTime(DateTime createdAt) {
    final Duration difference =
    DateTime.now().difference(createdAt);

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

  Future<void> _editMoment(
      MomentItem moment,
      ) async {
    final LocalMomentData? localMoment = moment.localData;

    if (localMoment == null) {
      return;
    }

    final TextEditingController controller =
    TextEditingController(
      text: moment.message,
    );

    int characterCount = controller.text.length;

    final String? updatedText = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF13001F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
                side: BorderSide(
                  color: const Color(0xFFA440F2)
                      .withValues(alpha: 0.75),
                ),
              ),
              titlePadding: const EdgeInsets.fromLTRB(
                22,
                20,
                22,
                0,
              ),
              contentPadding: const EdgeInsets.fromLTRB(
                22,
                18,
                22,
                8,
              ),
              actionsPadding: const EdgeInsets.fromLTRB(
                14,
                8,
                14,
                14,
              ),
              title: const Row(
                children: [
                  Icon(
                    Icons.edit_rounded,
                    color: Color(0xFFFFD36A),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Edit Moment',
                    style: TextStyle(
                      color: Color(0xFFFFE5B2),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: const Color(0xFF090010),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF9435CD),
                        ),
                      ),
                      child: TextField(
                        controller: controller,
                        maxLength: 1000,
                        maxLines: null,
                        expands: true,
                        cursorColor: const Color(0xFFFFD36A),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.4,
                        ),
                        textAlignVertical: TextAlignVertical.top,
                        onChanged: (value) {
                          setDialogState(() {
                            characterCount = value.length;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Say something',
                          hintStyle: TextStyle(
                            color: Colors.white38,
                          ),
                          counterText: '',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '$characterCount/1000',
                        style: const TextStyle(
                          color: Color(0xFFB45BEE),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white60,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final String text =
                    controller.text.trim();

                    if (text.isEmpty &&
                        localMoment.imagePaths.isEmpty) {
                      return;
                    }

                    Navigator.pop(
                      dialogContext,
                      text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF7620A9),
                    foregroundColor:
                    const Color(0xFFFFE5A1),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(
                    Icons.check_rounded,
                    size: 19,
                  ),
                  label: const Text('Save'),
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
              (item) =>
          item.localData?.id == localMoment.id,
        );

        if (momentIndex != -1) {
          _moments[momentIndex] =
              _convertSavedMoment(updatedMoment);
        }
      });

      _showMomentMessage(
        'Moment updated successfully.',
      );
    } catch (_) {
      if (!mounted) return;

      _showMomentMessage(
        'Moment could not be updated.',
        isError: true,
      );
    }
  }

  Future<void> _deleteMoment(
      MomentItem moment,
      ) async {
    final LocalMomentData? localMoment = moment.localData;

    if (localMoment == null) {
      return;
    }

    final bool shouldDelete =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              backgroundColor:
              const Color(0xFF13001F),
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(22),
                side: BorderSide(
                  color: const Color(0xFFFF4E80)
                      .withOpacity(0.65),
                ),
              ),
              title: const Row(
                children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFFF5E88),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Delete Moment?',
                    style: TextStyle(
                      color: Color(0xFFFFE5B2),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              content: const Text(
                'This moment and its saved images will be permanently deleted.',
                style: TextStyle(
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      false,
                    );
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white60,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      true,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFFB8234E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(
                    Icons.delete_rounded,
                    size: 19,
                  ),
                  label: const Text('Delete'),
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
      await _momentStorage.deleteMoment(
        localMoment,
      );

      if (!mounted) return;

      setState(() {
        _moments.removeWhere(
              (item) =>
          item.localData?.id == localMoment.id,
        );
      });

      _showMomentMessage(
        'Moment deleted successfully.',
      );
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

  int _selectedTab = 1;

  final List<MomentItem> _moments = [
    const MomentItem(
      username: '🇨🇦 Ms Pinky 👑',
      avatarAsset: 'assets/images/moments/pinky_avatar.jpg',
      message:
      'I’m not interested your coins i need true love 💘❤️\n💋💛',
      time: '3 days ago',
      badge: 'Q 45',
      comments: 19,
      likes: 39,
      isLive: true,
      media: [
        MomentMedia.asset(
          'assets/images/moments/pinky_post_1.jpg',
        ),
        MomentMedia.asset(
          'assets/images/moments/pinky_post_2.jpg',
        ),
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
        MomentMedia.asset(
          'assets/images/moments/ali_birthday.jpg',
        ),
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

  Future<void> _openCreateMomentScreen() async {
    final CreatedMoment? createdMoment =
    await Navigator.push<CreatedMoment>(
      context,
      MaterialPageRoute(
        builder: (context) =>
        const CreateMomentScreen(),
      ),
    );

    if (createdMoment == null || !mounted) {
      return;
    }

    try {
      final LocalMomentData savedMoment =
      await _momentStorage.createMoment(
        text: createdMoment.text,
        sourceImagePaths:
        createdMoment.imagePaths,
      );

      if (!mounted) return;

      setState(() {
        _selectedTab = 1;

        _moments.insert(
          0,
          _convertSavedMoment(savedMoment),
        );
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Moment posted successfully.',
            ),
            backgroundColor: Color(0xFF361050),
            behavior: SnackBarBehavior.floating,
          ),
        );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Moment could not be saved.',
            ),
            backgroundColor: Color(0xFF7A1835),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
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

                const SizedBox(height: 8),

                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
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
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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

          const SizedBox(width: 25),

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

          ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                colors: [
                  Color(0xFFFFE49A),
                  Color(0xFFD99122),
                  Color(0xFFFFD36A),
                ],
              ).createShader(bounds);
            },
            child: const Icon(
              Icons.workspace_premium_rounded,
              size: 52,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMomentsFeed() {
    return ListView.separated(
      key: const ValueKey('moments-feed'),
      padding: const EdgeInsets.fromLTRB(
        10,
        4,
        10,
        150,
      ),
      itemCount: _moments.length,
      separatorBuilder: (_, __) =>
      const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final MomentItem moment = _moments[index];

        return MomentCard(
          key: ValueKey(
            moment.localData?.id ??
                'moment-sample-$index',
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
      padding: const EdgeInsets.fromLTRB(
        10,
        4,
        10,
        150,
      ),
      itemCount: _moments.length,
      separatorBuilder: (_, __) =>
      const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final MomentItem moment = _moments[index];

        return MomentCard(
          key: ValueKey(
            moment.localData?.id ??
                'follow-sample-$index',
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
            horizontal: 3,
            vertical: 4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: selected
                      ? const Color(0xFFFFD36A)
                      : Colors.white54,
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 5),

              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                height: 2,
                width: selected ? 115 : 0,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.transparent,
                      Color(0xFFFFD36A),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: selected
                      ? [
                    BoxShadow(
                      color: const Color(0xFFFFC34A)
                          .withOpacity(0.6),
                      blurRadius: 6,
                    ),
                  ]
                      : null,
                ),
              ),

              if (selected)
                Transform.translate(
                  offset: const Offset(0, -5),
                  child: Transform.rotate(
                    angle: 0.785398,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFFD36A),
                            Color(0xFFA72CFF),
                          ],
                        ),
                        border: Border.all(
                          color: const Color(0xFFFFE495),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFA72CFF)
                                .withOpacity(0.8),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _MomentMenuAction {
  edit,
  delete,
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
  State<MomentCard> createState() =>
      _MomentCardState();
}

class _MomentCardState extends State<MomentCard> {



  bool _liked = false;
  bool _followed = false;

  @override
  Widget build(BuildContext context) {
    final MomentItem moment = widget.moment;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xE60B0015),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF8D36BD).withOpacity(0.72),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7D1FB0).withOpacity(0.11),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(moment),

          if (moment.message.isNotEmpty) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 78, right: 6),
              child: Text(
                moment.message,
                style: const TextStyle(
                  color: Color(0xFFF1EDF5),
                  fontSize: 16,
                  height: 1.35,
                ),
              ),
            ),
          ],

          if (moment.media.isNotEmpty) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 78),
              child: _buildMedia(moment.media),
            ),
          ],

          const SizedBox(height: 13),

          Padding(
            padding: const EdgeInsets.only(left: 78),
            child: _buildFooter(moment),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(MomentItem moment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProfileAvatar(
          assetPath: moment.avatarAsset,
          isLive: moment.isLive,
        ),

        const SizedBox(width: 12),

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
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 7),

              Wrap(
                spacing: 8,
                runSpacing: 5,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _SmallBadge(
                    text: moment.badge,
                  ),
                  const Icon(
                    Icons.military_tech_rounded,
                    color: Color(0xFFD89832),
                    size: 25,
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
            duration: const Duration(milliseconds: 220),
            width: 54,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              gradient: _followed
                  ? const LinearGradient(
                colors: [
                  Color(0xFF6E1AA0),
                  Color(0xFFA739E5),
                ],
              )
                  : const LinearGradient(
                colors: [
                  Color(0xFF21102D),
                  Color(0xFF38134A),
                ],
              ),
              border: Border.all(
                color: const Color(0xFFFFC95C),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFC95C).withOpacity(0.2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Icon(
              _followed
                  ? Icons.check_rounded
                  : Icons.add_rounded,
              color: const Color(0xFFFFD36A),
              size: 34,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMedia(List<MomentMedia> media) {
    if (media.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: AspectRatio(
          aspectRatio: 1.02,
          child: _MomentImage(
            media: media.first,
          ),
        ),
      );
    }

    if (media.length == 2) {
      return Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 0.78,
                child: _MomentImage(
                  media: media[0],
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 0.78,
                child: _MomentImage(
                  media: media[1],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: media.length.clamp(0, 4),
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 7,
        mainAxisSpacing: 7,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: _MomentImage(
            media: media[index],
          ),
        );
      },
    );
  }

  Widget _buildMomentOptions() {
    final bool hasOwnerActions =
        widget.onEdit != null ||
            widget.onDelete != null;

    if (!hasOwnerActions) {
      return const Icon(
        Icons.more_horiz_rounded,
        color: Color(0xFFB75CF0),
        size: 28,
      );
    }

    return PopupMenuButton<_MomentMenuAction>(
      tooltip: 'Moment options',
      padding: EdgeInsets.zero,
      color: const Color(0xFF190024),
      elevation: 12,
      offset: const Offset(0, 34),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: const Color(0xFFA440F2)
              .withOpacity(0.65),
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
              child: Row(
                children: [
                  Icon(
                    Icons.edit_rounded,
                    color: Color(0xFFFFD36A),
                    size: 21,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Edit moment',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

          if (widget.onDelete != null)
            const PopupMenuItem<_MomentMenuAction>(
              value: _MomentMenuAction.delete,
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFFF5D87),
                    size: 22,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Delete moment',
                    style: TextStyle(
                      color: Color(0xFFFF8BA8),
                    ),
                  ),
                ],
              ),
            ),
        ];
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 3,
          vertical: 4,
        ),
        child: Icon(
          Icons.more_horiz_rounded,
          color: Color(0xFFB75CF0),
          size: 28,
        ),
      ),
    );
  }

  Widget _buildFooter(MomentItem moment) {
    return Row(
      children: [
        Expanded(
          child: Text(
            moment.time,
            style: const TextStyle(
              color: Color(0xFFB45BEE),
              fontSize: 15,
            ),
          ),
        ),

        const Icon(
          Icons.chat_bubble_outline_rounded,
          color: Color(0xFFFFD36A),
          size: 23,
        ),

        const SizedBox(width: 6),

        Text(
          '${moment.comments}',
          style: const TextStyle(
            color: Color(0xFFFFD36A),
            fontSize: 15,
          ),
        ),

        const SizedBox(width: 22),

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
            size: 28,
          ),
        ),

        const SizedBox(width: 6),

        Text(
          '${moment.likes + (_liked ? 1 : 0)}',
          style: const TextStyle(
            color: Color(0xFFFFD36A),
            fontSize: 15,
          ),
        ),

        const SizedBox(width: 20),

        _buildMomentOptions(),

      ],
    );
  }
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
      width: 66,
      height: 76,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFD36A),
                  Color(0xFFB635FF),
                  Color(0xFF52156F),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB635FF).withOpacity(0.45),
                  blurRadius: 12,
                ),
              ],
            ),
            child: ClipOval(
              child: assetPath.isEmpty
                  ? Container(
                color: const Color(0xFF38104E),
                child: const Icon(
                  Icons.person_rounded,
                  color: Color(0xFFFFD36A),
                  size: 38,
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
                      size: 38,
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
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF20A9),
                      Color(0xFFB719E4),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                      const Color(0xFFFF20A9).withOpacity(0.45),
                      blurRadius: 7,
                    ),
                  ],
                ),
                child: const Text(
                  'Live',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
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
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF02B9B),
            Color(0xFFAF44F2),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEC2DAB).withOpacity(0.25),
            blurRadius: 7,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MomentImage extends StatelessWidget {
  final MomentMedia media;

  const _MomentImage({
    required this.media,
  });

  @override
  Widget build(BuildContext context) {
    if (media.type == MomentMediaType.file) {
      return Image.file(
        File(media.path),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }

    return Image.asset(
      media.path,
      fit: BoxFit.cover,
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
          size: 44,
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
          width: 66,
          height: 66,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFA02DE8),
                Color(0xFF6816A5),
                Color(0xFF321047),
              ],
            ),
            border: Border.all(
              color: const Color(0xFFFFD36A),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9C32EA).withOpacity(0.65),
                blurRadius: 18,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.send_rounded,
                color: Color(0xFFFFD36A),
                size: 36,
              ),

              Positioned(
                right: 6,
                bottom: 5,
                child: Container(
                  width: 19,
                  height: 19,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF341047),
                    border: Border.all(
                      color: const Color(0xFFFFD36A),
                    ),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    size: 15,
                    color: Color(0xFFFFD36A),
                  ),
                ),
              ),
            ],
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0C0015),
            Color(0xFF07000E),
            Color(0xFF0A0011),
          ],
        ),
      ),
    );
  }
}