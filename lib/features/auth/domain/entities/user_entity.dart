class UserEntity {
  final int? id;
  final String name;
  final String email;
  final String? avatar;

  const UserEntity({
    this.id,
    required this.name,
    required this.email,
    this.avatar,
  });
}
