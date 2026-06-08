class ChatRoomModel {
  final int id;
  final String name;
  final DateTime? createdAt;

  ChatRoomModel({
    required this.id,
    required this.name,
    this.createdAt,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse((json['id'] ?? '').toString()) ?? 0,
      name: json['name'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
