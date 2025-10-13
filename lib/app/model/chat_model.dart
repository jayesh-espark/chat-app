class ChatMessageModel {
  final String text;
  final bool isMe;
  final DateTime timestamp;

  ChatMessageModel({
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}
