class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime dateOfBirth;
  final String avatarUrl;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dateOfBirth,
    required this.avatarUrl,
    required this.createdAt,
  });

  // Factory constructor to create a User from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      avatarUrl: json['avatar_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
