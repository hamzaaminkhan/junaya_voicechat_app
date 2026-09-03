import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:junaya_voicechat_app/screens/moments/create%20moment/widgets/location_sheet.dart';
import 'package:junaya_voicechat_app/screens/moments/create%20moment/widgets/media_source_sheet.dart';
import 'package:junaya_voicechat_app/screens/moments/create%20moment/widgets/moment_media_picker.dart';
import 'package:junaya_voicechat_app/screens/moments/create%20moment/widgets/visibility_sheet.dart';
import 'package:junaya_voicechat_app/screens/moments/create%20moment/widgets/voice_note_sheet.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_draft_model.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/drafts_provider.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_publisher.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/moments_provider.dart';
import 'package:junaya_voicechat_app/screens/moments/services/moment_media_service.dart';
import 'package:junaya_voicechat_app/services/backend_auth_service.dart';


class CreateMomentScreen
    extends ConsumerStatefulWidget {
  const CreateMomentScreen({
    super.key,
  });

  @override
  ConsumerState<CreateMomentScreen>
  createState() =>
      _CreateMomentScreenState();
}

class _CreateMomentScreenState
    extends ConsumerState<CreateMomentScreen> {

  Map<String, dynamic>? _profile;
  final MomentPublisher _publisher =
  const MomentPublisher();

  final TextEditingController
  _captionController =
  TextEditingController();

  final MomentMediaService
  _mediaService =
  MomentMediaService();

  final List<String> _mediaPaths = [];

  MomentVisibility _visibility =
      MomentVisibility.public;

  String? _location;

  String? _voicePath;

  Duration? _voiceDuration;

  String? _draftId;

  DateTime? _draftCreatedAt;

  bool _hasChanges = false;

  bool _isAddingMedia = false;

  bool _isSavingDraft = false;

  @override
  void initState() {
    super.initState();

    _captionController.addListener(
      _onCaptionChanged,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
      _restoreDraft();
    });
  }

  Future<void> _loadProfile() async {
    try {
      final profile =
      await BackendAuthService.instance.getProfile();

      if (!mounted) return;

      setState(() {
        _profile = profile;
      });
    } catch (error) {
      debugPrint(
        'Create Moment profile error: $error',
      );
    }
  }

  void _onCaptionChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child:
              SingleChildScrollView(
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

                    const SizedBox(
                      height: 20,
                    ),

                    _buildCaption(),

                    const SizedBox(
                      height: 14,
                    ),

                    _buildMedia(),

                    const SizedBox(
                      height: 14,
                    ),

                    _buildOptions(),
                  ],
                ),
              ),
            ),

            _buildShareButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding:
      const EdgeInsets.fromLTRB(
        8,
        8,
        12,
        12,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed:
            _handleClose,
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
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap:
            _isSavingDraft
                ? null
                : _saveDraft,
            behavior:
            HitTestBehavior.opaque,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
              ),
              child: _isSavingDraft
                  ? const SizedBox(
                width: 16,
                height: 16,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color:
                  Color(0xffA855F7),
                ),
              )
                  : const Text(
                'Save',
                style: TextStyle(
                  color:
                  Color(0xffA855F7),
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    final username =
    (_profile?['username']?.toString().trim().isNotEmpty ?? false)
        ? _profile!['username'].toString().trim()
        : 'Junaya User';

    final avatarUrl =
        _profile?['avatarUrl']?.toString().trim() ?? '';

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(1.5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffA855F7),
                Color(0xffEC4899),
              ],
            ),
          ),
          child: CircleAvatar(
            backgroundColor: const Color(0xff20202A),
            backgroundImage: avatarUrl.isNotEmpty
                ? NetworkImage(avatarUrl)
                : const AssetImage(
              'assets/users/profile.png',
            ),
            child: avatarUrl.isEmpty
                ? const Icon(
              Icons.person_rounded,
              color: Colors.white54,
              size: 21,
            )
                : null,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Text(
            username,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        _buildVisibilityBadge(),
      ],
    );
  }

  Widget _buildVisibilityBadge() {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration:
      BoxDecoration(
        color:
        const Color(0xff191923),
        borderRadius:
        BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Icon(
            _visibilityIcon(),
            color:
            const Color(0xffA7A7B5),
            size: 14,
          ),
          const SizedBox(width: 5),
          Text(
            _visibilityLabel(),
            style:
            const TextStyle(
              color:
              Color(0xffD5D5DD),
              fontSize: 12,
              fontWeight:
              FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaption() {
    return Container(
      constraints:
      const BoxConstraints(
        minHeight: 156,
      ),
      padding:
      const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        10,
      ),
      decoration:
      BoxDecoration(
        color:
        const Color(0xff11111A),
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          TextField(
            controller:
            _captionController,
            minLines: 5,
            maxLines: 8,
            maxLength: 500,
            textCapitalization:
            TextCapitalization
                .sentences,
            keyboardType:
            TextInputType.multiline,
            style:
            const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.45,
            ),
            cursorColor:
            const Color(0xffA855F7),
            decoration:
            const InputDecoration(
              hintText:
              'What’s on your mind?',
              hintStyle:
              TextStyle(
                color:
                Color(0xff5F5F6D),
                fontSize: 16,
              ),
              border:
              InputBorder.none,
              enabledBorder:
              InputBorder.none,
              focusedBorder:
              InputBorder.none,
              contentPadding:
              EdgeInsets.zero,
              counterText: '',
            ),
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Share something with your community',
                  style: TextStyle(
                    color:
                    Color(0xff666675),
                    fontSize: 11.5,
                  ),
                ),
              ),
              ValueListenableBuilder<
                  TextEditingValue>(
                valueListenable:
                _captionController,
                builder: (
                    context,
                    value,
                    child,
                    ) {
                  return Text(
                    '${value.text.length}/500',
                    style:
                    const TextStyle(
                      color:
                      Color(0xff666675),
                      fontSize: 11,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedia() {
    return Stack(
      children: [
        MomentMediaPicker(
          mediaPaths:
          _mediaPaths,
          maxMedia: 10,
          onAdd:
          _openMediaSource,
          onRemove:
          _removeMedia,
        ),

        if (_isAddingMedia)
          Positioned.fill(
            child: Container(
              decoration:
              BoxDecoration(
                color: Colors.black
                    .withOpacity(.35),
                borderRadius:
                BorderRadius.circular(
                  20,
                ),
              ),
              child:
              const Center(
                child:
                CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color:
                  Color(0xffA855F7),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void>
  _openMediaSource() async {
    if (_isAddingMedia) {
      return;
    }

    if (_mediaPaths.length >= 10) {
      _showMessage(
        'You can add up to 10 media items.',
      );
      return;
    }

    final source =
    await showModalBottomSheet<
        MomentMediaSource>(
      context: context,
      backgroundColor:
      Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return const MediaSourceSheet();
      },
    );

    if (!mounted || source == null) {
      return;
    }

    setState(() {
      _isAddingMedia = true;
    });

    try {
      final remaining =
          10 - _mediaPaths.length;

      List<String> paths;

      switch (source) {
        case MomentMediaSource.camera:
          paths = await _mediaService
              .selectCameraMedia();
          break;

        case MomentMediaSource.photos:
          paths = await _mediaService
              .selectPhotos(
            remaining: remaining,
          );
          break;

        case MomentMediaSource.video:
          paths = await _mediaService
              .selectVideo();
          break;

        case MomentMediaSource.cameraVideo:
          paths = await _mediaService
              .selectCameraVideo();
          break;
      }

      if (!mounted ||
          paths.isEmpty) {
        return;
      }

      final available =
          10 - _mediaPaths.length;

      final accepted =
      paths.take(available).toList();

      setState(() {
        _mediaPaths.addAll(
          accepted,
        );
        _hasChanges = true;
      });
    } catch (_) {
      _showMessage(
        'Unable to add media.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAddingMedia = false;
        });
      }
    }
  }

  void _removeMedia(int index) {
    if (index < 0 ||
        index >= _mediaPaths.length) {
      return;
    }

    setState(() {
      _mediaPaths.removeAt(index);
      _hasChanges = true;
    });
  }

  Widget _buildOptions() {
    return Container(
      decoration:
      BoxDecoration(
        color:
        const Color(0xff11111A),
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildOptionRow(
            icon:
            Icons.location_on_outlined,
            color:
            const Color(0xffA855F7),
            title: 'Location',
            value:
            _location ??
                'Add location',
            onTap:
            _openLocation,
          ),

          _buildDivider(),

          _buildOptionRow(
            icon:
            _visibilityIcon(),
            color:
            _visibilityColor(),
            title: 'Visibility',
            value:
            _visibilityLabel(),
            onTap:
            _openVisibility,
          ),

          _buildDivider(),

          _buildOptionRow(
            icon:
            _voicePath == null
                ? Icons
                .mic_none_rounded
                : Icons
                .mic_rounded,
            color:
            const Color(0xffEC4899),
            title: 'Voice note',
            value:
            _voicePath == null
                ? 'Add a voice note'
                : _voiceDurationLabel(),
            onTap:
            _openVoiceNote,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionRow({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(20),
        child: Padding(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration:
                BoxDecoration(
                  color: color
                      .withOpacity(.11),
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
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      title,
                      style:
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      value,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style:
                      const TextStyle(
                        color:
                        Color(0xff777787),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons
                    .chevron_right_rounded,
                color:
                Color(0xff555563),
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding:
      const EdgeInsets.only(
        left: 66,
      ),
      child: Divider(
        height: 1,
        color: Colors.white
            .withOpacity(.05),
      ),
    );
  }

  Future<void> _openLocation() async {
    FocusScope.of(context).unfocus();

    final result =
    await showModalBottomSheet<String>(
      context: context,
      backgroundColor:
      Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return LocationSheet(
          selectedLocation:
          _location,
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _location =
      result.isEmpty ? null : result;
      _hasChanges = true;
    });
  }

  Future<void> _openVisibility() async {
    FocusScope.of(context).unfocus();

    final result =
    await showModalBottomSheet<
        MomentVisibility>(
      context: context,
      backgroundColor:
      Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return VisibilitySheet(
          selected:
          _visibility,
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _visibility = result;
      _hasChanges = true;
    });
  }

  Future<void> _openVoiceNote() async {
    FocusScope.of(context).unfocus();

    final result =
    await showModalBottomSheet<
        VoiceNoteResult>(
      context: context,
      backgroundColor:
      Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return VoiceNoteSheet(
          existingPath:
          _voicePath,
          existingDuration:
          _voiceDuration,
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _voicePath = result.path;
      _voiceDuration =
          result.duration;
      _hasChanges = true;
    });
  }

  // ============================================================
  // DRAFT
  // ============================================================

  Future<void> _restoreDraft() async {
    final draft =
    await ref
        .read(momentDraftProvider
        .notifier)
        .reload();

    if (!mounted || draft == null) {
      return;
    }

    final shouldRestore =
    await _showRestoreDraftDialog();

    if (!mounted) {
      return;
    }

    if (!shouldRestore) {
      await ref
          .read(momentDraftProvider
          .notifier)
          .clear();

      return;
    }

    _applyDraft(draft);
  }

  void _applyDraft(
      MomentDraft draft,
      ) {
    setState(() {
      _draftId = draft.id;
      _draftCreatedAt =
          draft.createdAt;

      _captionController.text =
          draft.caption;

      _mediaPaths
        ..clear()
        ..addAll(draft.mediaPaths);

      _location =
          draft.location;

      _visibility =
          _visibilityFromString(
            draft.visibility,
          );

      _voicePath =
          draft.voicePath;

      _voiceDuration =
          draft.voiceDuration;

      _hasChanges = false;
    });
  }

  Future<bool> _showRestoreDraftDialog() async {
    final result =
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
          const Color(0xff15151F),
          title: const Text(
            'Continue your draft?',
            style: TextStyle(
              color: Colors.white,
              fontWeight:
              FontWeight.w700,
            ),
          ),
          content: const Text(
            'You have an unfinished Moment. Would you like to continue where you left off?',
            style: TextStyle(
              color:
              Color(0xff9B9BA8),
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false);
              },
              child: const Text(
                'Discard',
                style: TextStyle(
                  color:
                  Color(0xffF87171),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true);
              },
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                const Color(
                    0xff8B5CF6),
                foregroundColor:
                Colors.white,
              ),
              child:
              const Text('Continue'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _saveDraft() async {
    if (_isSavingDraft) {
      return;
    }

    setState(() {
      _isSavingDraft = true;
    });

    try {
      final now = DateTime.now();

      final draft =
      MomentDraft(
        id: _draftId ??
            now.microsecondsSinceEpoch
                .toString(),
        caption:
        _captionController.text
            .trim(),
        mediaPaths:
        List.unmodifiable(
          _mediaPaths,
        ),
        location: _location,
        visibility:
        _visibility.name,
        voicePath: _voicePath,
        voiceDuration:
        _voiceDuration,
        createdAt:
        _draftCreatedAt ?? now,
        updatedAt: now,
      );

      await ref
          .read(momentDraftProvider
          .notifier)
          .save(draft);

      if (!mounted) {
        return;
      }

      setState(() {
        _draftId = draft.id;
        _draftCreatedAt =
            draft.createdAt;
        _hasChanges = false;
      });

      _showMessage(
        'Moment saved as draft.',
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Unable to save draft.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSavingDraft = false;
        });
      }
    }
  }

  Future<void> _handleClose() async {
    FocusScope.of(context).unfocus();

    if (!_hasUnsavedContent()) {
      if (mounted) {
        Navigator.of(context).pop();
      }
      return;
    }

    final action =
    await showModalBottomSheet<
        _CloseAction>(
      context: context,
      backgroundColor:
      Colors.transparent,
      builder: (_) {
        return const _CloseSheet();
      },
    );

    if (!mounted || action == null) {
      return;
    }

    switch (action) {
      case _CloseAction.save:
        await _saveDraft();

        if (!mounted) {
          return;
        }

        Navigator.of(context).pop();
        break;

      case _CloseAction.discard:
        await ref
            .read(momentDraftProvider
            .notifier)
            .clear();

        if (!mounted) {
          return;
        }

        Navigator.of(context).pop();
        break;

      case _CloseAction.cancel:
        break;
    }
  }

  bool _hasUnsavedContent() {
    return _captionController.text
        .trim()
        .isNotEmpty ||
        _mediaPaths.isNotEmpty ||
        _location != null ||
        _voicePath != null;
  }

  // ============================================================
  // SHARE
  // ============================================================

  Widget _buildShareButton() {
    final hasContent =
        _captionController.text
            .trim()
            .isNotEmpty ||
            _mediaPaths.isNotEmpty ||
            _voicePath != null;

    return Container(
      padding:
      const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        12,
      ),
      decoration:
      BoxDecoration(
        color:
        const Color(0xff07070D),
        border: Border(
          top: BorderSide(
            color: Colors.white
                .withOpacity(.05),
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed:
          hasContent
              ? _onSharePressed
              : null,
          style:
          ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor:
            const Color(0xff8B5CF6),
            disabledBackgroundColor:
            const Color(0xff292433),
            foregroundColor:
            Colors.white,
            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(
                16,
              ),
            ),
          ),
          child: const Text(
            'Share Moment',
            style: TextStyle(
              fontSize: 15,
              fontWeight:
              FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSharePressed() async {
    if (_isSavingDraft) {
      return;
    }

    FocusScope.of(context).unfocus();

    final caption =
    _captionController.text.trim();

    final hasContent =
        caption.isNotEmpty ||
            _mediaPaths.isNotEmpty ||
            _voicePath != null;

    if (!hasContent) {
      _showMessage(
        'Add something before sharing.',
      );
      return;
    }

    final moment =
    _publisher.build(
      caption: caption,
      visibility: _visibility.name,
      location: _location,
      mediaPaths:
      List.unmodifiable(_mediaPaths),
      voicePath: _voicePath,
      voiceDuration: _voiceDuration,
    );

    setState(() {
      _isSavingDraft = true;
    });

    try {
      await ref
          .read(momentsProvider.notifier)
          .createMoment(
        moment: moment,
        mediaPaths:
        List.unmodifiable(_mediaPaths),
      );

      if (!mounted) {
        return;
      }

      await ref
          .read(
        momentDraftProvider.notifier,
      )
          .clear();

      if (!mounted) {
        return;
      }

      setState(() {
        _hasChanges = false;
        _draftId = null;
        _draftCreatedAt = null;
      });

      _showMessage(
        'Moment shared successfully.',
      );

      await Future<void>.delayed(
        const Duration(milliseconds: 350),
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } catch (error, stackTrace) {
      debugPrint(
        'Publish Moment error: $error',
      );

      debugPrint(
        stackTrace.toString(),
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        'Unable to publish your Moment.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSavingDraft = false;
        });
      }
    }
  }

  // ============================================================
  // HELPERS
  // ============================================================

  MomentVisibility _visibilityFromString(
      String value,
      ) {
    switch (value) {
      case 'followers':
        return MomentVisibility.followers;

      case 'private':
        return MomentVisibility.private;

      case 'public':
      default:
        return MomentVisibility.public;
    }
  }

  IconData _visibilityIcon() {
    switch (_visibility) {
      case MomentVisibility.public:
        return Icons.public_rounded;

      case MomentVisibility.followers:
        return Icons.people_outline_rounded;

      case MomentVisibility.private:
        return Icons.lock_outline_rounded;
    }
  }

  Color _visibilityColor() {
    switch (_visibility) {
      case MomentVisibility.public:
        return const Color(0xff22C55E);

      case MomentVisibility.followers:
        return const Color(0xffA855F7);

      case MomentVisibility.private:
        return const Color(0xffF59E0B);
    }
  }

  String _visibilityLabel() {
    switch (_visibility) {
      case MomentVisibility.public:
        return 'Public';

      case MomentVisibility.followers:
        return 'Followers';

      case MomentVisibility.private:
        return 'Only me';
    }
  }

  String _voiceDurationLabel() {
    final duration = _voiceDuration;

    if (duration == null) {
      return 'Voice note added';
    }

    final minutes = duration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    final seconds = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
  }

  void _showMessage(
      String message,
      ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content:
          Text(message),
          behavior:
          SnackBarBehavior.floating,
          margin:
          const EdgeInsets.all(16),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              14,
            ),
          ),
        ),
      );
  }
}

enum _CloseAction {
  save,
  discard,
  cancel,
}

class _CloseSheet extends StatelessWidget {
  const _CloseSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        24,
      ),
      decoration:
      const BoxDecoration(
        color:
        Color(0xff11111A),
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 4,
              decoration:
              BoxDecoration(
                color:
                Colors.white24,
                borderRadius:
                BorderRadius.circular(
                  20,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Save your Moment?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight:
                FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'You have unsaved changes.',
              style: TextStyle(
                color:
                Color(0xff777787),
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 20),

            _ActionButton(
              title: 'Save draft',
              icon:
              Icons.bookmark_outline_rounded,
              onTap: () {
                Navigator.of(context)
                    .pop(
                  _CloseAction.save,
                );
              },
            ),

            const SizedBox(height: 8),

            _ActionButton(
              title: 'Discard',
              icon:
              Icons.delete_outline_rounded,
              destructive: true,
              onTap: () {
                Navigator.of(context)
                    .pop(
                  _CloseAction.discard,
                );
              },
            ),

            const SizedBox(height: 8),

            _ActionButton(
              title: 'Keep editing',
              icon:
              Icons.edit_outlined,
              onTap: () {
                Navigator.of(context)
                    .pop(
                  _CloseAction.cancel,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton
    extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool destructive;

  const _ActionButton({
    required this.title,
    required this.icon,
    required this.onTap,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
      const Color(0xff191923),
      borderRadius:
      BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(15),
        child: Padding(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 14,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: destructive
                    ? const Color(
                  0xffF87171,
                )
                    : const Color(
                  0xffA855F7,
                ),
                size: 21,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: destructive
                      ? const Color(
                    0xffF87171,
                  )
                      : Colors.white,
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}