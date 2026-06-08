class ChatMessageModel {
  final int id;
  final int roomId;
  final String senderId;
  final String content;
  final String username;
  final DateTime createdAt;
  final bool isMe;

  ChatMessageModel({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.content,
    required this.username,
    required this.createdAt,
    required this.isMe,
  });

  // Getters for compatibility with existing UI code
  String get text => content;
  DateTime get timestamp => createdAt;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json, String currentUserId) {
    final sId = (json['sender_id'] ?? json['senderId'] ?? '').toString();
    
    DateTime time;
    if (json['created_at'] != null) {
      time = DateTime.tryParse(json['created_at'] as String) ?? DateTime.now();
    } else if (json['timestamp'] != null) {
      time = DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now();
    } else {
      time = DateTime.now();
    }

    final rawRoomId = json['room_id'] ?? json['roomId'];
    final parsedRoomId = rawRoomId is int 
        ? rawRoomId 
        : int.tryParse((rawRoomId ?? '').toString()) ?? 0;

    return ChatMessageModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse((json['id'] ?? '').toString()) ?? 0,
      roomId: parsedRoomId,
      senderId: sId,
      content: json['content'] as String? ?? json['message'] as String? ?? '',
      username: json['username'] as String? ?? '',
      createdAt: time.toLocal(),
      isMe: sId == currentUserId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'sender_id': senderId,
      'content': content,
      'username': username,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
