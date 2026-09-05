import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoomChatInput extends StatefulWidget {
  final TextEditingController controller;

  final VoidCallback onSend;

  final VoidCallback? onEmojiTap;

  const RoomChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.onEmojiTap,
  });

  @override
  State<RoomChatInput> createState() => _RoomChatInputState();
}

class _RoomChatInputState extends State<RoomChatInput> {
  static const Color _pink = Color(0xFFFF48ED);
  static const Color _gold = Color(0xFFFFD76A);

  bool _hasText = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_onTextChanged);

    _hasText = widget.controller.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);

    super.dispose();
  }

  void _onTextChanged() {
    final hasText =
        widget.controller.text.trim().isNotEmpty;

    if (hasText != _hasText && mounted) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _submit() {
    if (widget.controller.text.trim().isEmpty) {
      return;
    }

    widget.onSend();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          10,
          8,
          10,
          8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // ==================================================
            // EMOJI BUTTON
            // ==================================================

            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onEmojiTap,
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF170525)
                        .withValues(alpha: .92),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _pink.withValues(alpha: .55),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.white,
                    size: 23,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // ==================================================
            // MESSAGE FIELD
            // ==================================================

            Expanded(
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 48,
                  maxHeight: 110,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF170525)
                      .withValues(alpha: .94),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: _pink.withValues(alpha: .45),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: widget.controller,

                  autofocus: false,

                  keyboardType: TextInputType.text,

                  textInputAction:
                  TextInputAction.send,

                  maxLength: 250,

                  minLines: 1,
                  maxLines: 4,

                  onSubmitted: (_) {
                    _submit();
                  },

                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                  ),

                  cursorColor: _gold,

                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'Say something...',

                    hintStyle: GoogleFonts.poppins(
                      color: Colors.white38,
                      fontSize: 12,
                    ),

                    border: InputBorder.none,

                    contentPadding:
                    const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 13,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // ==================================================
            // SEND BUTTON
            // ==================================================

            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _hasText ? _submit : null,
                borderRadius: BorderRadius.circular(28),
                child: AnimatedContainer(
                  duration:
                  const Duration(milliseconds: 180),

                  width: 48,
                  height: 48,

                  decoration: BoxDecoration(
                    color: _hasText
                        ? _gold
                        : const Color(0xFF170525)
                        .withValues(alpha: .92),

                    shape: BoxShape.circle,

                    border: Border.all(
                      color: _hasText
                          ? _gold
                          : _pink.withValues(alpha: .35),
                    ),
                  ),

                  child: Icon(
                    Icons.send_rounded,
                    size: 21,
                    color: _hasText
                        ? const Color(0xFF35105D)
                        : Colors.white38,
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