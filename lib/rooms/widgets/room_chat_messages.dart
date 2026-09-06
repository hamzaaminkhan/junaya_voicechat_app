import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/core/config/app_config.dart';
import 'package:junaya_voicechat_app/rooms/models/room_message_model.dart';

class RoomChatMessages extends StatefulWidget {
  final List<RoomMessage> messages;

  final String? currentUserId;

  const RoomChatMessages({
    super.key,
    required this.messages,
    this.currentUserId,
  });

  @override
  State<RoomChatMessages> createState() =>
      _RoomChatMessagesState();
}

class _RoomChatMessagesState
    extends State<RoomChatMessages> {
  final ScrollController _scrollController =
  ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollToBottom();
  }

  @override
  void didUpdateWidget(
      covariant RoomChatMessages oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (widget.messages.length !=
        oldWidget.messages.length) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          !_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 220,
        ),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.messages.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(
        14,
        8,
        90,
        12,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: widget.messages.length,
      itemBuilder: (
          context,
          index,
          ) {
        final message =
        widget.messages[index];

        final isMe =
            !message.isSystem &&
                widget.currentUserId != null &&
                widget.currentUserId!.isNotEmpty &&
                message.userId ==
                    widget.currentUserId;

        return _RoomChatMessageBubble(
          message: message,
          isMe: isMe,
        );
      },
    );
  }
}


// ============================================================
// MESSAGE BUBBLE
// ============================================================

class _RoomChatMessageBubble
    extends StatelessWidget {
  final RoomMessage message;

  final bool isMe;

  const _RoomChatMessageBubble({
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isSystem) {
      return _SystemMessage(
        message: message,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 7,
      ),
      child: Align(
        alignment: isMe
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 310,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: isMe
                ? const Color(0xFF853BA3)
                .withValues(alpha: .88)
                : const Color(0xFF35184A)
                .withValues(alpha: .88),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: .08,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: .10,
                ),
                blurRadius: 8,
                offset: const Offset(
                  0,
                  3,
                ),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              _MessageAvatar(
                avatar: message.avatar,
                name: message.userName,
              ),

              const SizedBox(width: 8),

              Flexible(
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _MessageHeader(
                      message: message,
                    ),

                    const SizedBox(height: 3),

                    Text(
                      message.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ============================================================
// MESSAGE HEADER
// ============================================================

class _MessageHeader
    extends StatelessWidget {
  final RoomMessage message;

  const _MessageHeader({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final badge =
        message.badge?.trim() ?? '';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            message.userName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        if (badge.isNotEmpty) ...[
          const SizedBox(width: 5),

          Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD76A),
              borderRadius:
              BorderRadius.circular(5),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                color: Color(0xFF35105D),
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],

        if (message.vipLevel > 0) ...[
          const SizedBox(width: 5),

          Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD76A)
                  .withValues(alpha: .14),
              borderRadius:
              BorderRadius.circular(5),
              border: Border.all(
                color: const Color(0xFFFFD76A)
                    .withValues(alpha: .30),
              ),
            ),
            child: Text(
              'VIP ${message.vipLevel}',
              style: const TextStyle(
                color: Color(0xFFFFD76A),
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }
}


// ============================================================
// SYSTEM MESSAGE
// ============================================================

class _SystemMessage
    extends StatelessWidget {
  final RoomMessage message;

  const _SystemMessage({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 7,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(
              alpha: .20,
            ),
            borderRadius:
            BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: .05,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if ((message.badge ?? '')
                  .trim()
                  .isNotEmpty) ...[
                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF7C4DFF,
                    ),
                    borderRadius:
                    BorderRadius.circular(5),
                  ),
                  child: Text(
                    message.badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 7,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 7),
              ],

              Flexible(
                child: Text(
                  message.message,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    height: 1.25,
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


// ============================================================
// AVATAR
// ============================================================

class _MessageAvatar
    extends StatelessWidget {
  final String? avatar;

  final String name;

  const _MessageAvatar({
    this.avatar,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final value =
        avatar?.trim() ?? '';

    Widget fallback() {
      final firstLetter =
      name.trim().isEmpty
          ? 'U'
          : name.trim()[0]
          .toUpperCase();

      return Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF6B3981),
        ),
        child: Text(
          firstLetter,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    if (value.isEmpty) {
      return SizedBox(
        width: 31,
        height: 31,
        child: fallback(),
      );
    }

    String imageUrl = value;

    if (value.startsWith('/')) {
      final base =
      AppConfig.apiBaseUrl.endsWith('/')
          ? AppConfig.apiBaseUrl
          .substring(
        0,
        AppConfig.apiBaseUrl.length - 1,
      )
          : AppConfig.apiBaseUrl;

      imageUrl = '$base$value';
    }

    if (!imageUrl.startsWith(
      'http://',
    ) &&
        !imageUrl.startsWith(
          'https://',
        )) {
      return SizedBox(
        width: 31,
        height: 31,
        child: ClipOval(
          child: Image.asset(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (
                _,
                __,
                ___,
                ) {
              return fallback();
            },
          ),
        ),
      );
    }

    return Container(
      width: 31,
      height: 31,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF6B3981),
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (
            _,
            __,
            ___,
            ) {
          return fallback();
        },
      ),
    );
  }
}