class User {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String avatar;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
    };
  }
}