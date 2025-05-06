class UserEntity {
  final String userId;
  final String email;
  final String fullName;
  final String? avatar;

  UserEntity({
    required this.userId,
    required this.email,
    required this.fullName,
    this.avatar,
  });
}