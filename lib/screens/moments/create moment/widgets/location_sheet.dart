import 'package:flutter/material.dart';

class LocationSheet extends StatefulWidget {
  final String? selectedLocation;

  const LocationSheet({
    super.key,
    this.selectedLocation,
  });

  @override
  State<LocationSheet> createState() =>
      _LocationSheetState();
}

class _LocationSheetState
    extends State<LocationSheet> {
  late final TextEditingController
  _controller;

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

  void _selectLocation() {
    final value = _controller.text.trim();

    if (value.isEmpty) {
      return;
    }

    Navigator.of(context).pop(value);
  }

  void _removeLocation() {
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
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius:
                BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Add location',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
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
            ),

            const SizedBox(height: 4),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Add a place to your moment.',
                style: TextStyle(
                  color: Color(0xff666675),
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 18),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xff191923),
                borderRadius:
                BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white
                      .withOpacity(.05),
                ),
              ),
              child: TextField(
                controller: _controller,
                autofocus: true,
                textInputAction:
                TextInputAction.done,
                onSubmitted: (_) {
                  _selectLocation();
                },
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                cursorColor:
                const Color(0xffA855F7),
                decoration:
                const InputDecoration(
                  hintText:
                  'e.g. Dubai, UAE',
                  hintStyle: TextStyle(
                    color: Color(0xff5F5F6D),
                    fontSize: 15,
                  ),
                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                    color: Color(0xffA855F7),
                    size: 21,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                    _controller.text
                        .trim()
                        .isNotEmpty
                        ? _removeLocation
                        : null,
                    style:
                    OutlinedButton.styleFrom(
                      minimumSize:
                      const Size(
                        0,
                        48,
                      ),
                      foregroundColor:
                      const Color(
                        0xffF87171,
                      ),
                      side: BorderSide(
                        color: Colors.white
                            .withOpacity(.07),
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Remove',
                      style: TextStyle(
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed:
                    _selectLocation,
                    style:
                    ElevatedButton.styleFrom(
                      minimumSize:
                      const Size(
                        0,
                        48,
                      ),
                      elevation: 0,
                      backgroundColor:
                      const Color(
                        0xff8B5CF6,
                      ),
                      foregroundColor:
                      Colors.white,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Add location',
                      style: TextStyle(
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}