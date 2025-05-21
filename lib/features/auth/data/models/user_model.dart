import 'package:expense_tracker_app/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity{
  UserModel({
    required super.userId,
    required super.email,
    required super.fullName,
    super.avatar,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'email': email,
      'full_name': fullName,
      'avatar': avatar,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['user_id'],
      email: map['email'],
      fullName: map['full_name'] ?? '',
      avatar: map['avatar'] ?? '',
    );
  }
}
