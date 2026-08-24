import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatedMoment {
  final String text;
  final List<String> imagePaths;

  const CreatedMoment({required this.text, required this.imagePaths});
}

class CreateMomentScreen extends StatefulWidget {
  const CreateMomentScreen({super.key});

  @override
  State<CreateMomentScreen> createState() => _CreateMomentScreenState();
}

class _CreateMomentScreenState extends State<CreateMomentScreen> {
  static const Color backgroundColor = Colors.transparent;
  static const Color purpleColor = Color(0xFF9D3BFF);
  static const Color lightPurpleColor = Color(0xFFD27AFF);
  static const Color goldColor = Color(0xFFFFD36A);

  final TextEditingController _textController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  final List<XFile> _selectedImages = [];

  bool _isSending = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedImages = await _imagePicker.pickMultiImage(
        imageQuality: 88,
      );

      if (!mounted || pickedImages.isEmpty) return;

      final int remainingSlots = 4 - _selectedImages.length;

      if (remainingSlots <= 0) {
        _showMessage('You can select a maximum of 4 images.');
        return;
      }

      setState(() {
        _selectedImages.addAll(pickedImages.take(remainingSlots));
      });

      if (pickedImages.length > remainingSlots) {
        _showMessage('Only 4 images can be added.');
      }
    } catch (error) {
      if (!mounted) return;
      _showMessage('Unable to open the gallery.');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _sendMoment() async {
    final String text = _textController.text.trim();

    if (text.isEmpty && _selectedImages.isEmpty) {
      _showMessage('Write something or add an image.');
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isSending = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 350));

    if (!mounted) return;

    Navigator.pop(
      context,
      CreatedMoment(
        text: text,
        imagePaths: _selectedImages.map((image) => image.path).toList(),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const Positioned.fill(child: _EditScreenBackground()),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.only(
                    left: 18,
                    right: 18,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 30,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),

                        _buildHeader(),

                        const SizedBox(height: 28),

                        _buildTextBox(),

                        const SizedBox(height: 24),

                        _buildImageSection(),

                        const SizedBox(height: 260),

                        const _BottomOrnament(),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 82,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _GlowBackButton(onTap: () => Navigator.pop(context)),
          ),

          const Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edit',
                  style: TextStyle(
                    color: goldColor,
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                SizedBox(height: 5),
                SizedBox(width: 180, child: _DiamondDivider()),
              ],
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: _GlowSendButton(
              loading: _isSending,
              onTap: _isSending ? null : _sendMoment,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextBox() {
    return Container(
      height: 215,
      decoration: BoxDecoration(
        color: const Color(0xB30A0015),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: purpleColor.withValues(alpha: 0.65),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: purpleColor.withValues(alpha: 0.07),
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: [
          TextField(
            controller: _textController,
            maxLength: 1000,
            maxLines: null,
            expands: true,
            keyboardType: TextInputType.multiline,
            textAlignVertical: TextAlignVertical.top,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              height: 1.4,
            ),
            cursorColor: goldColor,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Say something',
              hintStyle: TextStyle(color: Color(0xFFB8B3BF), fontSize: 20),
              counterText: '',
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(18, 18, 18, 42),
            ),
          ),

          Positioned(
            right: 18,
            bottom: 15,
            child: Text(
              '${_textController.text.length}/1000',
              style: const TextStyle(color: Color(0xFFC5C0CA), fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    if (_selectedImages.isEmpty) {
      return _UploadTile(width: 160, height: 180, onTap: _pickImages);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _selectedImages.length < 4
              ? _selectedImages.length + 1
              : 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.92,
          ),
          itemBuilder: (context, index) {
            if (index == _selectedImages.length && _selectedImages.length < 4) {
              return _UploadTile(onTap: _pickImages);
            }

            return _SelectedImageTile(
              imagePath: _selectedImages[index].path,
              onRemove: () => _removeImage(index),
            );
          },
        ),

        const SizedBox(height: 10),

        Text(
          '${_selectedImages.length}/4 images selected',
          style: TextStyle(
            color: lightPurpleColor.withValues(alpha: 0.85),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _GlowBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _GlowBackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF170020),
            border: Border.all(color: const Color(0xFFFFD36A)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9D3BFF).withValues(alpha: 0.5),
                blurRadius: 1,
              ),
              BoxShadow(
                color: const Color(0xFFFFD36A).withValues(alpha: 0.25),
                blurRadius: 1,
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFFFFD36A),
            size: 25,
          ),
        ),
      ),
    );
  }
}

class _GlowSendButton extends StatelessWidget {
  final bool loading;
  final VoidCallback? onTap;

  const _GlowSendButton({required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          width: 92,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Color(0xFF42105E), Color(0xFF7317A5), Color(0xFF291039)],
            ),
            border: Border.all(color: const Color(0xFFFFD36A)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFA52EFF).withValues(alpha: 0.55),
                blurRadius: 1,
              ),
              BoxShadow(
                color: const Color(0xFFFFD36A).withValues(alpha: 0.22),
                blurRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 21,
                    height: 21,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFFFFD36A),
                    ),
                  )
                : const Text(
                    'Send',
                    style: TextStyle(
                      color: Color(0xFFFFE2A0),
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  final double? width;
  final double? height;
  final VoidCallback onTap;

  const _UploadTile({this.width, this.height, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _DashedRoundedBorderPainter(),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 66,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFFFD36A),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFFA837FF,
                          ).withValues(alpha: 0.55),
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Color(0xFF50106E),
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Color(0xFFFFD36A),
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: Color(0xFF8B21C5),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    right: -12,
                    bottom: -12,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF35104C),
                        border: Border.all(
                          color: const Color(0xFFFFD36A),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Color(0xFFFFE7AE),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectedImageTile extends StatelessWidget {
  final String imagePath;
  final VoidCallback onRemove;

  const _SelectedImageTile({required this.imagePath, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) {
                return Container(
                  color: const Color(0xFF261030),
                  child: const Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white54,
                  ),
                );
              },
            ),
          ),
        ),

        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFB34FFF)),
            ),
          ),
        ),

        Positioned(
          top: 7,
          right: 7,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onRemove,
              customBorder: const CircleBorder(),
              child: Container(
                width: 31,
                height: 31,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.72),
                  border: Border.all(color: const Color(0xFFFFD36A)),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 19,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DiamondDivider extends StatelessWidget {
  const _DiamondDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  const Color(0xFFFFD36A).withValues(alpha: 0.9),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 7),

        Transform.rotate(
          angle: 0.785398,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFD36A),
                  Color(0xFFA32EFF),
                  Color(0xFF4F086F),
                ],
              ),
              border: Border.all(color: const Color(0xFFFFDF86)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFA52FFF).withValues(alpha: 0.8),
                  blurRadius: 1,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 7),

        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFFD36A).withValues(alpha: 0.9),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomOrnament extends StatelessWidget {
  const _BottomOrnament();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: _DiamondDivider(),
    );
  }
}

class _DashedRoundedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dashLength = 7;
    const double gapLength = 5;

    final Paint paint = Paint()
      ..color = const Color(0xFFD271FF).withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(18)),
      );

    for (final metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final double nextDistance = (distance + dashLength).clamp(
          0,
          metric.length,
        );

        canvas.drawPath(metric.extractPath(distance, nextDistance), paint);

        distance = nextDistance + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _EditScreenBackground extends StatelessWidget {
  const _EditScreenBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _EditBackgroundPainter(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D0017)],
          ),
        ),
      ),
    );
  }
}

class _EditBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double bottom = size.height - 75;

    final Paint glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = const Color(0xFF9A2BFF).withValues(alpha: 0.16)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    final Paint purplePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0xFF8F2BE2).withValues(alpha: 0.65);

    final Paint goldPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = const Color(0xFFFFB83E).withValues(alpha: 0.75);

    final Path leftWave = Path()
      ..moveTo(-30, bottom - 110)
      ..quadraticBezierTo(
        size.width * 0.19,
        bottom + 10,
        size.width * 0.48,
        bottom - 5,
      );

    final Path rightWave = Path()
      ..moveTo(size.width + 30, bottom - 110)
      ..quadraticBezierTo(
        size.width * 0.81,
        bottom + 10,
        size.width * 0.52,
        bottom - 5,
      );

    canvas.drawPath(leftWave, glowPaint);
    canvas.drawPath(rightWave, glowPaint);

    for (int index = 0; index < 4; index++) {
      final double offset = index * 10;

      final Path leftLine = Path()
        ..moveTo(-20, bottom - 115 - offset)
        ..quadraticBezierTo(
          size.width * 0.18,
          bottom - 4 - offset,
          size.width * 0.48,
          bottom - 10 - offset,
        );

      final Path rightLine = Path()
        ..moveTo(size.width + 20, bottom - 115 - offset)
        ..quadraticBezierTo(
          size.width * 0.82,
          bottom - 4 - offset,
          size.width * 0.52,
          bottom - 10 - offset,
        );

      canvas.drawPath(leftLine, index == 1 ? goldPaint : purplePaint);

      canvas.drawPath(rightLine, index == 1 ? goldPaint : purplePaint);
    }

    final Paint particlePaint = Paint()..color = const Color(0xFFFFC556);

    for (int index = 0; index < 26; index++) {
      final double x = index.isEven
          ? 12 + (index * 4.5)
          : size.width - 12 - (index * 4.5);

      final double y = bottom - 100 - ((index * 17) % 120);
      final double radius = index % 4 == 0 ? 1.8 : 0.9;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        particlePaint..color = particlePaint.color.withValues(alpha: 0.65),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
