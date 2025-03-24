// models/user_model.dart
class User {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String phone;
  final String avatar;
  final String createdAt;
  final String updatedAt;
  final String address;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.phone,
    required this.avatar,
    required this.createdAt,
    required this.updatedAt,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      phone: json['phone'],
      avatar: json['avatar'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      address: json['address'],
    );
  }
}