import 'package:flutter/material.dart';

class LocationPickerSheet extends StatefulWidget {
  final String? selectedLocation;

  const LocationPickerSheet({
    super.key,
    this.selectedLocation,
  });

  @override
  State<LocationPickerSheet> createState() =>
      _LocationPickerSheetState();
}

class _LocationPickerSheetState
    extends State<LocationPickerSheet> {
  late final TextEditingController _controller;

  final List<String> _suggestions = const [
    'Current location',
    'Nearby',
    'Home',
    'Work',
  ];

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text: widget.selectedLocation ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectLocation(String value) {
    final location = value.trim();

    if (location.isEmpty) {
      return;
    }

    Navigator.of(context).pop(location);
  }

  void _clearLocation() {
    Navigator.of(context).pop('');
  }

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
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(),

            const SizedBox(height: 18),

            _buildHeader(),

            const SizedBox(height: 18),

            _buildSearchField(),

            const SizedBox(height: 16),

            _buildSuggestions(),

            const SizedBox(height: 8),

            _buildMapPlaceholder(),

            const SizedBox(height: 14),

            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 38,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Add location',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Show where this moment was taken.',
                style: TextStyle(
                  color: Color(0xff666675),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          splashRadius: 20,
          icon: const Icon(
            Icons.close_rounded,
            color: Color(0xff777787),
            size: 21,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.done,
      onSubmitted: _selectLocation,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: 'Search a location',
        hintStyle: const TextStyle(
          color: Color(0xff666675),
          fontSize: 14,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Color(0xff777787),
          size: 21,
        ),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
          onPressed: () {
            setState(() {
              _controller.clear();
            });
          },
          icon: const Icon(
            Icons.close_rounded,
            color: Color(0xff777787),
            size: 18,
          ),
        )
            : null,
        filled: true,
        fillColor: const Color(0xff191923),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
      onChanged: (_) {
        setState(() {});
      },
    );
  }

  Widget _buildSuggestions() {
    return Column(
      children: [
        _LocationOption(
          icon: Icons.my_location_rounded,
          color: const Color(0xffA855F7),
          title: 'Use current location',
          subtitle: 'Find your current position',
          onTap: () {
            _selectLocation(
              'Current location',
            );
          },
        ),

        const SizedBox(height: 8),

        if (_controller.text.trim().isEmpty)
          ..._suggestions.skip(1).map(
                (location) {
              return Padding(
                padding:
                const EdgeInsets.only(
                  bottom: 8,
                ),
                child: _LocationOption(
                  icon:
                  Icons.location_on_outlined,
                  color:
                  const Color(0xff777787),
                  title: location,
                  subtitle:
                  'Saved location',
                  onTap: () {
                    _selectLocation(
                      location,
                    );
                  },
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 110,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff191923),
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(.05),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius:
              BorderRadius.circular(18),
              child: CustomPaint(
                painter: _MapPatternPainter(),
              ),
            ),
          ),

          const Center(
            child: Icon(
              Icons.location_on_rounded,
              color: Color(0xffA855F7),
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    final hasLocation =
        _controller.text.trim().isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: hasLocation
            ? () {
          _selectLocation(
            _controller.text,
          );
        }
            : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor:
          const Color(0xff8B5CF6),
          disabledBackgroundColor:
          const Color(0xff292432),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'Add location',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _LocationOption extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LocationOption({
    required this.icon,
    required this.color,
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
            horizontal: 13,
            vertical: 11,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(.11),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 19,
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
                        fontSize: 13.5,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xff777787),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),

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

class _MapPatternPainter extends CustomPainter {
  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(.035)
      ..strokeWidth = 1;

    const spacing = 24.0;

    for (double x = 0;
    x < size.width;
    x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = 0;
    y < size.height;
    y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) {
    return false;
  }
}