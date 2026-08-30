import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/screens/moments/create%20moment/widgets/moment_media_picker.dart';
import 'package:junaya_voicechat_app/screens/moments/create%20moment/widgets/moment_option_tile.dart';
import 'package:junaya_voicechat_app/screens/moments/create%20moment/widgets/voice_note_tile.dart';

class CreateMomentScreen extends StatefulWidget {
  const CreateMomentScreen({
    super.key,
  });

  @override
  State<CreateMomentScreen> createState() =>
      _CreateMomentScreenState();
}

class _CreateMomentScreenState
    extends State<CreateMomentScreen> {
  final TextEditingController _caption =
  TextEditingController();

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff07070D),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
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
                    const MomentMediaPicker(),
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
            onPressed: () {
              Navigator.of(context).pop();
            },
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
            onTap: () {},
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
        _VisibilityBadge(),
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
        controller: _caption,
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
            value: 'Add location',
          ),
          _divider(),
          MomentOptionTile(
            icon: Icons.public_rounded,
            color: const Color(0xff22C55E),
            title: 'Visibility',
            value: 'Public',
          ),
          _divider(),
          const VoiceNoteTile(),
        ],
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
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor:
            const Color(0xff8B5CF6),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
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
  const _VisibilityBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff191923),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.public_rounded,
            color: Color(0xffA7A7B5),
            size: 14,
          ),
          SizedBox(width: 5),
          Text(
            'Public',
            style: TextStyle(
              color: Color(0xffD5D5DD),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}