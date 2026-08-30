import 'package:flutter/material.dart';

class PublishMomentSheet extends StatelessWidget {
  final String caption;
  final List<String> media;
  final String visibility;
  final String? location;
  final String? voiceDuration;
  final VoidCallback? onPublish;
  final VoidCallback? onEdit;

  const PublishMomentSheet({
    super.key,
    this.caption = '',
    this.media = const [],
    this.visibility = 'Public',
    this.location,
    this.voiceDuration,
    this.onPublish,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        20,
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
            _handle(),

            const SizedBox(height: 18),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Ready to share?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _editButton(),
              ],
            ),

            const SizedBox(height: 16),

            _preview(),

            const SizedBox(height: 16),

            _details(),

            const SizedBox(height: 18),

            _publishButton(),
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

  Widget _editButton() {
    return GestureDetector(
      onTap: onEdit,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff20202A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.edit_outlined,
              color: Color(0xffA855F7),
              size: 15,
            ),
            SizedBox(width: 5),
            Text(
              'Edit',
              style: TextStyle(
                color: Color(0xffC084FC),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _preview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xff191923),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _mediaPreview(),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  caption.trim().isEmpty
                      ? 'Your moment'
                      : caption.trim(),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),

                if (media.isNotEmpty)
                  Padding(
                    padding:
                    const EdgeInsets.only(
                      top: 8,
                    ),
                    child: Text(
                      '${media.length} ${media.length == 1 ? 'item' : 'items'}',
                      style: const TextStyle(
                        color: Color(0xff777787),
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mediaPreview() {
    if (media.isEmpty) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xff20202A),
          borderRadius:
          BorderRadius.circular(13),
        ),
        child: const Icon(
          Icons.edit_note_rounded,
          color: Colors.white24,
          size: 28,
        ),
      );
    }

    final path = media.first;

    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: _image(path),
    );
  }

  Widget _image(String path) {
    if (path.startsWith('http://') ||
        path.startsWith('https://')) {
      return Image.network(
        path,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            _placeholder(),
      );
    }

    return Image.asset(
      path,
      width: 64,
      height: 64,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 64,
      height: 64,
      color: const Color(0xff20202A),
      child: const Icon(
        Icons.image_outlined,
        color: Colors.white30,
        size: 24,
      ),
    );
  }

  Widget _details() {
    return Column(
      children: [
        _detailRow(
          icon: Icons.public_rounded,
          title: 'Visibility',
          value: visibility,
          color: const Color(0xff22C55E),
        ),

        if (location != null &&
            location!.trim().isNotEmpty)
          _detailRow(
            icon: Icons.location_on_outlined,
            title: 'Location',
            value: location!,
            color: const Color(0xffA855F7),
          ),

        if (voiceDuration != null &&
            voiceDuration!.trim().isNotEmpty)
          _detailRow(
            icon: Icons.mic_none_rounded,
            title: 'Voice note',
            value: voiceDuration!,
            color: const Color(0xffA855F7),
          ),
      ],
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 18,
          ),

          const SizedBox(width: 9),

          Text(
            title,
            style: const TextStyle(
              color: Color(0xff9999A8),
              fontSize: 13,
            ),
          ),

          const Spacer(),

          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _publishButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPublish,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor:
          const Color(0xff8B5CF6),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.send_rounded,
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              'Share Moment',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}