import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:junaya_voicechat_app/models/chat_model.dart';
import 'package:junaya_voicechat_app/screens/chat/chat_screen.dart';
import 'package:junaya_voicechat_app/widgets/space_background.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  int selectedFilter = 0;
  String _searchQuery = '';

  final List<ChatModel> chats = [
    ChatModel(
      name: 'Ali',
      lastMessage: 'Bro, join my room!',
      time: '2:15 PM',
      online: true,
      unread: 3,
    ),
    ChatModel(
      name: 'Sara',
      lastMessage: 'Thank you ❤️',
      time: 'Yesterday',
      online: false,
      unread: 0,
    ),
    ChatModel(
      name: 'Ahmed',
      lastMessage: "Let's play later.",
      time: '10:40 AM',
      online: true,
      unread: 2,
    ),
  ];

  List<ChatModel> get _filteredChats {
    return chats.where((chat) {
      final matchesFilter = selectedFilter == 0 || chat.unread > 0;

      final query = _searchQuery.trim().toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          chat.name.toLowerCase().contains(query) ||
          chat.lastMessage.toLowerCase().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredChats = _filteredChats;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SafeArea(
        minimum: const EdgeInsets.only(right: 4, bottom: 78),
        child: _NewChatButton(
          onTap: () {
            // TODO: New Chat
          },
        ),
      ),
      body: SpaceBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildTopBar(context),

              const SizedBox(height: 6),

              _buildSearchBar(),

              const SizedBox(height: 12),

              _buildFilters(),

              const SizedBox(height: 13),

              _buildSectionHeader(filteredChats.length),

              const SizedBox(height: 7),

              Expanded(
                child: filteredChats.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 145),
                        itemCount: filteredChats.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final chat = filteredChats[index];

                          return _ChatRow(
                            chat: chat,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                    currentUserId: 'current_user_id',
                                    receiverId: chat.name,
                                    receiverName: chat.name,
                                    receiverImage: '',
                                    isOnline: chat.online,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
      child: SizedBox(
        height: 46,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
            Expanded(
              child: Text(
                'Chats',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              tooltip: 'More',
              onPressed: () {
                // TODO: Chat menu
              },
              icon: const Icon(
                Icons.more_horiz_rounded,
                color: Colors.white54,
                size: 23,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: SizedBox(
        height: 44,
        child: TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.5),
          decoration: InputDecoration(
            hintText: 'Search conversations',
            hintStyle: GoogleFonts.poppins(
              color: Colors.white38,
              fontSize: 11.5,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Colors.white38,
              size: 20,
            ),
            filled: true,
            fillColor: Colors.black.withValues(alpha: .14),
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: .08),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: const Color(0xFFFFC94D).withValues(alpha: .50),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            icon: Icons.forum_outlined,
            selected: selectedFilter == 0,
            onTap: () {
              setState(() {
                selectedFilter = 0;
              });
            },
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Unread',
            icon: Icons.mark_chat_unread_outlined,
            selected: selectedFilter == 1,
            onTap: () {
              setState(() {
                selectedFilter = 1;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Text(
            selectedFilter == 0 ? 'Recent conversations' : 'Unread messages',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            '$count chats',
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 9.8),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .04),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: .07)),
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Colors.white30,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No chats found',
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Try changing the filter or search.',
              style: GoogleFonts.poppins(color: Colors.white30, fontSize: 10.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatRow extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onTap;

  const _ChatRow({required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool hasUnread = chat.unread > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: .15),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: hasUnread
                  ? const Color(0xFFFFC94D).withValues(alpha: .14)
                  : Colors.white.withValues(alpha: .07),
            ),
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7A43DD).withValues(alpha: .22),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .07),
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  if (chat.online)
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF59D56F),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF10091A),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13.2,
                        fontWeight: hasUnread
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      chat.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: hasUnread ? Colors.white60 : Colors.white38,
                        fontSize: 10.8,
                        fontWeight: hasUnread
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    chat.time,
                    style: GoogleFonts.poppins(
                      color: Colors.white30,
                      fontSize: 8.8,
                    ),
                  ),
                  const SizedBox(height: 7),
                  if (hasUnread)
                    Container(
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFC83D),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${chat.unread}',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF170D18),
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 11),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFFFC83D)
                : Colors.black.withValues(alpha: .13),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: selected
                  ? const Color(0xFFFFC83D)
                  : Colors.white.withValues(alpha: .08),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: selected ? const Color(0xFF170D18) : Colors.white54,
                size: 14,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: selected ? const Color(0xFF170D18) : Colors.white70,
                  fontSize: 10.5,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewChatButton extends StatelessWidget {
  final VoidCallback onTap;

  const _NewChatButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF7C3CE8),
            border: Border.all(color: Colors.white.withValues(alpha: .11)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .18),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.edit_rounded, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
