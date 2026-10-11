class SignUpModel {
  final int? id;
  final String email;
  final String password;
  final String name;
  final String? role;
  final String? avatar;

  SignUpModel({
    this.id,
    required this.email,
    required this.password,
    required this.name,
    this.role,
    this.avatar,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      id: json['id'],
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
      role: json['role'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'role': role,
      'avatar': avatar,
    };
  }
}
