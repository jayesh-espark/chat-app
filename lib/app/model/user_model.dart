class UserModel {
  final String id;
  final String username;
  final String email;
  final String name;
  final String profileImageUrl;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.profileImageUrl,
    this.createdAt,
  });

  // Factory constructor to create a User from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '').toString(),
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      profileImageUrl: json['profile_image_url'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'name': name,
      'profile_image_url': profileImageUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
