class ChatModel {
  final String name;
  final String lastMessage;
  final String time;
  final bool online;
  final int unread;

  const ChatModel({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.online,
    required this.unread,
  });
}
