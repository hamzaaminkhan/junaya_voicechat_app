import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:junaya_voicechat_app/screens/moments/create%20moment/drafts_screen.dart';
import 'package:junaya_voicechat_app/screens/moments/create%20moment/widgets/moment_media_picker.dart';
import 'package:junaya_voicechat_app/screens/moments/create%20moment/widgets/moment_option_tile.dart';
import 'package:junaya_voicechat_app/screens/moments/create%20moment/widgets/voice_note_tile.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/moments_provider.dart';

class CreateMomentScreen extends ConsumerStatefulWidget {
  const CreateMomentScreen({
    super.key,
  });

  @override
  ConsumerState<CreateMomentScreen> createState() =>
      _CreateMomentScreenState();
}

class _CreateMomentScreenState
    extends ConsumerState<CreateMomentScreen> {

  Future<void> _handleClose() async {
    final hasChanges =
        _captionController.text.trim().isNotEmpty ||
            _mediaPaths.isNotEmpty ||
            _location != null;

    if (!hasChanges) {
      Navigator.of(context).pop();
      return;
    }

    final discard = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xff151522),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Discard moment?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'Your changes will be lost.',
            style: TextStyle(
              color: Color(0xff9999A8),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            14,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                'Keep editing',
                style: TextStyle(
                  color: Color(0xffA855F7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'Discard',
                style: TextStyle(
                  color: Color(0xffFF4D6D),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (discard == true && mounted) {
      Navigator.of(context).pop();
    }
  }


  final TextEditingController _captionController =
  TextEditingController();

  List<String> _mediaPaths = [];
  MomentLocation? _location;
  MomentVisibility _visibility =
      MomentVisibility.public;
  bool _posting = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _createMoment() async {
    final caption =
    _captionController.text.trim();

    if (caption.isEmpty && _mediaPaths.isEmpty) {
      _showMessage(
        'Add text or photos',
      );
      return;
    }

    if (_posting) {
      return;
    }

    setState(() {
      _posting = true;
    });

    try {
      final moment = Moment(
        id: generateId(),
        author: const MomentUser(
          id: 'local_user',
          username: 'junaya',
          displayName: 'Junaya User',
          avatar: '',
        ),
        caption: caption,
        media: const [],
        createdAt: DateTime.now(),
        visibility: _visibility,
        location: _location,
        hashtags: const [],
        stats: const MomentStats(),
        isLiked: false,
        reactions: const [],
        isPinned: false,
        isSaved: false,
      );

      await ref
          .read(momentsProvider.notifier)
          .createMoment(
        moment: moment,
        mediaPaths: _mediaPaths,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } catch (error, stackTrace) {
      debugPrint(
        'Create moment error: $error',
      );
      debugPrint(
        stackTrace.toString(),
      );

      if (mounted) {
        _showMessage(
          'Failed creating moment',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _posting = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  Future<void> _selectVisibility() async {
    final selected =
    await showModalBottomSheet<MomentVisibility>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _VisibilitySheet(
          current: _visibility,
        );
      },
    );

    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      _visibility = selected;
    });
  }

  Future<void> _selectLocation() async {
    final controller =
    TextEditingController(
      text: _location?.name ?? '',
    );

    final name =
    await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _LocationSheet(
          controller: controller,
        );
      },
    );

    controller.dispose();

    if (!mounted || name == null) {
      return;
    }

    setState(() {
      _location = name.trim().isEmpty
          ? null
          : MomentLocation(
        name: name.trim(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }

          _handleClose();
        },

      child : Scaffold(
      backgroundColor: const Color(0xff07070D),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics:
                const BouncingScrollPhysics(),
                padding:
                const EdgeInsets.fromLTRB(
                  16,
                  4,
                  16,
                  24,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _buildProfile(),
                    const SizedBox(height: 20),
                    _buildCaption(),
                    const SizedBox(height: 14),
                    MomentMediaPicker(
                      onChanged: (paths) {
                        setState(() {
                          _mediaPaths =
                          List<String>.from(paths);
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildOptions(),
                  ],
                ),
              ),
            ),
            _buildShareButton(),
          ],
        ),
      ),
    )
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        8,
        8,
        12,
        12,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _posting
                ? null
                : _handleClose,
            splashRadius: 22,
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),

          const Expanded(
            child: Center(
              child: Text(
                'Create Moment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const DraftsScreen(),
                ),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
              ),
              child: Text(
                'Drafts',
                style: TextStyle(
                  color: Color(0xffA855F7),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(1.5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color(0xffA855F7),
                Color(0xffEC4899),
              ],
            ),
          ),
          child: const CircleAvatar(
            backgroundColor: Color(0xff20202A),
            child: Icon(
              Icons.person,
              color: Colors.white54,
              size: 21,
            ),
          ),
        ),
        const SizedBox(width: 11),
        const Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Junaya',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2),
              Text(
                '@junaya',
                style: TextStyle(
                  color: Color(0xff858593),
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
        _VisibilityBadge(
          visibility: _visibility,
        ),
      ],
    );
  }

  Widget _buildCaption() {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 150,
      ),
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff11111A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: .06),
        ),
      ),
      child: TextField(
        controller: _captionController,
        maxLength: 500,
        minLines: 5,
        maxLines: 8,
        textCapitalization:
        TextCapitalization.sentences,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          height: 1.45,
        ),
        decoration: const InputDecoration(
          hintText: 'What’s on your mind?',
          hintStyle: TextStyle(
            color: Color(0xff5F5F6D),
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          counterStyle: TextStyle(
            color: Color(0xff5F5F6D),
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff11111A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: .05),
        ),
      ),
      child: Column(
        children: [
          MomentOptionTile(
            icon: Icons.location_on_outlined,
            color: const Color(0xffA855F7),
            title: 'Location',
            value: _location?.name ??
                'Add location',
            onTap: _selectLocation,
          ),
          _divider(),
          MomentOptionTile(
            icon: Icons.public_rounded,
            color: const Color(0xff22C55E),
            title: 'Visibility',
            value: _visibilityLabel,
            onTap: _selectVisibility,
          ),
          _divider(),
          const VoiceNoteTile(),
        ],
      ),
    );
  }

  String get _visibilityLabel {
    switch (_visibility) {
      case MomentVisibility.public:
        return 'Public';
      case MomentVisibility.friends:
        return 'Friends';
      case MomentVisibility.private:
        return 'Only me';
    }
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 54,
      ),
      child: Divider(
        height: 1,
        color: Colors.white.withValues(alpha: .05),
      ),
    );
  }

  Widget _buildShareButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff07070D),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: .05),
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed:
          _posting ? null : _createMoment,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor:
            const Color(0xff8B5CF6),
            disabledBackgroundColor:
            const Color(0xff3A3345),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(16),
            ),
          ),
          child: _posting
              ? const SizedBox(
            width: 20,
            height: 20,
            child:
            CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Text(
            'Share Moment',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _VisibilityBadge extends StatelessWidget {
  final MomentVisibility visibility;

  const _VisibilityBadge({
    required this.visibility,
  });

  @override
  Widget build(BuildContext context) {
    final isPublic =
        visibility == MomentVisibility.public;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff191923),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPublic
                ? Icons.public_rounded
                : Icons.lock_outline_rounded,
            color: const Color(0xffA7A7B5),
            size: 14,
          ),
          const SizedBox(width: 5),
          Text(
            _label,
            style: const TextStyle(
              color: Color(0xffD5D5DD),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String get _label {
    switch (visibility) {
      case MomentVisibility.public:
        return 'Public';
      case MomentVisibility.friends:
        return 'Friends';
      case MomentVisibility.private:
        return 'Only me';
    }
  }
}

class _VisibilitySheet extends StatelessWidget {
  final MomentVisibility current;

  const _VisibilitySheet({
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        28,
      ),
      decoration: const BoxDecoration(
        color: Color(0xff11111A),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _handle(),
          const SizedBox(height: 18),
          const Text(
            'Who can see this moment?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          _option(
            context,
            MomentVisibility.public,
            Icons.public_rounded,
            'Public',
            'Everyone can see this',
          ),
          _option(
            context,
            MomentVisibility.friends,
            Icons.people_outline_rounded,
            'Friends',
            'Only your friends can see this',
          ),
          _option(
            context,
            MomentVisibility.private,
            Icons.lock_outline_rounded,
            'Only me',
            'Only you can see this',
          ),
        ],
      ),
    );
  }

  Widget _option(
      BuildContext context,
      MomentVisibility value,
      IconData icon,
      String title,
      String subtitle,
      ) {
    final selected = current == value;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context, value);
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xffA855F7)
                    .withValues(alpha: .14)
                    : const Color(0xff20202A),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: selected
                    ? const Color(0xffA855F7)
                    : Colors.white54,
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
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xffA855F7),
                size: 21,
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
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class _LocationSheet extends StatelessWidget {
  final TextEditingController controller;

  const _LocationSheet({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom:
        MediaQuery.of(context)
            .viewInsets
            .bottom +
            24,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          20,
        ),
        decoration: const BoxDecoration(
          color: Color(0xff11111A),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(26),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius:
                BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 18),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Add location',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              autofocus: true,
              textCapitalization:
              TextCapitalization.words,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Enter a location',
                hintStyle: const TextStyle(
                  color: Colors.white38,
                ),
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xffA855F7),
                ),
                filled: true,
                fillColor:
                const Color(0xff20202A),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    controller.text,
                  );
                },
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xff8B5CF6),
                  elevation: 0,
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Save location',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}