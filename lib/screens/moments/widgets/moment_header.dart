import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';

class MomentHeader extends StatelessWidget {
  final Moment moment;
  final VoidCallback onDelete;

  const MomentHeader({
    super.key,
    required this.moment,
    required this.onDelete,
  });

  String _timeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);

    if (difference.inMinutes < 1) {
      return "now";
    }

    if (difference.inHours < 1) {
      return "${difference.inMinutes}m";
    }

    if (difference.inDays < 1) {
      return "${difference.inHours}h";
    }

    return "${difference.inDays}d";
  }

  @override
  Widget build(BuildContext context) {
    final user = moment.author;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        12,
        10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(1.8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xffFACC15),
                  Color(0xffA855F7),
                  Color(0xffEC4899),
                ],
              ),
            ),
            child: ClipOval(
              child: user.avatar.isNotEmpty
                  ? Image.network(
                user.avatar,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return _fallbackAvatar();
                },
              )
                  : _fallbackAvatar(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        user.displayName.isNotEmpty
                            ? user.displayName
                            : user.username,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ),
                    if (user.verified)
                      const Padding(
                        padding:
                        EdgeInsets.only(left: 5),
                        child: Icon(
                          Icons.verified,
                          size: 16,
                          color:
                          Color(0xff8B5CF6),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      "@${user.username}",
                      style: const TextStyle(
                        color:
                        Color(0xff8F8F9F),
                        fontSize: 13,
                      ),
                    ),
                    const Padding(
                      padding:
                      EdgeInsets.symmetric(
                        horizontal: 6,
                      ),
                      child: Text(
                        "•",
                        style: TextStyle(
                          color:
                          Color(0xff666675),
                        ),
                      ),
                    ),
                    Text(
                      _timeAgo(moment.createdAt),
                      style: const TextStyle(
                        color:
                        Color(0xff8F8F9F),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                if (moment.location != null)
                  Padding(
                    padding:
                    const EdgeInsets.only(
                      top: 5,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 13,
                          color:
                          Color(0xffA855F7),
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            moment.location!.name,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              color:
                              Color(0xffC4B5FD),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (moment.visibility
              .toString()
              .contains("public"))
            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color:
                const Color(0xff06352B),
                borderRadius:
                BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.public,
                    size: 13,
                    color:
                    Color(0xff00E6A0),
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Public",
                    style: TextStyle(
                      color:
                      Color(0xff00E6A0),
                      fontSize: 12,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              _showMenu(context);
            },
            child: const Icon(
              Icons.more_horiz,
              size: 24,
              color:
              Color(0xffB8B8C8),
            ),
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
      const Color(0xff151522),
      shape:
      const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
                title: const Text(
                  "Delete moment",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _fallbackAvatar() {
    return Container(
      color:
      const Color(0xff20202A),
      child: const Icon(
        Icons.person,
        color:
        Colors.white54,
      ),
    );
  }
}