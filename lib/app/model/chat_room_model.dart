class ChatRoomModel {
  final int id;
  final String name;
  final bool isGroup;
  final String profileImageUrl;
  final DateTime? createdAt;

  ChatRoomModel({
    required this.id,
    required this.name,
    required this.isGroup,
    required this.profileImageUrl,
    this.createdAt,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse((json['id'] ?? '').toString()) ?? 0,
      name: json['name'] as String? ?? '',
      isGroup: json['is_group'] as bool? ?? true,
      profileImageUrl: json['profile_image_url'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_group': isGroup,
      'profile_image_url': profileImageUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
