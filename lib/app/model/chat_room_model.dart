class ChatRoomModel {
  final String id;
  final String userId;
  final String user1Id;
  final String user2Id;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final ChatUser? user2;
  final ChatUser? user1;
  final ChatUser? user;

  ChatRoomModel({
    required this.id,
    required this.userId,
    required this.user1Id,
    required this.user2Id,
    this.lastMessage,
    this.lastMessageAt,
    this.user,
    this.user1,
    this.user2,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      user1Id: json['user1_id'] ?? '',
      user2Id: json['user2_id'] ?? '',
      lastMessage: json['last_message'],
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'])
          : null,
      user: json['user'] != null ? ChatUser.fromJson(json['user']) : null,
      user1: json['user1'] != null ? ChatUser.fromJson(json['user1']) : null,
      user2: json['user2'] != null ? ChatUser.fromJson(json['user2']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1_id': user1Id,
      'user_id': userId,
      'user2_id': user2Id,
      'last_message': lastMessage,
      'last_message_at': lastMessageAt?.toIso8601String(),
      'user1': user1?.toJson(),
      'user2': user2?.toJson(),
    };
  }
}

class ChatUser {
  final String firstName;
  final String lastName;
  final String avatarUrl;

  ChatUser({
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'avatar_url': avatarUrl,
    };
  }
}
